NGINX with pushstream
---

install [ArchLinuxArm for RPi2](https://github.com/rern/RuneAudio/tree/master/ArchLinuxArm)

```sh
pacman -Sy base-devel pcre zlib guile git wget openssl mercurial perl-gd perl-io-socket-ssl perl-fcgi perl-cache-memcached memcached ffmpeg

su alarm
cd
mkdir nginx
cd nginx

git clone https://github.com/wandenberg/nginx-push-stream-module.git

makepkg -A --skipinteg
```
