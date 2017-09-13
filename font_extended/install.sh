#!/bin/bash

version=20170901

rm $0

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

if [[ -e /usr/local/bin/uninstall_font.sh ]]; then
	echo -e "$info Extended fonts already installed."
	exit
fi

[[ $1 != u ]] && title -l = "$bar Install Extended fonts ..."

wgetnc https://github.com/rern/RuneAudio/raw/master/font_extended/uninstall_font.sh -P /usr/local/bin
chmod +x /usr/local/bin/uninstall_font.sh
wgetnc https://github.com/rern/_assets/raw/master/RuneUI_enhancement/lato.tar.xz
mv /srv/http/assets/fonts/lato{,.backup}
mkdir /srv/http/assets/fonts/lato
bsdtar -xvf lato.tar.xz -C /srv/http/assets/fonts/lato
rm lato.tar.xz

redis-cli hset addons font $version &> /dev/null

if [[ $1 != u ]]; then
	title -l = "$bar Extended fonts installed successfully."
	[[ -t 1 ]] && echo 'Uninstall: uninstall_font.sh'
	title -nt "$info Refresh browser for new fonts."
else
	title -l = "$bar Extended fonts updated successfully."
fi

# clear opcache if run from terminal #######################################
[[ -t 1 ]] && systemctl reload php-fpm

# restart local browser #######################################
if pgrep midori > /dev/null; then
	killall midori
	sleep 1
	xinit &> /dev/null &
fi
