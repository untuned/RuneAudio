**systemd run once method**
```sh
# systemd startup service
/etc/systemd/expand.service
ln -s /etc/systemd/expand.service /etc/systemd/system/multi-user.target.wants/expand.service

# fdisk script
/root/expand.sh
chmod +x /root/expand.sh

# 'partprobe' to avoid reboot
/usr/bin/partprobe
chmod +xr /usr/bin/partprobe
/usr/lib/libparted.so.2.0.1
ln -s /usr/lib/libparted.so.2.0.1 /usr/lib/libparted.so.2
```
