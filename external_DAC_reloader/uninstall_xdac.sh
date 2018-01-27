#!/bin/bash

alias=xdac

. /srv/http/addonstitle.sh

uninstallstart $@

if [[ $1 != u ]]; then
	redis-cli del aogpio volumegpio acardsgpio mpdconfgpio &> /dev/null
fi

echo -e "$bar Restore files ..."

rm /srv/http/xdac.php /srv/http/assets/js/xdac.js

echo -e "$bar Restore files ..."

file=/srv/http/app/templates/header.php
echo $file
sed -i '/id="xdac"/ d' $file

file=/srv/http/app/templates/footer.php
echo $file
sed -i '/xdac.js/ d' $file

file=/srv/http/app/templates/mpd.php
echo $file
sed -i -e '/id="savexdac"/ d
' -e '/<script>/,/<\/script>/ d' $file

chmod 644 /etc/mpd.conf

uninstallfinish $@
