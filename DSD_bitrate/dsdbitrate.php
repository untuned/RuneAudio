<?php
$file = $_POST[ 'file' ];
$byte = ( $ext === 'DSF' ) ? 56 : 60;
$bin = file_get_contents( $file, false, NULL, $byte, 4 );
$hex = bin2hex( $bin );
if ( $ext === 'DSF' ) {
	$hex = str_split( $hex, 2 );
	$hex = array_reverse( $hex );
	$hex = implode( '', $hex );
}
$bitrate = hexdec( $hex );
$dsd = $bitrate / 44100;
$bitrate = round( $bitrate / 1000000, 2 );
$sampling = '1 bit DSD '.$dsd.' - '.$bitrate.' Mbit/s';

echo $sampling;
