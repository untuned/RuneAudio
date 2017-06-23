**systemd method**
```sh
# get 'partprobe' by install parted
pacman -S parted

# fdisk script
/root/expand.sh
chmod +x /root/expand.sh

# systemd startup service
/etc/systemd/expand.service
ln -s /etc/systemd/expand.service /etc/systemd/system/multi-user.target.wants/expand.service
```
