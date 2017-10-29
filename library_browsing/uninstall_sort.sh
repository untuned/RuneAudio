#!/bin/bash

alias=libr

. /srv/http/addonstitle.sh

uninstallstart $@

file=/srv/http/app/templates/footer.php
echo $file
sed -i -e '/musiclibrary.js/ d' $file

file=/srv/http/app/templates/playback.php
echo $file
sed -i -e '/id="db-currentpath" class="hide"/, /<\/div>/ d
' -e '/id="db-index"/, /<\/ul>/ d
' -e 's/<!--libr\|libr-->//g
' $file

rm /srv/http/assets/js/musiclibrary.js

uninstallfinish $@
