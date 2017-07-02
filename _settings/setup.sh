#!/bin/bash

### Disable unused wlan0 service ###################################################
systemctl disable netctl-auto@wlan0.service

### set hdmi #######################################################################
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

### set fstab for usb drive ########################################################
mnt0=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
label=${mnt0##/*/}
mkdir -p /mnt/$label
echo "/dev/sda1       /mnt/$label           ext4     defaults,noatime  0   0" >> /etc/fstab
mnt=/mnt/$label

### set pacman cache to usb drive  #################################################
mkdir -p $mnt/varcache/pacman
rm -r /var/cache/pacman
ln -s $mnt/varcache/pacman /var/cache/pacman
# rankmirrors
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh; chmod +x rankmirrors.sh; ./rankmirrors.sh

### Settings  ######################################################################
# ?

### Upgrage and customize samba  ###################################################
pacman -R --noconfirm samba4-rune
pacman -Sy --noconfirm tdb tevent smbclient samba
# fix missing libreplace-samba4.so
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/libreplace-samba4.so -P /usr/lib/samba
# or run 'twice':
#pacman -S --noconfirm libwbclient

# make usb drive a common between os for smb.conf
[[ ! -e $mnt/samba/smb.conf ]] && wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/smb.conf -P $mnt/samba
rm /etc/samba/smb.conf
ln -s $mnt/samba/smb.conf /etc/samba/smb.conf
systemctl restart nmbd
systemctl restart smbd
# set samba password
smbpasswd -a root

### Transmission ####################################################################
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/install.sh; chmod +x install.sh; ./install.sh

### Aria2 ###########################################################################
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/install.sh; chmod +x install.sh; ./install.sh

### Enhancement  ####################################################################
wget -qN --show-progress https://github.com/rern/RuneUI_enhancement/raw/master/install.sh; chmod +x install.sh; ./install.sh

### GPIO  ###########################################################################
wget -qN --show-progress https://github.com/rern/RuneUI_GPIO/raw/master/install.sh; chmod +x install.sh; ./install.sh

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/mpd.conf.gpio -P /etc
# make usb drive a common between os for gpio.json
[[ ! -e $mnt/gpio/gpio.json ]] && wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/gpio.json -P $mnt/gpio
ln -s $mnt/gpio/gpio.json /home/osmc/gpio.json
systemctl restart gpioset
