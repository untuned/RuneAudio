#!/bin/bash

# import heading function
wget -qN --no-check-certificate https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

# check installed #######################################
if ! pacman -Q aria2 &>/dev/null; then
	echo -e "$info Aria2 not found."
	exit
fi

title -l = "$bar Uninstall Aria2 ..."
systemctl disable aria2
systemctl stop aria2
rm /etc/systemd/system/aria2.service
systemctl daemon-reload
# uninstall package #######################################
pacman -Rs --noconfirm aria2

# restore file
sed -i -e '/location \/aria2/, /^$/ d
' -e '/^\s*rewrite/ d
' -e 's/#rewrite/rewrite/g
' /etc/nginx/nginx.conf

# remove files #######################################
echo -e "$bar Remove files ..."
if mount | grep -q '/dev/sda1'; then
	mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
	rm -rv $mnt/aria2/web
else
	rm -rv /root/aria2/web
fi
rm -rv /root/.config/aria2

title -l = "$bar Aria2 uninstalled successfully."

rm $0
