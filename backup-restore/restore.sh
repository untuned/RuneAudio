#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

timestart

title -l = "$bar Restore settings and databases ..."

systemctl stop mpd redis

file="/srv/http/tmp/$1"
bsdtar -xpf "$file" -C /
rm "$file"

systemctl start mpd redis
sleep 2
mpc update Webradio &> /dev/null &

hostnamectl set-hostname $( redis-cli get hostname )

sed -i "s/opcache.enable=./opcache.enable=$( redis-cli get opcache )/" /etc/php/conf.d/opcache.ini

timestop
title -nt "$bar Settings and databases restored successfully."

reinitsystem
