#!/bin/bash

alias=sort

. /srv/http/addonstitle.sh

uninstallstart $@

file=/srv/http/app/templates/footer.php
echo $file
sed -i -e '/musiclibrary.js/ d' $file

file=/srv/http/app/templates/playback.php
echo $file
sed -i '/id="db-index"/,/<\/ul>/ d' $file

rm /srv/http/assets/js/musiclibrary.js

uninstallfinish $@
