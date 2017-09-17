Samba
---
_Tested on RuneAudio beta-20160313 - samba_

**Upgrage**  
- RuneAudio already installed `samba4-rune`  
- Upgrading to latest Samba with following configuration should improve transfer speed by 30%, from **8MB/s** up to **11MB/s**, on wired network  
- RuneAudio has trouble with system wide upgrade. **Do not** `pacman -Syu`. 

**Install**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons)  

or from SSH terminal
```
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/samba/install.sh; chmod +x install.sh; ./install.sh
```
RuneAudio has trouble with system wide upgrade. **Do not** `pacman -Syu` 

**Server name**  
- any os file browsers:
```
hostnamectl set-hostname [name]
```
- only Windows(NetBIOS) file browsers:  
`netbios name` in `/etc/samba-dev/smb.conf`  

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

**List accessing**  
`smbstatus`  
