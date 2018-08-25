<?php
$redis = new Redis();
$redis->connect('/tmp/redis.sock');
include('/var/www/app/libs/runeaudio.php');

if ( $_POST[ 'onoff' ] === "on" ) {
	// "exec" gets only last line which is new power-on card
	$ao = exec( '/usr/bin/aplay -lv | grep card | cut -d"]" -f1 | cut -d"[" -f2' );
	$name = $ao;
} else {
	$ao = $redis->get( 'aodefault' );
	$name = $redis->hGet( 'udaclist', $ao );
}
ui_notify( 'Audio Output', 'Switch to '.$name );
wrk_mpdconf( $redis, 'switchao', $ao );
}
