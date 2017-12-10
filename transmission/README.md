RuneAudio Transmission
---
_Tested on RuneAudio 0.3 and 0.4b_

[**Transmission**](https://transmissionbt.com/) - Fast, easy, and free BitTorrent client (CLI tools, daemon and web client)  
- [Native compiled version](https://github.com/rern/RuneAudio/blob/master/transmission/native_compiled.md): fix error, `libcrypto.so.1.1` and `libssl.so.1.1` ( `pacman -S openssl` > `pacman` failed )
- With optional WebUI alternative: [Transmission Web Control](https://github.com/ronggang/transmission-web-control#introduction)  

**Install**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons)   

**start / stop**  
```
systemctl < start / stop > tran
```

**WebUI**  
Browser URL:    
_[RuneAudio IP]_:9091 (eg: 192.168.1.11:9091)

**settings**  
`/path/transmission/settings.json` must be edited after stop transmission  
`transmission-daemon -d` may not show current `settings.json`  

**auto start download**  
add torrent files to `/path/transmission/torrents` will auto start download  

[optional] **set specific client IP**  
- allow only IP
- nolimit > `"rpc-whitelist-enabled": false`
```
    ...
    "rpc-whitelist": "127.0.0.1[,IP1, IP2]",
    "rpc-whitelist-enabled": true,
    ...
```

**create torrent file**  
```
transmission-create -p -o <file> -c "<comment>" -t "<url>"

# -p --private                 Allow this torrent to only be used with the specified tracker(s)
# -o --outfile   <file>        Save the generated .torrent to this filename
# -c --comment   <comment>     Add a comment
# -t --tracker   <url>         Add a tracker's announce URL
```
