#!/bin/bash

mkdir /mnt/hdd
echo '/dev/sda1  /mnt/hdd  ext4  defaults,noatime' >> /etc/fstab
mount -a
  
ln -sf /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

sed -i '/#CacheDir/ a\
CacheDir    = /mnt/hdd/varcache/pacman/pkg/
' /etc/pacman.conf

pacman -Sy

pacman -S wget
