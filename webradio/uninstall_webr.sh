#!/bin/bash

alias=webr

. /srv/http/addonstitle.sh

uninstallstart $1

file=/srv/http/assets/js/runeui.js
echo $file
sed -i -e 's|^//webr||
' -e '\|//webr0|,\|//webr1| d
' $file
    
file=/srv/http/assets/js/runeui.min.js
echo $file
sed -i -e 's|/\*webr0||
' -e 's|webr1\*/||
' -e 's|/\*webr0\*/.*/\*webr1\*/||
' $file

uninstallfinish $1
