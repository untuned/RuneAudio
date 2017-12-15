#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=mido

. /srv/http/addonstitle.sh

if ! pacman -Q midori-rune &> /dev/null; then
#	redis-cli hset addons mido 1 &> /dev/null # mark as upgraded - disable button
#	title "$info Midori already upgraged."
#	exit
fi

title -l '=' "$bar Upgrade Midori ..."
timestart

pacman -R midori-rune
pacman -Sy --noconfirm gstreamer gstreamer-vaapi glib2 gtk3 harfbuzz freetype2 libsoup libgcrypt gpg-crypter libgpg-error libwebp enchant icu

ln -s /lib/libicuuc.so.{60.1,56}
ln -s /lib/libicudata.so.{60.1,56}

pacman -S midori

echo -e "$bar Restart Midori ..."
killall midori
sleep 3
xinit &> /dev/null &

timestop
title -l '=' "$bar Midori upgraded successfully."
