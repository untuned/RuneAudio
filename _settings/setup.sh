#!/bin/bash

# command shortcuts and motd
# passwords for samba and transmission
# disable wifi, hdmi mode, fstab, pacman cache
# preload osmc pre-setup
# restore settings
# upgrade samba
# install transmission
# install aria2
# install rune enhancement
# install rune gpio

rm $0

mmc() {
	[[ $2 ]] && mntdir=/tmp/$2 || mntdir=/tmp/p$1
	if [[ ! $( mount | grep $mntdir ) ]]; then
		mkdir -p $mntdir
		mount /dev/mmcblk0p$1 $mntdir
	fi
}

# import heading function
wget -qN --show-progress https://github.com/rern/RuneAudio_Addons/raw/master/title.sh; . title.sh; rm title.sh
timestart l

# command shortcuts
gitpath=https://github.com/rern/RuneAudio/raw/master
[[ ! -e /etc/profile.d/cmd.sh ]] && wgetnc $gitpath/_settings/cmd.sh -P /etc/profile.d

# passwords for samba and transmission
echo -e "$bar root password for Samba and Transmission ..."
setpwd

echo -e "$bar Disable WiFi ..."
#################################################################################
systemctl disable netctl-auto@wlan0
systemctl stop netctl-auto@wlan0 shairport udevil upmpdcli
echo

echo -e "$bar Set HDMI mode ..."
#################################################################################
mmc 1
mmc 6
# force hdmi mode, remove black border (overscan)
hdmimode='
hdmi_group=1
hdmi_mode=31
disable_overscan=1
hdmi_ignore_cec=1'

! grep -q '^hdmi_mode=' /tmp/p1/config.txt && echo "$hdmimode" >> /tmp/p1/config.txt
! grep -q '^hdmi_mode=' /tmp/p6/config.txt && echo "$hdmimode" >> /tmp/p6/config.txt
! grep -q '^hdmi_mode=' /boot/config.txt && echo "$hdmimode" >> /boot/config.txt
echo

echo -e "$bar Mount USB drive to /mnt/hdd ..."
#################################################################################
# disable auto update mpd database
systemctl stop mpd
sed -i '/^sendMpdCommand/ s|^|//|' /srv/http/command/usbmount
sed -i '/^KERNEL/ s/^/#/' /etc/udev/rules.d/rune_usb-stor.rules
udevadm control --reload-rules && udevadm trigger

