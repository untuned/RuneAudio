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
systemctl disable transmission
rm -r /etc/systemd/system/transmission.service.d
systemctl daemon-reload
rm /lib/systemd/system/trans.service

title -l = "$bar Transmission uninstalled successfully."

rm $0
