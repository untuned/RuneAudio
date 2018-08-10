#!/bin/bash

alias=chro

. /srv/http/addonstitle.sh

uninstallstart $@

# uninstall package #######################################
pacman -Rs --noconfirm chromium

# restore file
echo -e "$bar Restore files ..."
file=/boot/cmdline.txt
echo $file
sed -i '1 s/$/ ipv6.disable=1/' $file

files="
/boot/config.txt
/root/.xinitrc
"
restorefile $files

uninstallfinish $@

clearcache
