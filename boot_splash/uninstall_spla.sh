#!/bin/bash

alias=spla

. /srv/http/addonstitle.sh

uninstallstart $1

echo -e "$bar Restore files ..."
echo /boot/cmdline.txt
sed -i -e 's/ loglevel=0 logo.nologo//' /boot/cmdline.txt

echo /boot/config.txt
sed '/disable_splash=1/ d' /boot/confix.txt

systemctl disable ply-image
systemctl enable getty@tty1.service

echo -e "$bar Remove files ..."
rm -v /etc/systemd/system/ply-image.service
rm -v /usr/local/bin/ply-image
rm -rv /usr/share/ply-image

uninstallfinish $1
