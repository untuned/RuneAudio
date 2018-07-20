<?php
$airplay_handle = fopen('/tmp/shairport-sync-metadata', 'r' );
stream_set_blocking( $airplay_handle, false );
while ( 1 ) {
	$line = fgets( $airplay_handle );
//	if ( preg_match( '/61736172|6d696e6d|6173616c|70726772/', $line ) ) continue;
	$line = preg_replace( '/<item>|<type>.*<\/type><code>|<length>.*<\/length>|<data encoding="base64">|<\/data>|<\/item>|\\n/', '', $line );
	$code = preg_replace( '/(.*)<\/code>.*/', "\ncode: $1\n", $line );
	$data = preg_replace( '/(.*)<\/code>.*/', 'data: ', $line );
	echo $code;
	echo $data;
}

// code: hex string
// data: base64 string
