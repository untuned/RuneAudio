#!/bin/bash

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

# check installed #######################################
if ! pacman -Q aria2 &>/dev/null; then
	echo -e "$info Aria2 not found."
	exit 1
fi

type=Uninstall
# if update, save settings #######################################
if [[ ${@:$#} == -u ]]; then
	rm -r /tmp/aria
	mkdir -p /tmp/aria
	[[ -e /etc/systemd/system/multi-user.target.wants/aria.service ]] && touch /tmp/aria/ansstartup
	type=Update
fi

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

title -l = "$bar Aria2 uninstalled successfully."

rm $0
