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

label=$( e2label /dev/sda1 )
title "$info Rename current USB label '$label':"
echo -e '  \e[0;36m0\e[m No'
echo -e '  \e[0;36m1\e[m Yes'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) echo
		echo 'New label: '
		read -n 1 label
		e2label /dev/sda1 $label
		;;
	* ) echo;;
esac

if ! grep -qs "/mnt/MPD/USB/$label" /proc/mounts; then
	titleend "$info Hard drive not mount at /mnt/MPD/USB/$label"
	exit
fi
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/uninstall_tran.sh
chmod +x uninstall_tran.sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/_repo/transmission/transmission-cli-2.92-6-armv7h.pkg.tar.xz

if  grep '^Server = http://mirror.archlinuxarm.org/' /etc/pacman.d/mirrorlist; then
	wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh
	chmod +x rankmirrors.sh
	./rankmirrors.sh
fi
if ! pacman -Q transmission-cli &>/dev/null; then
	title2 "Install Transmission ..."
	pacman -U --noconfirm transmission-cli-2.92-6-armv7h.pkg.tar.xz
else
	titleend "$info Transmission already installed."
	exit
fi
rm transmission-cli-2.92-6-armv7h.pkg.tar.xz

if [[ ! -e /media/$label ]]; then
	mkdir /media
	ln -s /mnt/MPD/USB/$label/ /media/$label
fi
path=/media/$label/transmission
mkdir -p $path/{incomplete,watch}
#chown -R transmission:transmission $path

# change user to 'root'
cp /lib/systemd/system/transmission.service /etc/systemd/system/transmission.service
sed -i -e 's|User=transmission|User=root|
' -e '/transmission-daemon -f --log-error$/ s|$| --config-dir '"$path"'|
' /etc/systemd/system/transmission.service
# refresh systemd services
systemctl daemon-reload
# create settings.json
systemctl start transmission
killall transmission-daemon
sleep 1
file=$path/settings.json
sed -i -e 's|"download-dir": ".*"|"download-dir": "'"$path"'"|
' -e 's|"incomplete-dir": ".*"|"incomplete-dir": "'"$path"'/incomplete"|
' -e 's|"incomplete-dir-enabled": false|"incomplete-dir-enabled": true|
' -e 's|"rpc-whitelist-enabled": true|"rpc-whitelist-enabled": false|
' -e '/[^{},]$/ s/$/\,/
' -e '/}/ i\
    "watch-dir": "'"$path"'/watch",\
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
		echo 'Password: '
		read -s pwd
		sed -i -e 's|"rpc-authentication-required": false|"rpc-authentication-required": true|
		' -e 's|"rpc-password": ".*"|"rpc-password": "'"$pwd"'"|
		' -e 's|"rpc-username": ".*"|"rpc-username": "root"|
		' $file
		;;
	* ) echo;;
esac
# hash password by start
systemctl start transmission

# web ui alternative
title "$info Install WebUI alternative (Transmission Web Control):"
echo -e '  \e[0;36m0\e[m No'
echo -e '  \e[0;36m1\e[m Yes'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) echo
		wget -qN --show-progress https://github.com/ronggang/transmission-web-control/raw/master/release/transmission-control-full.tar.gz
		mv /usr/share/transmission/web/index.html /usr/share/transmission/web/index.original.html
		bsdtar -xf transmission-control-full.tar.gz -C /usr/share/transmission
		chown -R root:root /usr/share/transmission/web
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
	1 ) echo;;
	* ) systemctl stop transmission;;
esac

title2 "Transmission installed successfully."
echo 'Uninstall: ./uninstall_tran.sh'
echo 'Start: systemctl start transmission'
echo 'Stop:  systemctl stop transmission'
echo 'Download directory: '$path
echo 'WebUI: [RuneAudio_IP]:9091'
titleend "user: root"
