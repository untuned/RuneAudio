samba
---
RuneAudio samba  

**/etc/samba/smb.conf**
```sh
[global]
#	netbios name = [name_in_network_browser]
	workgroup = WORKGROUP
	server string = Samba %v on %L
	encrypt passwords = yes
	wins support = yes
	domain master = yes
	preferred master = yes
	local master = yes
	os level = 255   
	dns proxy = no
	log level = 0
	syslog = 0

	guest ok = yes
	null passwords = yes
	map to guest = bad user

	load printers = no
	printing = bsd
	printcap name = /dev/null
	disable spoolss = yes

[hdd]
	comment = Restrict access, read and write, not show in network browser
	path = /mnt/MPD/USB/hdd
	browseable = no
	read only = no
	guest ok = no
	valid users = root
#	host allow = [ip1 ip2]
[Music]
	comment = Read only access
	path = /mnt/MPD/USB/hdd/Music
[x]
	comment = Read and write access
	path = /mnt/MPD/USB/hdd/x
	read only = no
```

**Restart samba**
```sh
systemctl restart smbd

# if set 'netbios name'
systemctl restart nmbd
```

**Add samba user + password**
```sh
smbpasswd -a [user]
```
