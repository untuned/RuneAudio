#!/bin/bash

alias=shai

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

rm /srv/http/shairport.php /srv/http/assets/js/shairport-sync.js

restorefile /srv/http/app/templates/footer.php /srv/http/command/rune_PL_wrk

pacman -R shairport-sync

systemctl enable shairport

uninstallfinish $@
