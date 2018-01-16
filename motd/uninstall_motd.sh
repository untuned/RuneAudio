#!/bin/bash

alias=motd

. /srv/http/addonstitle.sh

uninstallstart $@

if [[ $1 == u ]]; then
	color=$( grep echo /etc/profile.d/motd.sh | cut -d'$' -f1 | cut -d'"' -f2 )
	redis-cli set motdcolor $color
fi

echo -e "$bar Restore files ..."

mv -v /etc/motd{.original,} 2> /dev/null
rm -v /etc/motd.logo /etc/profile.d/motd.sh

file=/etc/bash.bashrc
echo $file
sed -i -e '/^PS1=/ d
' -e '/^#PS1=\|#export PS1=/ s/^#//
' $file

uninstallfinish $@

[[ $1 != u ]] && title -nt "$info Relogin to see original motd."
