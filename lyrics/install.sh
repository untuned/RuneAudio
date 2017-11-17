#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=lyri

. /srv/http/addonstitle.sh
if [[ -e /usr/local/bin/uninstall_enha.sh ]]; then
	title "$info RuneUI Enhancement must be installed"
	exit
fi

installstart $@

getuninstall

echo -e "$bar Add new files ..."
file=/srv/http/assets/js/lyrics.js
echo $file
wgetnc https://github.com/rern/RuneAudio/raw/master/lyrics/lyrics.js -P /srv/http/assets/js
chown http:http $file

echo -e "$bar Modify files ..."
file=/srv/http/app/templates/footer.php
echo $file
echo '<script src="<?=$this->asset('"'"'/js/lyrics.js'"'"')?>"></script>' >> $file

installfinish $@

title -nt "$info Refresh browser to activate."
