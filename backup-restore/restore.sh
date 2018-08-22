#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

timestart

title -l = "$bar Restore settings and databases ..."

echo -e "$bar Stop mpd and redis ..."
systemctl stop mpd redis
echo
echo -e "$bar Extract files ..."
echo File: $1
file=/srv/http/tmp/"$1"
bsdtar -xvpf "$file" -C /
rm "$file"

echo -e "$bar Restart mpd and redis ..."
systemctl start mpd redis
sleep 2

mpc update Webradio &> /dev/null &

hostnamectl set-hostname $( redis-cli get hostname )

sed -i "s/opcache.enable=./opcache.enable=$( redis-cli get opcache )/" /etc/php/conf.d/opcache.ini

timestop
title "$bar Settings and databases restored successfully."

reinitsystem
