#!/bin/bash

alias=spla

. /srv/http/addonstitle.sh

installstart $1

getuninstall

gitpath=https://github.com/rern/RuneAudio/raw/master/boot_splash

sed -i -e '/^\s*$/ d
' -e 's/ console=ttyAMA0,115200//
' -e 's/console=tty1/console=tty3/
' -e '1 s/$/ loglevel=3 logo.nologo/
' /boot/cmdline.txt

echo '[Unit]
Description=Boot splash screen
DefaultDependencies=no
After=systemd-vconsole-setup.service
Before=sysinit.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/ply-image /usr/share/ply-image/start.png

[Install]
WantedBy=getty.target
' > /etc/systemd/system/ply-image.service
systemctl enable ply-image

wgetnc $gitpath/ply-image -P /usr/local/bin
chmod 755 /usr/local/bin/ply-image

mkdir -p /usr/share/ply-image
wgetnc $gitpath/start.png -P /usr/share/ply-image

touch /root/.hushlogin

installfinish $1

title -nt "$info Change image: /usr/share/ply-image/start.png"
