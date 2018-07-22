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

pacman -S --noconfirm chromium nss harfbuzz freetype2 zlib libjpeg-turbo

# modify file
echo -e "$bar Modify file ..."
# fix - chromium try to probe ipv6
file=/boot/cmdline.txt
echo $file
sed -i 's/ ipv6.disable=1//' $file
# fix - page scaling
file=/boot/config.txt
echo $file
sed -i '/disable_overscan=1/ s/^#//' $file

# replace midori with chromium
if [[ $1 != u ]]; then
	z=$1;
	zoom=$( echo "0.5 $z 3" \
      | awk '{
          if (( $1 < $2 && $2 < $3 ))
            print $2
          else if (( $2 < $1 ))
            print $1
          else
            print $3
        }'
	)
else
	zoom=$( redis-cli get chrozoom )
	redis-cli del chrozoom &> /dev/null
fi

file=/boot/config.txt
echo $file
echo 'disable_overscan=1
hdmi_ignore_cec=1' >> $file

file=/root/.xinitrc
echo $file
sed -i '/^midori/ {
s/^/#/
a\
chromium --no-sandbox --app=http://localhost --start-fullscreen --force-device-scale-factor='$zoom'
}
' $file

installfinish $@

redis-cli save

title "$info Please reboot."
title -nt "$bar It may take a couple minutes for Chromium 1st launch."

