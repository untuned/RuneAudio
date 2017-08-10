#!/bin/bash

# import heading function
wget -qN https://raw.githubusercontent.com/rern/title_script/master/title.sh; . title.sh; rm title.sh

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
rm /etc/systemd/system/transmission.service
systemctl daemon-reload

title -l = "$bar Transmission uninstalled successfully."

rm $0
