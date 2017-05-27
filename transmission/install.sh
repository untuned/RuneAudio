#!/bin/bash

rm install.sh

line2='\e[0;36m=========================================================\e[m'
line='\e[0;36m---------------------------------------------------------\e[m'
bar=$( echo -e "$(tput setab 6)   $(tput setab 0)" )
info=$( echo $(tput setab 6; tput setaf 0) i $(tput setab 0; tput setaf 7) )

title2() {
	echo -e "\n$line2\n"
	echo -e "$bar $1"
	echo -e "\n$line2\n"
}
title() {
	echo -e "\n$line"
	echo $1
	echo -e "$line\n"
}
titleend() {
	echo -e "\n$1"
	echo -e "\n$line\n"
}

if ! grep -qs '/mnt/MPD/USB/hdd' /proc/mounts; then
	titleend "$info Hard drive not mount at /mnt/MPD/USB/hdd"
	exit
fi
wget -q --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/uninstall_tran.sh
chmod +x uninstall_tran.sh
wget -q --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/_repo/transmission/transmission-cli-2.92-6-armv7h.pkg.tar.xz

if ! pacman -Q transmission-cli &>/dev/null; then
	title2 "Install Transmission ..."
	pacman -U --noconfirm transmission-cli-2.92-6-armv7h.pkg.tar.xz
else
	titleend "$info Transmission already installed."
	exit
fi
rm transmission-cli-2.92-6-armv7h.pkg.tar.xz

if [[ ! -e /mnt/MPD/USB/hdd/transmission ]]; then
	mkdir /mnt/MPD/USB/hdd/transmission
	mkdir /mnt/MPD/USB/hdd/transmission/incomplete
	mkdir /mnt/MPD/USB/hdd/transmission/torrents
	chown -R transmission:transmission /mnt/MPD/USB/hdd/transmission
fi

# change user to 'root'
cp /lib/systemd/system/transmission.service /etc/systemd/system/transmission.service
sed -i 's|User=transmission|User=root|' /etc/systemd/system/transmission.service
# refresh systemd services
systemctl daemon-reload
# create settings.json
transmission-daemon
killall transmission-daemon

file='/root/.config/transmission-daemon/settings.json'
sed -i -e 's|"download-dir": ".*"|"download-dir": "/mnt/MPD/USB/hdd/transmission"|
' -e 's|"incomplete-dir": ".*"|"incomplete-dir": "/mnt/MPD/USB/hdd/transmission/incomplete"|
' -e 's|"incomplete-dir-enabled": false|"incomplete-dir-enabled": true|
' -e 's|"rpc-whitelist-enabled": true|"rpc-whitelist-enabled": false|
' -e '/[^{},]$/ s/$/\,/
' -e '/}/ i\
    "watch-dir": "/mnt/MPD/USB/hdd/transmission/torrents",\
    "watch-dir-enabled": true
' $file

title "$info Set password:"
echo -e '  \e[0;36m0\e[m No'
echo -e '  \e[0;36m1\e[m Yes'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) echo
		echo 'Username: '
		read usr 
		echo 'Password: '
		read -s pwd
		sed -i -e 's|"rpc-authentication-required": false|"rpc-authentication-required": true|
		' -e "s|\"rpc-password\": \".*\"|\"rpc-password\": \"$pwd\"|
		" -e "s|\"rpc-username\": \".*\"|\"rpc-username\": \"$usr\"|
		" $file
		;;
	* ) echo;;
esac

title "$info Start Transmission on system startup:"
echo -e '  \e[0;36m0\e[m No'
echo -e '  \e[0;36m1\e[m Yes'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) systemctl enable transmission;;
	* ) echo;;
esac

title "$info Start Transmission now:"
echo -e '  \e[0;36m0\e[m No'
echo -e '  \e[0;36m1\e[m Yes'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) systemctl start transmission;;
	* ) echo;;
esac

title2 "Transmission installed successfully."
echo 'Uninstall: ./uninstall_tran.sh'
echo 'Start: transmission-daemon'
echo 'Stop: killall transmission-daemon'
echo 'Download directory: /mnt/MPD/USB/hdd/transmission'
titleend "WebUI: [RuneAudio_IP]:9091"
