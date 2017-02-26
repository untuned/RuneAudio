#!/bin/bash

# expand.sh - expand partition
# https://github.com/rern/expand_partition

rm expand.sh

linered='\e[0;31m---------------------------------------------------------\e[m'
line2='\e[0;36m=========================================================\e[m'
line='\e[0;36m---------------------------------------------------------\e[m'
bar=$( echo -e "$(tput setab 6)   $(tput setab 0)" )
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

devpart=$( mount | sed -n '/on \/ type/,1p' | awk '{print $1}' )
part=${devpart/\/dev\//}
partini=$( echo $part | cut -c1-3 )
if [ $partini == 'mmc' ]; then
	diskesc='\/dev\/'${part::-2}
else
	diskesc='\/dev\/'$partini
fi
disk=${diskesc//\\/}

freekb=$( df | sed -n 2p | awk '{print $4}' ) # free disk space in kB
freemb=$( awk "BEGIN {print $freekb / 1000}" ) # bash itself cannot do float
unpartgb=$( sfdisk -F | sed -n '/'$diskesc'/,1p' | awk '{print $4}' ) # unpartitoned space in GB
unpartkb=$( awk "BEGIN {print $unpartgb * 1000000}" )
sumkb=$(( $freekb + $unpartkb ))

# expand partition #######################################
title "$info Available unused disk space: $unpartgb GB"
echo 'Current available free space' $freemb 'MB'
echo
echo 'Expand partiton to full unused space:'
echo -e '  \e[0;36m0\e[m Cancel'
echo -e '  \e[0;36m1\e[m Expand'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) if ! pacman -Q parted > /dev/null 2>&1; then
			title "Get packages file ..."
			wget -q --show-progress -O var.tar "https://github.com/rern/RuneAudio/blob/master/expand_partition//_repo/var.tar?raw=1"
			tar -xvf var.tar -C /
			rm var.tar
			pacman -Sy --noconfirm parted
		fi
		title "Expand partiton ..."
		echo -e 'd\n\nn\n\n\n\n\nw' | fdisk $disk > /dev/null 2>&1

		partprobe $disk

		resize2fs $devpart
		resize=$?
		if (( $resize != 0 )); then
			errorend "Failed: Expand partition\nTry - reboot > resize2fs $devpart"
			exit
		else
			freekb=$( df | sed -n 2p | awk '{print $4}' )
			freegb=$( awk "BEGIN {print $freekb / 1000000}" )
			freegbr=$( LC_ALL=C /usr/bin/printf "%.*f\n" 2 $freegb ) # round to 2 decimal
			echo
			echo $info 'Partiton now has' $freegbr 'GB free space.'
		fi;;

	* ) echo
			titleend "Expand partition canceled."
			exit;;
esac
