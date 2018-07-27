#!/bin/bash

. /srv/http/addonstitle.sh

title -l '=' "$bar Enable pointer of local browser ..."

if [[ $1 == 0 ]]; then
  yesno=no
  enable=disabled
else
  yesno=yes
  enable=enabled
fi

sed -i "s/\(use_cursor \).*/\1$yesno \&/" /root/.xinitrc

echo -e "$bar Restart local browser ..."
killall Xorg &> /dev/null
sleep 3
xinit &> /dev/null &

title -nt "$info Pointer of local browser $( tcolor $enable )."
