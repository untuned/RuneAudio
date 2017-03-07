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

title "$bar Install Transmission ..."
pacman -Sy --noconfirm transmission-cli

systemctl start transmission
systemctl stop transmission

mkdir /mnt/MPD/USB/hdd/transmission
mkdir /mnt/MPD/USB/hdd/transmission/incomplete
mkdir /mnt/MPD/USB/hdd/transmission/torrents
chown -R transmission:transmission /mnt/MPD/USB/hdd/transmission

file='/var/lib/transmission/.config/transmission-daemon/settings.json'

sed -i -e 's|"download-dir": "/var/lib/transmission/Downloads",|"download-dir": "/mnt/MPD/USB/hdd/transmission",|
' -e 's|"incomplete-dir": "/var/lib/transmission/Downloads",|"incomplete-dir": "/mnt/MPD/USB/hdd/transmission/incomplete",|
' -e 's|"incomplete-dir-enabled": false,|"incomplete-dir-enabled": true,|
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
			read pwd
			sed -i -e 's|"rpc-authentication-required": false,|"rpc-authentication-required": true,|
			' -e "s|\"rpc-password\": \".*\",|\"rpc-password\": \"$pwd\",|
			" -e "s|\"rpc-username\": \"\",|\"rpc-username\": \"$usr\",|
			' $file
		;;
	* ) echo;;
esac

title "$bar Transmission installed successfully."
echo 'Start: systemctl start transmission'
titleend "Web Interface: [IP address]:9091"
