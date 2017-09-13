#!/bin/bash

# required variables
alias=motd

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

uninstallstart $1

# if update, save settings #######################################
if [[ $1 == u ]] && [[ $( systemctl list-unit-files | grep 'aria.*enable' ) ]]; then
	redis-cli set ariastartup 1 &> /dev/null
fi

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

uninstallfinish $1
