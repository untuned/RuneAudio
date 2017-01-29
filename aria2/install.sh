#!/bin/bash

pacman -Sy --noconfirm aria2

mkdir /usr/share/nginx/html/aria2
cd /usr/share/nginx/html/aria2
wget -O aria2.zip https://github.com/ziahamza/webui-aria2/archive/master.zip
bsdtar -xf aria2.zip -s'|[^/]*/||'
rm aria2.zip

echo '
enable-rpc=true
rpc-listen-all=true

daemon=true
disable-ipv6=true
' > /root/.config/aria2/aria2.conf

sed '/end http block/ i\
    server {\
        listen 8888;\
        location / {\
            root  /usr/share/nginx/html/aria2;\
            index  index.php index.html index.htm;\
        }\
    }\
' /etc/nginx/nginx.conf
