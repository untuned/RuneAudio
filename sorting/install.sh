#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=sort

. /srv/http/addonstitle.sh

installstart $@

getuninstall

wegetnc https://github.com/rern/RuneAudio/raw/master/webradio/sorting.js -P /srv/http/assets/js
# modify files
footer=/srv/http/app/templates/footer.php
ech $footer
echo '<script src="<?=$this->asset('"'"'/js/sorting.js'"'"')?>"></script>' >> $footer

installfinish $@

clearcache
