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
		$code = $std;
	} else {
		$i = 0;
		$data = $std;
		$status[ $code ] = $data;
		// each stdout stream end with 'prgr'
		if ( $code === '70726772' ) {
			ui_render( 'airplay', json_encode( $status ) );
			$coverfile = fopen( '/srv/http/assets/img/airplay-cover.jpg', 'wb' );
			fwrite( $coverfile, base64_decode( $status[ '50494354' ] ) );
			fclose( $coverfile );
		}
	}
}
