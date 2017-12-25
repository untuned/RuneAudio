#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=redis

. /srv/http/addonstitle.sh

if [[ $( redis-cli -v | cut -d'.' -f1 ) == 'redis-cli 4' ]]; then
	redis-cli hset addons redis 1 &> /dev/null # mark as upgraded - disable button
	title "$info Redis already upgraged."
	exit
fi

title -l '=' "$bar Upgrade Redis ..."
timestart

pacman -S --noconfirm redis

sed -i -e 's/User=.*/User=root/
' -e 's/Group=.*/Group=root/
' -e '/CapabilityBoundingSet/,/LimitNOFILE/ d
' /lib/systemd/system/redis.service

systemctl daemon-reload
systemctl restart redis

timestop
title -l '=' "$bar Redis upgraded successfully."
