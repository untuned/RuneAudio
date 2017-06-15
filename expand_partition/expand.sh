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

# partition data #######################################
freekb=$( df | grep '/$' | awk '{print $4}' ) # free disk space in kB
freemb=$( python2 -c "print($freekb / 1000)" ) # bash itself cannot do float
devpart=$( mount | grep 'on / type' | awk '{print $1}' )
part=${devpart/\/dev\//}
disk='/dev/'${part::-2}

unpartb=$( sfdisk -F | grep $disk | awk '{print $6}' )
unpartmb=$( python2 -c "print($unpartb / 1000000)" )
summb=$(( $freemb + $unpartmb ))

if [[ echo $unpartb = 0 ]]; then
	titleend "No unused space available."
	exit
fi

if ls /dev/sd* &>/dev/null; then
	title "$info Unmount and remove all USB drives before proceeding:"
	echo -e '\e[0;36m'ls /dev/sd* '\e[m'
	echo
	echo 'Precaution - To make sure only SD card to be expanded.'
	echo
	read -n 1 -s -p 'Press any key to continue ... '
	echo
fi

# expand partition #######################################
title2 "Available unused disk space: \e[0;36m$unpartmb\e[m MB"
echo -e "Current available free space \e[0;36m$freemb\e[m MB"
echo
echo -e "Expand partiton \e[0;36m$devpart\e[m to full unused space:"
echo -e '  \e[0;36m0\e[m Cancel'
echo -e '  \e[0;36m1\e[m Expand'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) if ! pacman -Q parted &>/dev/null; then
			title "Get packages file ..."
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
