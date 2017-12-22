#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=chro

. /srv/http/addonstitle.sh

if [[ $( mpd -V | head -n 1 ) == 'Music Player Daemon 0.19.'* ]]; then
	title "$info MPD must be upgraged first."
	exit
fi

installstart $@

getuninstall

pacman -S --noconfirm chromium libwebp nss

# modify file
echo -e "$bar Modify file ..."
file=/root/.xinitrc
echo $file
sed -i -e '/export DISPLAY/ a\
export BROWSER=chromium
' -e '/^midori/ {
s/^/#/
a\
chromium --no-sandbox --app=http://localhost --start-fullscreen
}
' $file

timestop
title -l '=' "$bar Chromium installed successfully."

clearcache
