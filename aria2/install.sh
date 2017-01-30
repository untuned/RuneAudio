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

title "Install Aria2 ..."
pacman -Sy --noconfirm aria2

mkdir /usr/share/nginx/html/aria2
cd /usr/share/nginx/html/aria2

title "Get WebUI files ..."
wget -O aria2.zip https://github.com/ziahamza/webui-aria2/archive/master.zip
bsdtar -xf aria2.zip -s'|[^/]*/||'
rm aria2.zip

mkdir /root/.config/aria2
echo 'enable-rpc=true
rpc-listen-all=true
daemon=true
disable-ipv6=true
' > /root/.config/aria2/aria2.conf

sed -i '/end http block/ i\
    server {\
        listen 88;\
        location / {\
            root  /usr/share/nginx/html/aria2;\
            index  index.php index.html index.htm;\
        }\
    }
' /etc/nginx/nginx.conf

title "Restart nginx ..."
systemctl restart nginx

title "Aria2 successfully installed."
echo "Start Aria2: aria2c"
titleend "WebUI: [RuneAudio_IP]:88"
