Compile a package
--- 

```sh
pacman -Sy base-devel
useradd x
su x
mkdir -p /home/x/transmission
```

- `https://archlinuxarm.org/packages`  
- Search `transmission-cli` `armv7h`  
- `Source Files` > download to `/home/x/transmission`  
- (**error**: intltool is too old ....)

```sh
mkdir -p /home/x/intltool
```

- Search `intltool` `armv7h`  
- `Source Files` > download to `/home/x/intltool` 
- (**error**: libreadline ...)  
- (**error**: libguile ...)  

```sh
su
pacman -S readline guile
ln -s /lib/libreadline.so.6 /lib/libreadline.so.7.0
su x
cd /home/x/intltool
makepkg -A --skipinteg
pacman -U intltool-0.51.0-2-any.pkg.tar.xz
cd /home/x/transmission
makepkg -A --skipinteg
pacman -U transmission-cli-2.92-6-armv7h.pkg.tar.xz
```
