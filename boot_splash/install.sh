#!/bin/bash

alias=spla

. /srv/http/addonstitle.sh

checkversion04 'RuneAudio 0.4b has this feature built-in.'

installstart $1

getuninstall

gitpath=https://github.com/rern/RuneAudio/raw/master/boot_splash

sed -i -e '/^\s*$/ d
' -e '1 s/$/ logo.nologo/
' /boot/cmdline.txt

echo 'disable_splash=1' >> /boot/config.txt

systemctl disable getty@tty1.service

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

installfinish $1

title -nt "$info Change image: /usr/share/ply-image/start.png"
