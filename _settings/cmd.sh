#!/bin/bash

alias ls='ls -a --color --group-directories-first'
export LS_COLORS='tw=01;34:ow=01;34:ex=00;32:or=31'
info='\e[30m\e[46m i \e[0m'
yesno='\e[30m\e[43m ? \e[0m'

tcolor() { 
	echo -e "\e[38;5;10m$1\e[0m"
}

sstt() {
	echo -e '\n'$( tcolor "systemctl status $1" )'\n'
	systemctl status $1
}
ssta() {
	echo -e '\n'$( tcolor "systemctl start $1" )'\n'
	systemctl start $1
}
ssto() {
	echo -e '\n'$( tcolor "systemctl stop $1" )'\n'
	systemctl stop $1
}
sres() {
	echo -e '\n'$( tcolor "systemctl restart $1" )'\n'
	systemctl restart $1
}
srel() {
	echo -e '\n'$( tcolor "systemctl reload $1" )
	systemctl reload $1
}
sdre() {
	echo -e '\n'$( tcolor "systemctl daemon-reload" )'\n'
	systemctl daemon-reload
}
sfpm() {
	echo -e '\n'$( tcolor "systemctl reload php-fpm" )'\n'
	systemctl reload php-fpm
}

mntsettings=/tmp/p5
mkdir -p $mntsettings
mount /dev/mmcblk0p5 $mntsettings 2> /dev/null
installedlist=$( grep 'name\|mmc' $mntsettings/installed_os.json )

# mount sd
# omit current os)
currentroot=$( mount | grep 'on / ' | cut -d' ' -f1 | cut -d'/' -f3 )
currentline=$( echo "$installedlist" | sed -n "/$currentroot/=" )
osarraymount=( $( 
	echo "$installedlist" |
	sed "$(( currentline - 2 )), $currentline d" |
	sed -n '/name/,/mmcblk/ p' |
	sed '/part/ d; s/\s//g; s/"//g; s/,//; s/name://; s/\/dev\/mmcblk0p//' 
) )
ilength=${#osarraymount[*]}
mountlist="
$yesno \e[36mMount\e[m SD partition:
  \e[36m0\e[m Cancel
  \e[36m1\e[m RECOVERY
  \e[36m2\e[m SETTINGS
"
j=2
mountarray=(0 1 5)
for (( i=0; i < ilength; i+=2 )); do
	iname=${osarraymount[i]}
	j=$(( j + 1 ))
	mountlist+="  \e[36m$j\e[m ${iname}-boot\n"
	j=$(( j + 1 )) 
	mountlist+="  \e[36m$j\e[m ${iname}-root\n"
	imount=${osarraymount[i + 1]}
	mountarray+=($imount $(( imount + 1 )))
done

mmc() {
	if (( $# > 0 )); then
		p=$1
		if (( $p > 1 && $p < 5 )); then
			echo -e "$info \e[36m/dev/mmcblk0p$p\e[m not available."
			return
		fi
	else
		echo -e "$mountlist"
		echo -e "\e[36m0\e[m / n ? "
		read -n 1 ans
		echo
		[[ -z $ans || $ans == 0 ]] && return
		p=${mountarray[$ans]}
	fi
	
	mountline=$( mount | grep "mmcblk0p$p " )
	name=${namearray[$ans]}
	if [[ $mountline ]]; then
		mntdir=$( echo $mountline | cut -d' ' -f3 )
		echo -e "$info \e[36m$name\e[m already mounted at \e[36m$mntdir\e[m\n"
	else
		mntdir=/tmp/p$p
		mkdir -p $mntdir
		mount /dev/mmcblk0p$p $mntdir
		echo -e "$info \e[36m$name\e[m mounted at \e[36m$mntdir\e[m\n"
	fi
}
mmcall() {
	ilength=${#mountarray[*]}
	for (( i=1; i < ilength; i++ )); do
		p=${mountarray[i]}
		mntdir=/tmp/p$p
		mkdir -p $mntdir
		mount /dev/mmcblk0p$p $mntdir 2> /dev/null
	done
}

# reboot
osarrayboot=( $( 
	echo "$installedlist" |
	sed -n '/name/,/mmcblk/ p' |
	sed '/part/ d; s/\s//g; s/"//g; s/,//; s/name://; s/\/dev\/mmcblk0p//' 
) )
ilength=${#osarrayboot[*]}
bootlist="
$yesno \e[36mReboot\e[m to OS:
  \e[36m0\e[m Cancel
"
bootarray=(0)
for (( i=0; i < ilength; i+=2 )); do
	bootlist+="  \e[36m$(( i / 2 + 1 ))\e[m ${osarrayboot[i]}\n"
	bootarray+=(${osarrayboot[i + 1]})
done

boot() {
	echo -e "$bootlist"
	echo -e "\e[36m0\e[m / n ? "
	read -n 1 ans
	echo
	[[ -z $ans || $ans == 0 ]] && return
	
	bootnum=${bootarray[$ans]}
	
 	[[ -e /root/reboot.py ]] && /root/reboot.py $bootnum
	
	[[ -d /home/osmc ]] && reboot $bootnum
	
 	echo $bootnum > /sys/module/bcm2709/parameters/reboot_part
 	/var/www/command/rune_shutdown 2> /dev/null; reboot
}

if [[ -d /home/osmc ]]; then
	pkgcache() {
		mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
		mkdir -p $mnt/varcache/apt/archives
		echo "Dir::Cache::Archives $mnt/varcache/apt;" > /etc/apt/apt.conf.d/70dir-cache
	}
	setup() {
		if [[ -e /usr/local/bin/uninstall_motd.sh ]]; then
			echo -e "\n$info Already setup."
		else
			wget -qN --show-progress https://github.com/rern/OSMC/raw/master/_settings/setup.sh
			chmod +x setup.sh
			./setup.sh
		fi
	}
else
	pkgcache() {
		mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
		mkdir -p $mnt/varcache/pacman/pkg
		sed -i "s|^#CacheDir.*|CacheDir    = $mnt/varcache/pacman/pkg/|" /etc/pacman.conf
	}
	setup() {
		if [[ -e /usr/local/bin/uninstall_addo.sh ]]; then
			echo -e "$info Already setup."
		else
			wget -qN --no-check-certificate --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/setup.sh
			chmod +x setup.sh
			./setup.sh
		fi
	}
fi
