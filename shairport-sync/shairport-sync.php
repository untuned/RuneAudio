#!/usr/bin/php
<?php
include('/srv/http/app/libs/runeaudio.php');
$redis = new Redis();
$redis->connect( '/tmp/redis.sock' );

if ( $argv[ 1 ] === 'off' ) {
	wrk_stopAirplay($redis);
	exec( '/usr/bin/systemctl start mpd' );
	fclose( $airplay_handle );
	ui_render( 'playback', 1 );
	die();
}

wrk_startAirplay( $redis );
exec( '/usr/bin/systemctl stop mpd' );
ui_render( 'playback', 1 );
	
/* stdout stream from shairport-sync named pipe:
...
<item><type>636f7265</type><code>6173616c</code><length>18</length>
<data encoding="base64">
U29uZ3Mgb2YgSW5ub2NlbmNl</data></item>
...
*/
$replace = array(
	  '#<item><type>.*</type><code>.*</code><length>0</length>.*\\n#' => ''      // remove zero length
	, '#<item><type>.*</type><code>(.*)</code><length>.*</length>.*\\n#' => "$1" // get 'code'
	, '#<data encoding="base64">\\n#' => ''                                      // remove encoding="base64" line
	, '#(.*)</data></item>.*\\n#' => "$1"                                        // get 'data'
	, '#.*</item>.*\\n#' => ''                                                   // remove trailling '</item>'
);
$airplay_handle = fopen( '/tmp/shairport-sync-metadata', 'r' );
stream_set_blocking( $airplay_handle, false );
$i = 0;
while ( 1 ) ) {
	$line = fgets( $airplay_handle );
	$std = preg_replace( array_keys( $replace ), array_values( $replace ), $line );
	if ( !$std ) continue;
	if ( $i === 0 ) {
		$i++;
		$code = hex2bin( $std );
	} else {
		$i = 0;
		$data = base64_decode( $std );
		
		if ( $code === 'arar' ) {
			$status[ 'artist' ] = $data;
		} else if ( $code === 'minm' ) {
			$status[ 'song' ] = $data;
		} else if ( $code === 'asal' ) {
			$status[ 'album' ] = $data;
		} else if ( $code === 'PICT' ) {
			$cover = $data;
		} else if ( $code === 'prgr' ) { // each send end with 'prgr'
			$progress = explode( $data );
			$status[ 'elapsed' ] = round( ( $progress[ 1 ] - $progress[ 0 ] ) / 44100 );
			$status[ 'time' ] = round( ( $progress[ 2 ] - $progress[ 0 ] ) / 44100 ):
			$status[ 'cover' ] = '/srv/http/assets/img/airplay'.$progress[ 0 ].'.jpg';
			ui_render( 'airplay', json_encode( $status ) );
			// append start time to filename to avoid cache
			$coverfile = fopen( $status[ 'cover' ], 'wb' );
			fwrite( $coverfile, $cover );
			$cover = '';
			fclose( $coverfile );
			// current status not available in airplay 
			$redis->set( 'act_player_info', json_encode( $status ) );
		}
	}
}
