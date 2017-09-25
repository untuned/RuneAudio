#!/bin/bash

rm $0

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=webr

[[ ! -e /srv/http/addonstitle.sh ]] && wget -q https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/addonstitle.sh -P /srv/http
. /srv/http/addonstitle.sh
[[ ! -e /srv/http/addonslist.php ]] && wget -q https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/addonslist.php -P /srv/http

installstart $1

file=/srv/http/assets/js/runeui.js
# remove previous modified if exist
if grep -q 'text().toLowerCase().localeCompare' $file && ! grep -q 'var addwebradio' $file; then
	sed -i '/("#database-entries li").detach()/,/("#database-entries").append(elems)/ d' $file
	sed -i 's/var elems=.*("span","#db-currentpath")/var u=$("span","#db-currentpath")/' ${file/.js/.min.js}
fi

if ! grep -q "^//\s*if (path === 'Webradio')" $file; then
    sed -i $'/^\s*if (path === \'Webradio\')/, /}/ s|^|//|' $file
fi

if ! grep -q 'var addwebradio' $file; then
    sed -i '/highlighted entry/ a\
			if (path === "Webradio") {\
				var elems = $("#database-entries li").detach().sort(function (a, b) {\
					return $(a).text().toLowerCase().localeCompare($(b).text().toLowerCase());\
				});\
				$("#database-entries").append(elems);\
				var addwebradio = '"'"'<li id="webradio-add" class="db-webradio-add"><i class="fa fa-plus-circle db-icon"></i><span class="sn"><em>add new</em></span><span class="bl">add a webradio to your library</span></li>'"'"';\
				$("#database-entries").append(addwebradio);\
			}
    ' $file
    
	sed -i $'s|var u=$("span","#db-currentpath")|if("Webradio"===path){var elems=$("#database-entries li").detach().sort(function(a,e){return $(a).text().toLowerCase().localeCompare($(e).text().toLowerCase())});$("#database-entries").append(elems);var addwebradio=\'<li id="webradio-add" class="db-webradio-add"><i class="fa fa-plus-circle db-icon"></i><span class="sn"><em>add new</em></span><span class="bl">add a webradio to your library</span></li>\';$("#database-entries").append(addwebradio)}&|' ${file/.js/.min.js}
fi

installfinish $1
