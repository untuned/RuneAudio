#!/bin/bash

# rankmirrors.sh <SECONDS>
# mitigate download errors by enable(uncomment) and 
# rank servers in /etc/pacman.d/mirrorlist by download speed

if [[ $# -eq 0 ]]; then
	sec=3 # default 3 seconds each
elif [[ $1 =~ ^[0-9]+$ ]]; then
	sec=$1
else
	echo -e "\nUsage: rankmirrors.sh <N>"
	echo -e "Rank /etc/pacman.d/mirrorlist by download speed for N seconds from each server.\n"
	exit
fi

line=$( printf '\e[0;36m%*s\e[m\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' - )

tmpdir=/tmp/rankmirrors/
rm -rf $tmpdir && mkdir $tmpdir
list='/etc/pacman.d/mirrorlist'
tmplist=/tmp/mirrorlist
cp $list $tmplist

dlfile='armv7h/community/community.db' # download test file
# convert mirrorlist to url list
if grep -qs '# Server = ' $tmplist; then
	sed -i '/^\s*$/d
		/^# Server = /!d
		s/^# Server = //g
		s|$arch/$repo|'$dlfile'|g' $tmplist # use '|' to avoid escape '/'
		# delete blank lines and lines not start with '# Server = ', remove '# Server = '
else
	sed -i 's/^Server = //g
		s|$arch/$repo|'$dlfile'|g' $tmplist # already uncomment
fi

IFS=$'\n' read -d '' -r -a servers < $tmplist # convert list to array
echo $line
echo 'Rank mirror servers by download speed ...'
echo $line
echo 'Test' ${#servers[@]} 'servers @' $sec 'seconds:'
echo

i=0
dl_server=''
for server in ${servers[*]}; do # download from each mirror
	timeout $sec wget -q -P $tmpdir $server &
	wait
	dl=$(du -c $tmpdir | grep total | awk '{print $1}') # get downloaded amount

	server0='Server = '${servers[$i]/armv7h\/community\/community.db/\$arch\/\$repo} # for ranked mirrorlist file
	dl_server="$dl_server$dl $server0\n" # with download amount for ranking
	
	shorturl=$( sed 's/archlinux.*/../' <<< ${servers[$i]} ) # short url for output
	speed=$(expr $dl / $sec)
	((i+=1))
	printf "%3d. %-25s : %5d kB/s\n" $i $shorturl $speed
	
	rm $tmpdir* &>/dev/null & # remove downloaded file
done

rank=$( echo -e "$dl_server" | sort -k1 -n -r ) # sort by '1st column' 'as number' 'reverse order'
rankfile=$( echo -e "$rank" | cut -f2-4 -d' ' ) # keep '2nd-4th column' 'devided by space' (remove 1st column)

echo
echo -e '\e[0;36m/etc/pacman.d/mirrorlist\e[m was updated with these servers top the list:'
echo
echo -e "$rankfile" | sed -n 1,3p
echo '...'
echo

[ ! -f $list'.original' ] && cp $list $list'.original' # skip if already backup
echo -e "$rankfile" > $list
rm -rf $tmpdir
