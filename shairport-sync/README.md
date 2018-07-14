### shairport-sync

Compiled with `--with-meta` for metadata retrieval.

```sh
# activate improved audio driver
[[ ! grep 'audio_pwm_mode=2' ]] && sed '$ i\audio_pwm_mode=2' /boot/config.txt

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
```
