#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=ngin

. /srv/http/addonstitle.sh

if [[ $( nginx -v 2>&1 ) != 'nginx version: nginx/1.4.7' ]]; then
	redis-cli hset addons ngin 1 &> /dev/null # mark as upgraded - disable button
	title "$info NGINX already upgraged."
	exit
fi

installstart $@

# backup
mv /etc/nginx/nginx.conf{,.backup}

gitpath=https://github.com/rern/RuneAudio/raw/$branch/nginx
file=nginx-1.13.7-1-armv7h.pkg.tar.xz
wgetnc $gitpath/$file

pacman -U --noconfirm $file

rm $file
mv /etc/nginx/nginx.conf{.backup,}

echo -e "$bar Restart NGINX ..."
systemctl daemon-reload
systemctl restart nginx

installfinish $@
