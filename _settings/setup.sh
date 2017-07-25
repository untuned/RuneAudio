#!/bin/bash

rm $0

# import heading and password function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh
wget -qN https://github.com/rern/tips/raw/master/bash/f_password.sh; . f_password.sh; rm f_password.sh

# passwords
title "$info root password for Samba and Transmission ..."
setpwd

timestart=$( date +%s )

title "$bar Disable WiFi ..."
#################################################################################
systemctl disable netctl-auto@wlan0
systemctl stop netctl-auto@wlan0 shairport udevil upmpdcli

title "$bar Set HDMI mode ..."
#################################################################################
echo "1080p 50Hz, disable overscan (+OSMC)"
# prevent noobs cec hdmi power on
mkdir -p /tmp/p1
mount /dev/mmcblk0p1 /tmp/p1
if [[ -e /tmp/p1/config.txt ]]; then
  ! grep 'hdmi_ignore_cec_init=1' /tmp/p1/config.txt &> /dev/null && echo 'hdmi_ignore_cec_init=1' >> /tmp/p1/config.txt
else
  echo 'hdmi_ignore_cec_init=1' > /tmp/p1/config.txt
fi
# force hdmi mode, remove black border
if ! grep 'hdmi_mode=' /boot/config.txt &> /dev/null; then
echo '
hdmi_ignore_cec=1 # disable cec
hdmi_group=1
hdmi_mode=31      # 1080p 50Hz
disable_overscan=1
' >> /boot/config.txt
fi
# remove 'forcetrigger'
sed -i "s/ forcetrigger//" /tmp/p1/recovery.cmdline

### osmc ######################################
mkdir -p /tmp/p6
mount /dev/mmcblk0p6 /tmp/p6
if ! grep 'hdmi_mode=' /tmp/p6/config.txt &> /dev/null; then
echo '
hdmi_ignore_cec=1
hdmi_group=1
hdmi_mode=31
' >> /tmp/p6/config.txt
fi
sed -i '/^gpio/ s/^/#/
' /tmp/p6/config.txt

title "$bar Mount USB drive to /mnt/hdd ..."
#################################################################################
# disable auto update mpd database
systemctl stop mpd
sed -i '\|sendMpdCommand| s|^|//|' /srv/http/command/usbmount
sed -i '/^KERNEL/ s/^/#/' /etc/udev/rules.d/rune_usb-stor.rules
udevadm control --reload-rules && udevadm trigger

