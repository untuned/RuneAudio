#!/bin/bash

alias=brea

. /srv/http/addonstitle.sh

uninstallstart $@

echo -e "$bar Remove files ..."
rm /srv/http/assets/js/breadcrumb.js

echo -e "$bar Restore files ..."
file=/srv/http/app/templates/footer.php
echo $file
sed -i '/breadcrumb.js/ d' $file

file=/srv/http/app/templates/playback.php
echo $file
sed -i -e '/id="db-currentpath"/, /<\/div>/ d
' -e 's/<!--brea\|brea-->//g
' $file

uninstallfinish $@
