RuneAudio setup
---

[**setup.sh**](https://github.com/rern/RuneAudio/blob/master/_settings/setup.sh)  
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/setup.sh; chmod +x setup.sh; ./setup.sh
```
(RuneAudio has trouble with system wide upgrade. **Do not** `pacman -Syu`)  

This is just an example of setup script.  
- set password for Samba and Transmission
- disable unused `wlan0` service
- set hdmi mode (+ OSMC boot partition)
- set `fstab` mount USB drive to `/mnt/hdd` (+ OSMC root partition)
- restore settings
- set package cache to usb to avoid slow download on os reinstall
- install **Addons Menu**
- install **Login Logo**
- upgrage **Samba**
- install **Transmission**
- install **Aria2**
- install **RuneUI Enhancement**
- install **RuneUI GPIO**  
