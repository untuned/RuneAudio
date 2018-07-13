### shairport-sync

Compiled with modified PKGBUILD from https://github.com/EliaCereda/shairport-sync-PKGBUILD

```sh
# activate improved audio driver
[[ ! grep 'audio_pwm_mode=2' ]] && sed '$ i\audio_pwm_mode=2' /boot/config.txt

# turn off WiFi Power Management
iwconfig wlan0 power off
```
