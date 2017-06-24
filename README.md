RuneAudio setup
---

This is just an example for settings on a [Dual Boot](https://github.com/rern/RPi2-3.Dual.Boot-Rune.OSMC) system with some packages installed.  

**All setup**
```
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/setup.sh; chmod +x setup.sh; ./setup.sh
```
---

**pacman cache**
```
mkdir -p /mnt/MPD/USB/hdd/varcache/pacman
rm -r /var/cache/pacman
ln -s /mnt/MPD/USB/hdd/varcache/pacman /var/cache/pacman

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh; chmod +x rankmirrors.sh; ./rankmirrors.sh
```

**Disable unused wlan0 service**
```
systemctl disable netctl-auto@wlan0.service
```

**Unify USB path with OSMC**  
```
mkdir /media
ln -s /mnt/MPD/USB/hdd/ /media/hdd
```

**Upgrage and customize samba**
```bash
pacman -R --noconfirm samba4-rune
pacman -Sy --noconfirm tdb tevent smbclient samba

# fix missing libreplace-samba4.so
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/libreplace-samba4.so -P /usr/lib/samba
# or run 'twice':
#pacman -S --noconfirm libwbclient

killall nmbd
killall smbd

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/smb-dev.conf -P /etc/samba
ln -s /etc/samba/smb-dev.conf /etc/samba/smb.conf

systemctl daemon-reload
systemctl enable nmbd
systemctl enable smbd
systemctl start nmbd
systemctl start smbd

smbpasswd -a root
```

**Enhancement**
```
wget -qN --show-progress https://github.com/rern/RuneUI_enhancement/raw/master/install.sh; chmod +x install.sh; ./install.sh
```

**GPIO**
```
wget -qN --show-progress https://github.com/rern/RuneUI_GPIO/raw/master/install.sh; chmod +x install.sh; ./install.sh

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/mpd.conf.gpio -P /etc
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/gpio.json -P /srv/http
```

**Transmission**
```
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/install.sh; chmod +x install.sh; ./install.sh

if [[ -e /mnt/MPD/USB/hdd/transmission/web ]]; then
  rm -r /usr/share/transmission/web
else
  mv /usr/share/transmission/web /mnt/MPD/USB/hdd/transmission/web
fi
ln -s /mnt/MPD/USB/hdd/transmission/web /usr/share/transmission/web
```

**Aria2**
```
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/install.sh; chmod +x install.sh; ./install.sh
```
