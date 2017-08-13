#!/bin/bash

# modify.sh

# fix restore settings issue
# must 'systemctl restart rune_SY_wrk' after modify
# or menu > development > restart rune_SY_wrk

file=/srv/http/command/rune_SY_wrk
line=$( sed -n "/case 'restore'/=" $file )
sed -i "$line, $(( line + 4 )) s|// ||" $file

file=/srv/http/app/libs/runeaudio.php
line=$( sed -n "\|/run/backup_|=" $file )
sed -i -e $(( line + 1 ))' s|^|//|
' -e $line' a\
        \$dir = " /var/lib/mpd /etc/mpd.conf /var/lib/redis/rune.rdb /etc/netctl /etc/mpdscribble.conf /etc/spop /etc/localtime";\
        \$cmdstring = "redis-cli save; ";
        \$cmdstring .= "bsdtar -cf ".\$filepath.\$dir;
' -e '/tar xzf/ s|^|//|
' -e '/tar xzf/ i\
    \$cmdstring = "systemctl stop mpd redis; ";
    \$cmdstring .= "bsdtar -xf ".\$path." -C /; ";
    \$cmdstring .= "systemctl start mpd redis; ";
    \$cmdstring .= "mpc update Webradio";
' $file
