#!/bin/bash

. /srv/http/addonstitle.sh

sed -i "s/^\(zoom-level=\).*/\1$1/" /root/.config/midori/config
if grep '^chromium' /root/.xinitrc; then
    sed -i "s/\(force-device-scale-factor=\).*/\1$1/" /root/.xinitrc
fi

redis-cli set zoomlevel $1 &> /dev/null

echo -e "$bar Restart local browser ..."
killall Xorg &> /dev/null
sleep 3
xinit &> /dev/null &

title -l '=' "$info Zoom level of local browser changed to $1"