mnt0=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
label=${mnt0##/*/}
mnt="/mnt/$label"
mkdir -p "$mnt"
fstabmnt="/dev/sda1 $mnt ext4 defaults,noatime 0 0"
if ! grep $mnt /etc/fstab &> /dev/null; then
  echo "$fstabmnt" >> /etc/fstab
  umount -l /dev/sda1
  mount -a
fi
[[ -e /mnt/MPD/USB/hdd && $( ls -1 /mnt/MPD/USB/hdd | wc -l ) == 0 ]] && rm -r /mnt/MPD/USB/hdd
ln -s $mnt/Music /mnt/MPD/USB/Music
systemctl start mpd
### osmc ######################################
if ! grep $mnt /tmp/p7/etc/fstab &> /dev/null; then
  mkdir -p /tmp/p7
  mount /dev/mmcblk0p7 /tmp/p7
  echo "$fstabmnt" >> /tmp/p7/etc/fstab
  echo "$fstabmnt (+OSMC)"
fi

title "$bar Set pacman cache ..."
#################################################################################
echo "$mnt/varcache/pacman (+OSMC - $mnt/varcache/apt)"
mkdir -p $mnt/varcache/pacman
rm -r /var/cache/pacman
ln -s $mnt/varcache/pacman /var/cache/pacman

### osmc ######################################
if [[ ! -L /tmp/p7/var/cache/apt ]]; then
	mkdir -p $mnt/varcache/apt
	rm -r /tmp/p7/var/cache/apt
	ln -s $mnt/varcache/apt /tmp/p7/var/cache/apt
fi
# disable setup marker files
touch /tmp/p7/walkthrough_completed # initial setup
rm -f /tmp/p7/vendor # noobs marker for update prompt

title "$bar Set settings ..."
#################################################################################
{
	### Sources ###
	redis-cli set usb_db_autorebuild 0     # usb auto rebuild
	
	### MPD ###
	#redis-cli set ao bcm2835 ALSA_1       # audio output (string*)
	#redis-cli set volume 0                # volume control
	#redis-cli set mpd_start_volume -1     # start volume
	#redis-cli set dynVolumeKnob 0         # volume knob
	
	### Settings ###
	#redis-cli set hostname runeaudio      # hostname (string)
	#hostnamectl set-hostname runeaudio
	#redis-cli set ntpserever pool.ntp.org # ntpserever (string)
	redis-cli set timezone Asis/Bangkok    # timezone (string from list)
	timedatectl set-timezone Asia/Bangkok
	#redis-cli set orionprofile RuneAudio  # sound signature (string from list)
	redis-cli hset airplay enable 0        # airplay
	#hset spotify enable 0                 # spotify
	redis-cli hset dlna enable 0           # upnp/dlna
	#redis-cli set local_browser 0         # local browser
	redis-cli set udevil 0                 # usb automount
	#redis-cli set coverart 0              # album cover
	#redis-cli hset lastfm enable 0        # upnp/dlna
	
	### Development ###
	#redis-cli set opcache 0               # opcache
	#redis-cli set dev 1                   # dev mode
	#redis-cli set debug 0                 # debug
} &> /dev/null

# reboot command and motd
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/motd/install.sh; chmod +x install.sh; ./install.sh
touch /root/.hushlogin

gitpath=https://github.com/rern/RuneAudio/raw/master
wget -qN --show-progress $gitpath/_settings/cmd.sh -P /etc/profile.d
wget -qN --show-progress $gitpath/_settings/rebootosmc.php -P /srv/http
wget -qN --show-progress $gitpath/_settings/rebootrune.php -P /srv/http

# rankmirrors
wget -qN --show-progress $gitpath/rankmirrors/rankmirrors.sh; chmod +x rankmirrors.sh; ./rankmirrors.sh

title "$bar Update package database ..."
#################################################################################
pacman -Sy

title -l = "$bar Upgrade Samba ..."
#################################################################################
pacman -R --noconfirm samba4-rune
pacman -S --noconfirm tdb tevent smbclient samba
# fix missing libreplace-samba4.so (may need to run twice)
pacman -S --noconfirm libwbclient

# fix 'minimum rlimit_max'
echo -n '
root    soft    nofile    16384
root    hard    nofile    16384
' >> /etc/security/limits.conf

wget -q --show-progress $gitpath/_settings/smb.conf -O /etc/samba/smb-dev.conf
ln -sf /etc/samba/smb-dev.conf /etc/samba/smb.conf

# set samba password
(echo $pwd1; echo $pwd1) | smbpasswd -s -a root

title -l = "$bar Samba upgraded successfully."

# Transmission
#################################################################################
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/install.sh; chmod +x install.sh; ./install.sh $pwd1 1 1

# Aria2
#################################################################################
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/install.sh; chmod +x install.sh; ./install.sh 1

# Enhancement
#################################################################################
wget -qN --show-progress https://github.com/rern/RuneUI_enhancement/raw/master/install.sh; chmod +x install.sh; ./install.sh 3

# GPIO
#################################################################################
wget -qN --show-progress $gitpath/_settings/mpd.conf.gpio -P /etc
wget -qN --show-progress $gitpath/_settings/gpio.json -P /srv/http
wget -qN --show-progress https://github.com/rern/RuneUI_GPIO/raw/master/install.sh; chmod +x install.sh; ./install.sh 1

# add reboot menu
sed -i '/id="poweroff"/ i\
                <button id="rebootosmc" name="syscmd" value="rebootosmc" class="btn btn-primary btn-lg btn-block" data-dismiss="modal"><i class="fa fa-refresh sx"></i> Reboot OSMC</button> \
                &nbsp; \
                <button id="rebootrune" name="syscmd" value="rebootrune" class="btn btn-primary btn-lg btn-block" data-dismiss="modal"><i class="fa fa-refresh sx"></i> Reboot Rune</button> \
                &nbsp;
' /srv/http/app/templates/footer.php
sed -i "/function topbottom/ i\
$('#rebootosmc, #rebootrune').click(function() { \
	$.get(this.id +'.php'); \
}
" /srv/http/assets/js/custom.js

# systemctl daemon-reload # done in GPIO install
systemctl restart nmbd smbd

# show installed packages status
title "Installed packages status"
systemctl | egrep 'aria2|nmbd|smbd|transmission'

# update library
mpc update

timeend=$( date +%s )
timediff=$(( $timeend - $timestart ))
timemin=$(( $timediff / 60 ))
timesec=$(( $timediff % 60 ))

title -l = "$bar Setup finished successfully."
title -nt "Duration: $timemin min $timesec sec"
