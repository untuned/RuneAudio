#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=pacm

. /srv/http/addonstitle.sh

version0=$( pacman -V | grep 'Pacman v' | cut -d'v' -f2 | cut -d' ' -f1 )
if [[ $version0 > 5.0.1 ]]; then
	redis-cli hset addons pacm 1 &> /dev/null # mark as upgraded - disable button
	title "$info Pacman already upgraded."
	exit
fi

title -l '=' "$bar Upgrade Pacman ..."
timestart

wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib

echo -e "$bar Prefetch packages ..."
pacman -Syw --noconfirm glibc pacman

echo -e "$bar Install packages ..."
pacman -S --noconfirm glibc pacman

timestop

version=$( pacman -V | grep 'Pacman v' | cut -d'v' -f2 | cut -d' ' -f1 )

if [[  $version > $version0 ]]; then
	title -l '=' "$bar Pacman upgraded to $version successfully."
else
	title -l '=' "$warn Pacman upgrade failed."
fi
