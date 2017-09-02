#!/bin/bash

wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

if [[ ! -e /etc/motd.logo ]]; then
  echo -e "$info Rune logo motd not found."
  exit
fi

title -l = "$bar Uninstall Rune logo motd ..."

mv /etc/motd{.original,}
rm /etc/motd.logo /etc/profile.d/motd.sh

sed -i -e '/^PS1=/ d
' -e '/^#PS1=/ s/^#//
' /etc/bash.bashrc

redis-cli hdel addons motd &> /dev/null

title -nt "\n$info Relogin to see original motd."

rm $0
