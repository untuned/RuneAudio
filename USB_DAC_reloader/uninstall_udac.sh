#!/bin/bash

alias=udac

. /srv/http/addonstitle.sh

uninstallstart $@

echo -e "$bar Remove files ..."

rm /srv/http/udac.php /srv/http/assets/js/udac.js

echo -e "$bar Restore files ..."

file=/srv/http/app/templates/footer.php
echo $file
sed -i '/udac.js/ d' $file

file=/srv/http/app/templates/mpd.php
echo $file
sed -i -e '/id="udac"/ d' $file

uninstallfinish $@
