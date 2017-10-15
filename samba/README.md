Samba Upgrade
---
_Tested on RuneAudio 0.3 and 0.4b - samba_

**Upgrage**  
- RuneAudio already installed `samba4-rune` (samba 4.3.4)  
- Upgrading to latest Samba with custom configuration should improve transfer speed by 30%, from **8MB/s** up to **11MB/s**, on wired network (saturated 100Mbps) 
- RuneAudio has trouble with system wide upgrade. **Do not** `pacman -Syu`. 

**Install**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons)  

**Test conf parameters**
```
testparm
```

**Restart**
```sh
systemctl restart smbd

# if set new hostname
systemctl restart nmbd
```

**Add user + password**
```
adduser [user] # create new system user if not exist
smbpasswd -a [user]
```

**List currently accessing hosts**  
`smbstatus`  
