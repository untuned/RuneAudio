#!/bin/bash

alias=spla

. /srv/http/addonstitle.sh

installstart $1

getuninstall

gitpath=https://github.com/rern/RuneAudio/raw/master/boot_splash

sed -i -e 's/console=ttyAMA0,115200//
' -e 's/console=tty1/console=tty3/
' -e '${s/$/ logo.nologo/}
' /boot/cmdline.txt

wget $gitpath/ply-image.service -P /etc/systemd/system
systemctl enable ply-image

wgetnc $gitpath/ply-image -P /usr/local/bin
chmod 644 /usr/local/bin/ply-image

mkdir -p /usr/share/ply-image
wgetnc $gitpath/start.png -P /usr/share/ply-image

installfinish $1

title -nt "$info Change image: /usr/share/ply-image/start.png"
