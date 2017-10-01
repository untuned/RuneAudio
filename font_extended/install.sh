#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=font

. /srv/http/addonstitle.sh

installstart $1

getuninstall

wgetnc https://github.com/rern/_assets/raw/master/RuneUI_enhancement/lato.tar.xz
mv /srv/http/assets/fonts/lato{,.backup}
mkdir /srv/http/assets/fonts/lato
bsdtar -xvf lato.tar.xz -C /srv/http/assets/fonts/lato
rm lato.tar.xz

installfinish $1
