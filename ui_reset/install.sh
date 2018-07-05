#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=uire

. /srv/http/addonstitle.sh

version=$( redis-cli get buildversion )

title -l '=' "$bar Reset RuneUI ..."
timestart

wgetnc https://github.com/rern/RuneAudio/raw/$branch/ui_rest/ui-reset.tar.xz
bsdtar -xvf ui-reset.tar.xz -C /srv/http
rm ui_reset.tar.xz

clearcache

timestop

title "$bar RuneUI reset succesfully."
title -nt "$info RuneUI may need a reboot."
