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
sed -i -e '/SUBSYSTEM=="sound"/ s/^/#/
' -e '$ a\
ACTION=="add", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/var/www/command/refresh_ao on"\
ACTION=="remove", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/var/www/command/refresh_ao"
' $file

udevadm control --reload-rules && udevadm trigger

file=/srv/http/command/refresh_ao
echo $file
sed -i -e '/ui_notify/ s|^|//|
' -e $'/close Redis/ i\
// udac0\
if ( $argc > 1 ) {\
	// "exec" gets only last line which is new power-on card\
	$ao = exec( \'/usr/bin/aplay -lv | grep card | cut -d"]" -f1 | cut -d"[" -f2\' );\
	ui_notify( "Audio Output", "Switch to ".$ao );\
} else {\
	$ao = "bcm2835 ALSA_1";\
	ui_notify( "Audio Output", "Switch to RaspberryPi Analog Out" );\
}\
$redis->set( "ao", $ao );\
wrk_mpdconf( $redis, "switchao", $ao );\
// udac1
' $file

installfinish $@