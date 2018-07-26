#!/bin/bash

. /srv/http/addonstitle.sh

if grep '^chromium' /root/.xinitrc; then
    sed -i "s/\(force-device-scale-factor=\).*/\1$1/" /root/.xinitrc
else
    sed -i "s/^\(zoom-level=\).*/\1$1/" /root/.config/midori/config
fi

redis-cli set zoomlevel $1 &> /dev/null

title -nt "$bar Restart local browser ..."
killall Xorg &> /dev/null
sleep 3
xinit &> /dev/null &

title -l '=' "$info Zoom level of local browser changed to $1"
