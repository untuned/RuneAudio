#!/bin/bash

alias=motd

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

if [[ $1 == u ]]; then
	color=$( grep echo /etc/profile.d/motd.sh | cut -d'$' -f1 | cut -d'"' -f2 )
	redis-cli set motdcolor $color &> /dev/null
fi

echo -e "$bar Restore files ..."

mv -v /etc/motd{.backup,} 2> /dev/null
rm -v /etc/motd.logo /etc/profile.d/motd.sh

restorefile /etc/bash.bashrc

uninstallfinish $@

[[ $1 != u ]] && title -nt "$info Relogin to see original motd."
