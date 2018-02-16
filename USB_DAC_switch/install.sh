#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=udac

. /srv/http/addonstitle.sh

installstart $@

getuninstall

echo -e "$bar Modify files ..."

file=/etc/udev/rules.d/rune_usb-audio.rules
echo $file
# split add-remove to suppress notify twice
sed -i -e '/SUBSYSTEM=="sound"/ s/^/#/
' -e '$ a\
ACTION=="add", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/var/www/command/refresh_ao on"\
ACTION=="remove", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/var/www/command/refresh_ao off"
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
	$name = $ao;\
	if ( strpos( $ao, 'bcm2835') !== false ) {\
		$ao = "bcm2835 ALSA_2";\
		$name = "RaspberryPi HDMI Out";\
	}\
	ui_notify( "Audio Output", "Switch to ".$name );\
	wrk_mpdconf( $redis, "switchao", $ao );\
}\
// udac1
' $file

installfinish $@
