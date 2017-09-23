Webradio import
---

Webradio needs files and database data together to make hte list.

**webradio `<filename>.pls` file syntax:**    
`Radio name` in Webradio list = filename  
```sh
[playlist]
NumberOfEntries=1
File1=http://urlpath:port
Title1=filename
```

**import files to database**  
- copy webradio  `*.pls` files to `/mnt/MPD/Webradio/`  
- run import script:
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/webradio/webradiodb.sh; chmod +x webradiodb.sh; ./webradiodb.sh
```

**export database to file**
- copy `rune.rdb` backup files to `/var/lib/redis/`  
- run export script
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/webradio/webradiofile.sh; chmod +x webradiofile.sh; ./webradiofile.sh
```