mnt0=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
label=${mnt0##/*/}
mnt="/mnt/$label"
mkdir -p "$mnt"
if ! grep -q $mnt /etc/fstab; then
	echo "/dev/sda1  $mnt  ext4  defaults,noatime" >> /etc/fstab
	umount -l /dev/sda1
	mount -a
fi
[[ -e /mnt/MPD/USB/hdd && $( ls -1 /mnt/MPD/USB/hdd | wc -l ) == 0 ]] && rm -r /mnt/MPD/USB/hdd
find /mnt/hdd/Music -maxdepth 1 -mindepth 1 -type d -print0 | xargs -0 ln -sf -t /mnt/MPD/USB

echo -e "\n$bar Set pacman cache ...\n"
#################################################################################
mkdir -p $mnt/varcache/pacman
rm -rf /var/cache/pacman
ln -sf $mnt/varcache/pacman /var/cache/pacman

echo -e "$bar OSMC pre-setup ..."
#################################################################################
mmc 7
if [[ ! -e /tmp/p7/walkthrough_completed ]]; then
	wgetnc https://github.com/rern/OSMC/raw/master/_settings/presetup.sh
	. presetup.sh
fi
echo

echo -e "$bar Restore settings ..."
#################################################################################
# settings
systemctl stop redis
file=/var/lib/redis/rune.rdb
#mv $file{,.original}
wgetnc $gitpath/_settings/rune.rdb -O $file              # database
#chown redis:redis $file
#chmod 644 $file
systemctl start redis
restartredis() {
	sleep 1
	systemctl start redis
}
systemctl status redis | grep -q 'dead' && restartredis

# create webradio files
i=1
str=''
redis-cli hgetall webradios | \
while read line; do
	if [[ $(( i % 2)) == 1 ]]; then
		str+="[playlist]\nNumberOfEntries=1\nFile1=$line\n"
		filename="${line}.pls"
	else
		str+="Title1=$line"
		echo -e "$str" > "/mnt/MPD/Webradio/$filename"
		str=''
	fi
	(( i++ ))
done

# extra command for some settings
ln -sf /usr/share/zoneinfo/Asia/Bangkok /etc/localtime # set timezone
#hostnamectl set-hostname RT-AC66U                     # set hostname
sed -i 's/info,man/info,locale,man/' /usr/local/bin/osmcreset
sed -i "s/opcache.enable=./opcache.enable=$( redis-cli get opcache )/" /etc/php/conf.d/opcache.ini
systemctl restart php-fpm

# mpd database
systemctl stop mpd
file=/var/lib/mpd/mpd.db
#mv $file{,.original}
wgetnc $gitpath/_settings/mpd.db -O $file
#chown mpd:audio $file
#chmod 644 $file
systemctl start mpd
sleep 1
mpc update Webradio &> /dev/null

sed -i 's/8000/1000/' /srv/http/assets/js/runeui.js        # change pnotify 8 to 1 sec
sed -i -e '/m:0x0 + c:180/ s/^#//
' -e '/m:0x0 + c:180/ i\
"/root/gpioon.py"
' -e '/m:0x8 + c:64/ s/^#//
' -e '/m:0x8 + c:64/ i\
"/root/gpiooff.py"
' /root/.xbindkeysrc
echo

# rankmirrors
wgetnc $gitpath/rankmirrors/rankmirrors.sh; chmod +x rankmirrors.sh; ./rankmirrors.sh 1

# addons menu
wgetnc https://github.com/rern/RuneAudio_Addons/raw/master/install.sh; chmod +x install.sh; ./install.sh

# motd
wgetnc $gitpath/motd/install.sh; chmod +x install.sh; ./install.sh
touch /root/.hushlogin

title -l = "$bar Upgrade Samba ..."
#################################################################################
timestart
pacman -R --noconfirm samba4-rune
pacman -S --noconfirm tdb tevent smbclient samba
# fix missing libreplace-samba4.so (may need to run twice)
pacman -S --noconfirm libwbclient

# fix 'minimum rlimit_max'
echo -n '
root    soft    nofile    16384
root    hard    nofile    16384
' >> /etc/security/limits.conf

wgetnc $gitpath/_settings/smb.conf -O /etc/samba/smb-dev.conf
ln -sf /etc/samba/smb-dev.conf /etc/samba/smb.conf

# set samba password
(echo $pwd1; echo $pwd1) | smbpasswd -s -a root

timestop
title -l = "$bar Samba upgraded successfully."
echo

# Transmission
#################################################################################
wgetnc $gitpath/transmission/install.sh; chmod +x install.sh; ./install.sh $pwd1 1 1
echo

# Aria2
#################################################################################
wgetnc $gitpath/aria2/install.sh; chmod +x install.sh; ./install.sh 1
echo

# Enhancement
#################################################################################
wgetnc https://github.com/rern/RuneUI_enhancement/raw/master/install.sh; chmod +x install.sh; ./install.sh 1.5
echo

# GPIO
#################################################################################
wgetnc $gitpath/_settings/mpd.conf.gpio -P /etc
wgetnc $gitpath/_settings/gpio.json -P /srv/http
wgetnc https://github.com/rern/RuneUI_GPIO/raw/master/install.sh; chmod +x install.sh; ./install.sh 1
echo

systemctl reload php-fpm

# systemctl daemon-reload # done in GPIO install
systemctl restart nmbd smbd

# show installed packages status
echo -e "$bar Installed packages status"
systemctl | egrep 'aria2|nmbd|smbd|transmission'

# update library
#echo -e "$bar MPD library updating ..."
#mpc update &> /dev/null

timestop l
title -l = "$bar Setup finished successfully."
