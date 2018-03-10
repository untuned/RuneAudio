#!/bin/bash

alias=volu

. /srv/http/addonstitle.sh

uninstallstart $@

echo -e "$bar Remove files ..."

rm /srv/http/assets/js/volume.js
[[ ! -e /usr/local/bin/uninstall_enha.sh ]] && rm /srv/http/redis.php

echo -e "$bar Restore files ..."
file=/srv/http/app/templates/footer.php
echo $file
sed -i '/volume.js/ d' $file

uninstallfinish $@
