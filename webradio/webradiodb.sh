#!/bin/bash

rm $0

[[ ! -e /srv/http/addonstitle.sh ]] && wget -q https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/addonstitle.sh -P /srv/http
. /srv/http/addonstitle.sh

# if sub directories
if ls -d /mnt/MPD/Webradio/*/ &> /dev/null; then
	# -mindepth 2 = in sub directories && -type f = file
	find /mnt/MPD/Webradio -mindepth 2 -type f -name *.pls -exec cp -f -- '{}' /mnt/MPD/Webradio \;
	# * = all sub directory && .[^.] = not ..
	rm -rf /mnt/MPD/Webradio/{*,.[^.]}/
fi

if ! ls /mnt/MPD/Webradio/*.pls &> /dev/null; then
	title -l '=' "$info No webradio files found."
	title -nt 'Copy *.pls to /mnt/MPD/Webradio/ then run again.'
	exit
fi

title -l '=' "$bar Webradio Import ..."

# clear database
redis-cli del webradios &> /dev/null

# add data from files
for file in /mnt/MPD/Webradio/*.pls; do
	count=$( grep -c '^File' "$file" )
	for (( i=1; i <= $count; i++ )); do
		url=$( grep "^File$i" "$file" | cut -d '=' -f2 )
		name=$( grep "^Title$i" "$file" | cut -d '=' -f2 )
		redis-cli hset webradios "$name" "$url" &> /dev/null
		printf "%-30s : $url\n" "$name"
		
		if (( $count > 1 )); then
			string=$( cat <<EOF
[playlist]
NumberOfEntries=1
File1=$url
Title1=$name
EOF
)
			echo "$string" > /mnt/MPD/Webradio/"$name".pls
		fi
	done
	(( $count > 1 )) && rm "$file"
done

# refresh list
mpc update Webradio &> /dev/null

title -l '=' "$bar Webradio imported successfully."
