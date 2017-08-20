RuneAudio setup
---

[**setup.sh**](https://github.com/rern/RuneAudio/blob/master/_settings/setup.sh)  
```sh
wget -qN --show-progress https://raw.githubusercontent.com/rern/RuneAudio/master/_settings/setup.sh; chmod +x setup.sh; ./setup.sh
```
(RuneAudio has trouble with system wide upgrade. **Do not** `pacman -Syu`)  

This is just an example of setup script.  
- set password for Samba and Transmission
- disable unused `wlan0` service
- set hdmi mode (+ OSMC boot partition)
- set `fstab` mount USB drive to `/mnt/hdd` (+ OSMC root partition)
- restore settings
- set package cache to usb to avoid slow download on os reinstall
- upgrage and customize **Samba** to improve speed
- install **Transmission**
- install **Aria2**
- install **RuneUI Enhancement**
- install **RuneUI GPIO**  

**Hardware revision**  
```sh
cat /proc/cpuinfo | grep Revision | awk '{print $3}'
# a02082 - RPi 3 (Sony, UK)
# a22082 - RPi 3 (Embest, China)
# a01041 - RPi 2 (Sony, UK)
# a21041 - RPi 2 (Embest, China)
```
