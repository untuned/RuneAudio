#!/bin/bash

i=1
str=''
redis-cli hgetall webradios | \
while read line; do
	if [[ $i == 1 ]]; then
		str+="[playlist]\nNumberOfEntries=1\nFile1=$line\n"
		filename="${line}.pls"
		i=0
	else
		str+="Title1=$line"
		echo -e "$str" > "$filename"
		str=''
		i=1
	fi
done
