NGINX with pushstream
---

- Install [ArchLinuxArm for RPi2](https://github.com/rern/RuneAudio/tree/master/ArchLinuxArm)
- [ArchLinuxArm Packages](https://archlinuxarm.org/packages): search `nginx` - `armv7h`  
- `Source Files` > copy-paste code from each file, direct download not available, to `/home/alarm/nginx/` (with last empty line without whitespace)  
- Edit `PKGBUILD`:
```sh
...
--arch=(x86_64)
++arch=(armv7h)
...
--depends=(pcre zlib openssl geoip mailcap)
++depends=(pcre zlib openssl geoip)
...
#backup=(etc/nginx/fastcgi.conf
...
++        etc/nginx/mime.types
...
#build() {
...
--    --with-mail
--    --with-mail_ssl_module
...
++    --add-module=/home/alarm/nginx/nginx-push-stream-module
#  make
...
#package() {
...
++  mkdir -p "$pkgdir"/usr/lib/systemd/system/
++  install -Dm644 service "$pkgdir"/usr/lib/systemd/system/nginx.service
++  install -Dm644 logrotate "$pkgdir"/etc/logrotate.d/nginx
#}
--check() {
--  cd nginx-tests
--  TEST_NGINX_BINARY="$srcdir/$pkgname-$pkgver/objs/nginx" prove .
--}
#package() {
...

--  sed -e 's|\ "$pkgdir"/usr/share/man/man8/nginx.8.gz

--  for i in ftdetect indent syntax; do
--    install -Dm644 contrib/vim/$i/nginx.vim \
--      "$pkgdir/usr/share/vim/vimfiles/$i/nginx.vim"
--  done
#}
```

### Prepare environment
```sh
pacman -Sy base-devel pcre zlib guile git wget openssl mercurial perl-gd perl-io-socket-ssl perl-fcgi perl-cache-memcached memcached ffmpeg
```

### Compile
```sh
su alarm
cd
mkdir nginx
cd nginx

git clone https://github.com/wandenberg/nginx-push-stream-module.git

makepkg -A --skipinteg
```
