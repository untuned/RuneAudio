#!/bin/bash

alias=mpdu

. /srv/http/addonstitle.sh

if pacman -Qi mpd &> /dev/null; then
	redis-cli hset addons mpdu 1 &> /dev/null # mark as upgraded - disable button
	title "$info MPD already upgraged."
	title -nt "Further upgrade: pacman -Sy mpd"
	exit
fi

title -l '=' "$bar Upgrade MPD ..."
timestart l

rankmirrors

echo -e "$bar Get files ..."
# pacman -S openssl > libcrypto.so.1.0, libssl.so.1.0 error - some packages still need existing version
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
chown root:root /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}
chmod 755 /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}

# fix python3 issue by swith to python2
ln -sf /usr/bin/python{2.7,}

cp /etc/mpd.conf{,.backup}

sed -i '/^IgnorePkg/ s/mpd //; s/ffmpeg ashuffle //' /etc/pacman.conf

echo -e "$bar Remove conflict packages ..."
# pre-remove to avoid conflict messages (/usr/local/bin/ashuffle is used directly, not by installed)
pacman -R --noconfirm ashuffle-rune ffmpeg-rune mpd-rune

echo -e "$bar Install packages ..."
pacman -S --noconfirm libnfs icu libwebp gcc-libs wavpack ffmpeg
pacman -S python2-pip
ln -sf /usr/bin/pip{2,}
pip install flask

echo -e "$bar Install MPD ..."
pacman -S --noconfirm mpd

cp /etc/mpd.conf{.backup,}

# fix permission (default - mpd run by user 'mpd')
chmod -f 777 /var/log/runeaudio/mpd.log

# fix systemd unknown lvalue (not exist in current systemd version) 
echo -e "$bar Modify files ..."
sed -i -e 's/User=mpd/User=root/
' -e '/^ProtectKernel/ s/^/#/
' -e '/^ProtectControl/ s/^/#/
' -e '/^Restrict/ s/^/#/
' /usr/lib/systemd/system/mpd.service

# fix missing directory
mkdir -p /var/lib/mpd/playlists
chown mpd:audio /var/lib/mpd/playlists

systemctl daemon-reload

echo -e "$bar Start MPD ..."
if ! systemctl restart mpd &> /dev/null; then
	title -l = "$warn MPD upgrade failed."
	exit
fi

redis-cli hset addons mpdu 1 &> /dev/null # mark as upgraded - disable button
mpdversion=$( mpd -V | head -n1 | awk '{ print $NF }' )

clearcache
	
timestop l
title -l '=' "$bar MPD upgraded successfully to $mpdversion"
echo -e "$info Next upgrade: pacman -Sy mpd"
title -nt "$info Local browser: Chromium browser must be installed."
