ArchLinuxArm
---

### Download  
- https://archlinuxarm.org/about/downloads

## SD Card > 4GB  
- Gparted :  
- Partition #1 - fat32 - 100MB - BOOT  
- Partition #2 - ext4 - the rest - ROOT  

### Extract files (no bsdtar)  
```sh
tar xzpvf ArchLinuxARM-rpi-3-latest.tar.gz -C /media/x/ROOT
mv /media/x/ROOT/boot /media/x/BOOT
```

### Login  
- id / password : alarm / alarm
```sh
su

nano /etc/ssh/sshd_config
# PermitRootLogin yes
systemctl restart sshd

passwd
# rune
