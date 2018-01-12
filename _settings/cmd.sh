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

mkdir -p /tmp/p5
mount /dev/mmcblk0p5 /tmp/p5 2> /dev/null
part=$( sed -n '/name/,/mmcblk/ p' /tmp/p5/installed_os.json | sed '/part/ d; s/\s//g; s/"//g; s/,//; s/name://; s/\/dev\/mmcblk0p//' )
partarray=( $( echo $part ) )
ilength=${#partarray[*]}
bootlist="
$yesno Reboot to OS:
  \e[36m0\e[m Cancel
"
namearray=('0')
mountarray=(x)
for (( i=0; i < ilength; i++ )); do
	ivalue=${partarray[i]}
	if (( $(( i % 2 )) == 0 )); then
		bootlist+="  \e[36m$(( i / 2 + 1 ))\e[m $ivalue\n"
		namearray+=(${ivalue}-boot ${ivalue}-root)
	else
		j=${partarray[i]}
		mountarray+=($j $(( j + 1 )))
	fi
done

ilength=${#mountarray[*]}
mountlist="
$yesno Mount SD partition:
  \e[36m0\e[m Cancel
"
for (( i=1; i < ilength; i++ )); do
	mountlist+="  \e[36m$i\e[0m ${namearray[i]}\n"
done

mmc() {
	if (( $# > 0 )); then
		p=$1
		if (( $p > 1 && $p < 5 )); then
			echo -e "$info \e[36m/dev/mmcblk0p$p\e[0m not available."
			return
		fi
	else
		echo -e "$mountlist"
		echo
		echo -e "\e[36m0\e[m / partition ? "
		read -n 1 ans
		echo
		[[ -z $ans || $ans == 0 ]] && return
		p=${mountarray[$ans]}
	fi
	
	mountline=$( mount | grep "mmcblk0p$p " )
	name=${namearray[$ans]}
	if [[ $mountline ]]; then
		mountpoint=$( echo $mountline | cut -d' ' -f3 )
		echo -e "$info \e[36m$name\e[0m already mounted at \e[36m$mountpoint\e[0m\n"
	else
		mntdir=/tmp/p$p
		mkdir -p $mntdir
		mount /dev/mmcblk0p$p $mntdir
		echo -e "$info \e[36m$name\e[0m mounted at \e[36m$mntdir\e[0m\n"
	fi
}

boot() {
	echo -e "$bootlist"
	echo
	bootlistnum=$( seq $(( ${#bootarray[*]} - 1 )) )
	bootlistnum=$( echo $bootlistnum )
	echo -e "\e[36m0\e[m / ${bootlistnum// / \/ } ? "
	read -n 1 ans
	echo
	[[ -z $ans || $ans == 0 ]] && return
	
	partboot=${bootarray[$ans]}
 	if [[ -e /root/reboot.py ]]; then
	 	/root/reboot.py $partboot
		exit
	fi
	
 	echo $partboot > /sys/module/bcm2709/parameters/reboot_part
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
			echo -e "\n\e[30m\e[43m ! \e[0m Already setup."
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
