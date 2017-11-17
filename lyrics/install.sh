#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=lyri

. /srv/http/addonstitle.sh

installstart $@

getinstallzip

echo -e "$bar Modify files ..."
file=/srv/http/app/templates/header.php
echo $file
sed -i -e $'/runeui.css/ a\
    <link rel="stylesheet" href="<?=$this->asset(\'/css/lyrics.css\')?>">
' -e '/menu-top/ i\
<div id="lyricsfade" class="hide"></div>
' $file
# no RuneUI GPIO
! grep -q 'pnotify.css' $file && 
	sed -i $'/runeui.css/ a\    <link rel="stylesheet" href="<?=$this->asset(\'/css/pnotify.css\')?>">' $file

file=/srv/http/app/templates/footer.php
echo $file
echo '<script src="<?=$this->asset('"'"'/js/lyrics.js'"'"')?>"></script>' >> $file
# no RuneUI GPIO
! grep -q 'pnotify3.custom.min.js' $file && 
	echo '<script src="<?=$this->asset('"'"'/js/vendor/pnotify3.custom.min.js'"'"')?>"></script>' >> $file

installfinish $@

title -nt "$info Refresh browser to activate."
