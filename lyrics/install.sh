#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=lyri

. /srv/http/addonstitle.sh

installstart $@

getuninstall

echo -e "$bar Add new files ..."
file=/srv/http/assets/js/lyrics.js
echo $file
wgetnc https://github.com/rern/RuneAudio/raw/master/lyrics/lyrics.js -P /srv/http/assets/js
chmod 755 $file

installfinish $@

title -nt "$info Refresh browser to activate."
