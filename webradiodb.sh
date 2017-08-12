#!/bin/bash

# populate webradio files

# cp *.pls /mnt/MPD/Webradio
# ./webradiodb.sh

echo

redis-cli del webradios

for file in /mnt/MPD/Webradio/*.pls; do
	name=$( grep 'Title1' "$file" | cut -d '=' -f2 )
	url=$( grep 'File1' "$file" | cut -d '=' -f2 )
	
	redis-cli hset webradios "$name" "$url" &> /dev/null
	printf "%-30s : $url\n" "$name"
done

mpc update Webradio &> /dev/null

echo -e '\nWebradio imported successfully.\n'
