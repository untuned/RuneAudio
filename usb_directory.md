USB without label as root directory
---

Remove unnecessary USB label from path.  

**issue**
- USB drive normally mounted as `/mnt/MPD/USB/usblabel`
- `Library` > `USB storage` gets `USB/usblabel` as root directory

**mod**  
- disable USB automount
- mount USB drive with `fstab`
- link all direcrories in USB drive to `/mnt/MPD/USB`
- rebuild library

**script**  
```sh
sed -i '/^sendMpdCommand/ s|^|//|' /srv/http/command/usbmount
sed -i '/^KERNEL/ s/^/#/' /etc/udev/rules.d/rune_usb-stor.rules
udevadm control --reload-rules && udevadm trigger

mnt0=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
label=${mnt0##/*/}
mnt="/mnt/$label"
mkdir -p "$mnt"
if ! grep -q $mnt /etc/fstab; then
	echo "/dev/sda1  $mnt  ext4  defaults,noatime" >> /etc/fstab
	umount -l /dev/sda1
	mount -a
fi

[[ -e /mnt/MPD/USB/hdd && $( ls -1 /mnt/MPD/USB/hdd | wc -l ) == 0 ]] && rm -r /mnt/MPD/USB/hdd
find /mnt/hdd/Music -maxdepth 1 -mindepth 1 -type d -print0 | xargs -0 ln -s -t /mnt/MPD/USB

mpc update
```
