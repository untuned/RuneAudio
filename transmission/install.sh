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
wget -q --show-progress -O uninstall_tran.sh "https://github.com/rern/RuneAudio/blob/master/transmission/tranuninstall.sh?raw=1"
chmod +x uninstall_tran.sh
if [[ ! -e rankmirrors.sh ]]; then
	wget -q --show-progress -O rankmirrors.sh "https://github.com/rern/RuneAudio/blob/master/rankmirrors/rankmirrors.sh?raw=1"
	chmod +x rankmirrors.sh
	./rankmirrors.sh
fi

file='/var/lib/transmission/.config/transmission-daemon/settings.json'

if ! pacman -Q transmission-cli > /dev/null 2>&1; then
	title2 "Install Transmission ..."
	pacman -Sy --noconfirm transmission-cli
fi
if [[ ! -e $file ]]; then
	systemctl start transmission
	systemctl stop transmission
fi

if [[ ! -e /mnt/MPD/USB/hdd/transmission ]]; then
	mkdir /mnt/MPD/USB/hdd/transmission
	mkdir /mnt/MPD/USB/hdd/transmission/incomplete
	mkdir /mnt/MPD/USB/hdd/transmission/torrents
	chown -R transmission:transmission /mnt/MPD/USB/hdd/transmission
fi

sed -i -e 's|"download-dir": ".*"|"download-dir": "/mnt/MPD/USB/hdd/transmission"|
' -e 's|"incomplete-dir": ".*"|"incomplete-dir": "/mnt/MPD/USB/hdd/transmission/incomplete"|
' -e 's|"incomplete-dir-enabled": false|"incomplete-dir-enabled": true|
' -e 's|"rpc-whitelist": "127.0.0.1"|"rpc-whitelist": "*.*.*.*"|
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
		sed -i -e 's|"rpc-authentication-required": false,|"rpc-authentication-required": true,|
		' -e "s|\"rpc-password\": \".*\",|\"rpc-password\": \"$pwd\",|
		" -e "s|\"rpc-username\": \".*\",|\"rpc-username\": \"$usr\",|
		" $file
		;;
	* ) echo;;
esac

title "$info Enable transmission on system startup:"
echo -e '  \e[0;36m0\e[m No'
echo -e '  \e[0;36m1\e[m Yes'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) systemctl enable transmission
		systemctl start transmission;;
	* ) echo;;
esac

title2 "Transmission installed successfully."
echo 'Uninstall: ./uninstall_tran.sh'
echo 'Start: systemctl start transmission'
echo 'Stop: systemctl stop transmission'
echo 'Download directory: /mnt/MPD/USB/hdd/transmission'
titleend "WebUI: [RuneAudio_IP]:9091"
