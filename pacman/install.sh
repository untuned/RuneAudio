#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=pacm

. /srv/http/addonstitle.sh

if [[ $( pacman -V | grep 'Pacman v' | cut -d'v' -f2 | cut -d' ' -f1 ) > 5.0.1 ]]; then
	redis-cli hset addons pacm 1 &> /dev/null # mark as upgraded - disable button
	title "$info Pacman already upgraded."
	exit
fi

title -l '=' "$bar Upgrade Pacman ..."
timestart

wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib

echo -e "$bar Prefetch packages ..."
pacman -Sw --noconfirm glibc pacman

echo -e "$bar Install packages ..."
pacman -S --noconfirm glibc pacman

timestop
title -l '=' "$bar Pacman upgraded successfully."
