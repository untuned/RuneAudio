### shairport-sync

Compiled from [shairport-sync](https://github.com/mikebrady/shairport-sync) with `---with-metadata` for metadata retrieval.

**Compile**
```sh
# with normal ArchLinuxArm build environment setup
pacman -Sy libconfig xmltoman

# add user and group
useradd shairport-sync
```

**Configure**
```sh
# activate improved audio driver
if ! grep 'audio_pwm_mode=2' /boot/config.txt; then
    sed -i '$ a\audio_pwm_mode=2' /boot/config.txt
fi

# set config - usb dac
sed -i -e '/output_device = "default"/ i\
    output_device = "hw:0";\
	output_format = "S32";
' /etc/shairport-sync.conf

# set config - onboard dac (3.5mm jack)
sed -i -e '/output_device = "default"/ i\
    output_device = "hw:1";\
    mixer_control_name = "PCM";
' /etc/shairport-sync.conf

# set metadata pipe
sed -i '/enabled = "no"/ i\
	enabled = "yes";\
	include_cover_art = "yes";\
	pipe_name = "/tmp/shairport-sync-metadata";\
	pipe_timeout = 5000;
' /etc/shairport-sync.conf

wget https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wget https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
pacman -Sy libconfig

# start
systemctl start shairport-sync

# metadata pipe
shairport-sync-metadata-reader < /tmp/shairport-sync-metadata
```
