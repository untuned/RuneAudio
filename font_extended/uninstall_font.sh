#!/bin/bash

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

if [[ ! -e /srv/http/assets/fonts/lato.backup ]]; then
	echo -e "$info Extended fonts not found."
	exit 1
fi

title -l = "$bar $type Extended fonts ..."

rm -rv /srv/http/assets/fonts/lato
mv -v /srv/http/assets/fonts/lato{.backup,}

redis-cli hdel addons font &> /dev/null

if pgrep midori >/dev/null; then
	killall midori
	sleep 1
	xinit &>/dev/null &
	echo 'Local browser restarted.'
fi

if [[ $1 != u ]]; then
	title -l = "$bar Extended fonts uninstalled successfully."
	title -nt "$info Refresh browser for original fonts."
fi

# clear opcache if run from terminal #######################################
[[ -t 1 ]] && systemctl reload php-fpm

# restart local browser #######################################
if pgrep midori > /dev/null; then
	killall midori
	sleep 1
	xinit &> /dev/null &
fi

rm $0
