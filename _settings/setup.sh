#!/bin/bash

### pacman cache
mkdir -p /mnt/MPD/USB/hdd/varcache/pacman
rm -r /var/cache/pacman
ln -s /mnt/MPD/USB/hdd/varcache/pacman /var/cache/pacman

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh; chmod +x rankmirrors.sh; ./rankmirrors.sh


### Disable unused wlan0 service, cec
systemctl disable netctl-auto@wlan0.service
echo 'hdmi_ignore_cec=1' >> /boot/config.txt

### Unify USB path with OSMC
mkdir /media
ln -s /mnt/MPD/USB/hdd/ /media/hdd

### Upgrage and customize samba
pacman -R --noconfirm samba4-rune
pacman -Sy --noconfirm tdb tevent smbclient samba

# fix missing libreplace-samba4.so
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/libreplace-samba4.so -P /usr/lib/samba
# or run 'twice':
#pacman -S --noconfirm libwbclient

systemctl stop nmbd
systemctl stop smbd

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/smb-dev.conf -P /etc/samba
ln -s /etc/samba/smb-dev.conf /etc/samba/smb.conf

systemctl start nmbd
systemctl start smbd

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

if [[ -e /mnt/MPD/USB/hdd/transmission/web ]]; then
  rm -r /usr/share/transmission/web
else
  mv /usr/share/transmission/web /mnt/MPD/USB/hdd/transmission/web
fi
ln -s /mnt/MPD/USB/hdd/transmission/web /usr/share/transmission/web

mkdir -p /mnt/MPD/USB/hdd/transmission/blocklists
mkdir -p /mnt/MPD/USB/hdd/transmission/resume
mkdir -p /mnt/MPD/USB/hdd/transmission/torrents

path=/root/.config/transmission-daemon
pathhdd=/mnt/MPD/USB/hdd/transmission
mv $path/settings.json $pathhdd
rm -r $path/*
ln -s $pathhdd/blocklists $path/blocklists
ln -s $pathhdd/resume $path/resume
ln -s $pathhdd/torrents $path/torrents
ln -s $pathhdd/settings.json $path/settings.json

### Aria2
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/install.sh; chmod +x install.sh; ./install.sh
