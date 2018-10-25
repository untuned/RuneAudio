#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title -l '=' "$bar Change zoom level of local browser ..."

if ! grep '^chromium' /root/.xinitrc; then
	sed -i "s/^\(zoom-level=\).*/\1$1/" /root/.config/midori/config
else
	file=/etc/X11/xinit/start_chromium.sh
	[[ ! -e $file ]] && file=/root/.xinitrc
	sed -i "s/\(force-device-scale-factor=\).*/\1$1/" $file
fi

redis-cli hset settings zoom $1 &> /dev/null

echo -e "$bar Restart local browser ..."
killall Xorg &> /dev/null
sleep 3
xinit &> /dev/null &

title -nt "$info Zoom level of local browser changed to $1"
