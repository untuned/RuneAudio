NGINX with pushstream
---

install [ArchLinuxArm](https://github.com/rern/RuneAudio/tree/master/ArchLinuxArm)

```sh
pacman -Sy base-devel pcre zlib guile git wget openssl mercurial perl-gd perl-io-socket-ssl perl-fcgi perl-cache-memcached memcached ffmpeg

su alarm
cd
mkdir nginx
cd nginx

wget https://github.com/rern/RuneAudio/raw/master/nginx/PKGBUILD

makepkg --skipinteg
```
