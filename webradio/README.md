Webradio import
---

**import files to database**
- copy webradio  `*.pls` files to `/mnt/MPD/Webradio/`  
- run import script:
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/webradio/install.sh; chmod +x install.sh; ./install.sh
```

**covert database to file**
- copy `rune.rdb` backup files to `/var/lib/redis/`  
- run import script
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/webradio/webradiofile.sh; chmod +x webradiofile.sh; ./webradiofile.sh
```

**refresh**
- refresh browser
- done
