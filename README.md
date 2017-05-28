RuneAudio
---

**pacman cache**
```sh
rm -r /var/cache/pacman
ln -s /var/cache/pacman /media/hdd/varcache/pacman
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

**samba**
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/samba/smb-dev.conf
systemctl restart nmbd
systemctl restart smbd
```

**Transmission**
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/install.sh; chmod +x install.sh; ./install.sh
```
