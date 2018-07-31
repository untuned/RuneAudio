#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title -l '=' "$bar Pointer of local browser ..."

if [[ $1 == 0 ]]; then
  yesno=no
  enable=disabled
  val=0
else
  yesno=yes
  enable=enabled
  val=1
fi

sed -i "s/\(use_cursor \).*/\1$yesno \&/" /root/.xinitrc

redis-cli hset settings pointer $val &> /dev/null

echo -e "$bar Restart local browser ..."
killall Xorg &> /dev/null
sleep 3
xinit &> /dev/null &

title -nt "$info Pointer of local browser $( tcolor $enable )."
