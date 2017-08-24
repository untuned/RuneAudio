RuneAudio Transmission
---

[**Transmission**](https://transmissionbt.com/) - Fast, easy, and free BitTorrent client (CLI tools, daemon and web client)  
- [Native compiled version](https://github.com/rern/RuneAudio/blob/master/transmission/native_compile.md): fix error, `libcrypto.so.1.1` and `libssl.so.1.1`, in default package  
- With optional WebUI alternative: [Transmission Web Control](https://github.com/ronggang/transmission-web-control#introduction)  

**Install**  
- RuneAudio has trouble with system wide upgrade. **Do not** `pacman -Syu` 
```
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/install.sh; chmod +x install.sh; ./install.sh
```

**Start transmission**  
`transmission-daemon -d` will not correctly show `settings.json`  
```
systemctl start transmission
```

**Stop transmission**  
```
systemctl stop transmission
```

Browser URL:  
_[RuneAudio IP]_:9091 (eg: 192.168.1.11:9091)  

**auto start download**  
add torrent files to `/media/hdd/transmission/torrents` will auto start download  

[optional] **set specific client IP**  
- allow only IP
- nolimit > `"rpc-whitelist-enabled": false`
```
    ...
    "rpc-whitelist": "127.0.0.1,[IP1],[IP2]",
    "rpc-whitelist-enabled": true,
    ...
```

**Create**  
```
transmission-create -p -o <file> -c "<comment>" -t "<url>"

# -p --private                 Allow this torrent to only be used with the specified tracker(s)
# -o --outfile   <file>        Save the generated .torrent to this filename
# -c --comment   <comment>     Add a comment
# -t --tracker   <url>         Add a tracker's announce URL
```
