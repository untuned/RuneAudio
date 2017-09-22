#!/bin/bash

alias=back

. /srv/http/addonstitle.sh

uninstallstart $1

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

uninstallfinish $1

title -nt "Please wait 5 seconds before continue."

[[ -t 1 ]] && clearcache

systemctl restart rune_SY_wrk
