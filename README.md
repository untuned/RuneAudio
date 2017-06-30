RuneAudio setup
---

This is just an example of setup script. 

[**setup.sh**](https://github.com/rern/RuneAudio/blob/master/_settings/setup.sh)  
- unify usb mount point `/media`
- set package cache to usb to avoid slow download on os reinstall
- disable unused wlan0 service, cec
- upgrage and customize **samba** to improve speed
- make usb drive a common between os for `smb.conf`
- install **RuneUI Enhancement**
- install **RuneUI GPIO**
- make usb drive a common between os for `gpio.json`
- install **Transmission**
- make usb drive a common between os for web, `settings.json`, directory
- install **Aria2**

```
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/setup.sh; chmod +x setup.sh; ./setup.sh
```
