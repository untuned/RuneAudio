<?php
$replace = array(
	  '#<item><type>.*</type><code>.*</code><length>0</length>.*\\n#' => ''
	, '#<item><type>.*</type><code>(.*)</code><length>.*</length>.*#' => "$1"
	, '#<data encoding="base64">\\n#' => ''
	, '#(.*)</data></item>#' => "$1"
	, '#</item>#' => ''
);
$airplay_handle = fopen('/tmp/shairport-sync-metadata', 'r' );
//stream_set_blocking( $airplay_handle, false );
while ( !feof( $airplay_handle ) ) {
	$line = fgets( $airplay_handle );
	$std = preg_replace(
		array_keys( $replace ),
		array_values( $replace ),
		$line
	);
	echo $std;
}
fclose( $airplay_handle );

// output:
// hex string code
// base64 string data
