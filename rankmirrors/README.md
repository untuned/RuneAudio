rankmirrors.sh
---
_for ArchLinuxArm and RuneAudio_  
  
Fix packages download errors:  
- enable(uncomment) all mirror servers
- download test for 3 seconds from each servers
- ranked by download speed  
- update mirrorlist file, **/etc/pacman.d/mirrorlist** (with original backup)

**Rank**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons)  

or from SSH terminal
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh -P /usr/local/bin; chmod +x /usr/local/bin/rankmirrors.sh; rankmirrors.sh
```

**Update package databases**
```sh
pacman -Sy
```
