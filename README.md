RuneAudio setup
---

This is just an example of setup script.  
(RuneAudio has trouble with system wide upgrade. **Do not** `pacman -Syu`)  

[**setup.sh**](https://github.com/rern/RuneAudio/blob/master/_settings/setup.sh)  
( OSMC parts ease first boot)
- disable unused `wlan0` service
- set hdmi mode
- OSMC - set hdmi mode
- `/mnt/hdd` link - no `fstab` - Rune read from `/mnt/MPD/USB/hdd` only
- OSMC - set `fstab` for usb drive (fix automount to `/media/hdd_`)
- OSMC - restore settings
- set package cache to usb to avoid slow download on os reinstall
- upgrage and customize **samba** to improve speed
- make usb drive a common between os for `smb.conf`
- install **Transmission**
- install **Aria2**
- install **RuneUI Enhancement**
- install **RuneUI GPIO**
- make usb drive a common between os for `gpio.json`
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/setup.sh; chmod +x setup.sh; ./setup.sh
```
