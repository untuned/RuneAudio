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

file=/srv/http/assets/js/vendor/propagating.js
echo $file
[[ ! -e $file ]] && wgetnc https://github.com/rern/RuneAudio/raw/master/volume/propagating.js -O $file

file=/srv/http/assets/js/vendor/hammer.min.js
echo $file
[[ ! -e $file ]] && wgetnc https://github.com/rern/RuneAudio/raw/master/volume/hammer.min.js -O $file

echo -e "$bar Modify files ..."

file=/srv/http/app/templates/footer.php
echo $file
sed -i $'$ a\<script src="<?=$this->asset(\'/js/volume.js\')?>"></script>' $file
! grep -q 'hammer.min.js' $file && sed -i $'$ a\<script src="<?=$this->asset(\'/js/vendor/hammer.min.js\')?>"></script>' $file
! grep -q 'propagating.js' $file && sed -i $'$ a\<script src="<?=$this->asset(\'/js/vendor/propagating.js\')?>"></script>' $file

installfinish $@

clearcache
