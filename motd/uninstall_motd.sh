#!/bin/bash

wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

title -l = "$bar Uninstall Rune logo motd ..."

mv /etc/motd{.original,}
rm /etc/motd.banner
rm /etc/profile.f/motd.sh

sed -i '/PS1/ s/^#//' /etc/bash.bashrc

title -nt "$info Relogin to see original motd."

rm $0
