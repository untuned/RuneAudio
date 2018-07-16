#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=shai

. /srv/http/addonstitle.sh

installstart

getuninstall

pkg=shairport-sync-3.2.1-1-armv7h.pkg.tar.xz

wgetnc https://github.com/rern/RuneAudio/raw/$branch/shairport-sync/$pkg
wget https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wget https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
pacman -Sy --noconfirm libconfig
pacman -U --noconfirm $pkg

rm $pkg

installfinish
