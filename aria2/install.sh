#!/bin/bash

# install.sh [startup]
#   [startup] = 1 / null
#   any argument = no prompt + no package update

rm $0

# import heading function
wget -qN https://raw.githubusercontent.com/rern/title_script/master/title.sh; . title.sh; rm title.sh
timestart

if pacman -Q aria2 &>/dev/null; then
	echo -e "$info Aria2 already installed."
	exit
fi

if (( $# == 0 )); then
	# user input
	yesno "Start Aria2 on system startup:"
else
	answer=$1
fi

gitpath=https://raw.githubusercontent.com/rern/RuneAudio/master
wget -qN --show-progress $gitpath/aria2/uninstall_aria.sh -P /usr/local/bin
chmod +x /usr/local/bin/uninstall_aria.sh

if  grep -q '^Server = http://mirror.archlinuxarm.org/' /etc/pacman.d/mirrorlist; then
	wget -qN --show-progress $gitpath/rankmirrors/rankmirrors.sh -P /usr/local/bin
	chmod +x /usr/local/bin/rankmirrors.sh
	rankmirrors.sh
fi

title -l = "$bar Install Aria2 ..."
# skip with any argument
(( $# == 0 )) && pacman -Sy
pacman -S --noconfirm aria2 glibc

if mount | grep -q '/dev/sda1'; then
	mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
	mkdir -p $mnt/aria2
	path=$mnt/aria2
else
	mkdir -p /root/aria2
	path=/root/aria2
fi
if (( $# == 0 )); then
	echo -e "$bar Get WebUI files ..."
	wget -qN --show-progress https://github.com/ziahamza/webui-aria2/archive/master.zip
	mkdir -p $path/web
	bsdtar -xf master.zip --strip 1 -C $path/web
	rm master.zip
fi
ln -s $path/web /srv/http/aria2

# modify file
file=/etc/nginx/nginx.conf
linenum=$( sed -n '/listen 80 /=' $file )

sed -i -e '/^\s*rewrite/ s/^\s*/&#/
' -e "$(( $linenum + 7 ))"' a\
\            rewrite /css/(.*) /assets/css/$1 break;\
\            rewrite /less/(.*) /assets/less/$1 break;\
\            rewrite /js/(.*) /assets/js/$1 break;\
\            rewrite /img/(.*) /assets/img/$1 break;\
\            rewrite /fonts/(.*) /assets/fonts/$1 break;
' -e "$(( $linenum + 9 ))"' a\
\        location /aria2 {\
\            alias /mnt/hdd/aria2/web;\
\        }\
' $file

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

# start
[[ $answer == 1 ]] && systemctl enable aria2
echo -e "$bar Start Aria2 ..."
systemctl start aria2

timestop
title -l = "$bar Aria2 installed and started successfully."
echo "Uninstall: uninstall_aria.sh"
echo "Run: systemctl [ start / stop ] aria2"
echo "Startup: systemctl [ enable /disable ] aria2"
echo
echo "Download directory: $path"
title -nt "WebUI: [RuneAudio_IP]/aria2/"
