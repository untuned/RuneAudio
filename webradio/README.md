Webradio files import script
---

- copy webradio  `*.pls` files to `/mnt/MPD/Webradio/`  
- run import script:
```sh
wget -qN --show-progress https://raw.githubusercontent.com/rern/RuneAudio/master/webradio/webradiodb.sh; chmod +x webradiodb.sh; ./webradiodb.sh
```
- refresh browser
- done
