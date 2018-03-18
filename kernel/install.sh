#!/bin/bash

alias=kern

. /srv/http/addonstitle.sh

version=$( uname -r | cut -d'-' -f1 )

if [[ $version > 4.4.39 ]]; then
	title "$info Kernel already upgraged to $version"
	exit
fi

title -l '=' "$bar Upgrade Kernel ..."
timestart

rankmirrors

pacman -Sy --force --noconfirm raspberrypi-firmware raspberrypi-bootloader linux-raspberrypi linux-firmware cifs-utils

# get kernel version
version=$( pacman -Q linux-raspberrypi | cut -d' ' -f2 )

redis-cli set kernel "Linux runeaudio ${version}-ARCH" &> /dev/null
redis-cli hset addons kern 1 &> /dev/null # mark as upgraded - disable button

timestop
title -l '=' "$bar Kernel upgraded to $version successfully."
title -nt "$info Please reboot."
