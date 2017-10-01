Install Addons Menu with PuTTY
---

- download [**PuTTY**](https://the.earth.li/~sgtatham/putty/latest/w32/putty.exe) `<< click`
- start PuTTY by double click `putty.exe`
---
![putty_config](https://github.com/rern/RuneAudio/blob/master/Addons_install/putty_config.png)  
`192.168.1.22` **must be changed** to your RuneAudio's
- `1` fill `Host Name (or IP address)`
- `2` select `SSH`
- `3` click `Open` to connect
---
![putty_alert](https://github.com/rern/RuneAudio/blob/master/Addons_install/putty_alert.png)
- click `Yes` to continue
---
![putty_login](https://github.com/rern/RuneAudio/blob/master/Addons_install/addonsinstall.gif)  
- `1` login as: `root` > press `Enter`
- `2` root@192.168.1.22's password: `rune` > press `Enter` ( password will not show and cursor will not move )
- `3` root@runeaudio:~ # `wget -qN --show-progress https://github.com/rern/RuneAudio_Addons/raw/master/install.sh; chmod +x install.sh; ./install.sh` > press `Enter` ( `copy` code > `right-click` in PuTTY = paste )  

<hr>

### Using Addons Menu  
- Refresh RuneAudio browser
- `Menu` > `Addons`
