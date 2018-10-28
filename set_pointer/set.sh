#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title -l '=' "$bar Pointer of local browser ..."

file=/etc/X11/xinit/start_chromium.sh
[[ ! -e $file ]] && file=/root/.xinitrc
sed -i "s/\(use_cursor \).*/\1$1 \&/" $file
redis-cli hset settings pointer $1 &> /dev/null

echo -e "$bar Restart local browser ..."
killall Xorg &> /dev/null
sleep 3
xinit &> /dev/null &

[[ $1 == 'yes' ]] && enable=enabled || enable=disabled
title -nt "$info Pointer of local browser $( tcolor $enable )."
