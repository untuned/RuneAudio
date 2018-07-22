#!/bin/bash

. /srv/http/addonstitle.sh

sed -i "s/^\(zoom-level=\).*/\1$1" /root/.config/midori/config
sed -i "s/^\(force-device-scale-factor=\).*/\1$1" /root/.xinitrc

redis-cli set zoomlevel $1 &> /dev/null

title -l '=' "$bar Zoom level of local browser changed to $1"
