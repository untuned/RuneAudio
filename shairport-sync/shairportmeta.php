<?php
$replace = array(
	  '#<item><type>.*</type><code>.*</code><length>0</length>.*\\n#' => ''
	, '#<item><type>.*</type><code>(.*)</code><length>.*</length>.*\\n#' => "$1"
	, '#<data encoding="base64">\\n#' => ''
	, '#(.*)</data></item>.*\\n#' => "$1"
	, '#.*</item>.*\\n#' => ''
);
$airplay_handle = fopen( '/tmp/shairport-sync-metadata', 'r' );
//stream_set_blocking( $airplay_handle, false );
$i = 0;
$output = '';
while ( !feof( $airplay_handle ) ) {
	$line = fgets( $airplay_handle );
	$std = preg_replace(
		array_keys( $replace ),
		array_values( $replace ),
		$line
	);
	if ( !$std ) continue;
	if ( $i === 0 ) {
		$i++;
		$code = hex2bin( $std );
		$output.= "'$code'";
	} else {
		$data = preg_match( '/PICT|mper|astm/', $output ) ? $std : base64_decode( $std );
		$output.= " : '$data',\n";
		echo $output;
		$output = '';
		$i = 0;
	}
	//exec( "/usr/bin/curl -s -v -X POST 'http://localhost/pub?id=airplay' -d \"$std\"" );
}
fclose( $airplay_handle );


/*
<item><type>636f7265</type><code>6173616c</code><length>18</length>
<data encoding="base64">
U29uZ3Mgb2YgSW5ub2NlbmNl</data></item>
...
code:
hex        string  type
61736172 = asar => artist
6d696e6d = minm => title
6173616c = asal => album
70726772 = prgr => start/elapsed/end
50494354 = PICT => cover
*/
