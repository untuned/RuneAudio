#!/bin/bash

# for import /mnt/MPD/Webradio/*.pls
# - clear database
# - extract files to database
# - refresh ui
# - fix sorting

rm $0

[[ ! -e /srv/http/addonstitle.sh ]] && wget -q https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/addonstitle.sh -P /srv/http
. /srv/http/addonstitle.sh

title -l '=' "$bar Webradio Import ..."

# clear database
redis-cli del webradios &> /dev/null

echo
# add data from files
for file in /mnt/MPD/Webradio/*.pls; do
	if [[ ! -e $file ]]; then
		title -l '=' "$info No webradio files found."
		title -nt 'Copy *.pls to /mnt/MPD/Webradio/ then run again.'
		exit
	fi
	name=$( grep 'Title1' "$file" | cut -d '=' -f2 )
	url=$( grep 'File1' "$file" | cut -d '=' -f2 )
	
	redis-cli hset webradios "$name" "$url" &> /dev/null
	printf "%-30s : $url\n" "$name"
done

# refresh ui
mpc update Webradio &> /dev/null

# fix sorting
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

title -l '=' "$bar Webradio imported successfully."
title -nt "$info Refresh browser to start using."
