#!/bin/bash

version=20170901

# install.sh [password] [webui] [startup]
#   [webui] = 1 / 0
#   [startup] = 1 / null )
#   any argument = no prompt + no package update

rm $0

if [[ ${@:$#} == -u ]]; then
	shift
	update=1
	type=updated
else
	type=installed
fi

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh
timestart

if pacman -Q transmission-cli &>/dev/null; then
	echo -e "$info Transmission already installed."
	exit
fi

# user inputs
if (( $# == 0 )); then # with no argument
	yesno "Set password:" anspwd
	[[ $anspwd == 1 ]] && setpwd

	yesno "Install WebUI alternative (Transmission Web Control):" answebui

	yesno "Start Transmission on system startup:" ansstartup
	echo
else # with arguments
	pwd1=$1
	(( $# > 1 )) && answebui=$2 || answebui=0
	(( $# > 2 )) && ansstartup=$3 || ansstartup=0
fi

gitpath=https://github.com/rern/RuneAudio/raw/master/transmission
wgetnc $gitpath/uninstall_tran.sh -P /usr/local/bin
chmod +x /usr/local/bin/uninstall_tran.sh
wgetnc $gitpath/_repo/transmission/transmission-cli-2.92-6-armv7h.pkg.tar.xz

title -l = "$bar Install Transmission ..."
pacman -U --noconfirm transmission-cli-2.92-6-armv7h.pkg.tar.xz

rm transmission-cli-2.92-6-armv7h.pkg.tar.xz

# remove conf for non-exist user 'transmission'
rm /usr/lib/tmpfiles.d/transmission.conf

if mount | grep -q '/dev/sda1'; then
	mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
	mkdir -p $mnt/transmission
	path=$mnt/transmission
else
	mkdir -p /root/transmission
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

if [[ ! $update ]]; then
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
	if [[ -n $pwd1 && $pwd1 != 0 ]]; then
		sed -i -e 's|"rpc-authentication-required": false|"rpc-authentication-required": true|
		' -e 's|"rpc-password": ".*"|"rpc-password": "'"$pwd1"'"|
		' -e 's|"rpc-username": ".*"|"rpc-username": "root"|
		' $file
	fi
else
	mv /tmp/tran/settings.json $path
fi

# web ui alternative
if [[ $answebui == 1 ]] || [[ -e /tmp/tran/answebui ]]; then
	wgetnc https://github.com/ronggang/transmission-web-control/raw/master/release/transmission-control-full.tar.gz
	rm -rf $path/web
	mv /usr/share/transmission/web $path
	mv $path/web/index{,.original.}.html
	bsdtar -xf transmission-control-full.tar.gz -C $path
	rm transmission-control-full.tar.gz
	chown -R root:root $path/web
fi

# start
systemctl daemon-reload
[[ $ansstartup == 1 ]] || [[ -e /tmp/tran/ansstartup ]] && systemctl enable trans
echo -e "$bar Start Transmission ..."
if systemctl start trans &> /dev/null; then
	redis-cli hset addons tran $version &> /dev/null
else
	title -l = "$warn Transmission install failed."
	exit
fi

rm -r /tmp/tran

timestop
title -l = "$bar Transmission $type and started successfully."
# skip if upgrade
[[ $update ]] && exit
[[ -t 1 ]] && echo "Uninstall: uninstall_tran.sh"
echo "Run: systemctl < start / stop > trans"
echo "Startup: systemctl < enable / disable > trans"
echo
echo "Download directory: $path"
echo "WebUI: < RuneAudio_IP >:9091"
title -nt "User: root"
