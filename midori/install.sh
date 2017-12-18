#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=mido

. /srv/http/addonstitle.sh

if ! pacman -Q midori-rune &> /dev/null; then
	redis-cli hset addons mido 1 &> /dev/null # mark as upgraded - disable button
	title "$info Midori already upgraged."
	exit
fi

title -l '=' "$bar Upgrade Midori ..."
timestart

[[ $( pacman -Sy | grep -c 'up to date') != 5 ]] && rankmirrors

pacman -S --noconfirm enchant freetype2 gpg-crypter glib2 gstreamer gstreamer-vaapi gtk3 harfbuzz hunspell icu libgcrypt libgpg-error libsoup libwebp

ln -sf /lib/libicuuc.so.{60.2,56}
ln -sf /lib/libicudata.so.{60.2,56}

yes 2>/dev/null | pacman -S midori

echo -e "$bar Restart Midori ..."
killall midori
sleep 3
xinit &> /dev/null &

timestop
title -l '=' "$bar Midori upgraded successfully."
