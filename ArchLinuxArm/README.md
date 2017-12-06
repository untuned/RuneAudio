ArchLinuxArm
---

### Download
```sh
# RPI 3
wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-3-latest.tar.gz
# RPI 2
wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
```

### Partition SD Card
- Gparted does unmount > partition > format
```
Partition #1   BOOT   fat32   100MB  
Partition #2   ROOT   ext4    the rest  
```

### Extract files  
```sh
# make install bsdtar (fix - default package < 3.3)
file=libarchive-3.3.2.tar.gz
wget https://www.libarchive.org/downloads/$file
tar xzf $file
cd ${file/.tar.gz}
./configure
make
sudo make install

# extract
cd ..
bsdtar xpvf ArchLinuxARM-rpi-3-latest.tar.gz -C /media/x/ROOT

mv -r /media/x/ROOT/boot/* /media/x/BOOT
```

### Boot from SD card

### SSH / SCP login  
- id / password : alarm / alarm
- allow root ssh login and set password
```sh
su

nano /etc/ssh/sshd_config
	# PermitRootLogin yes
systemctl restart sshd

passwd
