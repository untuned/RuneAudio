#!/bin/bash

line2=$( printf '\e[0;36m%*s\e[m\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' = )
line=$( printf '\e[0;36m%*s\e[m\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' - )
bar=$( echo -e "$(tput setab 6)   $(tput setab 0)" )
info=$( echo $(tput setab 6; tput setaf 0) i $(tput setab 0; tput setaf 7) )

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
if ! pacman -Q transmission-cli &>/dev/null; then
	title "$info Transmission not found."
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

titleend "Transmission uninstalled successfully."

rm uninstall_tran.sh
