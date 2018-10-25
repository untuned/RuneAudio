#!/bin/bash

#  $1-password ; $2-server name ; $3-readonly name ; $4-readwrite name

alias=samb

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

smbdv=$( smbd -V )
if [[ $smbdv != 'Version 4.3.4' && $smbdv != 'Version 4.8.1' ]]; then
	redis-cli hset addons samb 1 &> /dev/null # mark as upgraded - disable button
	title "$info Samba already upgraded."
	title -nt "Further upgrade: pacman -Sy samba"
	exit
fi
if ! mount | grep -q '/dev/sda1'; then
	title "$info No USB drive found."
	exit
fi

title -l '=' "$bar Upgrade Samba ..."
timestart

echo -e "$bar Prefetch packages ..."
pacman -Syw libnsl ldb libtirpc tdb tevent smbclient samba libwbclient

systemctl stop nmbd smbd

pacman -Sy

mv /etc/samba/smb.conf{,.backup}

pacman -R --noconfirm samba4-rune
pacman -S --noconfirm --force libnsl
pacman -S --noconfirm ldb libtirpc tdb tevent smbclient samba
pacman -S --noconfirm libwbclient

# fix 'minimum rlimit_max'
echo -n '
root    soft    nofile    16384
root    hard    nofile    16384
' >> /etc/security/limits.conf

# remove rune default startup if any
file=/srv/http/command/rune_SY_wrk
comment 'start samba services' -n -1 '$kernel ='

if (( $# > 1 )); then
	file=/etc/samba/smb.conf
	echo $file
	wgetnc https://github.com/rern/RuneAudio/raw/master/samba/smb.conf -O $file

	mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
	usbroot=$( basename $mnt )
	server=$2
	read=$3
	readwrite=$4

	sed -i '/^\[global\]/ a\
	\tnetbios name = '"$2"'
	' $file

	echo "
	[$read]
		comment = browseable, read only, guess ok, no password
		path = $mnt/$read
	[$readwrite]
		comment = browseable, read, write, guess ok, no password
		path = $mnt/$readwrite
		read only = no
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
else
	mv /etc/samba/smb.conf{.backup,}
fi

systemctl daemon-reload

echo -e "$bar Start Samba ..."
if ! systemctl restart nmb smb &> /dev/null; then
	title -l = "$warn Samba upgrade failed."
	exit
fi

# startup
systemctl enable nmb smb

# set samba password
[[ $1 == 0 || $# -eq 0 ]] && pwd=rune || pwd=$1
(echo "$pwd"; echo "$pwd") | smbpasswd -s -a root

sambaversion=$(  smbd -V | cut -d' ' -f2 )

redis-cli hset addons samb 1 &> /dev/null # mark as upgraded - disable button

timestop
title -l '=' "$bar Samba upgraded successfully to $sambaversion"
echo -e "$info Next upgrade: pacman -Sy samba"

if (( $# > 1 )); then
	l=10
	lr=${#read}
	lrw=${#readwrite}
	(( $lr > $l )) && l=$lr
	(( $lrw > $l )) && l=$lrw
	echo -e "$info Windows Network > $server >"
	printf "%-${l}s - read+write share\n" $readwrite
	printf "%-${l}s - read only share\n\n" $read
else
	server=$( hostname )
fi

printf "%-${l}s - "'\\\\'"$server"'\\'"usbroot > user: root + password\n\n" usbroot

echo 'Add Samba user: smbpasswd -s -a < user >'
title -nt "Edit shares: /etc/smb-dev.conf"
