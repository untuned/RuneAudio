#!/bin/bash

# sharename: $1-read ; $2-readwrite

alias=samb

. /srv/http/addonstitle.sh

installstart

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

wgetnc $gitpath/samba/uninstall_samb.sh -P /usr/local/bin
chmod +x /usr/local/bin/uninstall_samb.sh
wgetnc $gitpath/samba/smb-dev.conf -O /etc/samba/smb-dev.conf
ln -sf /etc/samba/smb{-dev,}.conf

label=$( e2label /dev/sda1 )
read=$1
readwrite=$2

echo "
[$readwrite]
	comment = browseable, read, write, guess ok, no password
	path = /mnt/MPD/USB/$label/$readwrite
	read only = no
[$read]
	comment = browseable, read only, guess ok, no password
	path = /mnt/MPD/USB/$label/$read
[$label]
	comment = hidden, read, write, root with password only, from [IP1] [IP2] only
	path = /mnt/MPD/USB/$label
	browseable = no
	read only = no
	guest ok = no
	valid users = root
" >> /etc/samba/smb-dev.conf

mkdir -p /mnt/MPD/USB/$label/$read
mkdir -p /mnt/MPD/USB/$label/$readwrite
chmod 755 /mnt/MPD/USB/$label/$read
chmod 777 /mnt/MPD/USB/$label/$readwrite

# set samba password
(echo $1; echo $1) | smbpasswd -s -a root

systemctl daemon-reload
systemctl restart nmbd smbd

installfinish

l=${#read}
lrw=${#readwrite}
ll=${#label}
(( $lrw > $l )) && l=$lrw
(( $ll > $l )) && l=$ll
echo -e "$info Windows Network > RUNEAUDIO >"
printf "%-${l}s - read + write\n" $readwrite
printf "%-${l}s - read only\n\n" $read

printf "%-${l}s - 'Map network drive...' only\n\n" $label

echo 'Add Samba user: smbpasswd -s -a < user >'
title -nt "Edit /etc/smb-dev.conf if needed."
