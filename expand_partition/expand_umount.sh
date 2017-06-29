#!/bin/bash

# expand.sh - expand partition
# https://github.com/rern/expand_partition

rm expand.sh

linered='\e[0;31m---------------------------------------------------------\e[m'
line2='\e[0;36m=========================================================\e[m'
line='\e[0;36m---------------------------------------------------------\e[m'
bar=$( echo -e "$(tput setab 6)   $(tput setab 0)" )
warn=$( echo $(tput setab 1) ! $(tput setab 0) )
info=$( echo $(tput setab 6; tput setaf 0) i $(tput setab 0; tput setaf 7) )

# functions #######################################

title2() {
	echo -e "\n$line2\n"
	echo -e "$bar $1"
	echo -e "\n$line2\n"
}
title() {
	echo -e "\n$line"
	echo $1
	echo -e "$line\n"
}
titleend() {
	echo -e "\n$1"
	echo -e "\n$line\n"
}

if [[ ! -e /usr/bin/sfdisk ]] || [[ ! -e /usr/bin/python2 ]]; then
	title "$info Unable to continue (sfdisk / python2 not found)."
	exit
fi

# partition data #######################################
freekb=$( df | grep '/$' | awk '{print $4}' ) # free disk space in kB
freemb=$( python2 -c "print($freekb / 1000)" ) # bash itself cannot do float
devpart=$( mount | grep 'on / type' | awk '{print $1}' )
part=${devpart/\/dev\//}
disk='/dev/'${part::-2}

unpartmb=$( sfdisk -F | grep $disk | awk '{print $4}' )
summb=$(( $freemb + $unpartmb ))
# noobs has 3MB unpartitioned space
if (($unpartmb < 10)); then
	title "$info No useful space available. ( ${unpartmb}MB unused)"
	exit
fi

# check usb drives
if ls /dev/sd? &>/dev/null; then
	hdd=$( ls /dev/sd? )
	mnt=$( df | grep '/dev/sd' | awk '{print $NF}' )
	title "$info Unmount and remove all USB drives before proceeding:"
	echo 'Remove to make sure only SD card to be expanded.'
	echo
	echo -e "Drive: \e[0;36m$hdd\e[m"
	
	if df | grep '/dev/sd' &>/dev/null; then
		echo -e "Mount: \e[0;36m$mnt\e[m"
		title "$info Unmount: $mnt"
		echo -e '  \e[0;36m0\e[m No'
		echo -e '  \e[0;36m1\e[m Yes'
		echo
		echo -e '\e[0;36m0\e[m / 1 ? '
		read -n 1 answer
		case $answer in
			1 ) umount -l /dev/sd??
				if [ $? -eq 0 ]; then
					echo -e "\n$info USB drive: \e[0;36m$hdd\e[m unmounted and can be removed now.\n"
					read -n 1 -s -p 'Press any key to continue ... '
					echo
				else
					echo -e "$info USB drive: $mnt unmount failed."
					echo "Continue:"
					echo -e '  \e[0;36m0\e[m No'
					echo -e '  \e[0;36m1\e[m Yes'
					echo
					echo -e '\e[0;36m0\e[m / 1 ? '
					read -n 1 answer
					case $answer in
						1 ) echo;;
						* ) exit;;
					esac
				fi
				;;
			* ) echo;;
		esac
	else
		read -n 1 -s -p 'Press any key to continue ... '
		echo
	fi
fi

# expand partition #######################################
title2 "Expand partition"
echo -e "Current partiton: \e[0;36m$devpart\e[m"
echo -e "Current available free space: \e[0;36m$freemb MB\e[m"
echo -e "Available unused disk space: \e[0;36m$unpartmb MB\e[m"
echo
echo -e "Expand partiton to full unused space:"
echo -e '  \e[0;36m0\e[m Cancel'
echo -e '  \e[0;36m1\e[m Expand'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) if ! pacman -Q parted &>/dev/null; then
			title "Get package file ..."
			wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/expand_partition/parted-3.2-5-armv7h.pkg.tar.xz
			pacman -U --noconfirm parted-3.2-5-armv7h.pkg.tar.xz
			rm parted-3.2-5-armv7h.pkg.tar.xz
		fi
		title "Expand partiton ..."
		echo -e 'd\n\nn\n\n\n\n\nw' | fdisk $disk &>/dev/null

		partprobe $disk

		resize2fs $devpart
		if (( $? != 0 )); then
			errorend "$warn Failed: Expand partition\nTry - reboot > resize2fs $devpart"
			exit
		else
			freekb=$( df | grep '/$' | awk '{print $4}' )
			freemb=$( python2 -c "print($freekb / 1000)" )
			echo
			titleend "$info Partiton \e[0;36m$devpart\e[m now has \e[0;36m$freemb\e[m MB free space."
		fi;;

	* ) echo
			titleend "Expand partition canceled."
			exit;;
esac
