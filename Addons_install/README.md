Install Addons Menu with PuTTY
---

- download [**PuTTY**](https://the.earth.li/~sgtatham/putty/latest/w32/putty.exe)
- double click `putty.exe`
---
![putty1](https://github.com/rern/RuneAudio/blob/master/Addons_install/putty01.png)  
`192.168.1.22` **must be changed** to your RuneAudio's
- `1` fill `Host Name (or IP address)`
- `2` select `SSH`
- `3` click `Open` to connect
---
![putty2](https://github.com/rern/RuneAudio/blob/master/Addons_install/putty02.png)  
- `1` login as: `root` > `Enter`
- `2` root@192.168.1.22's password: `rune` > `Enter` (password will not show and cursor will not move)
- `3` install
  - copy this install script: `wget -qN --show-progress https://github.com/rern/RuneAudio_Addons/raw/master/install.sh; chmod +x install.sh; ./install.sh`
  - paste by right click anywhere in PuTTY window > `Enter`
