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
function wrk_backup(\$bktype) {\
	\$file = "/run/backup_"\.date('Ymd-hi')\."\.tar\.xz";\
	\$dir = '--exclude /etc/netctl/examples'\.\
	    ' /var/lib/redis/rune\.rdb'\.\
	    ' /var/lib/mpd'\.\
		' /etc/mpd\.conf'\.\
		' /etc/mpdscribble\.conf'\.\
		' /etc/spop'\.\
		' /etc/localtime'\.\
		' /etc/netctl'\.\
		' /mnt/MPD/Webradio'\
	;\
	\$exclude = '--exclude /etc/netctl/examples';\
	\$cmdstring = "redis-cli save; ";\
	\$cmdstring \.= "bsdtar -czf \$file \$dir";\
    sysCmd(\$cmdstring);\
    return \$file;\
}
' /srv/http/app/libs/runeaudio.php
