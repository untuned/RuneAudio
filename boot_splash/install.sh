#!/bin/bash

alias=spla

. /srv/http/addonstitle.sh

installstart $@

getuninstall

gitpath=https://github.com/rern/RuneAudio/raw/$branch/boot_splash

sed -i -e '/^\s*$/ d
' -e '1 s/$/ logo.nologo/
' /boot/cmdline.txt

echo 'disable_splash=1' >> /boot/config.txt

systemctl disable getty@tty1.service

string=$( cat <<'EOF'
[Unit]
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
EOF
)
echo -e "$string" > $file

systemctl enable ply-image

wgetnc $gitpath/ply-image -P /usr/local/bin
chmod 755 /usr/local/bin/ply-image

mkdir -p /usr/share/ply-image
wgetnc $gitpath/start.png -P /usr/share/ply-image

installfinish $@

title -nt "$info Change image: /usr/share/ply-image/start.png"
