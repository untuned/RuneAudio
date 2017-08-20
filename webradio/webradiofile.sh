#!/bin/bash

# webradiodb.sh

# for import redis database to /mnt/MPD/Webradio/*.pls
# - clear files
# - create files from database
# - refresh ui
# - fix sorting

if [[ ! -e /var/lib/redis/rune.rdb ]]; then
	echo -e '\e[30m\e[43m i \e[0m No database file found.'
	echo -e 'Copy rune.rdb backup to \e[36m/var/lib/\e[0m then run again.\n'
	exit
fi

path=/mnt/MPD/Webradio
# clear files
rm -f $path/*.pls

echo -e "\n\e[36m\e[46m . \e[0m $path\n"
# create files from database
i=1
str=''
redis-cli hgetall webradios | \
while read line; do
	if [[ $(( i % 2)) == 1 ]]; then
		str+="[playlist]\nNumberOfEntries=1\nFile1=$line\n"
		filename="${line}.pls"
	else
		str+="Title1=$line"
		echo -e "$str" > "$path/$filename"
		printf "%3s - $filename\n" $(( i / 2 ))
		str=''
	fi
	(( i++ ))
done

# refresh ui
mpc update Webradio &> /dev/null

echo -e '\n\e[36m\e[46m . \e[0m Webradio files created successfully.\n'
