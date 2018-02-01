#!/bin/bash

alias=udac

. /srv/http/addonstitle.sh

uninstallstart $@

if [[ $1 != u ]]; then
	redis-cli del aogpio volumegpio acardsgpio mpdconfgpio &> /dev/null
fi

echo -e "$bar Remove files ..."

rm /srv/http/udac.php /srv/http/assets/js/udac.js

echo -e "$bar Restore files ..."

file=/srv/http/app/templates/header.php
echo $file
sed -i '/id="udac"/ d' $file

file=/srv/http/app/templates/footer.php
echo $file
sed -i '/udac.js/ d' $file

file=/srv/http/app/templates/mpd.php
echo $file
sed -i -e '/udac0/,/udac1/ d' $file

chmod 644 /etc/mpd.conf

uninstallfinish $@
