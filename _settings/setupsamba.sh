#!/bin/bash

rm $0

[[ ! -e /srv/http/addonstitle.sh ]] && wget -q https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/addonstitle.sh -P /srv/http
. /srv/http/addonstitle.sh

# password
echo -e "$bar root password ..."
setpwd

pacman -Sy

title -l '=' "$bar Upgrade Samba ..."
timestart

systemctl stop nmbd smbd

pacman -R --noconfirm samba4-rune
pacman -S --noconfirm --force libnsl
pacman -S --noconfirm ldb libtirpc tdb tevent smbclient samba
pacman -S --noconfirm libwbclient

# fix 'minimum rlimit_max'
echo -n '
root    soft    nofile    16384
root    hard    nofile    16384
' >> /etc/security/limits.conf

# fix missing smbd startup
sed -i '/smb-prod/ a\
        sysCmd("systemctl start smb");\
        sysCmd("pgrep smb || systemctl start smb");
' /srv/http/command/rune_SY_wrk

wgetnc https://github.com/rern/RuneAudio/blob/master/_settings/smb.conf -O /etc/samba/smb.conf

(echo "$pwd"; echo "$pwd") | smbpasswd -s -a root

systemctl daemon-reload

echo -e "$bar Start Samba ..."
if ! systemctl restart nmb smb &> /dev/null; then
	title -l = "$warn Samba upgrade failed."
	exit
fi

redis-cli hset addons samb 1 &> /dev/null

timestop
title -l '=' "$bar Samba upgraded successfully."
