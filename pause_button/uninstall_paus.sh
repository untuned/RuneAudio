#!/bin/bash

alias=paus

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

rm -v /srv/http/assets/css/pausebutton.css

echo -e "$bar Restore files ..."

restorefile /srv/http/app/templates/header.php /srv/http/assets/js/runeui.js

uninstallfinish $@

restartlocalbrowser
