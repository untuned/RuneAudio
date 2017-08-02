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

setup() {
	if [[ ! -e /etc/motd.logo ]]; then
		wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/setup.sh
		chmod +x setup.sh
		./setup.sh
	else
		echo -e "Already setup."
	fi
}
resetosmc() {
	wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh
	timestart
	
	title -l = "$bar OSMC reset ..."
	umount -l /dev/mmcblk0p7 &> /dev/null
	# format with label to match cmdline.txt
	echo -e "$bar Format partition ..."
	label=$( blkid /dev/mmcblk0p7 | awk '{print $2}' | sed -e 's/LABEL="//' -e 's/"//' )
	echo y | mkfs.ext4 -L $label /dev/mmcblk0p7 &> /dev/null
	# extract image files
	mountmmc 7
	mountmmc 1
	pathosmc=/tmp/p7
	bsdtar -xvf /tmp/p1/os/OSMC/root-rbp2.tar.xz -C $pathosmc --exclude=./var/cache/apt
	
	### from partition_setup.sh
	vfat_part=$( blkid /dev/mmcblk0p6 | awk '{ print $2 }' )
	vfat_part=${vfat_part//\"/}

	mnt0=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
	label=${mnt0##/*/}
	mnt="/mnt/$label"
	
	echo "
#device         mount      type  options
$vfat_part      /boot      vfat  defaults,noatime
/dev/mmcblk0p1  /media/p1  vfat  noauto,noatime
/dev/mmcblk0p5  /media/p5  ext4  noauto,noatime
/dev/mmcblk0p8  /media/p8  vfat  noauto,noatime
/dev/mmcblk0p9  /media/p9  ext4  noauto,noatime
/dev/sda1       $mnt       ext4  defaults,noatime
" > $pathosmc/etc/fstab
	
	# customize files
	sed -i "s/root:.*/root:\$6\$X6cgc9tb\$wTTiWttk\/tRwPrM8pLZCZpYpHE8zEar2mkSSQ7brQvflqhA5K1dgcyU8nzX\/.tAImkMbRMR0ex51LjPsIk8gm0:17000:0:99999:7:::/" $pathosmc/etc/shadow
	sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/" $pathosmc/etc/ssh/sshd_config
	cp -r /tmp/p1/os/OSMC/custom/. $pathosmc
	chmod 644 $pathosmc/etc/udev/rules.d/usbsound.rules
	chmod 755 $pathosmc/home/osmc/*.py
	chown -R 1000:1000 $pathosmc/home/osmc
	
	### from setup.sh
	mkdir -p $mnt/varcache/apt
	rm -r $pathosmc/var/cache/apt
	ln -s $mnt/varcache/apt $pathosmc/var/cache/apt
	touch $pathosmc/walkthrough_completed
	rm $pathosmc/vendor
	wget -qN --show-progress https://github.com/rern/OSMC/raw/master/_settings/cmd.sh -P $pathosmc/etc/profile.d
	
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
