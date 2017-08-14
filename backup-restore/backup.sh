#!/bin/bash

dir='--exclude /etc/netctl/examples
 /var/lib/redis/rune.rdb
 /var/lib/mpd
 /etc/mpd.conf
 /etc/mpdscribble.conf
 /etc/spop
 /etc/localtime
 /etc/netctl
 /mnt/MPD/Webradio
'
redis-cli save
bsdtar -czf $1 $dir
