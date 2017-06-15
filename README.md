RuneAudio setup
---

**Unify USB path with OSMC**
```sh
mkdir /media
ln -s /mnt/MPD/USB/hdd/ /media/hdd
```

**pacman cache**
```sh
rm -r /var/cache/pacman
mkdir -p /media/hdd/varcache/pacman
ln -s /media/hdd/varcache/pacman /var/cache/pacman

wget -qN --show-progress $gitpath/rankmirrors/rankmirrors.sh; chmod +x rankmirrors.sh; ./rankmirrors.sh
```

**Enhancement**
```sh
wget -qN --show-progress https://github.com/rern/RuneUI_enhancement/raw/master/install.sh; chmod +x install.sh; ./install.sh
```

**GPIO**
```sh
wget -qN --show-progress https://github.com/rern/RuneUI_GPIO/raw/master/install.sh; chmod +x install.sh; ./install.sh
# customized files
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/mpd.conf.gpio -P /etc
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/gpio.json -P /srv/http
```

**Aria2**
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/install.sh; chmod +x install.sh; ./install.sh
```

**Transmission**
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/install.sh; chmod +x install.sh; ./install.sh
```

**Upgrage and customize samba**
```sh
systemctl stop nmbd
systemctl stop smbd
pacman -Rs --no-confirm samba4-rune
pacman -S --no-confirm tdb tevent libwbclient smbclient
pacman -S --no-confirm samba

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/samba/smb-dev.conf -P /etc/samba
ln -s /etc/samba/smb-dev.conf /etc/samba/smb.conf

systemctl start nmbd
systemctl start smbd
systemctl enable nmbd
systemctl enable smbd

smbpasswd - a root
```
