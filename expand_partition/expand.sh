#!/bin/bash

rm $0

[[ ! -e /srv/http/title.sh ]] && wget -q https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/title.sh -P /srv/http
. /srv/http/title.sh

if [[ ! -e /usr/bin/sfdisk ]] || [[ ! -e /usr/bin/python2 ]]; then
	title -l '=' "$info Unable to continue with this version."
	title -n "sfdisk and python2 expected but not found."
	exit
fi

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
	ls /dev/sd?
	echo
	read -n 1 -s -p 'Press any key to continue ... '
	echo
fi

# expand partition #######################################
title -l '=' "$bar Expand partition ..."
printf "%-23s %s\n"     'Current partiton      :' $devpart
printf "%-23s %5s %s\n" 'Available free space  :' $freemb MB
printf "%-23s %5s %s\n" 'Available unused space:' $unpartmb MB
echo

if [[ -t 1 ]]; then
	yesno "Expand partiton to full unused space:" answer
	if [[ $answer == 0 ]]; then
		title "$info Expand partition cancelled."
		exit
	fi
fi

if ! pacman -Q parted &>/dev/null; then
	echo -e "$bar Install parted ..."
	wgetnc https://github.com/rern/RuneAudio/raw/master/expand_partition/parted-3.2-5-armv7h.pkg.tar.xz
	pacman -U --noconfirm parted-3.2-5-armv7h.pkg.tar.xz
	rm parted-3.2-5-armv7h.pkg.tar.xz
fi

echo -e "$bar fdisk ..."
echo -e "d\n\nn\n\n\n\n\nw" | fdisk $disk &>/dev/null

partprobe $disk

echo -e "\n$bar resize2fs ..."
resize2fs $devpart
	
if [[ $? != 0 ]]; then
	title -l '=' "$warn Expand partition failed."
	title -nt "Try: reboot > resize2fs $devpart"
	exit
else
	freekb=$( df | grep '/$' | awk '{print $4}' )
	freemb=$( python2 -c "print($freekb / 1000)" )
	
	redis-cli hset addons expa 1 &> /dev/null # mark as expanded - disable webui button
	title -l '=' "$bar Partiton $( tcolor $devpart ) now has $( tcolor $freemb ) MB free space."
fi
