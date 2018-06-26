#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=redis

. /srv/http/addonstitle.sh

version0=$( redis-cli -v | cut -d' ' -f2 | cut -d'.' -f1 )
if [[ $version0 > 3 ]]; then
	redis-cli hset addons redis 1 &> /dev/null # mark as upgraded - disable button
	title "$info Redis already upgraded."
	tittle -nt "Further upgrade: pacman -Sy redis"
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

version=$( redis-cli -v | cut -d' ' -f2 | cut -d'.' -f1 )
if [[ $version0 > 3 ]]; then
	title -l '=' "$bar Redis upgraded to $version successfully."
else
	title -l '=' "$bar Redis upgrade failed."
fi
