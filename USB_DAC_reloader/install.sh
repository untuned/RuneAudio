#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=udac

. /srv/http/addonstitle.sh

if [[ -e /usr/local/bin/uninstall_gpio.sh ]]; then
	title "$info RuneUI GPIO already has this feature."
	exit
fi

installstart $@

getuninstall

echo -e "$bar Modify files ..."

file=/etc/udev/rules.d/rune_usb-audio.rules
echo $file
sed -i '/SUBSYSTEM=="sound"/ s/^/#/
' -e '$ a\
ACTION=="add", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/var/www/command/refresh_ao on"\
ACTION=="remove", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/var/www/command/refresh_ao"
' $file

udevadm control --reload-rules && udevadm trigger

file=/srv/http/command/refresh_ao
echo $file
sed -i $'/close Redis/ i\
if ( $argc > 1 ) {\
	// "exec" gets only last line which is new power-on card\
	$ao = exec( \'/usr/bin/aplay -lv | grep card | cut -d"]" -f1 | cut -d"[" -f2\' );\
	$redis->set( "ao", $ao );\
	wrk_mpdconf( $redis, "switchao", $ao );\
}
' $file

installfinish $@
