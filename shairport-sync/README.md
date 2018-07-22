### shairport-sync

Compiled from [shairport-sync](https://github.com/mikebrady/shairport-sync) with `---with-metadata` for metadata retrieval.

**Install**
```sh
wget https://github.com/rern/RuneAudio/raw/master/shairport-sync/shairport-sync-3.2.1-1-armv7h.pkg.tar.xz
wget https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wget https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
pacman -Sy libconfig
pacman -U shairport-sync-3.2.1-1-armv7h.pkg.tar.xz
```

**Configure**
```sh
# set usable volume range
sed -i '/name = "%H"/ i\
    volume_range_db = 50;
' /etc/shairport-sync.conf

# get dac's output_device
ao=$( redis-cli get ao )
if [[ ${ao:0:-2} == 'bcm2835 ALSA' ]]; then
	output_device=0
else
	output_device=$( aplay -l | grep "$ao" | sed 's/card \(.\):.*/\1/' )
fi
echo 'output_device = '$output_device

# get dac's output_format
for format in U8 S8 S16 S24 S24_3LE S24_3BE S32; do
	std=$( cat /dev/urandom | timeout 1 aplay -q -f $format 2>&1 )
	[[ -z $std ]] && output_format=$format
done
echo 'output_format = '$output_format

# ## set alsa = {...}
sed -i '/output_device = "default"/ i\
    output_device = "hw:1";\
    output_format = "S32";
' /etc/shairport-sync.conf
# onboard dac (3.5mm jack)
#     output_device = "hw:0";
#     mixer_control_name = "PCM";
# activate improved onboard dac (3.5mm jack) audio driver
if ! grep 'audio_pwm_mode=2' /boot/config.txt; then
    sed -i '$ a\audio_pwm_mode=2' /boot/config.txt
fi

# set metadata = {...}
sed -i '/enabled = "no"/ i\
    enabled = "yes";\
    include_cover_art = "yes";\
    pipe_name = "/tmp/shairport-sync-metadata";\
    pipe_timeout = 5000;
' /etc/shairport-sync.conf
```

**Usage**
```sh
# start
systemctl start shairport-sync

# shairport-sync-metadata-reader
shairport-sync-metadata-reader < /tmp/shairport-sync-metadata

# standard named pipe cat
cat /tmp/shairport-sync-metadata
# ...
# <item><type>636f7265</type><code>6173616c</code><length>18</length>
# <data encoding="base64">
# U29uZ3Mgb2YgSW5ub2NlbmNl</data></item>
# ...
# ------------------------------------------------------------------------------------------------------------------------
# hex        hex2bin DATA                      JS coversion and usage 
# ------------------------------------------------------------------------------------------------------------------------
# 61736172   asar    base64 artist             artist = atob( DATA );
# 6d696e6d   minm    base64 song               song   = atob( DATA );
# 6173616c   asal    base64 album              album  = atob( DATA );
# 70726772   prgr    base64 start/elapsed/end  st_el_en = atob( DATA ).split( '/' ); second = st_el_en[ n ] / 44100;
# 50494354   PICT    base64 jpeg coverart      background-image = 'url( "data:image/jpeg;base64,DATA" )'; // no conversion
