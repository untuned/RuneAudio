ArchLinuxArm
---

### Download
```sh
# RPi 3
wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-3-latest.tar.gz
# RPi 2
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
# bsdtar
apt-cache policy bsdtar
	# version 3.3+
apt install bsdtar
	# otherwise make install
file=libarchive-3.3.2.tar.gz
wget https://www.libarchive.org/downloads/$file
tar xzf $file
cd ${file/.tar.gz}
./configure
make
sudo make install

# extract
cd ..
bsdtar -xpvf ArchLinuxARM-rpi-3-latest.tar.gz boot
cp -rv boot/* /media/x/BOOT
rm -r boot

bsdtar -xpvf ArchLinuxARM-rpi-3-latest.tar.gz -C /media/x/ROOT
rm -r /media/x/ROOT/boot/*
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
