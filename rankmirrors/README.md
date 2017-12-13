rankmirrors.sh
---
_for ArchLinuxArm and tested on RuneAudio 0.3 and 0.4b_  
  
Fix packages download errors:  
- get current `mirrorlist` from ArchLinuxArm source
- enable(uncomment) all mirror servers
- ranked by download speed  
- update mirrorlist file, **/etc/pacman.d/mirrorlist** (with original backup)

**Rank**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons)  

or from SSH terminal
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh -P /usr/local/bin; chmod +x /usr/local/bin/rankmirrors.sh; rankmirrors.sh
```
