Webradio import
---

**import files to database**
- copy webradio  `*.pls` files to `/mnt/MPD/Webradio/`  
- run import script:
```sh
wget -qN --show-progress --no-check-certificate https://github.com/rern/RuneAudio/raw/master/webradio/webradiodb.sh; chmod +x webradiodb.sh; ./webradiodb.sh
```

**covert database to file**
- copy `rune.rdb` backup files to `/var/lib/redis/`  
- run import script
```sh
wget -qN --show-progress --no-check-certificate https://github.com/rern/RuneAudio/raw/master/webradio/webradiofile.sh; chmod +x webradiofile.sh; ./webradiofile.sh
```

**refresh**
- refresh browser
- done
