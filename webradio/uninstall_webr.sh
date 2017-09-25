#!/bin/bash

alias=webr

. /srv/http/addonstitle.sh

uninstallstart $1

file=/srv/http/assets/js/runeui.js
echo $file

if grep -q "^//\s*if (path === 'Webradio')" $file; then
    sed -i $'/^\s*if (path === \'Webradio\')/, /}/ s|^//||' $file
fi

if grep -q 'var addwebradio' $file; then
    sed -i '/if (path === "Webradio")/,/}/ d' $file
    
	file=/srv/http/assets/js/runeui.min.js
	echo $file
	perl -p -i -e 's|/\*("Webradio"===t.*?</li>'"'"'\),)\*/|\1|' $file
	perl -p -i -e 's|if\("Webradio"===path\).*?(var u=\$\("span","#db-currentpath"\))|\1|' $file
fi

uninstallfinish $1
