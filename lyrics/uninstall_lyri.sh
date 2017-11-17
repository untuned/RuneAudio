#!/bin/bash

alias=lyri

. /srv/http/addonstitle.sh

uninstallstart $1

echo -e "$bar Restore files ..."
file=/srv/http/app/templates/footer.php
echo $file
sed -i '/lyrics.js/ d' $file

echo -e "$bar Remove files ..."
rm -v /srv/http/assets/{js/lyrics.js,css/lyrics.css}

# no RuneUI GPIO
if [[ ! -e /usr/local/bin/uninstall_gpio.sh ]]; then
	rm $path/css/pnotify.css
	rm $path/js/vendor/pnotify3.custom.min.js
	sed -i '/pnotify.css/ d' $header
	sed -i '/pnotify3.custom.min.js/ d' $footer
fi

uninstallfinish $1
