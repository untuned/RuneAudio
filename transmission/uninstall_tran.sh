#!/bin/bash

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

# check installed #######################################
if ! pacman -Q transmission-cli &>/dev/null; then
	echo -e "$info Transmission not found."
	exit 1
fi

if mount | grep -q '/dev/sda1'; then
	mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
	path=$mnt/transmission
else
	path=/root/transmission
fi

# if update, save settings #######################################
if [[ $1 == u ]]; then
	cp $path/settings.json /tmp
	[[ -e $path/web/index.original.html ]] && redis-cli set tranwebui 1
	[[ $( systemctl list-unit-files | grep 'tran.*enable' ) ]] && redis-cli set transtartup 1
fi

[[ $1 != u ]] && type=Uninstall || type=Update
title -l = "$bar $type Transmission ..."

# uninstall package #######################################
pacman -Rs --noconfirm transmission-cli

# remove files #######################################
echo -e "$bar Remove files ..."

rm -rv /etc/systemd/system/transmission.service.d
rm -v /lib/systemd/system/trans.service
rm -r $path/web

redis-cli hdel addons tran &> /dev/null

[[ $1 != u ]] && title -l = "$bar Transmission uninstalled successfully."

rm $0
