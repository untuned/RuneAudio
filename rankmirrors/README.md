rankmirrors.sh
---
for ArchLinuxArm  
  
Fix packages download errors:  
- enable(uncomment) all mirror servers
- download test for 3 seconds from each servers
- ranked by download speed  
- update mirrorlist file, **/etc/pacman.d/mirrorlist** (with original backup)

- **Rank**
```sh
wget -q --show-progress -O rankmirrors.sh "https://github.com/rern/RuneAudio/rankmirrors/blob/master/rankmirrors.sh?raw=1"; chmod +x rankmirrors.sh; ./rankmirrors.sh
```

- **Update package databases**
```sh
pacman -Sy
```
