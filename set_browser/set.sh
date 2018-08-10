#!/bin/bash

. /srv/http/addonstitle.sh

title -l '=' "$bar Switch local browser ..."

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

redis-cli hset settings browser $1 &> /dev/null

title -nt "$info Local browser switched to $( tcolor $browser )"

clearcache
