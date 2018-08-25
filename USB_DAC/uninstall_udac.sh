#!/bin/bash

alias=udac

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

rm -v /srv/http/usbdac

echo -e "$bar Restore files ..."

restorefile /etc/udev/rules.d/rune_usb-audio.rules

udevadm control --reload-rules && udevadm trigger

redis-cli del aodefault &> /dev/null

uninstallfinish $@
