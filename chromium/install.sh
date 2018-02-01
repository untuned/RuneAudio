#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=chro

. /srv/http/addonstitle.sh

if ! pacman -Qi mpd &> /dev/null; then
	title "$info MPD must be upgraged first."
	exit
fi

installstart $@

getuninstall

pacman -S --noconfirm chromium nss harfbuzz freetype2

# modify file
echo -e "$bar Modify file ..."
# fix - chromium try to probe ipv6
file=/boot/cmdline.txt
echo $file
sed -i 's/ ipv6.disable=1//' $file
# fix - page scaling
file=/boot/config.txt
if grep -q '^disable_overscan' $file; then
	echo $file
	sed -i '$ a\disable_overscan=1' $file
fi
# replace midori with chromium
if [[ $1 != u ]]; then
	zoom=$1;
	zoom=$( echo $zoom | awk '{if ($1 < 0.5) print 0.5; else print $1}' )
	zoom=$( echo $zoom | awk '{if ($1 > 2) print 2; else print $1}' )
else
	zoom=$( redis-cli get chrozoom )
	redis-cli del chrozoom &> /dev/null
fi

file=/root/.xinitrc
echo $file
sed -i '/^midori/ {
s/^/#/
a\
chromium --no-sandbox --app=http://localhost --start-fullscreen --force-device-scale-factor='$zoom'
}
' $file

installfinish $@

echo -e "$info Please wait until reboot finished ..."
partroot=$( mount | grep 'on / ' | cut -d' ' -f1 )
partboot=${partroot/\/dev\/mmcblk0p}
echo $(( partboot - 1 )) > /sys/module/bcm2709/parameters/reboot_part
/var/www/command/rune_shutdown
reboot
