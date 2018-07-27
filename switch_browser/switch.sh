#!/bin/bash

. /srv/http/addonstitle.sh

file=/root/.xinitrc
if [[ $1 == 1 ]]; then
    sed -i 's/^#*\(midori\)/\1/' $file
    sed -i 's/^\(chromium\)/#\1/' $file
    browser=Midori
else
    sed -i 's/^\(midori\)/#\1/' $file
    sed -i 's/^#*\(chromium\)/\1/' $file
    browser=Chromium
fi

redis-cli set browser $1 &> /dev/null

title "$bar Start $( tcolor $browser ) as local browser ..."
killall Xorg &> /dev/null
sleep 3
xinit &> /dev/null &
