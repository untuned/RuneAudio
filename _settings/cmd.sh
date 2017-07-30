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
	pathtmp=/tmp/p7
	vfat_part=$( blkid /dev/mmcblk0p6 | awk '{ print $2 }' )
	vfat_part=${vfat_part//\"/}

	mnt0=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
	label=${mnt0##/*/}
	mnt="/mnt/$label"
	
	fstabcontent="
#device         mount      type  options
$vfat_part      /boot      vfat  defaults,noatime
/dev/mmcblk0p1  /media/p1  vfat  noauto,noatime
/dev/mmcblk0p5  /media/p5  ext4  noauto,noatime
/dev/mmcblk0p8  /media/p8  vfat  noauto,noatime
/dev/mmcblk0p9  /media/p9  ext4  noauto,noatime
/dev/sda1       $mnt       ext4  defaults,noatime
"
	file=$pathtmp/etc/fstab
	echo "$fstabcontent" | column -t > $file
	
	w=$( wc -L < $file )                 # widest line
	hr=$( printf "%${w}s\n" | tr ' ' - ) # horizontal line
	sed -i '1 a\#'$hr $file
	
	path=$pathtmp/media
	mkdir -p $path/p1 $path/p5 $path/p8 $path/p9

	# customize files
	sed -i "s/root:.*/root:\$6\$X6cgc9tb\$wTTiWttk\/tRwPrM8pLZCZpYpHE8zEar2mkSSQ7brQvflqhA5K1dgcyU8nzX\/.tAImkMbRMR0ex51LjPsIk8gm0:17000:0:99999:7:::/" $pathtmp/etc/shadow
	sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/" $pathtmp/etc/ssh/sshd_config
	cp -r /tmp/p1/os/OSMC/custom/. $pathtmp
	chmod 644 $pathtmp/etc/udev/rules.d/usbsound.rules
	chmod 755 $pathtmp/home/osmc/*.py
	chown -R 1000:1000 $pathtmp/home/osmc
	
	### from setup.sh
	mkdir -p $mnt/varcache/apt
	rm -r $pathtmp/var/cache/apt
	ln -s $mnt/varcache/apt $pathtmp/var/cache/apt
	touch $pathtmp/walkthrough_completed
	rm $pathtmp/vendor
	wget -qN --show-progress https://github.com/rern/OSMC/raw/master/_settings/cmd.sh -P $pathtmp/etc/profile.d
	
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
