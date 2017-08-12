#!/bin/bash

echo

# fix sorting
file=/srv/http/assets/js/runeui.js
if ! grep 'a.playlist > b.playlist' $file; then
	line=$(( $( sed -n '/id="webradio-add"/=' $file ) - 9 ))
	sed -i $line' i\
            data.sort(function(a, b){\
                if (a.playlist < b.playlist)\
                    return -1;\
                if (a.playlist > b.playlist)\
                    return 1;\
                return 0;\
            });
	' $file
fi

# clear database
redis-cli del webradios

# add data from files
for file in /mnt/MPD/Webradio/*.pls; do
	name=$( grep 'Title1' "$file" | cut -d '=' -f2 )
	url=$( grep 'File1' "$file" | cut -d '=' -f2 )
	
	redis-cli hset webradios "$name" "$url" &> /dev/null
	printf "%-30s : $url\n" "$name"
done

# refresh ui
mpc update Webradio &> /dev/null

echo -e '\nWebradio imported successfully.\n'
