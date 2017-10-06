#!/bin/bash

# $1-readonly name ; $2-readwrite name ; $3-password

alias=samb

. /srv/http/addonstitle.sh

if [[ $( smbd -V ) != 'Version 4.3.4' ]]; then
	title "$info Samba already upgraged."
	exit
fi
if ! mount | grep -q '/dev/sda1'; then
	title "$info No USB drive found."
	exit
fi

mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
usbroot=$( basename $mnt )
[[ $1 == 0 ]] && server=RuneAudio || server=$1
[[ $2 == 0 ]] && read=readonly || read=$2
[[ $3 == 0 ]] && readwrite=readwrite || readwrite=$3
[[ $4 == 0 ]] && pwd=rune || pwd=$4

title -l '=' "$bar Upgrade Samba ..."
timestart

gitpath=https://github.com/rern/RuneAudio/raw/master
# fix packages download errors
if  grep '^Server = http://mirror.archlinuxarm.org/' /etc/pacman.d/mirrorlist; then
	wgetnc $gitpath/rankmirrors/rankmirrors.sh
	chmod +x rankmirrors.sh
	./rankmirrors.sh
fi
pacman -Sy

systemctl stop nmbd smbd

pacman -R --noconfirm samba4-rune
pacman -S --noconfirm ldb tdb tevent smbclient samba
pacman -S --noconfirm libwbclient

# fix 'minimum rlimit_max'
echo -n '
root    soft    nofile    16384
root    hard    nofile    16384
' >> /etc/security/limits.conf

file=/etc/samba/smb-dev.conf
echo $file
wgetnc $gitpath/samba/smb-dev.conf -O $file
ln -sf /etc/samba/smb{-dev,}.conf

sed -i "/\^[global\]/ a\
	netbios name = $server
" $file

echo "
[$readwrite]
	comment = browseable, read, write, guess ok, no password
	path = $mnt/$readwrite
	read only = no
[$read]
	comment = browseable, read only, guess ok, no password
	path = $mnt/$read
[usbroot]
	comment = hidden, read, write, root with password only
	path = $mnt
	browseable = no
	read only = no
	guest ok = no
	valid users = root
" >> $file

mkdir -p $mnt/$read
mkdir -p $mnt/$readwrite
chmod 755 $mnt/$read
chmod 777 $mnt/$readwrite

# set samba password
(echo "$pwd"; echo "$pwd") | smbpasswd -s -a root

systemctl daemon-reload
systemctl restart nmbd smbd

redis-cli hset addons samb 1 &> /dev/null # mark as expanded - disable webui button

title -l '=' "$bar Samba upgraded successfully."

l=10
lr=${#read}
lrw=${#readwrite}
(( $lr > $l )) && l=$lr
(( $lrw > $l )) && l=$lrw
echo -e "$info Windows Network > RUNEAUDIO >"
printf "%-${l}s - read+write share\n" $readwrite
printf "%-${l}s - read only share\n\n" $read

printf "%-${l}s - \\\\\\$server\\usbroot > user: root + password\n\n" usbroot

echo 'Add Samba user: smbpasswd -s -a < user >'
title -nt "Edit shares: /etc/smb-dev.conf"
