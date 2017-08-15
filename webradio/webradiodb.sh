#!/bin/bash

# webradiodb.sh

# for import /mnt/MPD/Webradio/*.pls
# - clear database
# - extract files to database
# - refresh ui
# - fix sorting

# clear database
redis-cli del webradios &> /dev/null

echo
# add data from files
for file in /mnt/MPD/Webradio/*.pls; do
	if [[ ! -e $file ]]; then
		echo -e '\e[30m\e[43m i \e[0m No webradio files found.'
		echo -e 'Copy *.pls to \e[36m/mnt/MPD/Webradio/\e[0m then run again.\n'
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
if ! grep -q 'append(elems)' $runeui; then
	sed -i '/highlighted entry/ a\
            var elems = $("#database-entries li").detach().sort(function (a, b) {\
                return $(a).text().toLowerCase().localeCompare(\$(b).text().toLowerCase());\
            });\
            $('#database-entries').append(elems);
	' $runeui
	
	sed -i 's/for(d=0;c=a\[d\];d+=1)/ a.sort(function(x,y){return x.playlist<y.playlist?-1:x.playlist>y.playlist?1:0});&/
	' /srv/http/assets/js/runeui.min.js
fi

echo -e '\n\e[36m\e[46m . \e[0m Webradio imported successfully.\n'
