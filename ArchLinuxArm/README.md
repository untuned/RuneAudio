ArchLinuxArm
---

### Download  
- https://archlinuxarm.org/about/downloads

## SD Card > 4GB  
- Gparted :  
- Partition #1 [BOOT] fat32 - 100MB  
- Partition #2 [ROOT] ext4 - the rest  

### Extract files)  
```sh
# do not use bsdtar
tar xzpvf ArchLinuxARM-rpi-3-latest.tar.gz -C /media/x/ROOT
mv -r /media/x/ROOT/boot/* /media/x/BOOT
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
