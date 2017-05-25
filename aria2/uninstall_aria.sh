#!/bin/bash

line2='\e[0;36m=========================================================\e[m'
line='\e[0;36m---------------------------------------------------------\e[m'
bar=$( echo -e "$(tput setab 6)   $(tput setab 0)" )
info=$( echo $(tput setab 6; tput setaf 0) i $(tput setab 0; tput setaf 7) )

# functions #######################################
title2() {
	echo -e "\n$line2\n"
	echo -e "$bar $1"
	echo -e "\n$line2\n"
}
title() {
	echo -e "\n$line"
	echo $1
	echo -e "$line\n"
}

# check installed #######################################
if ! pacman -Q aria2 &>/dev/null; then
	title "$info Aria2 not found."
	exit
fi

title2 "Uninstall Aria2 ..."
# uninstall package #######################################
pacman -Rs --noconfirm aria2

# remove files #######################################
title "Remove files ..."
rm -rfv /root/.config/aria2
rm -rfv /usr/share/nginx/html/aria2

# restore modified files #######################################
title "Restore modified files ..."
echo '/etc/nginx/nginx.conf'
sed -i '/server { #aria2/, /} #aria2/ d' /etc/nginx/nginx.conf
systemctl restart nginx

title2 "Aria2 successfully uninstalled."

rm uninstall_aria.sh
