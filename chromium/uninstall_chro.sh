#!/bin/bash

alias=chro

. /srv/http/addonstitle.sh

uninstallstart $@

if [[ $1 == u ]]; then
	zoom=$( grep '^chromium' /root/.xinitrc | cut -d '=' -f 3 )
	redis-cli set chrozoom $zoom &> /dev/null
fi

# uninstall package #######################################
pacman -Rs --noconfirm chromium

# restore file
echo -e "$bar Restore files ..."
file=/boot/cmdline.txt
echo $file
sed -i '1 s/$/ ipv6.disable=1/' $file

file=/boot/config.txt
echo $file
sed -i '/disable_overscan=1/ d' $file

file=/root/.xinitrc
echo $file
sed -i -e '/^#midori/ s/^#//
' -e '/^chromium/ d
' $file

if [[ $1 != u ]]; then
	echo -e "$bar Start default local browser..."
	killall Xorg
	sleep 3
	xinit &> /dev/null &
fi

uninstallfinish $@
