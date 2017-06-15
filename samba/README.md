samba
---
RuneAudio already installed samba.  
Upgrading samba with custom configuration will potentially gain 25% more transfer speed.  

**Server name**  
- any os file browsers:
```
hostnamectl set-hostname [name]
```
- only Windows(NetBIOS) file browsers:  
`netbios name` in `/etc/samba-dev/smb.conf`  

**/etc/samba/smb-dev.conf**
```
[global]
#	netbios name = [name]
	workgroup = WORKGROUP
	server string = Samba %v on %L
	
	wins support = yes
	domain master = yes
	preferred master = yes
	local master = yes
	os level = 255   
	dns proxy = no
	log level = 0
	syslog = 0

	socket options = IPTOS_LOWDELAY SO_RCVBUF=131072 SO_SNDBUF=131072
	min receivefile size = 2048
	use sendfile = true
	aio read size = 2048
	aio write size = 2048
	write cache size = 1024000
	read raw = yes
	write raw = yes
	getwd cache = yes
	oplocks = yes
	max xmit = 32768
	dead time = 15
	large readwrite = yes

	guest ok = yes
	map to guest = bad user
	encrypt passwords = yes

	load printers = no
	printing = bsd
	printcap name = /dev/null
	disable spoolss = yes

[readwrite]
	comment = browseable, read, write, guess ok, no password
	path = /mnt/MPD/USB/hdd/readwrite
	read only = no
[read]
	comment = browseable, read only, guess ok, no password
	path = /mnt/MPD/USB/hdd/read
[root]
	comment = hidden, read, write, root with password only, from [IP1] [IP2] only
	path = /mnt/MPD/USB/root
	browseable = no
	read only = no
	guest ok = no
	valid users = root
#	host allow = [IP1] [IP2]
```

**Upgrage samba**
```
systemctl stop nmbd
systemctl stop smbd
pacman -Rs --no-confirm samba4-rune
pacman -S --no-confirm tdb tevent libwbclient smbclient
pacman -S --no-confirm samba

ln -s /etc/samba/smb-dev.conf /etc/samba/smb.conf

systemctl start nmbd
systemctl start smbd
systemctl enable nmbd
systemctl enable smbd

smbpasswd - a root
```

**Add samba user + password**
```
smbpasswd -a [user]
```
