#!/bin/bash

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

if mount | grep -q '/dev/sda1'; then
	mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
	mkdir -p $mnt/transmission
	path=$mnt/transmission
else
	mkdir -p /root/transmission
	path=/root/transmission
fi

# if update, save settings
if [[ ${@:$#} == -u ]]; then
	rm -r /tmp/tran
	mkdir -p /tmp/tran
	mv $path/settings.json /tmp/tran
	[[ -e $path/web ]] && touch /tmp/tran/answebui
	[[ -e /etc/systemd/system/multi-user.target.wants/transmission.service ]] && touch /tmp/tran/ansstartup
fi

# check installed #######################################
if ! pacman -Q transmission-cli &>/dev/null; then
	echo -e "$info Transmission not found."
	exit 1
fi

title -l = "$bar Uninstall Transmission ..."
# uninstall package #######################################
pacman -Rs --noconfirm transmission-cli

# remove files #######################################
echo -e "$bar Remove files ..."

rm -rv /etc/systemd/system/transmission.service.d
rm -v /lib/systemd/system/trans.service
rm -r $path/web

redis-cli hdel addons tran &> /dev/null

title -l = "$bar Transmission uninstalled successfully."

rm $0
