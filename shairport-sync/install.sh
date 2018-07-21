#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=shai

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart

getuninstall

pkg=shairport-sync-3.2.1-1-armv7h.pkg.tar.xz

wgetnc https://github.com/rern/RuneAudio/raw/$branch/shairport-sync/shairport.php
wgetnc https://github.com/rern/RuneAudio/raw/$branch/shairport-sync/$pkg
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
pacman -Sy --noconfirm libconfig
pacman -U --noconfirm $pkg

rm $pkg

# get dac's output_device
ao=$( redis-cli get ao )
if [[ ${ao:0:-2} == 'bcm2835 ALSA' ]]; then
	# activate improved onboard dac (3.5mm jack) audio driver
	if ! grep 'audio_pwm_mode=2' /boot/config.txt; then
    	sed -i '$ a\audio_pwm_mode=2' /boot/config.txt
	fi
	string=$( cat <<'EOF'
	output_device=0;
	mixer_control_name = "PCM";
EOF
)
else
	output_device=$( aplay -l | grep "$ao" | sed 's/card \(.\):.*/\1/' )
	# get dac's output_format
	echo -e "$bar Get DAC Sample Format ..."
	for format in U8 S8 S16 S24 S24_3LE S24_3BE S32; do
		std=$( cat /dev/urandom | timeout 1 aplay -q -f $format 2>&1 )
		[[ -z $std ]] && output_format=$format
	done
	echo "Sample format = $output_format"
	string=$( cat <<EOF
	output_device = "hw:$output_device";
    output_format = "$output_format";
EOF
)
fi
# set config
sed -i -e "/output_device = / i\
$string
" -i '/name = "%H"/ i\
    volume_range_db = 50;
' -e '/enabled = "no"/ i\
    enabled = "yes";\
    include_cover_art = "yes";\
    pipe_name = "/tmp/shairport-sync-metadata";\
    pipe_timeout = 5000;
' -e '/run_this_before_play_begins/ i\
    run_this_before_play_begins = '/var/www/command/airplay_toggle on';\
    run_this_after_play_ends = '/var/www/command/airplay_toggle off';\
    session_timeout = 120;
' /etc/shairport-sync.conf

systemctl stop shairport
systemctl disable shairport
systemctl start shairport-sync
systemctl enable shairport-sync

file=/srv/http/command/rune_Pl_wrk
echo $file
comment "activePlayer === 'Airplay'" -n -5 'close Redis connection'

installfinish
