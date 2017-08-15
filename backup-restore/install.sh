#!/bin/bash

# install.sh

# fix restore settings issue
# must 'systemctl restart rune_SY_wrk' after modify
# or menu > development > restart rune_SY_wrk

mkdir -p /srv/http/tmp
chown http:http /srv/http/tmp

sed -i -e '\|/run/backup_|,+1 s|^|//|
' -e '\|/run/backup_| a\
    \$cmdstring = "rm -f /srv/http/tmp/backup_\* &> /dev/null; "\.\
        "redis-cli save; "\.\
        "tar -czf \$filepath"\.\
            " --exclude /etc/netctl/examples "\.\
            "/etc/netctl "\.\
            "/mnt/MPD/Webradio "\.\
            "/var/lib/redis/rune\.rdb "\.\
            "/var/lib/mpd "\.\
            "/etc/mpd\.conf "\.\
            "/etc/mpdscribble\.conf "\.\
            "/etc/spop"\
    ;
' /srv/http/app/libs/runeaudio.php

sed -i -e '/value="backup"/ {n;n;n;n;n;n; s/method="post"/id="restore"/}
' -e 's/type="file"/& name="filebackup"/
' -e'/value="restore"/ s/name="syscmd" value="restore" //; s/type="submit" disabled>Upload/disabled>Restore/
' /srv/http/app/templates/settings.php
