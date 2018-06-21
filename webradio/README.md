Webradio import / export
---
_Tested on RuneAudio 0.3 and 0.4b_

Webradio needs files and database data together to make the list.

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
	- delete webradio database
	- get data from `*.pls` files
	- write data to database
	- update MPD data
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/webradio/webradiodb.sh; chmod +x webradiodb.sh; ./webradiodb.sh
```
**Install**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons) 
  
  
**export database to file**
- copy `rune.rdb` backup files to `/var/lib/redis/`  
- run export script
	- get data from database
	- write data to `*.pls` files
	- update MPD data
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/webradio/webradiofile.sh; chmod +x webradiofile.sh; ./webradiofile.sh
``` 
