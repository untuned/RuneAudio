samba
---
_Tested on RuneAudio beta-20160313 - samba_

RuneAudio already installed `samba4-rune`  
Upgrading to latest samba with following configuration should improve transfer speed by 30%, **8MB/s** > **11MB/s** on wired network  

**Server name**  
- any os file browsers:
```
hostnamectl set-hostname [name]
```
- only Windows(NetBIOS) file browsers:  
`netbios name` in `/etc/samba-dev/smb.conf`  

**/etc/samba/smb-dev.conf**
```apacheconf
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
	
	# fix IP4 only server - call failed: Address family not supported by protocol
	# but nmbd will have trouble starting
#	bind interfaces only = yes
#	interfaces = lo eth0 wlan

	socket options = IPTOS_LOWDELAY SO_RCVBUF=131072 SO_SNDBUF=131072
	min receivefile size = 2048
	use sendfile = yes
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

**Test samba parameters**
```
testparm
```

**Fix minimum `rlimit_max`**
```sh
echo -n '
root    soft    nofile    16384
root    hard    nofile    16384
' >> /etc/security/limits.conf
# Close SSH and reconnect to update new value.
```

**Restart samba**
```sh
systemctl restart smbd

# if set new hostname
systemctl restart nmbd
```

**Upgrage samba**
```sh
systemctl stop nmbd
systemctl stop smbd

# fix packages download errors
if  grep '^Server = http://mirror.archlinuxarm.org/' /etc/pacman.d/mirrorlist; then
	wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh
	chmod +x rankmirrors.sh
	./rankmirrors.sh
fi
pacman -Sy

pacman -R --noconfirm samba4-rune
pacman -S --noconfirm tdb tevent smbclient samba
# fix missing libreplace-samba4.so
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/libreplace-samba4.so -P /usr/lib/samba
# or run 'twice':
#pacman -S --noconfirm libwbclient

killall nmbd
killall smbd

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/smb-dev.conf -P /etc/samba
ln -s /etc/samba/smb-dev.conf /etc/samba/smb.conf

systemctl daemon-reload
systemctl enable nmbd smbd
systemctl start nmbd
systemctl start smbd
```

**Add samba user + password**
```
smbpasswd -a [user]
```
