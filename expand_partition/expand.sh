#!/bin/bash

# expand.sh - expand partition
# https://github.com/rern/expand_partition

rm $0

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

if [[ ! -e /usr/bin/sfdisk ]] || [[ ! -e /usr/bin/python2 ]]; then
	echo -e "$info Unable to continue with this version."
	echo "(sfdisk and python2 expected but not found.)"
	exit
fi

# partition data #######################################
freekb=$( df | grep '/$' | awk '{print $4}' ) # free disk space in kB
freemb=$( python2 -c "print($freekb / 1000)" ) # bash itself cannot do float
devpart=$( mount | grep 'on / type' | awk '{print $1}' )
part=${devpart/\/dev\//}
disk=/dev/${part::-2}

unpartb=$( sfdisk -F | grep $disk | awk '{print $6}' )
unpartmb=$( python2 -c "print($unpartb / 1000000)" )
summb=$(( $freemb + $unpartmb ))
# noobs has 3MB unpartitioned space
if [[ $unpartmb -lt 10 ]]; then
	echo -e "$info No useful space available. ( ${unpartmb}MB unused)"
	redis-cli hset addons expa 1 &> /dev/null
	exit
fi

if ls /dev/sd* &>/dev/null; then
	echo -e "$info Unmount and remove all USB drives before proceeding:"
	hdd=$( ls /dev/sd? )
	echo -e "\e[0;36m$hdd\e[m"
	echo
	echo "Precaution - To make sure only SD card to be expanded."
	echo
	read -n 1 -s -p 'Press any key to continue ... '
	echo
fi

# expand partition #######################################
title -l = $bar Expand partition ...
echo -e "Current partiton: \e[0;36m$devpart\e[m"
echo -e "Available free space \e[0;36m$freemb MB\e[m"
echo -e "Available unused disk space: \e[0;36m$unpartmb MB\e[m"
echo
yesno "Expand partiton to full unused space:" answer
if [[ $answer == 1 ]]; then
	if ! pacman -Q parted &>/dev/null; then
		echo -e "$bar Get package file ..."
		wgetnc https://github.com/rern/RuneAudio/raw/master/expand_partition/parted-3.2-5-armv7h.pkg.tar.xz
		pacman -U --noconfirm parted-3.2-5-armv7h.pkg.tar.xz
		rm parted-3.2-5-armv7h.pkg.tar.xz
	fi
	echo -e "$bar Expand partiton ..."
	echo -e "d\n\nn\n\n\n\n\nw" | fdisk $disk &>/dev/null

	partprobe $disk

	resize2fs $devpart
	if [[ $? != 0 ]]; then
		echo -e "$warn Failed: Expand partition\nTry - reboot > resize2fs $devpart"
		exit
	else
		freekb=$( df | grep '/$' | awk '{print $4}' )
		freemb=$( python2 -c "print($freekb / 1000)" )
		echo
		redis-cli hset addons expa 1 &> /dev/null
		title -l = "$bar Partiton \e[0;36m$devpart\e[m now has \e[0;36m$freemb\e[m MB free space."
	fi
else
	echo -e "$info Expand partition cancelled."
	exit
fi