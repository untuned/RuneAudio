Native compiled mpd
---

**copy files**  
- missing lib: `libcrypto.so.1.1` `libssl.so.1.1`  
- mpd: `PKGBUILD` `conf` `install` `tmpfiles.d`
```sh
wget -qN https://github.com/rern/RuneAudio/raw/master/mpd/files.tar.xz
rm -rf /tmp/install
mkdir -p /tmp/install
bsdtar -xvf files.tar.xz -C /tmp/install
cp -rf /tmp/install/* /
rm -rf files.tar.xz /tmp/install
```

**remove conflict packages**  
```sh
pacman -R ashuffle-rune mpd-rune ffmpeg-rune
```

**fix libreadline error** 
```sh
pacman -Sy
pacman -S readline
ln -s /lib/libreadline.so.7.0 /lib/libreadline.so.6
```

**install packages**
```sh
pacman -S base-devel
pacman -S alsa-lib audiofile avahi boost curl dbus doxygen expat faad2 ffmpeg flac guile icu jack lame ldb 
pacman -S libao libcdio-paranoia libgme libid3tag libmad libmms libmodplug libmpdclient libnfs libogg libsamplerate libshout libsndfile libsoxr libupnp libvorbis libwebp
pacman -S mp3unicode smbclient sqlite tdb tevent wavpack yajl zlib zziplib
```

**pre-compile**
```sh
useradd x
chown -R x:x /home/x
cd /home/x/mpd
su x
```

**compile**
```sh
makepkg
```
