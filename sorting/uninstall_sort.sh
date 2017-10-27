#!/bin/bash

alias=sort

. /srv/http/addonstitle.sh

uninstallstart $@

file=/srv/http/app/templates/footer.php
echo $file
sed -i -e '/sorting.js/ d' $file

rm /srv/http/assets/js/sorting.js

uninstallfinish $@
