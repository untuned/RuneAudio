RuneAudio
---

**pacman cache**
```sh
rm -r /var/cache/pacman
mkdir -p /mnt/MPD/USB/hdd/varcache/pacman
ln -s /mnt/MPD/USB/hdd/varcache/pacman /var/cache/pacman
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh; chmod +x rankmirrors.sh; ./rankmirrors.sh
```

**Enhancement**
```sh
wget -qN --show-progress https://github.com/rern/RuneUI_enhancement/raw/master/install.sh; chmod +x install.sh; ./install.sh
```

**GPIO**
```sh
wget -qN --show-progress https://github.com/rern/RuneUI_GPIO/raw/master/install.sh; chmod +x install.sh; ./install.sh
```

**Aria2**
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/install.sh; chmod +x install.sh; ./install.sh
```

**Transmission**
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/install.sh; chmod +x install.sh; ./install.sh
```

**Customize samba**
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/samba/smb-dev.conf -P /etc/samba
systemctl restart nmbd
systemctl restart smbd
```
