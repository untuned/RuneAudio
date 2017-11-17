#!/bin/bash

alias=lyri

. /srv/http/addonstitle.sh

uninstallstart $1

echo -e "$bar Restore files ..."
file=/srv/http/app/templates/footer.php
echo $file
sed -i '/lyrics.js/ d' $file

echo -e "$bar Remove files ..."
rm -v /srv/http/assets/js/lyrics.js

uninstallfinish $1
