#!/bin/bash

alias=udac

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

echo -e "$bar Restore files ..."

restorefile /etc/udev/rules.d/rune_usb-audio.rules /srv/http/command/refresh_ao

udevadm control --reload-rules && udevadm trigger

uninstallfinish $@
