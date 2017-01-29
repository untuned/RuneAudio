RuneAudio aria2 with webui
---

[**aria2**](https://aria2.github.io/) - Download utility that supports HTTP(S), FTP, BitTorrent, and Metalink  
[**webui-aria2**](https://github.com/ziahamza/webui-aria2) - Web inferface for aria2  


**Install**  
```sh
pacman -S aria2

mkdir /usr/share/nginx/html/aria2
cd /usr/share/nginx/html/aria2
wget -O aria2.zip https://github.com/ziahamza/webui-aria2/archive/master.zip
bsdtar -xf aria2.zip -s'|[^/]*/||'
rm aria2.zip
```

**/root/.config/aria2/aria2.conf** - create new file  
```sh
enable-rpc=true
rpc-listen-all=true

daemon=true
disable-ipv6=true
```

**/etc/nginx/nginx/conf** - add these lines between `http { ... }`  
```sh
    server {
        listen 88;
        location / {
            root   /usr/share/nginx/html/webui-aria2-master;
            index  index.php index.html index.htm;
        }
	}
```

**Restart nginx**  
```sh
systemctl restart nginx
```

**Start aria2**  
```sh
aria2c
```

**WebUI**  
  
Browser URL:  
  
_RuneAudio IP_:88 (eg: 192.168.1.11:88)  

**Stop aria2**  
```sh
killall aria2c
```

