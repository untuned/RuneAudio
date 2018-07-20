#!/bin/bash

alias=shai

. /srv/http/addonstitle.sh

uninstallstart $@

pacman -R shairport-sync

systemctl enable shairport

uninstallfinish $@
