#!/bin/bash

alias=motd

. /srv/http/addonstitle.sh

uninstallstart $@

echo -e "$bar Restore files ..."

mv -v /etc/motd{.original,} 2> /dev/null
rm -v /etc/motd.logo /etc/profile.d/motd.sh

file=/etc/bash.bashrc
echo $file
sed -i -e '/^color=/, /^PS1=\x27/ d
' -e '/^#PS1=/ s/^#//
' $file

uninstallfinish $@

[[ $1 != u ]] && title -nt "$info Relogin to see original motd."
