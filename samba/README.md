Samba Upgrade
---
_Tested on RuneAudio 0.3 and 0.4b_
 
- RuneAudio already installed `samba4-rune` (samba 4.3.4)  
- Upgrading to latest Samba, 4.8.5 as of 20180906, with custom configuration should improve transfer speed by 30%, from **8MB/s** up to **11MB/s**, on wired network (max RPi 100Mbps bandwidth) 
- RuneAudio has trouble with system wide upgrade. **Do not** `pacman -Syu`. 

**Upgrage**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons)  

**Test conf parameters**
```
testparm
```

**Restart**
Samba 4.8 changes **nmbd**.service / **smbd**.service to **nmb**.service / **smb**.service
```sh
systemctl restart smb

# if set new hostname
systemctl restart nmb
```

**Add user + password**
```
adduser [user] # create new system user if not exist
smbpasswd -a [user]
```

**List shares**  
`smbtree`

**List users**  
`pdbedit -L`

**List currently accessing hosts**  
`smbstatus`
