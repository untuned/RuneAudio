#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=uire

[[ ! -e /srv/http/addonstitle.sh ]] && wget -qN --no-check-certificate https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/addonstitle.sh -P /srv/http
. /srv/http/addonstitle.sh

title -l '=' "$bar Reset RuneUI ..."
timestart

crontab -l | { cat | sed '/addonsupdate.sh/ d'; } | crontab -

# enha
rm -f /usr/share/bootsplash/{start,reboot,shutdown}-runeaudio.png
# gpio
rm -f /root/gpio*.py
# back
rm -f /etc/sudoers.d/http-backup
#motd
rm -f /etc/motd.logo /etc/profile.d/motd.sh

version=$( redis-cli get buildversion )
if [[ $version == 20170229 ]]; then
	file=ui_reset.tar.xz
else
	file=ui_reset03.tar.xz
	# spla
	systemctl disable ply-image
	systemctl enable getty@tty1.service
	rm -f /etc/systemd/system/ply-image.service
	rm -f /usr/local/bin/ply-image
	rm -fr /usr/share/ply-image
fi

rm -fr /srv
rm -f /usr/local/bin/uninstall_*

wgetnc https://github.com/rern/RuneAudio/raw/master/ui_reset/$file -P /tmp

rm -rf /tmp/install
mkdir -p /tmp/install
bsdtar -xvf /tmp/$file -C /tmp/install
rm /tmp/$file

chown -R http:http /tmp/install/srv
chmod -R 755 /tmp/install
cp -rfp /tmp/install/* /
rm -rf /tmp/install

redis-cli del addons volumemute webradios pathlyrics &> /dev/null

title "$bar Install Addons ..."
wget -qN --show-progress --no-check-certificate https://github.com/rern/RuneAudio_Addons/raw/master/install.sh; chmod +x install.sh; ./install.sh

timestop

clearcache

title "$bar RuneUI reset succesfully."
title -nt "$info Please reboot and clear browser cache."
