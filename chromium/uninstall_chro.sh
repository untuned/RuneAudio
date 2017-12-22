#!/bin/bash

alias=chro

. /srv/http/addonstitle.sh

uninstallstart $@

# uninstall package #######################################
pacman -Rs --noconfirm chromium

# restore file
echo -e "$bar Restore files ..."
file=/root/.xinitrc
echo $file
sed -i -e '/export BROWSER=chromium/ d
' -e '/^#midori/ s/^#//
' -e '/^chromium/ d
' $file

echo -e "$bar Start default local browser..."
killall Xorg
sleep 3
xinit &> /dev/null &

uninstallfinish $@
