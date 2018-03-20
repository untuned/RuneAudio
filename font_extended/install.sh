#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=font

. /srv/http/addonstitle.sh

installstart $@

getuninstall

wgetnc https://github.com/rern/RuneAudio/raw/$branch/font_extended/lato.tar.xz
mv /srv/http/assets/fonts/lato{,.backup}
mkdir /srv/http/assets/fonts/lato
bsdtar -xvf lato.tar.xz -C /srv/http/assets/fonts/lato
rm lato.tar.xz

installfinish $@

clearcache
