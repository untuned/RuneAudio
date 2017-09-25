#!/bin/bash

rm $0

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=webr

[[ ! -e /srv/http/addonstitle.sh ]] && wget -q https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/addonstitle.sh -P /srv/http
. /srv/http/addonstitle.sh
[[ ! -e /srv/http/addonslist.php ]] && wget -q https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/addonslist.php -P /srv/http

installstart $1

wgetnc https://github.com/rern/RuneAudio/raw/master/webradio/uninstall_webr.sh -P /usr/local/bin
chmod +x /usr/local/bin/uninstall_webr.sh

runeui=/srv/http/assets/js/runeui.js
runeuimin=/srv/http/assets/js/runeui.min.js

# remove previous modified if exist
echo $runeui

if grep -q "^//\s*if (path === 'Webradio')" $runeui; then
	sed -i $'/^\s*if (path === \'Webradio\')/, /}/ s|^|//|' $runeui
else
	sed -i '/("#database-entries li").detach()/,/("#database-entries").append(elems)/ d' $runeui
	sed -i 's/var elems=.*("span","#db-currentpath")/var u=$("span","#db-currentpath")/' $runeuimin
fi

# modify files
if ! grep -q "^//\s*if (path === 'Webradio')" $runeui; then
    sed -i $'/^\s*if (path === \'Webradio\')/, /}/ s|^|//|' $runeui
fi

if ! grep -q 'var addwebradio' $runeui; then
    sed -i '/highlighted entry/ a\
		if (path === "Webradio") {\
			var elems = $("#database-entries li").detach().sort(function (a, b) {\
				return $(a).text().toLowerCase().localeCompare($(b).text().toLowerCase());\
			});\
			$("#database-entries").append(elems);\
			var addwebradio = '"'"'<li id="webradio-add" class="db-webradio-add"><i class="fa fa-plus-circle db-icon"></i><span class="sn"><em>add new</em></span><span class="bl">add a webradio to your library</span></li>'"'"';\
			$("#database-entries").append(addwebradio);\
		}
    ' $runeui
fi

echo $runeuimin

if ! grep -q 'var addwebradio' $runeuimin; then
	perl -p -i -e 's|("Webradio"===t.*?</li>'"'"'\),)|/\*\1\*/|' $runeuimin
	sed -i $'s|var u=$("span","#db-currentpath")|if("Webradio"===path){var elems=$("#database-entries li").detach().sort(function(a,e){return $(a).text().toLowerCase().localeCompare($(e).text().toLowerCase())});$("#database-entries").append(elems);var addwebradio=\'<li id="webradio-add" class="db-webradio-add"><i class="fa fa-plus-circle db-icon"></i><span class="sn"><em>add new</em></span><span class="bl">add a webradio to your library</span></li>\';$("#database-entries").append(addwebradio)}&|' $runeuimin
fi

installfinish $1
