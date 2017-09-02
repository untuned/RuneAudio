#!/bin/bash

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

# check installed #######################################
if ! pacman -Q transmission-cli &>/dev/null; then
	echo -e "$info Transmission not found."
	exit
fi

title -l = "Uninstall Transmission ..."
# uninstall package #######################################
pacman -R --noconfirm transmission-cli

# remove files #######################################
echo -e "$bar Remove files ..."
rm -r /etc/systemd/system/transmission.service.d
rm /lib/systemd/system/trans.service
if mount | grep -q '/dev/sda1'; then
	mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
	rm -r $mnt/transmission/web
else
	rm -r /root/transmission/web
fi

redis-cli hdel addons tran &> /dev/null

title -l = "$bar Transmission uninstalled successfully."

rm $0
