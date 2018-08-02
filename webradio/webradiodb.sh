#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

# if sub directories
if ls -d /mnt/MPD/Webradio/*/ &> /dev/null; then
	# -mindepth 2 = in sub directories && -type f = file
	find /mnt/MPD/Webradio -mindepth 2 -type f -exec mv -i -- {} /mnt/MPD/Webradio \;
	# * = all sub directory && .[^.] = not ..
	rm -rf /mnt/MPD/Webradio/{*,.[^.]}/
fi

for file in /mnt/MPD/Webradio/*; do
	filename=$( basename "$file" )
	ext=${filename##*.}
	[[ $ext == 'pls' || $ext == 'm3u' ]] && break
	title -l '=' "$info No webradio files found."
	title -nt 'Copy *.pls or *.m3u to /mnt/MPD/Webradio/ then run again.'
	exit
done

title -l '=' "$bar Webradio Import ..."

# clear database
redis-cli del webradios &> /dev/null

# add data from files
makefile() {
	string=$( cat <<EOF
[playlist]
NumberOfEntries=1
Title1=$1
File1=$2
EOF
)
	echo "$string" > /mnt/MPD/Webradio/"$1".pls
}
incrementname() {
	if (( ${#names[@]} > 0 )); then
		for n in "${names[@]}"; do
			if [[ $n == $1 ]]; then
				[[ -n $( echo $n | grep '_[0-9]\+$' ) ]] && num=${n##*_} || num=1
				(( num++ ))
				name=$1'_'$num
			fi
		done
	fi
	names+=( $name )
}

for file in /mnt/MPD/Webradio/*; do
	if [[ ${file##*.} == pls ]]; then
		# count to work with multiple items
		count=$( grep -c '^File' "$file" )
		for (( i=1; i <= $count; i++ )); do
			name=$( grep "^Title$i" "$file" | cut -d '=' -f2 )
			# no name
			[[ -z $name ]] && name="noName"
			# increment same name
			incrementname "$name"
			url=$( grep "^File$i" "$file" | cut -d '=' -f2 )
			printf "%-30s : $url\n" "$name"
			redis-cli hset webradios "$name" "$url" &> /dev/null
			# delete if has only 1 item
			(( $count == 1 )) && rm "$file"
			makefile "$name" "$url"
		done
		# delete after gone through all items
		(( $count > 1 )) && rm "$file"
	else
		# *.m3u
		cat $file | while read line; do
			[[ ${line:0:4} != http ]] && continue
			
			linenohttp=${line:7}
			if [[ $linenohttp =~ '/' ]]; then
				filename=${linenohttp##*/}
				name=${filename%.*}
			else
				name="noName"
			fi
			incrementname "$name"
			printf "%-30s : $line\n" "$name"
			redis-cli hset webradios "$name" "$url" &> /dev/null
			makefile "$name" "$line"
		done
		rm "$file"
	fi
done

# refresh list
mpc update Webradio &> /dev/null

title -l '=' "$bar Webradio imported successfully."
