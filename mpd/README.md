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

bacman ashuffle-rune
pacman -R --noconfirm ashuffle-rune mpd-rune
yes | pacman -S mpd

systemctl stop mpd
cp /etc/mpd.conf{.backup,}
echo -e '\n 1' | pacman -S ffmpeg

pacman -S --noconfirm libnfs icu libwebp gcc-libs wavpack 
echo y | pacman -U ashuffle-rune

sed -i -e '/^Protect/ s/^/#/
' -e '/^Restrict/ s/^/#/
' /usr/lib/systemd/system/mpd.service

systemctl daemon-reload

systemctl start mpd
```
