#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=ngin

. /srv/http/addonstitle.sh

if [[ $( nginx -v 2>&1 ) == 'nginx version: nginx/1.13.7' ]]; then
	redis-cli hset addons ngin 1 &> /dev/null # mark as upgraded - disable button
	title "$info NGINX already upgraded."
	exit
fi

title -l '=' "$bar Upgrade NGINX ..."
timestart

# backup
mv /etc/nginx/mime.types{,.backup}
mv /etc/nginx/nginx.conf{,.backup}
mv /usr/lib/systemd/system/nginx.service{,.backup}

echo -e "$bar Get NGINX packages ..."
gitpath=https://github.com/rern/RuneAudio/raw/master/nginx/
file=nginx-1.14.0-1-armv7h.pkg.tar.xz
echo $file
wgetnc $gitpath/$file

yes 2>/dev/null | pacman -U $file

rm $file
mv /etc/nginx/nginx.conf{.backup,}
mv /etc/nginx/nginx.conf{.backup,}
mv /usr/lib/systemd/system/nginx.service{.backup,}

lnfile=$( find /lib/libevent* -type f | grep '.*/libevent-.*' )
ln -sf $lnfile /lib/libevent-2.0.so.5

systemctl daemon-reload

redis-cli hset addons ngin 1 &> /dev/null # mark as upgraded - disable button

echo -e "$bar Restart NGINX ..."

restartnginx

timestop
title -l '=' "$bar NGINX upgraded successfully."
