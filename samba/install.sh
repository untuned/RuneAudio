#!/bin/bash

rm $0

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

if [[ $( smbd -V ) != 'Version 4.3.4' ]]; then
	echo -e "$info Samba already upgraged."
	redis-cli hset addons samb 1 &> /dev/null
	exit
fi

title -l = "$bar Upgrade Samba ..."
#################################################################################
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
pacman -S --noconfirm tdb tevent smbclient samba
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

# set samba password
(echo $1; echo $1) | smbpasswd -s -a root

systemctl daemon-reload
systemctl restart nmbd smbd

redis-cli hset addons samb 1 &> /dev/null

timestop
title -l = "$bar Samba upgraded successfully."
title -nt "$info Edit /etc/smb-dev.conf to fit usage."
