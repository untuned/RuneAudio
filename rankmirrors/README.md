rankmirrors.sh
---
_for ArchLinuxArm and RuneAudio_  
  
Fix packages download errors:  
- enable(uncomment) all mirror servers
- download test for 3 seconds from each servers
- ranked by download speed  
- update mirrorlist file, **/etc/pacman.d/mirrorlist** (with original backup)

- **Rank**
```
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh; chmod +x rankmirrors.sh; ./rankmirrors.sh
```

- **Update package databases**
```
pacman -Sy
```
