rankmirrors.sh
---
for ArchLinuxArm and RuneAudio  
  
Fix packages download errors:  
- enable(uncomment) all mirror servers
- download test for 3 seconds from each servers
- ranked by download speed  
- update mirrorlist file, **/etc/pacman.d/mirrorlist** (with original backup)

- **Rank**
```sh
wget -q --show-progress https://github.com/rern/RuneAudio/blob/master/rankmirrors/rankmirrors.sh; chmod +x rankmirrors.sh; ./rankmirrors.sh
```

- **Update package databases**
```sh
pacman -Sy
```
