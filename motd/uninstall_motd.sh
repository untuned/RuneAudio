#!/bin/bash

wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

title -l = "$bar Uninstall Rune logo motd ..."

mv /etc/motd{.original,}
rm /etc/motd.logo /etc/profile.d/motd.sh

sed -i -e '/^PS1=/ d
' -e '/^#PS1=/ s/^#//
' /etc/bash.bashrc

redis-cli hset addons motd 0

title -nt "\n$info Relogin to see original motd."

rm $0
