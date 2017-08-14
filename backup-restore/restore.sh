#!/bin/bash

systemctl stop mpd redis
bsdtar -xf $1 -C /
systemctl start mpd redis
mpc update Webradio
hostnamectl set-hostname $( redis-cli get hostname )
rm $1
