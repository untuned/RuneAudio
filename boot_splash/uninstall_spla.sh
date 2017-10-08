#!/bin/bash

alias=spla

. /srv/http/addonstitle.sh

uninstallstart $1

echo -e "$bar Restore files ..."
echo /boot/cmdline.txt
sed -i -e 's/console=tty3/console=ttyAMA0,115200 console=tty1/
' -e 's/ logo.nologo//
' /boot/cmdline.txt

systemctl disable bootsplash

echo -e "$bar Remove files ..."
rm -v /etc/systemd/system/bootsplash.service
rm -v /usr/local/bin/ply-image
rm -rv /usr/share/bootsplash

uninstallfinish $1
