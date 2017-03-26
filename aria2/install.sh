#!/bin/bash

line2='\e[0;36m=========================================================\e[m'
line='\e[0;36m---------------------------------------------------------\e[m'
bar=$( echo -e "$(tput setab 6)   $(tput setab 0)" )
info=$( echo $(tput setab 6; tput setaf 0) i $(tput setab 0; tput setaf 7) )

# functions #######################################
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

rm install.sh

if ! pacman -Q aria2 > /dev/null 2>&1; then
	title2 "Install Aria2 ..."
	pacman -S --noconfirm aria2
else
	titleend "$info Aria2 already installed."
	exit
fi

mkdir /usr/share/nginx/html/aria2
cd /usr/share/nginx/html/aria2

title "Get WebUI files ..."
wget -q --show-progress -O ariauninstall.sh "https://github.com/rern/RuneAudio/blob/master/aria2/ariauninstall.sh?raw=1"; chmod +x ariauninstall.sh
wget -q --show-progress -O aria2.zip https://github.com/ziahamza/webui-aria2/archive/master.zip
bsdtar -xf aria2.zip -s'|[^/]*/||'
rm aria2.zip

mkdir /root/.config/aria2
[[ ! -e /mnt/MPD/USB/hdd/aria2 ]] && mkdir /mnt/MPD/USB/hdd/aria2
echo '
enable-rpc=true
rpc-listen-all=true
daemon=true
disable-ipv6=true
dir=/mnt/MPD/USB/hdd/aria2
max-connection-per-server=3
' > /root/.config/aria2/aria2.conf
	
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

title2 "Aria2 successfully installed."
echo "Start Aria2: aria2c"
titleend "WebUI: [RuneAudio_IP]:88"
