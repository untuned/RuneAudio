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

wget -q --show-progress -O uninstall_aria.sh "https://github.com/rern/RuneAudio/blob/master/aria2/uninstall_aria.sh?raw=1"
chmod +x uninstall_aria.sh

if  grep '^Server = http://mirror.archlinuxarm.org/' /etc/pacman.d/mirrorlist; then
	wget -q --show-progress -O rankmirrors.sh "https://github.com/rern/RuneAudio/blob/master/rankmirrors/rankmirrors.sh?raw=1"
	chmod +x rankmirrors.sh
	./rankmirrors.sh
fi
if ! pacman -Q aria2 > /dev/null 2>&1; then
	title2 "Install Aria2 ..."
	pacman -Sy --noconfirm aria2
else
	titleend "$info Aria2 already installed."
	exit
fi

title "Get WebUI files ..."
wget -q --show-progress -O aria2.zip https://github.com/ziahamza/webui-aria2/archive/master.zip
mkdir /usr/share/nginx/html/aria2
bsdtar -xf aria2.zip -s'|[^/]*/||' -C /usr/share/nginx/html/aria2/
rm aria2.zip

mkdir /root/.config/aria2
[[ ! -e /mnt/MPD/USB/hdd/aria2 ]] && mkdir /mnt/MPD/USB/hdd/aria2
echo 'enable-rpc=true
rpc-listen-all=true
daemon=true
disable-ipv6=true
dir=/mnt/MPD/USB/hdd/aria2
max-connection-per-server=3
' > /root/.config/aria2/aria2.conf

echo '[Unit]
Description=Aria2
After=network-online.target
[Service]
Type=forking
ExecStart=/usr/bin/aria2c
[Install]
WantedBy=multi-user.target
' > /usr/lib/systemd/system/aria2.service

if ! grep -qs 'aria2' /etc/nginx/nginx.conf; then
	sed -i '/end http block/ i\
	    server { #aria2\
		listen 88;\
		location / {\
		    root  /usr/share/nginx/html/aria2;\
		    index  index.php index.html index.htm;\
		}\
	    } #aria2
	' /etc/nginx/nginx.conf
fi

title "Restart nginx ..."
systemctl restart nginx

title "$info Aria2 startup"
echo 'Enable:'
echo -e '  \e[0;36m0\e[m No'
echo -e '  \e[0;36m1\e[m Yes'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) systemctl enable aria2
		systemctl start aria2
	;;
	* ) echo;;	
esac

title2 "Aria2 successfully installed."
echo 'Uninstall: ./uninstall_aria.sh'
echo 'Start: systemctl start aria2'
echo 'Stop: systemctl stop aria2'
echo 'Download directory: /mnt/MPD/USB/hdd/aria2'
titleend "WebUI: [RuneAudio_IP]:88"
