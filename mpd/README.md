Native compiled mpd
---

**copy files**  
- fix missing `lib...`s: `libcrypto.so.1.1` `libssl.so.1.1`
- mpd build files: `PKGBUILD` `conf` `install` `tmpfiles.d`
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

**fix `libreadline.so.6` error**  
[`rankmirrors.sh`](https://github.com/rern/RuneAudio/tree/master/rankmirrors) fixes download errors.
```sh
pacman -Sy
pacman -S readline
ln -s /lib/libreadline.so.7.0 /lib/libreadline.so.6
```

**install packages**
```sh
pacman -S base-devel
pacman -S alsa-lib audiofile avahi boost bzip2 curl dbus doxygen expat faad2 ffmpeg flac guile icu jack lame ldb 
pacman -S libao libcdio-paranoia libgme libid3tag libmad libmms libmodplug libmpdclient libnfs libogg libsamplerate libshout libsndfile libsoxr libupnp libutil-linux libvorbis libwebp
pacman -S mp3unicode mpg123 smbclient sqlite tdb tevent wavpack yajl zlib zziplib
```

**pre-compile**
```sh
# cpu cores + 1 and put temp file to faster drive
sed -i -e 's/#AKEFLAGS="-j2"/MAKEFLAGS="-j5"/
' -e 's|#BUILDDIR=.*|BUILDDIR=/mnt/MPD/USB/hdd/makepkg|
' /etc/makepkg.conf

useradd x
chown -R x:x /home/x
cd /home/x/mpd
su x
```

**compile**
```sh
makepkg

su
pacman -U /home/x/mpd/mpd-0.20.11-1-armv7h.pkg.tar.xz
```
