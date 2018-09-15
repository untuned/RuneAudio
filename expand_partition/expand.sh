#!/bin/bash

rm $0

[[ ! -e /srv/http/addonstitle.sh ]] && wget -q https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/addonstitle.sh -P /srv/http
. /srv/http/addonstitle.sh

devpart=$( mount | grep 'on / type' | awk '{print $1}' )
part=${devpart/\/dev\//}
disk=/dev/${part::-2}

free=$( df -h / | tail -n1 | awk '{print $4}' )
unpart=$( sfdisk -F | grep mmcblk0 )
unpartnum=$( echo $unpart | awk '{print $4}' )
unpart=$( echo $unpart | awk '{print $4$5}' | tr -d ',' )

# noobs has 3MB unpartitioned space
if [[ $unpartnum -lt 10 ]]; then
	title -l '=' "$info No expandable space available. ( $unpart unused space )"
	redis-cli hset addons expa 1 &> /dev/null
	exit
fi

# expand partition #######################################
title -l '=' "$bar Expand partition ..."
printf "%-23s %s\n"     'Current partiton :' $devpart
printf "%-23s %5s %s\n" 'Available space  :' $free'iB'
printf "%-23s %5s %s\n" 'Expandable space :' $unpart
echo

if [[ -t 1 ]]; then
	yesno "Expand partiton to full expandable space:" answer
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
	free=$( df -h / | tail -n1 | awk '{print $4}' )
	redis-cli hset addons expa 1 &> /dev/null # mark as expanded - disable webui button
	title -l '=' "$bar Partiton $( tcolor $devpart ) now has $( tcolor ${free}iB ) available space."
fi
