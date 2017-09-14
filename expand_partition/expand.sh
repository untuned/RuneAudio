#!/bin/bash

# expand.sh - expand partition
# https://github.com/rern/expand_partition

rm $0

# import heading function
wget -qN https://github.com/rern/RuneAudio_Addons/raw/master/title.sh; . title.sh; rm title.sh

if [[ ! -e /usr/bin/sfdisk ]] || [[ ! -e /usr/bin/python2 ]]; then
	title -l '=' "$info Unable to continue with this version."
	title -n "sfdisk and python2 expected but not found."
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
	title -l '=' "$info No useful space available. ( ${unpartmb}MB unused space )"
	redis-cli hset addons expa 1 &> /dev/null
	exit
fi

if [[ -t 1 ]] && ls /dev/sd* &>/dev/null; then
	echo -e "$info Unmount and remove all USB drives before proceeding:"
	hdd=$( ls /dev/sd? )
	echo -e "\e[0;36m$hdd\e[m"
	echo
	read -n 1 -s -p 'Press any key to continue ... '
	echo
fi

# expand partition #######################################
title -l '=' "$bar Expand partition ..."
echo -e "Current partiton: \e[0;36m$devpart\e[m"
echo -e "Available free space \e[0;36m$freemb MB\e[m"
echo -e "Available unused disk space: \e[0;36m$unpartmb MB\e[m"
echo

[[ -t 1 ]] && yesno "Expand partiton to full unused space:" answer

if [[ -t 1 && $answer == 0 ]]; then
	title "$info Expand partition cancelled."
	exit
fi

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
	# expanded marking
	redis-cli hset addons expa 1 &> /dev/null
	title -l '=' "$bar Partiton \e[0;36m$devpart\e[m now has \e[0;36m$freemb\e[m MB free space."
fi
