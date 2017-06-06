Native compile Transmission
--- 
Normal `pacman -S transmission-cli` failed to start, error: `libcrypto.so.1.1`, `libssl.so.1.1`  
RuneAudio has trouble with system wide upgrade.  
  

```sh
pacman -Sy base-devel
useradd -m x
su x
cd
mkdir transmission
mkdir intltool
```

- [ArchLinuxArm Packages](https://archlinuxarm.org/packages)  
- search `transmission-cli` - `armv7h`  
- `Source Files` > copy code from [each file](https://archlinuxarm.org/packages/armv7h/transmission-cli/files), except `transmission-2.92-openssl-1.1.0.patch`, to `/home/x/transmission/` (with last empty line without whitespace)  
- Edit to [`PKGBUILD`](https://github.com/rern/RuneAudio/blob/master/transmission/_repo/transmission/PKGBUILD): remove lines  
  * `gtk` `qt` - no need  
  * `patch` - skip `libssl-1.1.0` ( fix: `libcrypto.so.1.1`, `libssl.so.1.1` )  

**Fix errors:**  

**`intltool`**  
(normal `pacman -S intltool` not recognize newer version)  
  * [ArchLinuxArm Packages](https://archlinuxarm.org/packages)
  * search `intltool`  
  * `Source Files` > copy code from [each file](https://archlinuxarm.org/packages/any/intltool/files) to `/home/x/intltool/` (with last empty line without whitespace)  

**`libcrypto.so.1.1`, `libssl.so.1.1`**  
(upgraged `pacman`, by `base-devel`, needs newer version)
  * [ArchLinuxArm Packages](https://archlinuxarm.org/packages)
  * search `openssl` - `armv7h`
  * [`Download`](https://archlinuxarm.org/packages/armv7h/openssl) > extract > copy `libcrypto.so.1.1`, `libssl.so.1.1` to `/lib/`
  
**`libreadline`, `libguile`**  
(`makepkg intltool` needs newer version)
```sh
su
pacman -S readline guile
# fix error: /lib/libreadline.so.6
ln -s /lib/libreadline.so.7.0 /lib/libreadline.so.6
pacman -S readline guile
# for xbindkeys
ln -s libguile-2.2.so.1.2.0 libguile-2.0.so.22
```
  * compile `initltool`
```sh
su x
cd /home/x/intltool
makepkg -A --skipinteg
su
pacman -U /home/x/intltool/intltool-0.51.0-2-any.pkg.tar.xz
```

**Compile:**  
On multicore CPU RPi3, edit `/etc/makepkg.conf` > `MAKEFLAGS="-j4"`
```sh
su x
cd /home/x/transmission
makepkg -A --skipinteg
su
pacman -U /home/x/transmission/transmission-cli-2.92-6-armv7h.pkg.tar.xz
```
The compiled package can be install on unupdated RuneAudio.
