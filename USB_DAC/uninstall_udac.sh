#!/bin/bash

alias=udac

. /srv/http/addonstitle.sh

uninstallstart $@

echo -e "$bar Restore files ..."

file=/etc/udev/rules.d/rune_usb-audio.rules
echo $file
sed -i -e '/SUBSYSTEM=="sound"/ s/^#//
' -e '/^ACTION/ d
' $file

udevadm control --reload-rules && udevadm trigger

file=/srv/http/command/refresh_ao
echo $file
sed -i -e '/ui_notify/ s|^//||
' -e '/udac0/,/udac1/ d' $file

redis-cli del udaclist &> /dev/null

uninstallfinish $@
