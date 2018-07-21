<?php
$airplay_handle = fopen( '/tmp/shairport-sync-metadata', 'r' );
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
$replacecode = array(
	  '/asar/' => 'currentartist'  // hex: 61736172
	, '/minm/' => 'currentsong'    // hex: 6d696e6d
	, '/asal/' => 'currentalbum'   // hex: 6173616c
	, '/prgr/' => 'time'           // hex: 70726772
	, '/PICT/' => 'coverart'       // hex: 50494354
);
stream_set_blocking( $airplay_handle, false );
$i = 0;
while ( !feof( $airplay_handle ) ) {
	$line = fgets( $airplay_handle );
	$std = preg_replace( array_keys( $replace ), array_values( $replace ), $line );
	if ( !$std ) continue;
	if ( $i === 0 ) {
		$i++;
		$code = hex2bin( $std );
	} else {
		$i = 0;
		// keep coverart and some others as base64
		$data = preg_match( '/astc|astm|astn|caps|PICT|mper/', $code ) ? $std : base64_decode( $std );
		$status[ $code ] = $data;
		// each stdout stream end with 'prgr'
		if ( $code === 'prgr' ) {
			print_r( $status );
			$status[ 'actPlayer' ] = 'Airplay';
			$json = json_encode( $status );
			$ch = curl_init( 'http://127.0.0.1/pub?id=airplay' );
			curl_setopt( $ch, CURLOPT_HTTPHEADER, array( 'Content-Type:application/json' ) );
			curl_setopt( $ch, CURLOPT_POSTFIELDS, $json );
			curl_exec( $ch );
			curl_close( $ch );
		}
	}
}
fclose( $airplay_handle );
