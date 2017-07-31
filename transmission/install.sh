#!/bin/bash

# install.sh [password] [webui] [startup]
#   [webui] = 1 / 0
#   [startup] = 1 / null )
#   any argument = no prompt + no package update

rm $0

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh
timestart

if pacman -Q transmission-cli &>/dev/null; then
	echo -e "$info Transmission already installed."
	exit
fi

# user inputs
if (( $# == 0 )); then # with no argument
	yesno "$info Set password:" anspwd
	[[ $anspwd == 1 ]] && setpwd

	yesno "$info Install WebUI alternative (Transmission Web Control):" answebui

	yesno "$info Start Transmission on system startup:" ansstartup
	echo
else # with arguments
	pwd1=$1
	(( $# > 1 )) && answebui=$2 || answebui=0
	(( $# > 2 )) && ansstartup=$3 || ansstartup=0
fi

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/uninstall_tran.sh
chmod +x uninstall_tran.sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/_repo/transmission/transmission-cli-2.92-6-armv7h.pkg.tar.xz

title -l = "$bar Install Transmission ..."
pacman -U --noconfirm transmission-cli-2.92-6-armv7h.pkg.tar.xz

rm transmission-cli-2.92-6-armv7h.pkg.tar.xz

# remove conf for non-exist user 'transmission'
rm /usr/lib/tmpfiles.d/transmission.conf

if mount | grep '/dev/sda1' &>/dev/null; then
	mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
	mkdir -p $mnt/transmission
	path=$mnt/transmission
else
	mkdir -p /root/transmission
	path=/root/transmission
fi
mkdir -p $path/{incomplete,watch}

systemctl stop transmission
systemctl disable transmission

# custom systemd unit
cp /lib/systemd/system/transmission*.service /etc/systemd/system/transmission.service
sed -i -e 's|User=.*|User=root|
' -e '/ExecStart/ i\
Environment=TRANSMISSION_HOME='$path'\
Environment=TRANSMISSION_WEB_HOME='$path'/web
' /etc/systemd/system/transmission.service
systemctl daemon-reload

# create settings.json
file=$path/settings.json
[[ -e $file ]] && rm $file
systemctl start transmission; systemctl stop transmission

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
if [[ -n $pwd1 ]]; then
	sed -i -e 's|"rpc-authentication-required": false|"rpc-authentication-required": true|
	' -e 's|"rpc-password": ".*"|"rpc-password": "'"$pwd1"'"|
	' -e 's|"rpc-username": ".*"|"rpc-username": "root"|
	' $file
fi

# web ui alternative
if [[ $answebui == 1 ]]; then
	wget -qN --show-progress https://github.com/ronggang/transmission-web-control/raw/master/release/transmission-control-full.tar.gz
	cp /usr/share/transmission/web $path
	mv $path/web/index{,.original.}.html
	bsdtar -xf transmission-control-full.tar.gz -C $path
	rm transmission-control-full.tar.gz
	chown -R root:root $path/web
fi

# start
[[ $ansstartup == 1 ]] && systemctl enable transmission
echo -e "$bar Start Transmission ..."
systemctl start transmission

timestop
title -l = "$bar Transmission installed and started successfully."
echo "Uninstall: ./uninstall_tran.sh"
echo "Run: systemctl [ start / stop ] transmission"
echo "Startup: systemctl [ enable / disable ] transmission"
echo
echo "Download directory: $path"
echo "WebUI: [RuneAudio_IP]:9091"
title -nt "User: root"
