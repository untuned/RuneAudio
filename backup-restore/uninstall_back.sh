#!/bin/bash

alias=back

. /srv/http/addonstitle.sh

uninstallstart $@

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

rm -v /etc/sudoers.d/http-backup
rm -v /srv/http/restore.*
rm -v /srv/http/assets/js/restore.js
rm -rv /srv/http/tmp

uninstallfinish $@

title -nt "Please wait 5 seconds before continue."

systemctl restart rune_SY_wrk
