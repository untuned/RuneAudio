#!/bin/bash

alias=tran

# import heading function
wget -qN https://github.com/rern/RuneAudio_Addons/raw/master/title.sh; . title.sh; rm title.sh

uninstallstart $1

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

# uninstall package #######################################
pacman -Rs --noconfirm transmission-cli

# remove files #######################################
echo -e "$bar Remove files ..."

rm -rv /etc/systemd/system/transmission.service.d
rm -v /lib/systemd/system/trans.service
rm -r $path/web

uninstallfinish $1
