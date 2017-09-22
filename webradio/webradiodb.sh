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
runeui=/srv/http/assets/js/runeui.js
if ! grep -q 'localeCompare' $runeui; then
    sed -i '/highlighted entry/ a\
            var elems = $("#database-entries li").detach().sort(function (a, b) {\
                return $(a).text().toLowerCase().localeCompare($(b).text().toLowerCase());\
            });\
            $("#database-entries").append(elems);
    ' $runeui
    
    sed -i 's/var u=$("span","#db-currentpath")/var elems=$("#database-entries li").detach().sort(function(a,b){return $(a).text().toLowerCase().localeCompare($(b).text().toLowerCase())});$("#database-entries").append(elems);&/
    ' ${runeui/.js/.min.js}
fi

title -l '=' "$bar Webradio imported successfully."
