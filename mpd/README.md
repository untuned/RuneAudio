Native compiled mpd
---

**remove packages**  
```sh
pacman -R ashuffle-rune mpd-rune ffmpeg-rune`
```

**fix libreadline error** 
```sh
pacman -S readline
ln -s /lib/libreadline.so.7.0 /lib/libreadline.so.6
```

**install packages**
```sh
pacman -S base-devel boost guile libsamplerate libsoxr sqlite avahi dbus libunicodenames mp3unicode icu ffmpeg smbclient libmp3tag curl alsa-lib lib-nfs libmms zlib flac yajl expat libmad wavpack libogg faad2 libvorbis audiofile libsndfile libupnp libmpdclient lame libwebp tdb tevent ldb
```

**pre-compile**
```sh
useradd -m x
mkdir /home/x/mpd
cd /home/x/mpd
su x
wget -qN https://gtihub.com/rern/RuneAudio/mpd/
```

**compile**
```sh
makepkg -A --skipinteg
```
