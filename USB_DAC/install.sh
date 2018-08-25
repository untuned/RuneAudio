#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=udac

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

echo -e "$bar Modify files ..."

file=/etc/udev/rules.d/rune_usb-audio.rules
echo $file
# split add-remove to suppress notify twice
commentS 'SUBSYSTEM=="sound"'

string=$( cat <<'EOF'
ACTION=="add", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/var/www/command/udac.php on"
ACTION=="remove", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/var/www/command/udac.php"
EOF
)
appendS 'SUBSYSTEM=="sound"'

udevadm control --reload-rules && udevadm trigger

string=$( cat <<'EOF'
<?php
$redis = new Redis();
$redis->connect('/tmp/redis.sock');
include('/var/www/app/libs/runeaudio.php');

if ( $argc > 1 ) {
	// "exec" gets only last line which is new power-on card
	$ao = exec( '/usr/bin/aplay -lv | grep card | cut -d"]" -f1 | cut -d"[" -f2' );
	$name = $ao;
} else {
	$ao = $redis->get( 'aodefault' );
	$name = $redis->hGet( 'udaclist', $ao );
}

ui_notify( 'Audio Output Switch', $name );
wrk_mpdconf( $redis, 'switchao', $ao );
}
EOF
)
echo "string" /srv/http/udac.php

redis-cli set aodefault "$1" &> /dev/null

installfinish $@
