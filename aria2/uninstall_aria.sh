#!/bin/bash

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

# check installed #######################################
if [[ ! -e /usr/local/bin/uninstall_aria.sh ]]; then
	echo -e "$info Aria2 not found."
	exit 1
fi

# if update, save settings #######################################
if [[ $1 == u ]] && [[ $( systemctl list-unit-files | grep 'aria.*enable' ) ]]; then
	redis-cli set ariastartup 1 &> /dev/null
fi

[[ $1 != u ]] && type=Uninstall || type=Update
title -l = "$bar $type Aria2 ..."

if mount | grep -q '/dev/sda1'; then
	mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
else
	mnt=/root
fi

systemctl disable aria2
systemctl stop aria2
rm -v /etc/systemd/system/aria2.service
systemctl daemon-reload
# uninstall package #######################################
pacman -Rs --noconfirm aria2

# restore file
file=/etc/nginx/nginx.conf
echo $file
sed -i -e '/location \/aria2/, /^$/ d
' -e '/^\s*rewrite/ d
' -e 's/#rewrite/rewrite/g
' $file

# remove files #######################################
echo -e "$bar Remove files ..."

rm -r $mnt/aria2/web	
rm -rv /root/.config/aria2 /srv/http/aria2

redis-cli hdel addons aria &> /dev/null

[[ $1 != u ]] && title -l = "$bar Aria2 uninstalled successfully."

rm $0
