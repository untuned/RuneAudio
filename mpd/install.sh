#!/bin/bash

alias=mpdu

. /srv/http/addonstitle.sh

if [[ $( mpd -V | head -n 1 ) != 'Music Player Daemon 0.19.'* ]]; then
	redis-cli hset addons mpdu 1 &> /dev/null # mark as upgraded - disable button
	title "$info MPD already upgraged."
	exit
fi

checkspace 250000

title -l '=' "$bar Upgrade MPD ..."
timestart l

rankmirrors

echo -e "$bar Get files ..."
# pacman -S openssl > libcrypto.so.1.0, libssl.so.1.0 error - some packages still need existing version
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
chown root:root /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}
chmod 755 /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}

cp /etc/mpd.conf{,.backup}

sed -i '/^IgnorePkg/ s/mpd //; s/ffmpeg ashuffle //' /etc/pacman.conf

echo -e "$bar Remove conflict packages ..."
# pre-remove to avoid conflict messages (/usr/local/bin/ashuffle is used directly, not by installed)
pacman -R --noconfirm ashuffle-rune ffmpeg-rune mpd-rune

echo -e "$bar Install packages ..."
pacman -S --noconfirm libnfs icu libwebp gcc-libs wavpack ffmpeg

echo -e "$bar Install MPD ..."
pacman -S --noconfirm mpd

cp /etc/mpd.conf{.backup,}

# fix permission (default - mpd run by user 'mpd')
chmod 777 /var/log/runeaudio/mpd.log

# fix systemd unknown lvalue (not exist in current systemd version) 
echo -e "$bar Modify files ..."
sed -i -e '/^ProtectKernel/ s/^/#/
' -e '/^ProtectControl/ s/^/#/
' -e '/^Restrict/ s/^/#/
' /usr/lib/systemd/system/mpd.service

sed -i -e '/^ProtectKernel/ s/^/#/
' -e '/^ProtectControl/ s/^/#/
' -e '/^Restrict/ s/^/#/
' /usr/lib/systemd/user/mpd.service

systemctl daemon-reload
systemctl restart mpd

# fix midori missing libs
echo -e "$bar Fix Midori dependencies ..."
ln -s /usr/lib/libicudata.so.59.1 /usr/lib/libicudata.so.56
ln -s /usr/lib/libicui18n.so.59.1 /usr/lib/libicui18n.so.56
ln -s /usr/lib/libicuuc.so.59.1 /usr/lib/libicuuc.so.56
ln -s /usr/lib/libwebp.so.7.0.0 /usr/lib/libwebp.so.6
pacman -S --noconfirm glib2 gtk3 webkitgtk

redis-cli hset addons mpdu 1 &> /dev/null # mark as upgraded - disable button

clearcache
	
timestop l
title -l '=' "$bar MPD upgraded successfully."
