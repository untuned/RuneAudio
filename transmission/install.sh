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
setpwd() {
	echo
	echo 'Password: '
	read -s pwd1
	echo
	echo 'Retype password: '
	read -s pwd2
	echo
	if [[ $pwd1 != $pwd2 ]]; then
		echo
		echo "$info Passwords not matched. Try again."
		setpwd
	fi
}

# user inputs
if (( $# == 0 )); then # with no argument
	title "$info Set password:"
	echo -e '  \e[0;36m0\e[m No'
	echo -e '  \e[0;36m1\e[m Yes'
	echo
	echo -e '\e[0;36m0\e[m / 1 ? '
	read -n 1 anspwd
	[[ $anspwd == 1 ]] && setpwd

	title "$info Install WebUI alternative (Transmission Web Control):"
	echo -e '  \e[0;36m0\e[m No'
	echo -e '  \e[0;36m1\e[m Yes'
	echo
	echo -e '\e[0;36m0\e[m / 1 ? '
	read -n 1 answebui

	title "$info Start Transmission on system startup:"
	echo -e '  \e[0;36m0\e[m No'
	echo -e '  \e[0;36m1\e[m Yes'
	echo
	echo -e '\e[0;36m0\e[m / 1 ? '
	read -n 1 ansstartup
	echo
else # with arguments
	pwd1=$1
	(( $# > 1 )) && answebui=$2 || answebui=0
	(( $# > 2 )) && ansstartup=$3 || ansstartup=0
fi

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/uninstall_tran.sh
chmod +x uninstall_tran.sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/_repo/transmission/transmission-cli-2.92-6-armv7h.pkg.tar.xz

if ! pacman -Q transmission-cli &>/dev/null; then
	title2 "Install Transmission ..."
	pacman -U --noconfirm transmission-cli-2.92-6-armv7h.pkg.tar.xz
else
	titleend "$info Transmission already installed."
	exit
fi
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

# custom systemd unit
systemctl stop transmission
systemctl disable transmission
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

title "$info Set password:"
echo -e '  \e[0;36m0\e[m No'
echo -e '  \e[0;36m1\e[m Yes'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
if [[ $anspwd == 1 ]] && [[ -n $pwd1 ]]; then
	sed -i -e 's|"rpc-authentication-required": false|"rpc-authentication-required": true|
	' -e 's|"rpc-password": ".*"|"rpc-password": "'"$pwd1"'"|
	' -e 's|"rpc-username": ".*"|"rpc-username": "root"|
	' $file
fi

# web ui alternative
if [[ $answebui == 1 ]]; then
	wget -qN --show-progress https://github.com/ronggang/transmission-web-control/raw/master/release/transmission-control-full.tar.gz
	mv /usr/share/transmission/web $path
	mv $path/web/index.html $path/web/index.original.html
	bsdtar -xf transmission-control-full.tar.gz -C $path
	rm transmission-control-full.tar.gz
	chown -R root:root $path/web
fi

# start
[[ $ansstartup == 1 ]] && systemctl enable transmission
title "Start Transmission ..."
systemctl start transmission

title2 "Transmission installed and started successfully."
echo 'Uninstall: ./uninstall_tran.sh'
echo 'Start: systemctl start transmission'
echo 'Stop:  systemctl stop transmission'
echo 'Download directory: '$path
echo 'WebUI: [RuneAudio_IP]:9091'
titleend "user: root"
