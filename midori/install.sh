#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=mido

. /srv/http/addonstitle.sh

if ! pacman -Q midori-rune &> /dev/null; then
	redis-cli hset addons mido 1 &> /dev/null # mark as upgraded - disable button
	title "$info Midori already upgraded."
	exit
fi

title -l '=' "$bar Upgrade Midori ..."
timestart

[[ $( pacman -Sy | grep -c 'up to date') != 5 ]] && rankmirrors

pacman -S --noconfirm enchant freetype2 gpg-crypter glib2 gstreamer gstreamer-vaapi gtk3 \
	harfbuzz hunspell icu libgcrypt libgpg-error libsoup libwebp gst-plugins-base-libs zbar

file=$( ls -l /lib/libicuuc* | grep -v '^lrw' )
file=$( echo $file | cut -d' ' -f9 )
ln -sf $file /lib/libicuuc.so.56

file=$( ls -l /lib/libicudata* | grep -v '^lrw' )
file=$( echo $file | cut -d' ' -f9 )
ln -sf $file /lib/libicudata.so.56

yes 2>/dev/null | pacman -S midori

redis-cli hset addons mido 1 &> /dev/null

if grep '^chromium' /root/.xinitrc; then
	echo -e "$bar Disable Chromium ..."
	sed -i -e '/^chromium/ s/^/#/
	' -e '/midori/ s/^#//
	' /root/.xinitrc
fi

echo -e "$bar Restart Midori ..."
killall midori
sleep 3
xinit &> /dev/null &

timestop
title -l '=' "$bar Midori upgraded successfully."
