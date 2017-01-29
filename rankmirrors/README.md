rankmirrors.sh
---
for ArchLinuxArm  
```sh
wget -q --show-progress -O rankmirrors.sh "https://github.com/rern/rankmirrors/blob/master/rankmirrors.sh?raw=1"; chmod +x rankmirrors.sh; ./rankmirrors.sh
```
#

Mitigate packages download errors by :  
file - /etc/pacman.d/mirrorlist
- enable(uncomment) all mirror servers
- download test for N seconds from each servers (default N=3)
- ranked by download speed  
- update mirrorlist file (with original backup)
