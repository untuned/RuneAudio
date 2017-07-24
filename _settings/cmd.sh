#!/bin/bash

# terminal
color=51
motd=/etc/motd.banner
[[ -e $motd ]] && echo -e "\e[38;5;${color}m$(< $motd)\e[0m\n"
PS1=$( echo -e "\e[38;5;${color}m$PS1\e[0m" )


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

yesno() {
	echo
	echo "$1"
	echo -e '  \e[0;36m0\e[m No'
	echo -e '  \e[0;36m1\e[m Yes'
	echo
	echo -e '\e[0;36m0\e[m / 1 ? '
	read -n 1 ans
}
hardresetosmc() {
	yesno 'Reset to virgin OSMC?'	
	if [[ $ans == 1 ]]; then
		mountmmc 1
		umount -l /dev/mmcblk0p7
		mkfs.ext4 /dev/mmcblk0p7
		mountmmc 7
		bsdtar -xvf /tmp/p1/os/OSMC/root-rbp2.tar.xz -C /tmp/p7
	fi
}

}
hardreset() {
	yesno 'Reset to virgin NOOBS?'
	if [[ $ans == 1 ]]; then
		mkdir /tmp/p1
		mount /dev/mmcblk0p1 /tmp/p1
		echo -n " forcetrigger" >> /tmp/p1/recovery.cmdline
		/var/www/command/rune_shutdown
		reboot
	fi
}
