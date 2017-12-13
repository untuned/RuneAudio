#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=ngin

. /srv/http/addonstitle.sh

installstart $@

getuninstall

# backup
mv /etc/nginx/nginx.conf{,.backup}

gitpath=https://github.com/rern/RuneAudio/raw/$branch/nginx
file=nginx-1.13.7-2-armv7h.pkg.tar.xz
wgetnc $gitpath/$file

pacman -U --noconfirm $file

rm $file
mv /etc/nginx/nginx.conf{.backup,}

echo -e "$bar Restart NGINX ..."
systemctl daemon-reload
systemctl restart nginx

installfinish $@
