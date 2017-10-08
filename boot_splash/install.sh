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

wget $gitpath/bootsplash.service -P /etc/systemd/system
systemctl enable bootsplash

wgetnc $gitpath/ply-image -P /usr/local/bin
chmod 755 /usr/local/bin/ply-image

mkdir -p /usr/share/bootsplash
wgetnc $gitpath/start.png -P /usr/share/bootsplash

installfinish $1

title -nt "$info Change image: /usr/share/bootsplash/start.png"
