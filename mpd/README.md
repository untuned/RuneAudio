Native compiled mpd
---

**copy files**  
- missing lib: `libcrypto.so.1.1` `libssl.so.1.1`  
- mpd: `PKGBUILD` `conf` `install` `tmpfiles.d`
```sh
wget -qN https://gtihub.com/rern/RuneAudio/mpd/files.tar -P /home/x
bsdtar -xvf files.tar -C /
rm files.tar
```

**remove conflict packages**  
```sh
pacman -R ashuffle-rune mpd-rune ffmpeg-rune`
```

**fix libreadline error** 
```sh
pacman -Sy
pacman -S readline
ln -s /lib/libreadline.so.7.0 /lib/libreadline.so.6
```

**install packages**
```sh
pacman -S base-devel boost guile libsamplerate libsoxr sqlite avahi dbus mp3unicode icu ffmpeg smbclient libid3tag curl alsa-lib libnfs libmms zlib flac yajl expat libmad wavpack libogg faad2 libvorbis audiofile libsndfile libupnp libmpdclient lame libwebp tdb tevent ldb jack libao libmodplug libshout libcdio-paranoia libgme zziplib doxygen
```

**pre-compile**
```sh
useradd -m x
mkdir /home/x/mpd
chown -R x:x x
cd /home/x/mpd
su x
```

**compile**
```sh
makepkg -A --skipinteg
```
