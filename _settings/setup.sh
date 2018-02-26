#!/bin/bash

# command shortcuts
# passwords for samba and transmission
# disable wifi, hdmi mode, fstab, pacman cache
# preload osmc pre-setup
# restore settings
# install addons menu
# install motd
# upgrade samba
# install transmission
# install aria2
# install runeui enhancement
# install runeui lyrics
# install runeui gpio
# install usb dac auto switch

rm $0

wgetnc https://github.com/rern/RuneAudio/raw/master/_settings/setupsystem.sh
. setupsystem.sh
rm setupsystem.sh

# rankmirrors
#################################################################################
if  grep -q '^Server = http://mirror.archlinuxarm.org/' /etc/pacman.d/mirrorlist; then
	wgetnc $gitpath/rankmirrors/rankmirrors.sh
	chmod +x rankmirrors.sh
	./rankmirrors.sh
fi

# addons menu
#################################################################################
wgetnc https://github.com/rern/RuneAudio_Addons/raw/master/install.sh; chmod +x install.sh; ./install.sh

# motd
#################################################################################
wgetnc $gitpath/motd/install.sh; chmod +x install.sh; ./install.sh
touch /root/.hushlogin

# samba
#################################################################################
wgetnc $gitpath/samba/install.sh; chmod +x install.sh; ./install.sh $pwd1
wgetnc $gitpath/_settings/smb.conf -O /etc/samba/smb-dev.conf
cp -f /etc/samba/smb-{dev,prod}.conf
ln -sf /etc/samba/smb{-dev,}.conf
rm -r /mnt/hdd/{readonly,readwrite}
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
wgetnc https://github.com/rern/RuneUI_enhancement/raw/master/install.sh; chmod +x install.sh; ./install.sh 1.8
echo

# Lyrics
#################################################################################
wgetnc https://github.com/RuneAddons/Lyrics/raw/master/install.sh; chmod +x install.sh; ./install.sh
echo

# GPIO
#################################################################################
wgetnc $gitpath/_settings/gpio.json -P /srv/http
chown http:http /srv/http/gpio.json
wgetnc https://github.com/rern/RuneUI_GPIO/raw/master/install.sh; chmod +x install.sh; ./install.sh
echo

# USB DAC
#################################################################################
wgetnc $gitpath/USB_DAC_switch/install.sh; chmod +x install.sh; ./install.sh
echo

# mpd
#################################################################################
#wgetnc $gitpath/mpd/install.sh; chmod +x install.sh; ./install.sh

# chromium
#################################################################################
#wgetnc $gitpath/chromium/install.sh; chmod +x install.sh; ./install.sh

systemctl reload php-fpm

# systemctl daemon-reload # done in GPIO install
systemctl restart nmbd smbd

# show installed packages status
title "$bar Installed packages status"
systemctl | egrep 'aria2|nmbd|smbd|transmission'

timestop l
title -l = "$bar Setup finished successfully."

clearcache
