#!/bin/bash

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

title -l = "$bar Uninstall Backup-Restore update ..."

if [[ ! -e /srv/http/restore.php ]]; then
    echo -e "$info Uninstall Backup-Restore update not found."
    exit 1
fi

echo -e "$bar Restore files ..."
file=/srv/http/app/libs/runeaudio.php
echo $file
sed -i -e '\|/run/backup_|,+1 s|^//||
' -e '\|/srv/http/tmp|,/^ \+;/ d
' $file

file=/srv/http/app/templates/settings.php
echo $file
sed -i -e 's/id="restore"/method="post"/
' -e 's/type="file" name="filebackup"/type="file"/
' -e '/id="btn-backup-upload"/ s/id="btn-backup-upload"/& name="syscmd" value="restore"/; s/disabled>Restore/type="submit" disabled>Upload/
' $file

file=/srv/http/assets/js/runeui.js
echo $file
sed -i '/#restore/,/^});/ d' $file

file=/srv/http/assets/js/runeui.min.js
echo $file
sed -i 's/\$("#restore").\+});//' $file

rm -v /srv/http/restore.* /etc/sudoers.d/http-backup
rm -rv /srv/http/tmp

redis-cli hdel addons back &> /dev/null

title -l = "$bar Backup-Restore update uninstalled successfully."

# clear opcache if run from terminal #######################################
[[ -t 1 ]] && systemctl reload php-fpm

systemctl restart rune_SY_wrk

rm $0
