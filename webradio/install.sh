#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=webr

. /srv/http/addonstitle.sh

if [[ $( redis-cli get release ) == '0.4b' ]]; then
	title -l '=' "$info RuneAudio 0.4b does not need this fix."
	exit
fi

installstart $1

getuninstall

runeui=/srv/http/assets/js/runeui.js
runeuimin=/srv/http/assets/js/runeui.min.js
echo $runeui
echo $runeuimin

# remove previous modified if exist
if grep -q 'var addwebradio' $runeui; then                                                        # 2nd version
	sed -i -e '\|^//\s*if (path === .Webradio.)|, \|^//\s*}$| s|^//||
	' -e '/^\s*if (path === "Webradio")/, /^\s*}$/ d
	' $runeui
fi
sed -i 's|/\*||g; s|\*/||' $runeuimin                                                             # 2nd
sed -i 's/if("Webradio"===path).*append(addwebradio)}//' $runeuimin                               # 2nd + 1st
sed -i '/("#database-entries li").detach()/,/("#database-entries").append(elems)/ d' $runeui      # 1st version

# modify files
sed -i $'/^\s*if (path === \'Webradio\')/, /}/ s|^|//webr|' $runeui

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

sed -i 's|"Webradio"===t.*</li>.),|/\*webr0&webr1\*/|' $runeuimin

sed -i $'s|var u=$("span","#db-currentpath")|/\*webr0\*/if("Webradio"===path){var elems=$("#database-entries li").detach().sort(function(a,e){return $(a).text().toLowerCase().localeCompare($(e).text().toLowerCase())});$("#database-entries").append(elems);var addwebradio=\'<li id="webradio-add" class="db-webradio-add"><i class="fa fa-plus-circle db-icon"></i><span class="sn"><em>add new</em></span><span class="bl">add a webradio to your library</span></li>\';$("#database-entries").append(addwebradio)}/\*webr1\*/&|' $runeuimin

installfinish $1

clearcache
