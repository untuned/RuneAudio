#!/bin/bash

# 'partprope', 'libparted.so.2' needed

unpartb=$( sfdisk -F | grep /dev/mmcblk0 | awk '{print $6}' )
if (( $unpartb > 0 )); then
	echo -e 'd\n\nn\n\n\n\n\nw' | fdisk /dev/mmcblk0 &>/dev/null
	partprobe /dev/mmcblk0
	resize2fs /dev/mmcblk0p2
fi

systemctl disable expand
rm /etc/systemd/system/rootexpand.service
systemctl daemon-reload
rm /root/expand.sh

