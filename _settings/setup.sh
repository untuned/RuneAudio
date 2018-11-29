#!/bin/bash

# command shortcuts
# passwords for samba and transmission
# disable hdmi mode, fstab, pacman cache
# preload osmc pre-setup
# restore settings
# install addons

rm $0

[[ ! -e /srv/http/addonstitle.sh ]] && wget -qN --no-check-certificate https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/addonstitle.sh -P /srv/http
. /srv/http/addonstitle.sh

# passwords for samba and transmission
setpwd() {
	echo
	echo -e "$yn Password: "
	read -s pwd1
	echo
	echo 'Retype password: '
	read -s pwd2
	echo
	if [[ $pwd1 != $pwd2 ]]; then
		echo
		echo "$info Passwords not matched. Try again."
		setpwd
	fi
}
echo -e "$bar root password for Samba and Transmission ..."
setpwd

wget -qN --no-check-certificate https://github.com/untuned/RuneAudio/raw/master/_settings/setupsystem.sh
. setupsystem.sh
rm setupsystem.sh

# rankmirrors
#################################################################################
if  grep -q '^Server = http://mirror.archlinuxarm.org/' /etc/pacman.d/mirrorlist; then
	wgetnc $gitpath/rankmirrors/rankmirrors.sh
	chmod +x rankmirrors.sh
	./rankmirrors.sh
fi

# addons menu
#################################################################################
wgetnc https://github.com/rern/RuneAudio_Addons/raw/master/install.sh; chmod +x install.sh; ./install.sh

# motd
#################################################################################
wgetnc $gitpath/motd/install.sh; chmod +x install.sh; ./install.sh 0
touch /root/.hushlogin

# samba
#################################################################################
wgetnc $gitpath/_settings/smb.conf -O /etc/samba/smb.conf
wgetnc $gitpath/samba/install.sh; chmod +x install.sh; ./install.sh $pwd1
echo

# Transmission
#################################################################################
wgetnc $gitpath/transmission/install.sh; chmod +x install.sh; ./install.sh $pwd1 1 1
echo

# Aria2
#################################################################################
wgetnc $gitpath/aria2/install.sh; chmod +x install.sh; ./install.sh 1
echo

# Enhancement
#################################################################################
wgetnc https://github.com/rern/RuneUI_enhancement/raw/master/install.sh; chmod +x install.sh; ./install.sh 1.8
echo

# Lyrics
#################################################################################
wgetnc https://github.com/RuneAddons/Lyrics/raw/master/install.sh; chmod +x install.sh; ./install.sh
echo

# GPIO
#################################################################################
wgetnc $gitpath/_settings/gpio.json -P /srv/http
chown http:http /srv/http/gpio.json
wgetnc https://github.com/rern/RuneUI_GPIO/raw/master/install.sh; chmod +x install.sh; ./install.sh
echo

# USB DAC
#################################################################################
wgetnc $gitpath/USB_DAC/install.sh; chmod +x install.sh; ./install.sh 'bcm2835 ALSA_1'
echo

# mpd
#################################################################################
#wgetnc $gitpath/mpd/install.sh; chmod +x install.sh; ./install.sh

# chromium
#################################################################################
#wgetnc $gitpath/chromium/install.sh; chmod +x install.sh; ./install.sh

systemctl reload php-fpm

# systemctl daemon-reload # done in GPIO install
systemctl restart nmbd smbd

# show installed packages status
title "$bar Installed packages status"
systemctl | egrep 'aria2|nmbd|smbd|transmission'

timestop l
title -l = "$bar Setup finished successfully."

clearcache
