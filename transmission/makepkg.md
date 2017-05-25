Recompile Transmission
--- 
Default `pacman -S transmission-cli` failed to start, error: `libcrypto.so.1.1`, `libssl.so.1.1`  
This is how to fix it.

```sh
pacman -Sy base-devel
useradd x
su x
mkdir -p /home/x/transmission
```

- `https://archlinuxarm.org/packages`  
- Search `transmission-cli` `armv7h`  
- `Source Files` > download to `/home/x/transmission` 
- Edit `PKGBUILD`: remove `gtk` and `qt` parts
```sh
...
pkgname=(transmission-cli transmission-gtk transmission-qt)
...
makedepends=(gtk3 intltool curl qt5-base libevent systemd qt5-tools)
...
  sed -i '/^Icon=/ s/$/-qt/' qt/transmission-qt.desktop
...
  cd qt
  qmake qtr.pro \
    DEFINES+=TRANSLATIONS_DIR=\\\\\\\"/usr/share/transmission-qt/translations\\\\\\\"
  make
  lrelease translations/*.ts
...
package_transmission-gtk() {
# to
}
...
package_transmission-qt() {
# to
}
```  

Fix **error**: intltool is too old ....
```sh
mkdir -p /home/x/intltool
```

- Search `intltool` `armv7h`  
- `Source Files` > download to `/home/x/intltool` 

Fix **error**: libreadline ... and libguile ...   
```sh
su
pacman -S readline guile
ln -s /lib/libreadline.so.6 /lib/libreadline.so.7.0
```

- Make `initltool`
```sh
su x
cd /home/x/intltool
makepkg -A --skipinteg
pacman -U intltool-0.51.0-2-any.pkg.tar.xz
```
- Make `transmission`
```sh
cd /home/x/transmission
makepkg -A --skipinteg
pacman -U transmission-cli-2.92-6-armv7h.pkg.tar.xz
```
