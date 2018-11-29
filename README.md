RuneAudio setup
---

[**setup.sh**](https://github.com/rern/RuneAudio/blob/master/_settings/setup.sh)  
```sh
wget --no-check-certificate https://github.com/untuned/RuneAudio/raw/master/_settings/setup.sh; chmod +x setup.sh; ./setup.sh
```
[**setupsystem.sh**](https://github.com/rern/RuneAudio/blob/master/_settings/setupsystem.sh)  
```sh
wget --no-check-certificate https://github.com/untuned/RuneAudio/raw/master/_settings/setupsystem.sh; chmod +x setupsystem.sh; ./setupsystem.sh
```
(RuneAudio has trouble with system wide upgrade. **Do not** `pacman -Syu`)  

This is just an example of setup script.  
- set password for Samba and Transmission
- set hdmi mode (+ OSMC boot partition)
- set `fstab` mount USB drive to `/mnt/hdd` (+ OSMC root partition)
- restore settings
- set package cache to usb to avoid slow download on os reinstall
- install addons 
