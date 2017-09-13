#!/bin/bash

# required variables
alias=motd
title='Login Logo for SSH Terminal'

wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

uninstallstart

echo -e "$bar Restore files ..."

mv -v /etc/motd{.original,}
rm -v /etc/motd.logo /etc/profile.d/motd.sh

file=/etc/bash.bashrc
echo $file
sed -i -e '/^PS1=/ d
' -e '/^#PS1=/ s/^#//
' $file

uninstallfinish
title -nt "$info Relogin to see original motd."
