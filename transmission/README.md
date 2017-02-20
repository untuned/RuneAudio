RuneAudio_transmission
---

[**Transmission**](https://transmissionbt.com/) - Fast, easy, and free BitTorrent client (CLI tools, daemon and web client)  

**Install**  
```sh
pacman -S transmission-cli
```

**Config**  
_start to create_ `settings.json` _file, stop to allow edit_
```sh
systemctl start transmission
systemctl stop transmission
```

**/var/lib/transmission/.config/transmission-daemon/settings.json** - edit:  
- plain text `password` will be hash once login
- logout > close browser (no explicit logout, close tab not logout)
- no password > "rpc-authentication-required": false  
```sh
    "download-dir": "/[path]/transmission",
    "incomplete-dir": "/[path]/transmission/.incomplete",
    "incomplete-dir-enabled": true,
    
    "rpc-authentication-required": true,
    "rpc-password": "[password]",
    "rpc-url": "/[path]/transmission",
    "rpc-username": "[username]",
    "rpc-whitelist-enabled": false,
```

**Create download-dir, set owner**
```sh
mkdir /[path]/transmission
chown -R transmission:transmission /[path]/transmission
```

**Start transmission**  
```sh
systemctl start transmission
```

**Auto start transmission on system start**  
```sh
systemctl enable transmission
```

**WebUI**  
  
Browser URL:  
  
_RuneAudio IP_:9091 (eg: 192.168.1.11:9091)  
