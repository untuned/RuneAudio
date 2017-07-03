#!/bin/bash

line2='\e[0;36m=========================================================\e[m'
line='\e[0;36m---------------------------------------------------------\e[m'
bar=$( echo -e "$(tput setab 6)   $(tput setab 0)" )
info=$( echo $(tput setab 6; tput setaf 0) i $(tput setab 0; tput setaf 7) )

title2() {
	echo -e "\n$line2\n"
	echo -e "$bar $1"
	echo -e "\n$line2\n"
}
title() {
	echo -e "\n$line"
	echo $1
	echo -e "$line\n"
}
setpwd() {
	echo
	echo 'Password: '
	read -s pwd1
	echo
	echo 'Retype password: '
	read -s pwd2
	echo
	if [[ $pwd1 != $pwd2 ]]; then
		echo
		echo "$info Passwords not matched. Try again."
		setpwd
	fi
}

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
echo 'hdmi_ignore_cec_init=1' >> /tmp/p1/config.txt
# force hdmi mode, remove black border
echo '
hdmi_group=1   # cec
hdmi_mode=31   # 1080p 50Hz
disable_overscan=1
' >> /boot/config.txt
### osmc ######################################
mkdir -p /tmp/p6
mount /dev/mmcblk0p6 /tmp/p6
echo '
hdmi_group=1
hdmi_mode=31
' >> /tmp/p6/config.txt

title2 "Symlink /mnt/hdd ..."
#################################################################################
mnt0=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
label=${mnt0##/*/}
mnt=/mnt/$label
ln -s $mnt0 $mnt

### osmc ######################################
mnt0=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
label=${mnt0##/*/}
mkdir -p /tmp/p7
mount /dev/mmcblk0p7 /tmp/p7
echo "/dev/sda1       /mnt/$label           ext4     defaults,noatime  0   0" >> /tmp/p7/etc/fstab

# Settings
#################################################################################
# ?

### osmc setting ##############################
gitpath=https://github.com/rern/OSMC/raw/master/_settings
kodipath=/tmp/p7/home/osmc/.kodi/userdata
wget -qN --show-progress $gitpath/guisettings.xml -P $kodipath
wget -qN --show-progress $gitpath/mainmenu.DATA.xml -P $kodipath/addon_data/script.skinshortcuts
chown -R osmc:osmc $kodipath
# setup marker file
touch /walkthrough_completed

title2 "Set pacman cache ..."
#################################################################################
mkdir -p $mnt/varcache/pacman
rm -r /var/cache/pacman
ln -s $mnt/varcache/pacman /var/cache/pacman
# rankmirrors
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh; chmod +x rankmirrors.sh; ./rankmirrors.sh

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

# make usb drive a common between os for smb.conf
[[ ! -e $mnt/samba/smb.conf ]] && wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/smb.conf -P $mnt/samba
rm /etc/samba/smb-dev.conf
ln -s $mnt/samba/smb.conf /etc/samba/smb-dev.conf
ln -s $mnt/samba/smb.conf /etc/samba/smb.conf
systemctl daemon-reload
systemctl restart nmbd smbd
# set samba password
(echo $pwd1; echo $pwd1) | smbpasswd -s -a root

# Transmission
#################################################################################
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/install.sh; chmod +x install.sh; ./install.sh $pwd1 0 1

# Aria2
#################################################################################
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/install.sh; chmod +x install.sh; ./install.sh 1

# Enhancement
#################################################################################
wget -qN --show-progress https://github.com/rern/RuneUI_enhancement/raw/master/install.sh; chmod +x install.sh; ./install.sh 3

# GPIO
#################################################################################
wget -qN --show-progress https://github.com/rern/RuneUI_GPIO/raw/master/install.sh; chmod +x install.sh; ./install.sh 1

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/mpd.conf.gpio -P /etc
# make usb drive a common between os for gpio.json
[[ ! -e $mnt/gpio/gpio.json ]] && wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/gpio.json -P $mnt/gpio
rm /srv/http/gpio.json
ln -s $mnt/gpio/gpio.json /srv/http/gpio.json
systemctl restart gpioset

title "Finished."
