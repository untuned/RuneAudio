#!/bin/bash

. /srv/http/addonstitle.sh

sed -i "s/[0-9]000\( : notify.delay\)/$(( $1 * 1000 ))\1/" /srv/http/assets/js/runeui.js
sed -i "s/[0-9]e3\(:notify.delay\)/${1}e3\1/" /srv/http/assets/js/runeui.min.js

title -l '=' "$bar Notification duration changed to $1 seconds"
