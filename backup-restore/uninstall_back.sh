#!/bin/bash

alias=back

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

echo -e "$bar Restore files ..."
restorefile /srv/http/app/libs/runeaudio.php /srv/http/app/templates/settings.php

rm -v /etc/sudoers.d/http-backup
rm -v /srv/http/restore.*
rm -v /srv/http/assets/js/restore.js
rm -rv /srv/http/tmp

uninstallfinish $@

title -nt  "$info Please wait Reinitialize for 5 seconds before continue."

systemctl restart rune_SY_wrk
