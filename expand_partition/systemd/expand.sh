#!/bin/bash

# 'partprope', a part of 'parted' package, must be included in image

unpartb=$( sfdisk -F | grep $disk | awk '{print $6}' )
if ( $unpartb > 0 ); then
	echo -e 'd\n\nn\n\n\n\n\nw' | fdisk /dev/mmcblk0 &>/dev/null
	partprobe /dev/mmcblk0
	resize2fs /dev/mmcblk0p2
fi

rm /etc/systemd/system/rootexpand.service
rm /root/expand.sh
