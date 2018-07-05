#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=uire

. /srv/http/addonstitle.sh

version=$( redis-cli get buildversion )

title -l '=' "$bar Reset RuneUI ..."
timestart

rm -f /srv/http/app/templates/enhanceplayback.php
rm -f /srv/http/enhance*
rm -f /srv/http/assets/css/{enhance.css,midori.css,roundslider.min.css}
rm -f /srv/http/assets/fonts/enhance*
rm -f /srv/http/assets/img/{controls*,runelogo.svg,turntable*}
rm -f /srv/http/assets/js/enhance.js
rm -f /srv/http/assets/js/vendor/{jquery-ui.min.js,modernizr-custom.js,roundslider.min.js}
rm -f /usr/share/bootsplash/{start,reboot,shutdown}-runeaudio.png

mv /srv/http/assets/fonts/fontawesome-webfont.woff{.backup,} 2>/dev/null
mv /srv/http/assets/fonts/fontawesome-webfont.ttf{.backup,} 2>/dev/null
mv /srv/http/assets/js/runeui.min.js{.backup,} 2>/dev/null
mv /srv/http/app/coverart_ctl.php{.backup,} 2>/dev/null
mv /usr/share/bootsplash/start-runeaudio.png{.backup,} 2>/dev/null
mv /usr/share/bootsplash/reboot-runeaudio.png{.backup,} 2>/dev/null
mv /usr/share/bootsplash/shutdown-runeaudio.png{.backup,} 2>/dev/null

wgetnc https://github.com/rern/RuneAudio/raw/$branch/ui_rest/ui-reset.tar.xz
bsdtar -xvf ui-reset.tar.xz -C /srv/http
rm ui_reset.tar.xz

clearcache

timestop

title "$bar RuneUI reset succesfully."
title -nt "$info RuneUI may need a reboot."
