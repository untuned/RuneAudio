Native compiled Transmission
--- 
`pacman -S transmission-cli` > failed to start - error: `libcrypto.so.1.1`, `libssl.so.1.1`  
RuneAudio has trouble with system wide upgrade.  

- Install [ArchLinuxArm for RPi2](https://github.com/rern/RuneAudio/tree/master/ArchLinuxArm)
- create new directory
```sh
su alarm
cd
cd nginx
```
- [ArchLinuxArm Packages](https://archlinuxarm.org/packages): search `transmission-cli` - `armv7h`  
- `Source Files` > copy-paste code from each file, direct download not available, to `/home/alarm/nginx/` (with last empty line without whitespace)
- Edit [`PKGBUILD`](https://github.com/rern/RuneAudio/blob/master/transmission/_repo/transmission/PKGBUILD): remove lines  
  * `pkgname=(transmission-cli)`
  * remove all `gtk` `qt` - no need  

**pre-compile**
```sh
# cpu cores + 1 and put temp file to faster drive
sed -i -e 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j5"/
' -e 's|#BUILDDIR=.*|BUILDDIR=/mnt/MPD/USB/hdd/makepkg|
' /etc/makepkg.conf
```

**Compile:**  
```sh
makepkg -A --skipinteg
```
The compiled package can be install on unupdated RuneAudio.
