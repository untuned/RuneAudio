#!/bin/bash

alias=mpdu

. /srv/http/addonstitle.sh

if [[ $( mpd -V | head -n 1 ) != 'Music Player Daemon 0.19.13-dsd' ]]; then
	redis-cli hset addons mpdu 1 &> /dev/null # mark as upgraded - disable button
	title "$info MPD already upgraged."
	exit
fi

title -l '=' "$bar Upgrade MPD ..."
timestart

echo -e "$bar Get files ..."
# pacman -S openssl > error - some packages still need existing version
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
chown root:root /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}
chmod 755 /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}

cp /etc/mpd.conf{,.backup}

echo -e "$bar Remove conflict packages ..."
# pre-remove to avoid conflict messages
pacman -R --noconfirm ashuffle-rune ffmpeg-rune mpd-rune

rankmirrors

echo -e "$bar Install packages ..."
pacman -S --noconfirm libnfs icu libwebp gcc-libs wavpack

echo -e "$bar Install MPD ..."
pacman -S --noconfirm mpd
systemctl stop mpd

# reinstall ashuffle back
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/ashuffle-rune-1.0-20160319-armv7h.pkg.tar.xz
pacman -U ashuffle-rune-1.0-20160319-armv7h.pkg.tar.xz
rm ashuffle-rune-1.0-20160319-armv7h.pkg.tar.xz

cp /etc/mpd.conf{.backup,}

sed -i -e '/^Protect/ s/^/#/
' -e '/^Restrict/ s/^/#/
' /usr/lib/systemd/system/mpd.service

sed -i -e '/^Protect/ s/^/#/
' -e '/^Restrict/ s/^/#/
' /usr/lib/systemd/user/mpd.service

# fix permission (default - mpd run by user 'mpd')
touch /var/log/mpd.log
chmod 777 /var/log/mpd.log

systemctl daemon-reload
systemctl start mpd

redis-cli hset addons mpdu 1 &> /dev/null # mark as upgraded - disable button

# fix midori missing libs
ln -s /usr/lib/libicui18n.so.59.1 /usr/lib/libicui18n.so.56
ln -s /usr/lib/libicuuc.so.59.1 /usr/lib/libicuuc.so.56
ln -s /usr/lib/libwebp.so.7.0.0 /usr/lib/libwebp.so.6
ln -s /usr/lib/libicudata.so.59.1 /usr/lib/libicudata.so.56
pacman -S --noconfirm gstreamer gstreamer-vaapi gtk3 glib2 harfbuzz freetype2 libsoup libgcrypt gpg-crypter libgpg-error

timestop
title -l '=' "$bar MPD upgraded successfully."
