ArchLinuxArm
---

### Download
```sh
# RPi 3 (not for compiling)
wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-3-latest.tar.gz
# RPi 2
wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
```

### Partition SD Card
- Gparted does unmount > partition > format
```sh
# primary #1  BOOT   fat32   100MB  
# primary #2   ROOT   ext4    the rest
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
bsdtar xpvf ArchLinuxARM-rpi-3-latest.tar.gz -C /media/x/ROOT
cp -r /media/x/ROOT/boot/* /media/x/BOOT
rm -r /media/x/ROOT/boot/*

sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /media/x/ROOT/etc/ssh/sshd_config
```

### Boot from SD card

### SSH / SCP login  
- id / password : root / root
```sh
passwd
	# rune
```
