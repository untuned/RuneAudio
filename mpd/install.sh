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
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
chown root:root /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}

echo -e "$bar Remove conflict packages ..."
pacman -R ashuffle-rune mpd-rune ffmpeg-rune

rankmirrors

echo -e "bar Install packaes ..."
# fix libreadline error
pacman -S readline
ln -s /lib/libreadline.so.7.0 /lib/libreadline.so.6

pacman -S base-devel
pacman -S alsa-lib audiofile avahi boost bzip2 curl dbus doxygen expat faad2 ffmpeg flac guile icu jack lame ldb 
pacman -S libao libcdio-paranoia libgme libid3tag libmad libmms libmodplug libmpdclient libnfs libogg libsamplerate libshout libsndfile libsoxr libupnp libutil-linux libvorbis libwebp
pacman -S mp3unicode mpg123 smbclient sqlite tdb tevent wavpack yajl zlib zziplib

mv /etc/mpd.conf{,.backup}
pacman -S mpd
mv /etc/mpd.conf{.backup,}
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/ashuffle-rune-1.0-20160319-armv7h.pkg.tar.xz
pacman -U ashuffle-rune-1.0-20160319-armv7h.pkg.tar.xz
rm ashuffle-rune-1.0-20160319-armv7h.pkg.tar.xz

systemctl daemon-reload
systemctl restart mpd

timefinish
title -l '=' "$bar MPD upgraded successfully."
