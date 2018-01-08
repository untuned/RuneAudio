#!/bin/bash

echo root | su
echo "root:rune" | chpasswd

mkdir /mnt/hdd
echo '/dev/sda1  /mnt/hdd  ext4  defaults,noatime' >> /etc/fstab
mount -a
  
ln -sf /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

sed -i '/#CacheDir/ a\
CacheDir    = /mnt/hdd/varcache/pacman/pkg/
' /etc/pacman.conf

mv /etc/ssl/certs/ca-certificates.crt{,.bak}

pacman Syu

pacman -S wget

wget https://github.com/rern/RuneAudio/raw/master/_settings/cmd.sh -P /etc/profile.d
