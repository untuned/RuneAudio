#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=webr

[[ ! -e /srv/http/addonstitle.sh ]] && wget -q https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/addonstitle.sh -P /srv/http
. /srv/http/addonstitle.sh

installstart $1

getuninstall

runeui=/srv/http/assets/js/runeui.js
runeuimin=/srv/http/assets/js/runeui.min.js
echo $runeui
echo $runeuimin

# remove previous modified if exist
if grep -q 'var addwebradio' $runeui; then                                                        # 2nd version
	sed -i -e '\|^//\t*\s*if \(path === "Webradio"\)|,/}/ s|^//||
	' -e '\|^\t*\s*if (path === "Webradio")|,/}\n/ d
	' $runeui
fi
sed -i '/("#database-entries li").detach()/,/("#database-entries").append(elems)/ d' $runeui      # 1st version
perl -p -i -e 's|/\*("Webradio"===t.*?</li>'"'"'\),)\*/|\1|' $runeuimin                           # 2nd + 1st
perl -p -i -e 's|if\("Webradio"===path\).*?(var u=\$\("span","#db-currentpath"\))|\1|' $runeuimin # 1st

# modify files
sed -i $'/^\s*if (path === \'Webradio\')/, /}/ s|^|//webr|' $runeui

if ! grep -q 'var addwebradio' $runeui; then
    sed -i '/highlighted entry/ a\
			if (path === "Webradio") { //webr0\
				var elems = $("#database-entries li").detach().sort(function (a, b) {\
					return $(a).text().toLowerCase().localeCompare($(b).text().toLowerCase());\
				});\
				$("#database-entries").append(elems);\
				var addwebradio = '"'"'<li id="webradio-add" class="db-webradio-add"><i class="fa fa-plus-circle db-icon"></i><span class="sn"><em>add new</em></span><span class="bl">add a webradio to your library</span></li>'"'"';\
				$("#database-entries").append(addwebradio);\
			} //webr1
    ' $runeui
fi

if ! grep -q 'var addwebradio' $runeuimin; then
	perl -p -i -e 's|("Webradio"===t.*?</li>'"'"'\),)|/\*webr0\1webr1\*/|' $runeuimin
	sed -i $'s|var u=$("span","#db-currentpath")|/\*webr0\*/if("Webradio"===path){var elems=$("#database-entries li").detach().sort(function(a,e){return $(a).text().toLowerCase().localeCompare($(e).text().toLowerCase())});$("#database-entries").append(elems);var addwebradio=\'<li id="webradio-add" class="db-webradio-add"><i class="fa fa-plus-circle db-icon"></i><span class="sn"><em>add new</em></span><span class="bl">add a webradio to your library</span></li>\';$("#database-entries").append(addwebradio)}/\*webr1\*/&|' $runeuimin
fi

installfinish $1
