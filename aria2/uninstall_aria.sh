#!/bin/bash

# import heading function
wget -qN https://github.com/rern/tips/raw/master/bash/f_heading.sh
. f_heading.sh
rm f_heading.sh

# check installed #######################################
if ! pacman -Q aria2 &>/dev/null; then
	title "$info Aria2 not found."
	exit
fi

title2 "Uninstall Aria2 ..."
systemctl disable aria2
systemctl stop aria2
rm /etc/systemd/system/aria2.service
systemctl daemon-reload
# uninstall package #######################################
pacman -Rs --noconfirm aria2

# remove files #######################################
title "Remove files ..."
rm -rv /root/.config/aria2
rm -r /usr/share/nginx/html/aria2

# restore modified files #######################################
title "Restore modified files ..."
echo '/etc/nginx/nginx.conf'
sed -i '/server { #aria2/, /} #aria2/ d' /etc/nginx/nginx.conf
systemctl restart nginx

titleend "Aria2 uninstalled successfully."

rm uninstall_aria.sh
