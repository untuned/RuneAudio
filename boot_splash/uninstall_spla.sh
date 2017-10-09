#!/bin/bash

alias=spla

. /srv/http/addonstitle.sh

uninstallstart $1

echo -e "$bar Restore files ..."
echo /boot/cmdline.txt
sed -i -e 's/console=tty3/console=ttyAMA0,115200 console=tty1/
' -e 's/ loglevel=0 logo.nologo//
' /boot/cmdline.txt

echo /boot/config.txt
sed '/disable_splash=1/ d' /boot/confix.txt

mv /etc/motd{.ply,}

systemctl disable ply-image

echo -e "$bar Remove files ..."
rm -v /etc/systemd/system/ply-image.service
rm -v /usr/local/bin/ply-image
rm -rv /usr/share/ply-image
rm -v /root/.hushlogin

uninstallfinish $1
