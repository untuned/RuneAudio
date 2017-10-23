MPD Upgrade
---

Upgrade MPD to latest version  
- fix all errors caused by normal upgrade

```sh
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
chown root:root /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}
chmod 755 /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}

cp /etc/mpd.conf{,.backup}

pacman -R --noconfirm ashuffle-rune ffmpeg-rune mpd-rune
pacman -S --noconfirm mpd

systemctl stop mpd
cp /etc/mpd.conf{.backup,}
pacman -S --noconfirm ffmpeg

pacman -S --noconfirm libnfs icu libwebp gcc-libs wavpack 

wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/ashuffle-rune-1.0-20160319-armv7h.pkg.tar.xz
pacman -U --noconfirm ashuffle-rune-1.0-20160319-armv7h.pkg.tar.xz

sed -i -e '/^Protect/ s/^/#/
' -e '/^Restrict/ s/^/#/
' /usr/lib/systemd/system/mpd.service

touch /var/log/mpd.log
chmod 777 /var/log/mpd.log

systemctl daemon-reload

systemctl start mpd
```
