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

devpart=$( mount | grep 'on / type' | awk '{print $1}' )
part=${devpart/\/dev\//}
partini=${part:0:3}
if [ $partini == 'mmc' ]; then
	disk='/dev/'${part::-2}
else
	disk='/dev/'$partini
fi

freekb=$( df | grep '/$' | awk '{print $4}' ) # free disk space in kB
freemb=$( python -c "print($freekb / 1000)" ) # bash itself cannot do float
unpartb=$( sfdisk -F | grep $disk | awk '{print $6}' ) # unpartitoned space in GB
unpartmb=$( python -c "print($unpartb / 1000000)" )
summb=$(( $freemb + $unpartmb ))

# expand partition #######################################
title "$info Available unused disk space: $unpartmb MB"
echo 'Current available free space' $freemb 'MB'
echo
echo 'Expand partiton to full unused space:'
echo -e '  \e[0;36m0\e[m Cancel'
echo -e '  \e[0;36m1\e[m Expand'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) if ! pacman -Q parted &>/dev/null; then
			title "Get packages file ..."
			wget -q --show-progress -O var.tar "https://github.com/rern/RuneAudio/blob/master/expand_partition//_repo/var.tar?raw=1"
			tar -xvf var.tar -C /
			rm var.tar
			pacman -Sy --noconfirm parted
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
			freemb=$( python -c "print($freekb / 1000)" )
			echo
			titleend "$info Partiton now has $freemb MB free space."
		fi;;

	* ) echo
			titleend "Expand partition canceled."
			exit;;
esac
