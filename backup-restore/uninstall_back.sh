#!/bin/bash

# import heading function
wget -qN https://raw.githubusercontent.com/rern/title_script/master/title.sh; . title.sh; rm title.sh

title -l = "$bar Uninstall Backup-Restore update ..."

if [[ ! -e /srv/http/restore.php ]]; then
    echo -e "$info Uninstall Backup-Restore update not found."
    exit
fi

rm -r /srv/http/tmp

sed -i -e '\|/run/backup_|,+1 s|^//||
' -e '\|/srv/http/tmp|,/^ \+;/ d
' /srv/http/app/libs/runeaudio.php

sed -i -e 's/id="restore"/method="post"/
' -e 's/type="file" name="filebackup"/type="file"/
' -e '/id="btn-backup-upload"/ s/id="btn-backup-upload"/& name="syscmd" value="restore"/; s/disabled>Restore/type="submit" disabled>Upload/
' /srv/http/app/templates/settings.php

sed -i '/#restore/,/^});/ d' /srv/http/assets/js/runeui.js

sed -i 's/\$("#restore").\+});//' /srv/http/assets/js/runeui.min.js

rm /srv/http/restore.* /etc/sudoers.d/sudoers

systemctl restart rune_SY_wrk

echo -e "$bar Clear PHP OPcache ..."
curl '127.0.0.1/clear'
echo

title -l = "$bar Backup-Restore update uninstalled successfully."

rm $0
