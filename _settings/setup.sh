#!/bin/bash

# import heading and password function
wget -qN https://github.com/rern/tips/raw/master/bash/f_heading.sh; . f_heading.sh; rm f_heading.sh
wget -qN https://github.com/rern/tips/raw/master/bash/f_password.sh; . f_password.sh; rm f_password.sh

rm setup.sh

# passwords
title "$info root password for Samba and Transmission ..."
setpwd

title2 "Disable WiFi ..."
#################################################################################
systemctl disable netctl-auto@wlan0.service

title2 "Set HDMI mode ..."
#################################################################################
# prevent noobs cec hdmi power on
mkdir -p /tmp/p1
mount /dev/mmcblk0p1 /tmp/p1
if [[ -e /tmp/p1/config.txt ]]; then
  ! grep 'hdmi_ignore_cec_init=1' /tmp/p1/config.txt &> /dev/null && echo 'hdmi_ignore_cec_init=1' >> /tmp/p1/config.txt
else
  echo 'hdmi_ignore_cec_init=1' > /tmp/p1/config.txt
fi
# force hdmi mode, remove black border
if ! grep 'hdmi_mode=' /boot/config.txt &> /dev/null; then
echo 'hdmi_group=1   # cec
hdmi_mode=31   # 1080p 50Hz
disable_overscan=1' >> /boot/config.txt
fi
### osmc ######################################
mkdir -p /tmp/p6
mount /dev/mmcblk0p6 /tmp/p6
if ! grep 'hdmi_mode=' /tmp/p6/config.txt &> /dev/null; then
echo 'hdmi_group=1
hdmi_mode=31' >> /tmp/p6/config.txt
fi

title2 "Mount USB drive to /mnt/hdd ..."
#################################################################################
# disable auto update mpd database
systemctl stop mpd
sed -i '\|sendMpdCommand| s|^|//|' /srv/http/command/usbmount

mnt0=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
label=${mnt0##/*/}
mnt=/mnt/$label
mkdir -p $mnt
if ! grep $mnt /etc/fstab &> /dev/null; then
  echo "/dev/sda1 $mnt ext4 defaults,noatime 0 0" >> /etc/fstab
  umount -l /dev/sda1
  mount -a
fi
ln -s $mnt/Music /mnt/MPD/USB/Music
systemctl start mpd
### osmc ######################################
if ! grep $mnt /tmp/p7/etc/fstab &> /dev/null; then
  mkdir -p /tmp/p7
  mount /dev/mmcblk0p7 /tmp/p7
  echo "/dev/sda1 $mnt ext4 defaults,noatime 0 0" >> /tmp/p7/etc/fstab
fi

title2 "Set pacman cache ..."
#################################################################################
mkdir -p $mnt/varcache/pacman
rm -r /var/cache/pacman
ln -s $mnt/varcache/pacman /var/cache/pacman

### osmc ######################################
mkdir -p $mnt/varcache/apt
rm -r /tmp/p7/var/cache/apt
ln -s $mnt/varcache/apt /tmp/p7/var/cache/apt

# rankmirrors
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh; chmod +x rankmirrors.sh; ./rankmirrors.sh

# Settings
#################################################################################
# ?

title2 "Upgrade Samba ..."
#################################################################################
pacman -R --noconfirm samba4-rune
pacman -Sy --noconfirm tdb tevent smbclient samba
# fix missing libreplace-samba4.so
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/libreplace-samba4.so -P /usr/lib/samba
# or run 'twice':
#pacman -S --noconfirm libwbclient

# fix 'minimum rlimit_max'
echo -n '
root    soft    nofile    16384
root    hard    nofile    16384
' >> /etc/security/limits.conf

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/smb.conf -P /etc/samba
rm /etc/samba/smb-dev.conf
ln -s /etc/samba/smb.conf /etc/samba/smb-dev.conf

systemctl daemon-reload
systemctl restart nmbd smbd
# set samba password
(echo $pwd1; echo $pwd1) | smbpasswd -s -a root

title2 "Samba upgraded successfully."

# Transmission
#################################################################################
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/install.sh; chmod +x install.sh; ./install.sh $pwd1 1 1

# Aria2
#################################################################################
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/install.sh; chmod +x install.sh; ./install.sh 1
rm -r $mnt/aria2/web/*
mv /var/www/html/aria2 $mnt/aria2/web
ln -s $mnt/aria2/web /var/www/html/aria2

# Enhancement
#################################################################################
wget -qN --show-progress https://github.com/rern/RuneUI_enhancement/raw/master/install.sh; chmod +x install.sh; ./install.sh 3

# GPIO
#################################################################################
wget -qN --show-progress https://github.com/rern/RuneUI_GPIO/raw/master/install.sh; chmod +x install.sh; ./install.sh 1

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/mpd.conf.gpio -P /etc
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/gpio.json -P /srv/http

systemctl restart gpioset

title2 "Setup finished successfully."
echo "Proceed to menu Settings."
titleend "Update library database: menu Sources > Rebuild"
