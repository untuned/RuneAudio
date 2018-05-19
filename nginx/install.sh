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
#mv /etc/nginx/nginx.conf{,.backup}

echo -e "$bar Get NGINX packages ..."
gitpath=https://github.com/rern/RuneAudio/raw/master/nginx/
file=nginx-1.14.0-1-armv7h.pkg.tar.xz
echo $file
wgetnc $gitpath/$file

yes 2>/dev/null | pacman -U $file

systemctl daemon-reload

rm $file
#mv /etc/nginx/nginx.conf{.backup,}

redis-cli hset addons ngin 1 &> /dev/null # mark as upgraded - disable button

echo -e "$bar Restart NGINX ..."

## restart nginx seamlessly without dropping client connections
# spawn new nginx master-worker set
kill -s USR2 $( cat /run/nginx.pid )
# stop old worker
kill -s WINCH $( cat /run/nginx.pid.oldbin )
# stop old master
kill -s QUIT $( cat /run/nginx.pid.oldbin )

timestop
title -l '=' "$bar NGINX upgraded successfully."
