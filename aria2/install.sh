#!/bin/bash

# install.sh [startup]
#   [startup] = 1 / null
#   any argument = no prompt + no package update

# import heading function
wget -qN https://github.com/rern/tips/raw/master/bash/f_heading.sh; . f_heading.sh; rm f_heading.sh

rm install.sh

if pacman -Q aria2 &>/dev/null; then
	titleend "$info Aria2 already installed."
	exit
fi

if (( $# == 0 )); then
	# user input
	titleinfo "Start Aria2 on system startup:"
	echo -e '  \e[0;36m0\e[m No'
	echo -e '  \e[0;36m1\e[m Yes'
	echo
	echo -e '\e[0;36m0\e[m / 1 ? '
	read -n 1 ansstartup
	echo
else
	ansstartup=$1
fi

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/uninstall_aria.sh
chmod +x uninstall_aria.sh

if  grep '^Server = http://mirror.archlinuxarm.org/' /etc/pacman.d/mirrorlist; then
	wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh
	chmod +x rankmirrors.sh
	./rankmirrors.sh
fi

title2 "Install Aria2 ..."
# skip with any argument
(( $# == 0 )) && pacman -Sy
pacman -S --noconfirm aria2 glibc

if mount | grep '/dev/sda1' &>/dev/null; then
	mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
	mkdir -p $mnt/aria2
	path=$mnt/aria2
else
	mkdir -p /root/aria2
	path=/root/aria2
fi
if (( $# == 0 )); then
	title "Get WebUI files ..."
	wget -qN --show-progress https://github.com/ziahamza/webui-aria2/archive/master.zip
	mkdir -p $path/web
	bsdtar -xf master.zip -s'|[^/]*/||' -C $path/web
	rm master.zip
fi

mkdir -p /root/.config/aria2
echo "enable-rpc=true
rpc-listen-all=true
daemon=true
disable-ipv6=true
dir=$path
max-connection-per-server=4
" > /root/.config/aria2/aria2.conf

echo '[Unit]
Description=Aria2
After=network-online.target
[Service]
Type=forking
ExecStart=/usr/bin/aria2c
[Install]
WantedBy=multi-user.target
' > /etc/systemd/system/aria2.service

if ! grep -qs 'aria2' /etc/nginx/nginx.conf; then
	sed -i '/end http block/ i\
		\tserver { #aria2\
		\t\tlisten 88;\
		\t\tlocation / {\
			\t\t\troot  '$path'/web;\
			\t\t\tindex  index.php index.html index.htm;\
		\t\t}\
		\t} #aria2
	' /etc/nginx/nginx.conf
fi

title "Restart NGINX ..."
systemctl restart nginx

# start
[[ $ansstartup == 1 ]] && systemctl enable aria2
title "Start Aria2 ..."
systemctl start aria2

title2 "Aria2 installed and started successfully."
echo Uninstall: ./uninstall_aria.sh
echo Run: systemctl [ start / stop ] aria2
echo Startup: systemctl [ enable /disable ] aria2
echo
echo Download directory: $path
titleend "WebUI: [RuneAudio_IP]:88"
