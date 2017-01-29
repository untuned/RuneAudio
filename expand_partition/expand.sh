#!/bin/bash

# expand.sh - expand partition
# https://github.com/rern/expand_partition

arg=$#

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
error() {
		echo -e "\n$linered"
		echo $warn $1
		echo -e "$linered\n"
}
errorend() {
		echo -e "\n$warn $1"
		echo -e "\n$linered\n"
}
mirror() { # rank mirrors
	if [ ! -f rankmirrors.sh ]; then 
		wget -q --show-progress -O rankmirrors.sh "https://github.com/rern/ArchLinuxArm_rankmirrors/blob/master/rankmirrors.sh?raw=1"
		chmod +x rankmirrors.sh
	fi
	./rankmirrors.sh
}
installparted() {
	mirror
	title "Install Parted ..."
	pacman -Sy --noconfirm parted
	pa=$?
	if (( $pa != 0 )); then
		error "Failed: Install Parted"
		echo 'Try again:'
		echo -e '  \e[0;36m0\e[m No'
		echo -e '  \e[0;36m1\e[m Yes'
		echo
		echo -e '\e[0;36m0\e[m / 1 ? '
		read -n 1 answer
		case $answer in
			1 ) installparted;;
			* ) echo
				errorend "Expand partition canceled"
				file='/etc/pacman.d/mirrorlist'
				mv $file'.original' $file
				rm expand.sh
				rm rankmirrors.sh
				exit;;	
		esac
	fi
}

# manage partition #######################################

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
	1 ) pacman -Q parted > /dev/null 2>&1
			pa=$?
			if (( $pa != 0 )); then
				echo
				echo 'Update pakage server list ...'
				echo
				installparted
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
			rm expand.sh
			exit;;
esac
