#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title -l '=' "$bar Change notification duration ..."

if [[ -e /srv/http/enhance.php ]]; then
	#sed -i "s/\(notify.delay : \)[0-9]\+$/\1$(( $1 * 1000 ))/" /srv/http/assets/js/enhancefunction.js
	sed -i "s/\(options.delay : \)[0-9]\+$/\1$(( $1 * 1000 ))/" /srv/http/assets/js/enhance.js
fi

sed -i "s/[0-9]\+\( : notify.delay\)/$(( $1 * 1000 ))\1/" /srv/http/assets/js/runeui.js
sed -i "s/[0-9]\+e3\(:notify.delay\)/${1}e3\1/" /srv/http/assets/js/runeui.min.js

redis-cli hset settings notify $1 &> /dev/null

title -nt "$info Notification duration changed to $1 seconds"
