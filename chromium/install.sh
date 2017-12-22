#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=chro

. /srv/http/addonstitle.sh

if [[ $( mpd -V | head -n 1 ) == 'Music Player Daemon 0.19.'* ]]; then
	title "$info MPD must be upgraged first."
	exit
fi

title -l '=' "$bar Install Chromium ..."
timestart

getuninstall

yes 2>/dev/null | pacman -S chromium libwebp nss

sed -i -e '/export DISPLAY/ a\
export BROWSER=chromium
' -e '/^midori/ {
s/^/#/
a\
chromium --no-sandbox --app=http://localhost --start-fullscreen
}
' /root/.xinitrc

echo -e "$bar Start Chromium on local display..."
killall Xorg
xinit &> /dev/null &

timestop
title -l '=' "$bar Chromium installed successfully."
