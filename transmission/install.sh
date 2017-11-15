#!/bin/bash

# $1-password; $2-webui alternative; $3-startup

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=tran

. /srv/http/addonstitle.sh

installstart $@

getuninstall

gitpath=https://github.com/rern/RuneAudio/raw/$branch/transmission
wgetnc $gitpath/files.tar.xz
rm -rf /tmp/install
mkdir -p /tmp/install
bsdtar -xf files.tar.xz -C /tmp/install
chown root:root /tmp/install/*
cp /tmp/install/* /usr/lib
rm -rf files.tar.xz /tmp/install

rankmirrors

pacman -S --noconfirm libevent transmission-cli

# fix missing libevent-2.0.so.5
ln -s /lib/libevent-2.1.so.6.0.2 /lib/libevent-2.0.so.5

# remove conf for non-exist user 'transmission'
rm /usr/lib/tmpfiles.d/transmission.conf

if mount | grep -q '/dev/sda1'; then
	mnt=$( mount | grep '/dev/sda1' | cut -d' ' -f3 )
	path=$mnt/transmission
else
	path=/root/transmission
fi
mkdir -p $path/{incomplete,watch}

# custom systemd unit
ln -s /lib/systemd/system/trans{mission,}.service
systemctl stop trans
systemctl disable trans

dir=/etc/systemd/system/transmission.service.d
mkdir $dir
echo "[Service]
User=root
Environment=TRANSMISSION_HOME=$path
Environment=TRANSMISSION_WEB_HOME=$path/web
" > $dir/override.conf
systemctl daemon-reload

# create settings.json
file=$path/settings.json
[[ -e $file ]] && rm $file
systemctl start trans
systemctl stop trans

if [[ $1 != u ]]; then
	sed -i -e 's|"download-dir": ".*"|"download-dir": "'"$path"'"|
	' -e 's|"incomplete-dir": ".*"|"incomplete-dir": "'"$path"'/incomplete"|
	' -e 's|"incomplete-dir-enabled": false|"incomplete-dir-enabled": true|
	' -e 's|"rpc-whitelist-enabled": true|"rpc-whitelist-enabled": false|
	' -e '/[^{},\{, \}]$/ s/$/, /
	' -e '/}/ i\
	    "watch-dir": "'"$path"'/watch", \
	    "watch-dir-enabled": true
	' $file

	# set password
	if [[ -n $1 && $1 != 0 ]]; then
		sed -i -e 's|"rpc-authentication-required": false|"rpc-authentication-required": true|
		' -e 's|"rpc-password": ".*"|"rpc-password": "'"$1"'"|
		' -e 's|"rpc-username": ".*"|"rpc-username": "root"|
		' $file
	fi
else
	mv /tmp/settings.json $path
fi

# web ui alternative
if [[ $2 == 1 ]] || [[ $( redis-cli get tranwebui ) ]]; then
	echo -e "$bar Get WebUI alternative ..."
	wgetnc https://github.com/ronggang/transmission-web-control/raw/master/release/transmission-control-full.tar.gz
	rm -rf $path/web
	mv /usr/share/transmission/web $path
	mv $path/web/index{,.original}.html
	bsdtar -xf transmission-control-full.tar.gz -C $path
	rm transmission-control-full.tar.gz
	chown -R root:root $path/web
	redis-cli del tranwebui &> /dev/null
fi

systemctl daemon-reload
if [[ $3 == 1 ]] || [[ $( redis-cli get transtartup ) ]]; then
	systemctl enable trans
	redis-cli del transtartup &> /dev/null
fi

echo -e "$bar Start Transmission ..."
if ! systemctl start trans &> /dev/null; then
	title -l = "$warn Transmission install failed."
	exit
fi

installfinish $@

echo "Run: systemctl < start / stop > trans"
echo "Startup: systemctl < enable / disable > trans"
echo
echo "Download directory: $path"
echo "WebUI: < RuneAudio_IP >:9091"
title -nt "User: root"
