#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=volu

. /srv/http/addonstitle.sh

installstart $@

getuninstall

echo -e "$bar Add new files ..."

file=/srv/http/assets/js/volume.js
echo $file
wgetnc https://github.com/rern/RuneAudio/raw/master/volume/volume.js -O $file

enhapath=https://github.com/rern/RuneUI_enhancement/raw/master/srv/http
file=/srv/http/redis.php
echo $file
[[ ! -e $file ]] && wgetnc $enhapath/redis.php

echo -e "$bar Modify files ..."

file=/srv/http/app/templates/footer.php
echo $file
sed -i $'$ a\<script src="<?=$this->asset(\'/js/volume.js\')?>"></script>' $file

file=/srv/http/assets/js/runeui.js
echo $file
sed -i '/var knobvol/ a\
            if ( knobvol ) GUI.volume = knobvol;
' $file

redis-cli set dev 1 &> /dev/null # avoid edit runeui.min.js

installfinish $@

clearcache
