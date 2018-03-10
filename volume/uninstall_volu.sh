#!/bin/bash

alias=volu

. /srv/http/addonstitle.sh

uninstallstart $@

echo -e "$bar Remove files ..."

rm /srv/http/assets/js/volume.js
if [[ ! -e /usr/local/bin/uninstall_enha.sh ]]; then
	rm /srv/http/redis.php
	rm /srv/http/assets/js/vendor/{hammer.min.js,propagating.js}
	sed '/hammer.min.js\|propagating.js/ d' /srv/http/app/templates/footer.php
fi

echo -e "$bar Restore files ..."
file=/srv/http/app/templates/footer.php
echo $file
sed -i '/volume.js/ d' $file

uninstallfinish $@
