#!/bin/bash

alias=webr

. /srv/http/addonstitle.sh

uninstallstart $1

if grep -q "^//\s*if (path === 'Webradio')" $file; then
    sed -i $'/^\s*if (path === \'Webradio\')/, /}/ s|^//||' $file
fi
if grep -q 'var addwebradio' $file; then
    sed -i '/if (path === "Webradio")/,/}/ d' $file
    
	perl -p -i -e 's|if\("Webradio"===path\).*?(var u=\$\("span","#db-currentpath"\))|\1|' ${file/.js/.min.js}
fi

uninstallfinish $1
