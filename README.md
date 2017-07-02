RuneAudio setup
---

This is just an example of setup script. 

[**setup.sh**](https://github.com/rern/RuneAudio/blob/master/_settings/setup.sh)  
- disable unused wlan0 service
- set hdmi mode
- set fstab for usb drive
- set package cache to usb to avoid slow download on os reinstall
- restore settings
- upgrage and customize **samba** to improve speed
- make usb drive a common between os for `smb.conf`
- install **Transmission**
- install **Aria2**
- install **RuneUI Enhancement**
- install **RuneUI GPIO**
- make usb drive a common between os for `gpio.json`
```
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/setup.sh; chmod +x setup.sh; ./setup.sh
```
