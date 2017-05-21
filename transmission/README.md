RuneAudio Transmission
---

[**Transmission**](https://transmissionbt.com/) - Fast, easy, and free BitTorrent client (CLI tools, daemon and web client)  

**Install**  
Connect a hard drive with label `hdd` or mount as `/mnt/MPD/USB/hdd`  
```sh
wget -q --show-progress -O install.sh "https://github.com/rern/RuneAudio/blob/master/transmission/install.sh?raw=1"; chmod +x install.sh; ./install.sh
```

**Complications**  
- Transmission 2.92 needs openssl 1.1 and 1.0 
    * libcrypto.so.1.1, libcrypto.so.1.0.0
    * libssl.so.1.1, libssl.so.1.0.0
- Both versions must be in `/lib/`
- Edit `/root/.config/transmission-daemon/settings.json`
   * `killall transmission-daemon` > `systemctl start transmission` > `systemctl stop transmission`
- Restart
   * `systemctl start transmission`

**Uninstall**  
```sh
./uninstall_tran.sh
```

**Start transmission**  
```sh
systemctl start transmission
```

**Stop transmission**  
```sh
systemctl stop transmission
```

**WebUI**  
Browser URL:  
_[RuneAudio IP]_:9091 (eg: 192.168.1.11:9091)  

**auto start download**  
add torrent files to `/media/hdd/transmission/torrents` will auto start download  

[optional] **set specific client IP**  
- allow only IP
- nolimit > `"rpc-whitelist-enabled": false`
```sh
    ...
    "rpc-whitelist": "127.0.0.1,[IP1],[IP2]",
    "rpc-whitelist-enabled": true,
    ...
```
