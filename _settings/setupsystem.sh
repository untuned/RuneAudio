#!/bin/bash

# command shortcuts
# disable wifi, hdmi mode, fstab, pacman cache
# preload osmc pre-setup
# restore settings

rm $0

[[ ! -e /srv/http/addonstitle.sh ]] && wget -qN --no-check-certificate https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/addonstitle.sh -P /srv/http
. /srv/http/addonstitle.sh

mmc() {
	[[ $2 ]] && mntdir=/tmp/$2 || mntdir=/tmp/p$1
	if [[ ! $( mount | grep $mntdir ) ]]; then
		mkdir -p $mntdir
		mount /dev/mmcblk0p$1 $mntdir
	fi
}

echo -e "$bar OSMC pre-setup ..."
#################################################################################
mmc 5
osmcroot=$( sed -n '/"OSMC"/ {n;n;n;p}' $mntsettings/installed_os.json | sed 's/.*p\(.*\)"/\1/' )
mmc $osmcroot
if [[ ! -e /tmp/p$osmcroot/walkthrough_completed ]]; then
	wgetnc https://github.com/rern/OSMC/raw/master/_settings/presetup.sh
	. presetup.sh
fi
echo

# command shortcuts
gitpath=https://github.com/rern/RuneAudio/raw/master
[[ ! -e /etc/profile.d/cmd.sh ]] && wgetnc $gitpath/_settings/cmd.sh -P /etc/profile.d

echo -e "$bar Disable WiFi ..."
#################################################################################
systemctl disable netctl-auto@wlan0
systemctl stop netctl-auto@wlan0 shairport udevil upmpdcli
echo

echo -e "$bar Set HDMI mode ..."
#################################################################################
# force hdmi mode, remove black border (overscan)
hdmimode='
hdmi_group=1
hdmi_mode=31
disable_overscan=1
hdmi_ignore_cec=1'
# get partitions: 1 and even partition > 5
partlist=( 1 $( fdisk -l /dev/mmcblk0 | grep '^/dev/mmc' | sed 's/.*mmcblk0p\([0-9]*\).*/\1/' | awk '$1 > 5 && $1%2 == 0' ) )
ilength=${#partlist[*]}
for (( i=0; i < ilength; i++ )); do
	mmc $i
	! grep -q '^hdmi_mode=' /tmp/p$i/config.txt && echo "$hdmimode" >> /tmp/p$i/config.txt
done

echo

echo -e "$bar Mount USB drive to /mnt/hdd ..."
#################################################################################
# disable auto update mpd database
systemctl stop mpd
sed -i '/^sendMpdCommand/ s|^|//|' /srv/http/command/usbmount
sed -i '/^KERNEL/ s/^/#/' /etc/udev/rules.d/rune_usb-stor.rules
udevadm control --reload-rules && udevadm trigger

mnt0=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
label=${mnt0##/*/}
mnt="/mnt/$label"
mkdir -p "$mnt"
if ! grep -q $mnt /etc/fstab; then
	echo "/dev/sda1  $mnt  ext4  defaults,noatime" >> /etc/fstab
	umount -l /dev/sda1
	rm -r /mnt/MPD/USB/hdd
	mount -a
fi
find /mnt/hdd/Music -maxdepth 1 -mindepth 1 -type d -print0 | xargs -0 ln -sf -t /mnt/MPD/USB

echo -e "$bar Restore settings ..."
#################################################################################
# keep version number
build=$( redis-cli get buildversion )
rel=$( redis-cli get release )

# settings
systemctl stop redis
file=/var/lib/redis/rune.rdb
wgetnc $gitpath/_settings/rune.rdb -O $file
systemctl start redis

sleep 2
systemctl status redis | grep -q 'dead' && systemctl start redis
if [[ $release == 0.4b ]]; then
	redis-cli set buildversion $build
	redis-cli set release $rel
fi
# create webradio files
i=1
str=''
redis-cli hgetall webradios | \
while read line; do
	if [[ $(( i % 2)) == 1 ]]; then
		str+="[playlist]\nNumberOfEntries=1\nFile1=$line\n"
		filename="${line}.pls"
	else
		str+="Title1=$line"
		echo -e "$str" > "/mnt/MPD/Webradio/$filename"
		str=''
	fi
	(( i++ ))
done

# extra command for some settings
ln -sf /usr/share/zoneinfo/Asia/Bangkok /etc/localtime # set timezone
#hostnamectl set-hostname RT-AC66U                     # set hostname
sed -i 's/info,man/info,locale,man/' /usr/local/bin/osmcreset
sed -i "s/opcache.enable=./opcache.enable=$( redis-cli get opcache )/" /etc/php/conf.d/opcache.ini
systemctl restart php-fpm

# mpd database
systemctl stop mpd
file=/var/lib/mpd/mpd.db
wgetnc $gitpath/_settings/mpd.db -O $file
systemctl start mpd
sleep 1
mpc update Webradio &> /dev/null

sed -i 's/8000/1000/' /srv/http/assets/js/runeui.js        # change pnotify 8 to 1 sec

sed -i -e '/m:0x0 + c:180/ s/^#//
' -e '/m:0x0 + c:180/ i\
"/root/gpioon.py"
' -e '/m:0x8 + c:64/ s/^#//
' -e '/m:0x8 + c:64/ i\
"/root/gpiooff.py"
' /root/.xbindkeysrc
echo

echo -e "\n$bar Set pacman cache ...\n"
#################################################################################
sed -i '/#CacheDir/ a\
CacheDir    = '$mnt'/varcache/pacman/pkg/
' /etc/pacman.conf
