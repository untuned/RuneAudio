#!/bin/bash

wget -qN --no-check-certificate https://raw.githubusercontent.com/rern/title_script/master/title.sh; . title.sh; rm title.sh

title -l = "$bar Uninstall Rune logo motd ..."

mv /etc/motd{.original,}
rm /etc/motd.logo /etc/profile.d/motd.sh /root/.hushlogin

sed -i -e '/^PS1=/ d
' -e '/^#PS1=/ s/^#//
' /etc/bash.bashrc

title -nt "\n$info Relogin to see original motd."

rm $0
