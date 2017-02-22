#!/bin/bash

line='\e[0;36m---------------------------------------------------------\e[m'
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
	title "Install Aria2 ..."
	pacman -S --noconfirm aria2
fi

mkdir /usr/share/nginx/html/aria2
cd /usr/share/nginx/html/aria2

title "Get WebUI files ..."
wget -q --show-progress -O aria2.zip https://github.com/ziahamza/webui-aria2/archive/master.zip
bsdtar -xf aria2.zip -s'|[^/]*/||'
rm aria2.zip

if [ ! -e /root/.config/aria2/aria2.conf ]; then
	mkdir /root/.config/aria2
	mkdir /mnt/MPD/USB/hdd/aria2
	echo '
	enable-rpc=true
	rpc-listen-all=true
	daemon=true
	disable-ipv6=true
	dir=/mnt/MPD/USB/hdd/aria2
	max-connection-per-server=3
	' > /root/.config/aria2/aria2.conf
fi
fi grep -qs 'aria2' /etc/nginx/nginx.conf; then
	sed -i '/end http block/ i\
	    server {\
		listen 88;\
		location / {\
		    root  /usr/share/nginx/html/aria2;\
		    index  index.php index.html index.htm;\
		}\
	    }
	' /etc/nginx/nginx.conf
fi

title "Restart nginx ..."
systemctl restart nginx

title "Aria2 successfully installed."
echo "Start Aria2: aria2c"
titleend "WebUI: [RuneAudio_IP]:88"
