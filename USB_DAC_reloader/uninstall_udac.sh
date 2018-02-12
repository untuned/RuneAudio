#!/bin/bash

alias=udac

. /srv/http/addonstitle.sh

uninstallstart $@

echo -e "$bar Restore files ..."

file=/etc/udev/rules.d/rune_usb-audio.rules
echo $file
sed -i '/SUBSYSTEM=="sound"/ s/^#//
' -e '/^ACTION/ d
' $file

file=/srv/http/command/refresh_ao
echo $file
sed -i '/argc > 1/,/^}/ d' $file

uninstallfinish $@
