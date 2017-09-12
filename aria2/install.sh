#!/bin/bash

version=20170901

# install.sh [startup]
#   [startup] = 1 / null
#   any argument = no prompt + no package update

rm $0

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh
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

gitpath=https://github.com/rern/RuneAudio/raw/master
wgetnc $gitpath/aria2/uninstall_aria.sh -P /usr/local/bin
chmod +x /usr/local/bin/uninstall_aria.sh

if  grep -q '^Server = http://mirror.archlinuxarm.org/' /etc/pacman.d/mirrorlist; then
	wgetnc $gitpath/rankmirrors/rankmirrors.sh
	chmod +x rankmirrors.sh
	./rankmirrors.sh
fi

[[ $1 != u ]] && title -l = "$bar Install Aria2 ..."

pacman -Sy --noconfirm aria2 glibc

if mount | grep -q '/dev/sda1'; then
	mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
	mkdir -p $mnt/aria2
	path=$mnt/aria2
else
	mkdir -p /root/aria2
	path=/root/aria2
fi

echo -e "$bar Get WebUI files ..."
wgetnc https://github.com/ziahamza/webui-aria2/archive/master.zip
rm -rf $path/web
mkdir $path/web
bsdtar -xf master.zip --strip 1 -C $path/web
rm master.zip

ln -s $path/web /srv/http/aria2

# modify file
file=/etc/nginx/nginx.conf
echo $file
if ! grep -q 'aria2' $file; then
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
\            alias '$path'/web;\
\        }\
' $file
fi

mkdir -p /root/.config/aria2
file=/root/.config/aria2/aria2.conf
echo $file
echo "enable-rpc=true
rpc-listen-all=true
daemon=true
disable-ipv6=true
dir=$path
max-connection-per-server=4
" > $file

file=/etc/systemd/system/aria2.service
echo $file
echo '[Unit]
Description=Aria2
After=network-online.target
[Service]
Type=forking
ExecStart=/usr/bin/aria2c
[Install]
WantedBy=multi-user.target
' > $file

[[ $answer == 1 ]] || [[ $( redis-cli get ariastartup ) ]] && systemctl enable aria2
redis-cli del ariastartup &> /dev/null
# start
echo -e "$bar Start Aria2 ..."
if systemctl start aria2 &> /dev/null; then
	redis-cli hset addons aria $version &> /dev/null
else
	title -l = "$warn Aria2 install failed."
	exit
fi

timestop

if [[ $1 != u ]]; then
	title -l = "$bar Aria2 installed and started successfully."
	[[ -t 1 ]] && echo "Uninstall: uninstall_aria.sh"
	echo "Run: systemctl < start / stop > aria2"
	echo "Startup: systemctl < enable / disable > aria2"
	echo
	echo "Download directory: $path"
	title -nt "WebUI: < RuneAudio_IP >/aria2/"
else
	title -l = "$bar Aria2 updated and started successfully."
fi

# refresh svg support last for directories fix
systemctl reload nginx
