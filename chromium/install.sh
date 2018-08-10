#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=chro

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

pacman -S --noconfirm chromium nss harfbuzz freetype2 zlib libjpeg-turbo

echo -e "$bar Modify file ..."

# -----------------------------------------------------------------------------
# fix - chromium try to probe ipv6
file=/boot/cmdline.txt
echo $file
sed -i 's/ ipv6.disable=1//' $file
# -----------------------------------------------------------------------------
# remove black border on local screen
file=/boot/config.txt
echo $file

commentS 'disable_overscan=1'
# -----------------------------------------------------------------------------
file=/boot/config.txt
echo $file

string=$( cat <<'EOF'
disable_overscan=1
hdmi_ignore_cec=1
EOF
)
appendS '$'
# -----------------------------------------------------------------------------
# replace midori with chromium
zoom=$( redis-cli hget settings zoom )
file=/root/.xinitrc
echo $file

commentS 'midori'

string=$( cat <<EOF
chromium --no-sandbox --app=http://localhost --start-fullscreen --force-device-scale-factor=$zoom
EOF
)
appendS '$'

installfinish $@

echo -e "Chromium will take a little longer to launch."
title -nt  "$info Please wait Reinitialize for 5 seconds before continue."

systemctl restart rune_SY_wrk

