#!/bin/bash

alias ls='ls -a --color --group-directories-first'
export LS_COLORS='tw=01;34:ow=01;34:ex=00;32:or=31'

tcolor() { 
	echo -e "\e[38;5;10m$1\e[0m"
}

sstatus() {
	echo -e '\n'$( tcolor "systemctl status $1" )'\n'
	systemctl status $1
}
sstart() {
	echo -e '\n'$( tcolor "systemctl start $1" )'\n'
	systemctl start $1
}
sstop() {
	echo -e '\n'$( tcolor "systemctl stop $1" )'\n'
	systemctl stop $1
}
srestart() {
	echo -e '\n'$( tcolor "systemctl restart $1" )'\n'
	systemctl restart $1
}

mountmmc() {
	mkdir -p /tmp/p$1
	mount /dev/mmcblk0p$1 /tmp/p$1
}
mountosmc() {
	mountmmc 7
}

bootosmc() {
	echo 6 > /sys/module/bcm2709/parameters/reboot_part
	/var/www/command/rune_shutdown
	reboot
}
bootrune() {
	echo 8 > /sys/module/bcm2709/parameters/reboot_part
	/var/www/command/rune_shutdown
	reboot
}

resetosmc() {
	wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh
	timestart
	
	umount -l /dev/mmcblk0p7 &> /dev/null
	# format with label to match cmdline.txt
	title "$bar Format partition ..."
	label=$( blkid /dev/mmcblk0p7 | awk '{print $2}' | sed -e 's/LABEL="//' -e 's/"//' )
	echo y | mkfs.ext4 -L $label /dev/mmcblk0p7 &> /dev/null
	# extract image files
	mountmmc 7
	mountmmc 1
	bsdtar -xvf /tmp/p1/os/OSMC/root-rbp2.tar.xz -C /tmp/p7 --exclude=/var/cache/apt
	
	### from partition_setup.sh
	vfat_part=$( blkid /dev/mmcblk0p6 | awk '{ print $2 }' )
	vfat_part=${vfat_part//\"/}

	mnt0=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
	label=${mnt0##/*/}
	mnt="/mnt/$label"
	
	fstabcontent="
#device         mount            type  options           dump pass
$vfat_part      /boot            vfat  defaults,noatime  0    0
/dev/mmcblk0p1  /media/RECOVERY  vfat  noauto,noatime    0    0
/dev/mmcblk0p5  /media/SETTINGS  ext4  noauto,noatime    0    0
/dev/mmcblk0p8  /media/boot      vfat  noauto,noatime    0    0
/dev/mmcblk0p9  /media/root      ext4  noauto,noatime    0    0
/dev/sda1       $mnt             ext4  defaults,noatime  0    0
"
	file=/tmp/p7/etc/fstab
	echo "$fstabcontent" | column -t > $file
	w=$( wc -L < $file )                 # widest line
	hr=$( printf "%${w}s\n" | tr ' ' - ) # horizontal line
	sed -i '1 a'$hr $file

	# customize files
	sed -i "s/root:.*/root:\$6\$X6cgc9tb\$wTTiWttk\/tRwPrM8pLZCZpYpHE8zEar2mkSSQ7brQvflqhA5K1dgcyU8nzX\/.tAImkMbRMR0ex51LjPsIk8gm0:17000:0:99999:7:::/" /tmp/p7/etc/shadow
	sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/" /tmp/p7/etc/ssh/sshd_config
	cp -r /tmp/p1/os/OSMC/custom/. /tmp/p7
	chmod 644 /tmp/p7/etc/udev/rules.d/usbsound.rules
	chmod 755 /tmp/p7/home/osmc/*.py
	chown -R 1000:1000 /tmp/p7/home/osmc
	
	### from setup.sh
	mkdir -p $mnt/varcache/apt
	rm -r /tmp/p7/var/cache/apt
	ln -s $mnt/varcache/apt /tmp/p7/var/cache/apt
	touch /tmp/p7/walkthrough_completed
	rm /tmp/p7/vendor
	wget -qN --show-progress https://github.com/rern/OSMC/raw/master/_settings/cmd.sh -P /etc/profile.d
	
	timestop
	title -l = "$bar OSMC reset successfully."
	
	yesno 'Reboot to OSMC:' ansre
	[[ $ansre == 1 ]] && bootosmc
}

hardreset() {
	echo
	echo "Reset to virgin OS:"
	echo -e '  \e[0;36m0\e[m Cancel'
	echo -e '  \e[0;36m1\e[m OSMC'
	echo -e '  \e[0;36m2\e[m NOOBS: OSMC + Rune'
	echo
	echo -e '\e[0;36m0\e[m / 1 / 2 ? '
	read -n 1 ans
	echo
	case $ans in
		1) resetosmc;;
		2) mountmmc 1
			echo -n " forcetrigger" >> /tmp/p1/recovery.cmdline
			/var/www/command/rune_shutdown
			reboot;;
		*) ;;
	esac
}
