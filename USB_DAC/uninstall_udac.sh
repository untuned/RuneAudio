#!/bin/bash

alias=udac

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

echo -e "$bar Remove file ..."
file=/srv/http/usbdac
rm -v $file

echo -e "$bar Restore file ..."

restorefile /etc/udev/rules.d/rune_usb-audio.rules

udevadm control --reload-rules && udevadm trigger

redis-cli del aodefault &> /dev/null

uninstallfinish $@
