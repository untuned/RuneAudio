#!/bin/bash

. /srv/http/addonstitle.sh

# get dac's output_device
ao=$( redis-cli get ao )
if [[ ${ao:0:-2} == 'bcm2835 ALSA' ]]; then
	# activate improved onboard dac (3.5mm jack) audio driver
	if ! grep 'audio_pwm_mode=2' /boot/config.txt; then
    	sed -i '$ a\audio_pwm_mode=2' /boot/config.txt
	fi
	string=$( cat <<'EOF'
	output_device = 0;
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
echo $string

# set config
sed -i -e '/^\s*output_device\|^\s*mixer_control_name\|^\s*output_format/ d
' -e "/output_device = / i\
$string
" /etc/shairport-sync.conf

systemctl restart shairport-sync

title -l '=' "$info AirPlay output changed to $ao"
