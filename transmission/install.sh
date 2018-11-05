#!/bin/bash

# $1-password; $2-webui alternative; $3-startup

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=tran

. /srv/http/addonstitle.sh

installstart $@

getuninstall

wgetnc https://github.com/rern/RuneAudio/raw/$branch/transmission/_repo/transmission/transmission-cli-2.92-6-armv7h.pkg.tar.xz

pacman -U --noconfirm transmission-cli-2.92-6-armv7h.pkg.tar.xz

rm transmission-cli*

# remove conf for non-exist user 'transmission'
rm /usr/lib/tmpfiles.d/transmission.conf

if mount | grep -q '/dev/sda1'; then
	mnt=$( mount | grep '/dev/sda1' | cut -d' ' -f3 )
	mkdir -p $mnt/transmission
	path=$mnt/transmission
else
	mkdir -p /root/transmission
	path=/root/transmission
fi
mkdir -p $path/{incomplete,watch}

# custom systemd unit
ln -sf /lib/systemd/system/tran{smission,}.service
systemctl stop tran
systemctl disable tran

# custom user and env - TRANSMISSION_HOME must be /<path>/transmission-daemon
dir=/etc/systemd/system/transmission.service.d
mkdir -p $dir
echo "[Service]
User=root
Environment=TRANSMISSION_HOME=$path
Environment=TRANSMISSION_WEB_HOME=$path/web
" > $dir/override.conf
systemctl daemon-reload

file=$path/settings.json
rm -f $file
# create settings.json
systemctl start tran
systemctl stop tran

sed -i -e 's|"download-dir": ".*"|"download-dir": "'"$path"'"|
' -e 's|"incomplete-dir": ".*"|"incomplete-dir": "'"$path"'/incomplete"|
' -e 's|"incomplete-dir-enabled": false|"incomplete-dir-enabled": true|
' -e 's|"rpc-whitelist-enabled": true|"rpc-whitelist-enabled": false|
' -e '/[^{},\{, \}]$/ s/$/, /
' -e '/^}$/ i\
"watch-dir": "'"$path"'/watch", \
"watch-dir-enabled": true
' $file
# set password
if [[ -n $1 && $1 != 0 ]]; then
	sed -i -e 's|"rpc-authentication-required": false|"rpc-authentication-required": true|
	' -e 's|"rpc-password": ".*"|"rpc-password": "'"$1"'"|
	' -e 's|"rpc-username": ".*"|"rpc-username": "root"|
	' $file
else
	sed -i 's|"rpc-authentication-required": true|"rpc-authentication-required": false|
	' $file
fi

# web ui alternative
if [[ $2 == 1 ]]; then
	echo -e "$bar Get WebUI alternative ..."
	wgetnc https://github.com/ronggang/transmission-web-control/archive/master.zip
	rm -rf $path/web
	mv /usr/share/transmission/web $path
	mv $path/web/index{,.original}.html
	bsdtar -xf master.zip --strip 1 --exclude '.*' --exclude '*.md' -C $path/web
	rm master.zip
	chown -R root:root $path/web
fi

systemctl daemon-reload
[[ $3 == 1 ]] && systemctl enable tran

echo -e "$bar Start Transmission ..."
if ! systemctl start tran &> /dev/null; then
	title -l = "$warn Transmission install failed."
	exit
fi

installfinish $@

echo "Run: systemctl < start / stop > tran"
echo "Startup: systemctl < enable / disable > tran"
echo
echo "Download directory: $path"
echo "WebUI: < RuneAudio_IP >:9091"
title -nt "User: root"
