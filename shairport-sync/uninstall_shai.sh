#!/bin/bash

alias=shai

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

rm /srv/http/shairport.php

restorefile /srv/http/command/rune_PL_wrk

pacman -R shairport-sync

systemctl enable shairport

uninstallfinish $@
