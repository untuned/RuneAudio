#!/bin/bash

### Dual Boot - Unify USB path with OSMC
mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
label=${mnt##/*/}
mkdir -p /media
ln -s $mnt /media/$label

### pacman cache
mkdir -p $mnt/varcache/pacman
rm -r /var/cache/pacman
ln -s $mnt/varcache/pacman /var/cache/pacman

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh; chmod +x rankmirrors.sh; ./rankmirrors.sh


### Disable unused wlan0 service, cec
systemctl disable netctl-auto@wlan0.service
echo 'hdmi_ignore_cec=1' >> /boot/config.txt

### Upgrage and customize samba
pacman -R --noconfirm samba4-rune
pacman -Sy --noconfirm tdb tevent smbclient samba

# fix missing libreplace-samba4.so
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/libreplace-samba4.so -P /usr/lib/samba
# or run 'twice':
#pacman -S --noconfirm libwbclient

# make usb drive a common between os for smb.conf
[[ ! -e /media/hdd/samba/smb.conf ]] && wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/smb.conf -P /media/hdd/samba
rm /etc/samba/smb.conf /etc/samba/smb-dev.conf
ln -s /media/hdd/samba/smb.conf /etc/samba/smb.conf
ln -s /media/hdd/samba/smb.conf /etc/samba/smb-dev.conf

systemctl restart nmbd
systemctl restart smbd

smbpasswd -a root

### Enhancement
wget -qN --show-progress https://github.com/rern/RuneUI_enhancement/raw/master/install.sh; chmod +x install.sh; ./install.sh

### GPIO
wget -qN --show-progress https://github.com/rern/RuneUI_GPIO/raw/master/install.sh; chmod +x install.sh; ./install.sh

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/mpd.conf.gpio -P /etc
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/gpio.json -P /srv/http

### Transmission
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/install.sh; chmod +x install.sh; ./install.sh

systemctl stop transmission

# make usb drive a common between os for web, settings.json, directory
pathhdd=/media/$label/transmission
if [[ -e $pathhdd/web ]]; then
  rm -r /usr/share/transmission/web
else
  mv /usr/share/transmission/web $pathhdd/web
fi
ln -s $pathhdd/web /usr/share/transmission/web

path=/root/.config/transmission-daemon
if [[ ! -e $pathhdd/settings.json ]]; then
  mkdir -p $pathhdd/blocklists
  mkdir -p $pathhdd/resume
  mkdir -p $pathhdd/torrents
  mv $path/settings.json $pathhdd
fi
rm -r $path
ln -s $pathhdd $path

### Aria2
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/install.sh; chmod +x install.sh; ./install.sh
