RuneAudio_transmission
---

[**Transmission**](https://transmissionbt.com/) - Fast, easy, and free BitTorrent client (CLI tools, daemon and web client)  

**Install**  
```sh
wget -q --show-progress -O install.sh "https://github.com/rern/RuneAudio/blob/master/transmission/install.sh?raw=1"; chmod +x install.sh; ./install.sh
```

**Uninstall**  
```sh
./uninstall_tran.sh
```

**Start transmission**  
```sh
systemctl start transmission
```

**WebUI**  
Browser URL:  
_RuneAudio IP_

Manually install
---
**Install**  
```sh
pacman -Sy transmission-cli
```

**Create settings file**  
_start to create_ `settings.json` _file, stop to make changes permanent_
```sh
systemctl start transmission
systemctl stop transmission
```

**/var/lib/transmission/.config/transmission-daemon/settings.json** - edit:  
`systemctl stop transmisson` before changing, otherwise it will not be saved on next run.  
_~/.config/transmission-daemon/settings.json - if run with other users_  
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

[optional] **Auto start transmission on system start**  
```sh
systemctl enable transmission
```



:9091 (eg: 192.168.1.11:9091)  

**Stop transmission**  
```sh
systemctl stop transmission
```
