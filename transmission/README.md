RuneAudio_transmission
---

[**Transmission**](https://transmissionbt.com/) - Fast, easy, and free BitTorrent client (CLI tools, daemon and web client)  

**Install**  
```sh
pacman -S transmission-cli
```

**Create settings file**  
_start to create_ `settings.json` _file, stop to make it permanent_
```sh
systemctl start transmission
systemctl stop transmission
```

**Create directories, set owner**
_default user = transmission_
```sh
mkdir /mnt/MPD/USB/hdd/transmission
mkdir /mnt/MPD/USB/hdd/transmission/incomplete
mkdir /mnt/MPD/USB/hdd/transmission/torrents
chown -R transmission:transmission /mnt/MPD/USB/hdd/transmission
```
To run with other users, change user in `/usr/lib/systemd/system/transmission.service` and `chown` accordingly.

**/var/lib/transmission/.config/transmission-daemon/settings.json** - edit:  
`systemctl stop transmisson` before changing, otherwise it will not be saved on next run.  
_~/.config/transmission-daemon/settings.json - if run with other users_  

set directories  
```sh
    ...
    "download-dir": "/mnt/MPD/USB/hdd/transmission",
    "incomplete-dir": "/mnt/MPD/USB/hdd/transmission/incomplete",
    "incomplete-dir-enabled": true,
    ...
```
[optional] set login  
- plain text `"rpc-password"` will be hash once login
- logout > close browser (no explicit logout, close tab not logout)
- no login > `"rpc-authentication-required": false`  
```sh
    ...
    "rpc-authentication-required": true,
    ...
    "rpc-password": "rune",
    ...
    "rpc-username": "rune",
    ....
```
[optional] set specific client IP  
- allow only IP
- nolimit > `"rpc-whitelist-enabled": false`
```sh
    ....
    "rpc-whitelist": "127.0.0.1,[IP1],[IP2]",
    "rpc-whitelist-enabled": true,
    ...
```
set auto start download  
- add torrent files to `watch-dir` will auto start download  
- appending to last line needs a comma in the line before
```sh
    ...
    "watch-dir": "/mnt/MPD/USB/hdd/transmission/torrents",
    "watch-dir-enabled": true
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
