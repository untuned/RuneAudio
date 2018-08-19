#!/bin/bash

alias=back

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

echo -e "$bar Restore files ..."

file=/srv/http/app/templates/footer.php
[[ -e $file.backup ]] && file=$file.backup

files="
$file
/srv/http/app/libs/runeaudio.php
/srv/http/app/templates/settings.php
"
restorefile $files

rm -v /etc/sudoers.d/http-backup
rm -v /srv/http/backuprestore.*
rm -v /srv/http/assets/js/backuprestore.js
rm -rv /srv/http/tmp

uninstallfinish $@

reinitsystem
