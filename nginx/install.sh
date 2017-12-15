#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=ngin

. /srv/http/addonstitle.sh

if [[ $( nginx -v 2>&1 ) != 'nginx version: nginx/1.4.7' ]]; then
	redis-cli hset addons ngin 1 &> /dev/null # mark as upgraded - disable button
	title "$info NGINX already upgraged."
	exit
fi

title -l '=' "$bar Upgrade NGINX ..."
timestart

# backup
mv /etc/nginx/nginx.conf{,.backup}

echo -e "$bar Uninstall NGINX ..."
pacman -R --noconfirm nginx-rune

echo -e "$bar Get NGINX packages ..."
gitpath=https://github.com/rern/RuneAudio/raw/master/nginx/_repo
file=nginx-1.13.7-1-armv7h.pkg.tar.xz
echo $file
wgetnc $gitpath/$file

pacman -U --noconfirm $file

rm $file
mv /etc/nginx/nginx.conf{.backup,}

echo -e "$bar Restart NGINX ..."
systemctl reload php-fpm
systemctl daemon-reload
systemctl restart nginx

redis-cli hset addons ngin 1 &> /dev/null # mark as upgraded - disable button

timestop
title -l '=' "$bar NGINX upgraded successfully."
