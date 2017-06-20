RuneAudio setup
---

**Settings**  
```
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/mpd.db -P /var/lib/mpd
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/rune.rdb -P /var/lib/redis
```

**pacman cache**
```
rm -r /var/cache/pacman
mkdir -p /mnt/MPD/USB/hdd/varcache/pacman
ln -s /mnt/MPD/USB/hdd/varcache/pacman /var/cache/pacman

wget -qN --show-progress $gitpath/rankmirrors/rankmirrors.sh; chmod +x rankmirrors.sh; ./rankmirrors.sh
```

**Disable wlan service**
```
systemctl disable netctl-auto@wlan0.service
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

**Expand partition**
```
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/expand_partition/expand.sh; chmod +x expand.sh; ./expand.sh
```

**Unify USB path with OSMC** (on [Dual Boot](https://github.com/rern/RPi2-3.Dual.Boot-Rune.OSMC) only)
```
mkdir /media
ln -s /mnt/MPD/USB/hdd/ /media/hdd
```

**Aria2**
```
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/install.sh; chmod +x install.sh; ./install.sh
```

**Transmission**
```
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/install.sh; chmod +x install.sh; ./install.sh

rm -r /usr/share/transmission/web
ln -s /mnt/MPD/USB/hdd/transmission/web /usr/share/transmission/web
```

**Upgrage and customize samba**
```bash
pacman -R --noconfirm samba4-rune
pacman -S --noconfirm tdb tevent smbclient libwbclient
pacman -S --noconfirm samba
# fix missing libreplace.so
pacman -S --noconfirm libwbclient

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/smb-dev.conf -P /etc/samba

systemctl daemon-reload

smbpasswd - a root
```
