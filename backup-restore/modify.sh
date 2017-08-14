#!/bin/bash

# modify.sh

# fix restore settings issue
# must 'systemctl restart rune_SY_wrk' after modify
# or menu > development > restart rune_SY_wrk

sed -i "/case 'restore'/,+4 s|// ||" /srv/http/command/rune_SY_wrk

sed -i -e '/function wrk_backup/, /^}/ s|^|//|
' -e '/function wrk_backup/ i\
function wrk_backup(\$bktype) {\
    \$file = "/tmp/backup_"\.date('Ymd-hi')\."\.tar\.xz";\
    \$exclude = " --exclude /etc/netctl/examples ";\
    \$dir = " /var/lib/mpd /etc/mpd\.conf /var/lib/redis/rune\.rdb /etc/netctl /etc/mpdscribble\.conf /etc/spop /etc/localtime";\
    \$cmdstring = "redis-cli save; ";\
    \$cmdstring \.= "bsdtar -czf \.\$exclude\.\$file\.\$dir";\
    sysCmd(\$cmdstring);\
    return \$file;\
}
' -e '/function wrk_restore/, /^}/ s|^|//|
' -e '/function wrk_restore/ i\
function wrk_restore(\$backupfile) {\
    \$file = "/tmp/backup\.tar\.xz";\
    \$cmdstring = "systemctl stop mpd redis; ";\
    \$cmdstring \.= "bsdtar -xf "\.\$path\." -C /; ";\
    \$cmdstring \.= "systemctl start mpd redis; ";\
    \$cmdstring \.= "mpc update Webradio";\
    \$cmdstring \.= "rm \$file";\
    sysCmd(\$cmdstring);\
}
' /srv/http/app/libs/runeaudio.php
