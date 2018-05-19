NGINX with pushstream
---

- Iinstall [ArchLinuxArm for RPi2](https://github.com/rern/RuneAudio/tree/master/ArchLinuxArm)
- [ArchLinuxArm Packages](https://archlinuxarm.org/packages): search `nginx` - `armv7h`  
- `Source Files` > copy code from [each file](https://archlinuxarm.org/packages/armv7h/transmission-cli/files) to `/home/alarm/nginx/` (with last empty line without whitespace)  
- Edit `PKGBUILD`:
```
...
arch=(armv7h)
...
#backup=(etc/nginx/fastcgi.conf
...
        etc/nginx/mime.types
...
#build() {
...
    --add-module=/home/alarm/nginx/nginx-push-stream-module
#  make
...
#package() {
...
  mkdir -p "$pkgdir"/usr/lib/systemd/system/
  install -Dm644 service "$pkgdir"/usr/lib/systemd/system/nginx.service
  install -Dm644 logrotate "$pkgdir"/etc/logrotate.d/nginx
#}
```sh
pacman -Sy base-devel pcre zlib guile git wget openssl mercurial perl-gd perl-io-socket-ssl perl-fcgi perl-cache-memcached memcached ffmpeg

su alarm
cd
mkdir nginx
cd nginx

git clone https://github.com/wandenberg/nginx-push-stream-module.git

makepkg -A --skipinteg
```
