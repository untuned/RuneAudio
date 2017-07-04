#!/bin/bash

line2=$( printf '\e[0;36m%*s\e[m\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' = )
line=$( printf '\e[0;36m%*s\e[m\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' - )
bar=$( echo -e "$(tput setab 6)   $(tput setab 0)" )
info=$( echo $(tput setab 6; tput setaf 0) i $(tput setab 0; tput setaf 7) )

# functions #######################################
title2() {
	echo $line2
	echo -e "$bar $1"
	echo $line2
}
title() {
	echo $line
	echo -e "$1"
	echo $line
}
titleend() {
	echo -e "\n$1"
	echo $line
}

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
