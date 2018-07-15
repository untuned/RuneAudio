### shairport-sync

Compiled with `--with-meta` for metadata retrieval.

```sh
# activate improved audio driver
if ! grep 'audio_pwm_mode=2' /boot/config.txt; then
    sed -i '$ a\audio_pwm_mode=2' /boot/config.txt
fi

# turn off WiFi Power Management
iwconfig wlan0 power off

# set config
sed -i -e '/output_device = "default"/ i\
    output_device = "hw:0";\
    mixer_control_name = "PCM";
' -e '/enabled = "no"/ i\
	enabled = "yes";\
	include_cover_art = "yes";\
	pipe_name = "/tmp/shairport-sync-metadata";\
	pipe_timeout = 5000;
' /etc/shairport-sync.conf

wget https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wget https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
pacman -Sy libconfig
```
