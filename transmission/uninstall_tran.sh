#!/bin/bash

# import heading function
wget -qN https://github.com/rern/tips/raw/master/bash/f_heading.sh; . f_heading.sh; rm f_heading.sh

# check installed #######################################
if ! pacman -Q transmission-cli &>/dev/null; then
	titleinfo "Transmission not found."
	exit
fi

title2 "Uninstall Transmission ..."
# uninstall package #######################################
pacman -R --noconfirm transmission-cli

# remove files #######################################
title "Remove files ..."
systemctl disable transmission
rm /etc/systemd/system/transmission.service
systemctl daemon-reload

title2 "Transmission uninstalled successfully."

rm uninstall_tran.sh
