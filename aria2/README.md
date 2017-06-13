RuneAudio Aria2 with WebUI
---

[**aria2**](https://aria2.github.io/) - Download utility that supports HTTP(S), FTP, BitTorrent, and Metalink  
[**webui-aria2**](https://github.com/ziahamza/webui-aria2) - Web inferface for aria2  
 
**Install**
- RuneAudio has trouble with system wide upgrade. Do not `pacman -Syu` upgrage.  
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/install.sh; chmod +x install.sh; ./install.sh
```

**Uninstall**  
```sh
./uninstall_aria.sh
```

**Start aria2**  
```sh
systemctl start aria2
```

**Stop aria2**  
```sh
systemctl stop aria2
```

**WebUI**  
Browser URL:    
_[RuneAudio IP]_:88 (eg: 192.168.1.11:88)

**Tips**  
Specify saved filename.ext - without spaces: (set directory in `dir` option)  
[download link] --out=[filename.ext]   

Fix download speed drop:  
`[pause]` > `[resume]` button   
