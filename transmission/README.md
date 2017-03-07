RuneAudio_transmission
---

[**Transmission**](https://transmissionbt.com/) - Fast, easy, and free BitTorrent client (CLI tools, daemon and web client)  

**Install**  
```sh
pacman -S transmission-cli
```

**Create settings file**  
_start to create_ `settings.json` _file, stop to make changes permanent_
```sh
systemctl start transmission
systemctl stop transmission
```

**Create directories, set owner**  
- default user: transmission   
- To run with other users, change user in `/usr/lib/systemd/system/transmission.service` and `chown` accordingly.
```sh
mkdir /mnt/MPD/USB/hdd/transmission
mkdir /mnt/MPD/USB/hdd/transmission/incomplete
mkdir /mnt/MPD/USB/hdd/transmission/torrents
chown -R transmission:transmission /mnt/MPD/USB/hdd/transmission
```

**/var/lib/transmission/.config/transmission-daemon/settings.json** - edit:  
`systemctl stop transmisson` before changing, otherwise it will not be saved on next run.  
_~/.config/transmission-daemon/settings.json - if run with other users_  
 
```sh
sed -i -e 's|"download-dir": "/var/lib/transmission/Downloads",|"download-dir": "/mnt/MPD/USB/hdd/transmission",|
' -e 's|"incomplete-dir": "/var/lib/transmission/Downloads",|"incomplete-dir": "/mnt/MPD/USB/hdd/transmission/incomplete",|
' -e 's|"incomplete-dir-enabled": false,|"incomplete-dir-enabled": true,|
' -e 's|"rpc-authentication-required": false,|"rpc-authentication-required": true,|
' -e 's|"rpc-password": ".*",|"rpc-password": "rune",|
' -e 's|"rpc-username": "",|"rpc-username": "rune",|
' -e '/[^{},]$/ s/$/\,/
' -e '/}/ i\
    "watch-dir": "/mnt/MPD/USB/hdd/transmission/torrents",\
    "watch-dir-enabled": true
' /var/lib/transmission/.config/transmission-daemon/settings.json
```
`watch-dir` start download on adding torrent files  

[optional] set specific client IP  
- allow only IP
- nolimit > `"rpc-whitelist-enabled": false`
```sh
    ....
    "rpc-whitelist": "127.0.0.1,[IP1],[IP2]",
    "rpc-whitelist-enabled": true,
    ...
```

**Start transmission**  
```sh
systemctl start transmission
```

[optional] **Auto start transmission on system start**  
```sh
systemctl enable transmission
```

**WebUI**  
  
Browser URL:  
  
_RuneAudio IP_:9091 (eg: 192.168.1.11:9091)  
