### Prepare environment
```sh
pacman -Sy pacman base-devel pcre zlib guile git wget openssl mercurial perl-gd perl-io-socket-ssl perl-fcgi perl-cache-memcached memcached ffmpeg libdaemon libconfig avahi
```

### Compile
```sh
su alarm
cd
mkdir nginx
cd nginx

git clone https://github.com/mikebrady/shairport-sync.git

makepkg -A --skipinteg
```
