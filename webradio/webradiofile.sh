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
# clear files
rm /mnt/MPD/Webradio/*.pls

echo
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
		echo -e "$str" > "/mnt/MPD/Webradio/$filename"
		echo $i - $filename
		str=''
	fi
	(( i++ ))
done

echo -e '\n\e[36m\e[46m . \e[0m Webradio files created successfully.\n'
