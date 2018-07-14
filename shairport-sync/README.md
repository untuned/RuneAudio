### shairport-sync

Compiled with `--with-meta` for metadata retrieval.

```sh
# activate improved audio driver
[[ ! grep 'audio_pwm_mode=2' ]] && sed '$ i\audio_pwm_mode=2' /boot/config.txt

# turn off WiFi Power Management
iwconfig wlan0 power off
```
