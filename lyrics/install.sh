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
file=/srv/http/app/templates/header.php
echo $file
sed -i -e $'/runeui.css/ a\
    <link rel="stylesheet" href="<?=$this->asset(\'/css/lyrics.css\')?>">
' -e '/menu-top/ i\
<div id="lyricsfade" class="hide"></div>
' $file
# no RuneUI GPIO
if ! grep -q 'pnotify.css' $file; then
	wgetnc https://github.com/rern/RuneAudio/raw/master/lyrics/pnotify.css -P /srv/http/assets/css
	sed -i $'/runeui.css/ a\    <link rel="stylesheet" href="<?=$this->asset(\'/css/pnotify.css\')?>">' $file
	chown http:http $file
fi

file=/srv/http/app/templates/footer.php
echo $file
echo '<script src="<?=$this->asset('"'"'/js/lyrics.js'"'"')?>"></script>' >> $file
# no RuneUI GPIO
if ! grep -q 'pnotify3.custom.min.js' $file; then
	wgetnc https://github.com/rern/RuneAudio/raw/master/lyrics/pnotify3.custom.min.js -P /srv/http/assets/js
	echo '<script src="<?=$this->asset('"'"'/js/vendor/pnotify3.custom.min.js'"'"')?>"></script>' >> $file
fi

installfinish $@

title -nt "$info Refresh browser to activate."
