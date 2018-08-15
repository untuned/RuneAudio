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
ACTION=="add", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/var/www/command/refresh_ao on"
ACTION=="remove", KERNEL=="card*", SUBSYSTEM=="sound", RUN+="/var/www/command/refresh_ao off"
EOF
)
appendS 'SUBSYSTEM=="sound"'

udevadm control --reload-rules && udevadm trigger

file=/srv/http/command/refresh_ao
echo $file
# $1 = ao@name
if [[ $1 == 'bcm2835 ALSA_1@RaspberryPi Analog Out' ]]; then
	string=$( cat <<'EOF'
if ( $argc > 1 ) {
	if ( $argv[ 1 ] === "on" ) {
		// "exec" gets only last line which is new power-on card
		$ao = exec( '/usr/bin/aplay -lv | grep card | cut -d"]" -f1 | cut -d"[" -f2' );
		$name = $ao;
	} else {
		$ao = 'bcm2835 ALSA_1';
		$name = 'RaspberryPi Analog Out';
	}
	ui_notify( "Audio Output", "Switch to ".$name );
	wrk_mpdconf( $redis, "switchao", $ao );
}
EOF
)
else
	string=$( cat <<'EOF'
if ( $argc > 1 ) {
	if ( $argv[ 1 ] === "on" ) {
		// "exec" gets only last line which is new power-on card
		$ao = exec( '/usr/bin/aplay -lv | grep card | cut -d"]" -f1 | cut -d"[" -f2' );
		$name = $ao;
	} else {
		$ao = 'bcm2835 ALSA_1';
		$name = 'RaspberryPi HDMI Out';
	}
	ui_notify( "Audio Output", "Switch to ".$name );
	wrk_mpdconf( $redis, "switchao", $ao );
}
EOF
)
fi
insert 'close Redis'

installfinish $@
