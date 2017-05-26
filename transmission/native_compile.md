Native compile Transmission
--- 
Default `pacman -S transmission-cli` failed to start, error: `libcrypto.so.1.1`, `libssl.so.1.1`  
RuneAudio cannot handle system wide upgrade.  
  
**Native compile:**  
```sh
pacman -Sy base-devel
useradd x
su x
mkdir -p /home/x/transmission
```

- [ArchLinuxArm Packages](https://archlinuxarm.org/packages)  
- Search `transmission-cli` `armv7h`  
- `Source Files` > copy code from `PKGBUILD`, **only one**, to `/home/x/transmission/PKGBUILD`  
- Edit `PKGBUILD`: remove lines  
  * `gtk` `qt` - no need  
  * `patch` - skip `libcrypto.so.1.1`, `libssl.so.1.1` check   
  * `user` `directory` - to run as root  

**Fix errors:**  

**`intltool`**  
```sh
mkdir -p /home/x/intltool
```
  * [ArchLinuxArm Packages](https://archlinuxarm.org/packages)
  * search `intltool` `armv7h`  
  * `Source Files` > copy code from **each file** to `/home/x/intltool` 

**`libreadline`**  
**`libguile`**  
```sh
su
pacman -S readline guile
ln -s /lib/libreadline.so.6 /lib/libreadline.so.7.0
```
  * compile `initltool`
```sh
su x
cd /home/x/intltool
makepkg -A --skipinteg
pacman -U intltool-0.51.0-2-any.pkg.tar.xz
```

**Compile:**  
```sh
cd /home/x/transmission
makepkg -A --skipinteg
pacman -U transmission-cli-2.92-6-armv7h.pkg.tar.xz
```
