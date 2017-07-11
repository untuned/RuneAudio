#!/bin/bash

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

# check installed #######################################
if ! pacman -Q transmission-cli &>/dev/null; then
	title $info Transmission not found.
	exit
fi

title2 "Uninstall Transmission ..."
# uninstall package #######################################
pacman -R --noconfirm transmission-cli

# remove files #######################################
title Remove files ...
systemctl disable transmission
rm /etc/systemd/system/transmission.service
systemctl daemon-reload

title -l = $bar Transmission uninstalled successfully.

rm uninstall_tran.sh
