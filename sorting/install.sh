#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=sort

. /srv/http/addonstitle.sh

if [[ -e /usr/local/bin/uninstall_webr.sh ]]; then
	uninstall_webr.sh
	redis-cli hdel addons webr
fi

installstart $@

getuninstall

echo -e "$bar Get files ..."
wgetnc https://github.com/rern/RuneAudio/raw/master/sorting/sorting.js -P /srv/http/assets/js
# modify files
footer=/srv/http/app/templates/footer.php
echo $footer
if ! grep -q 'sorting.js' /srv/http/app/templates/footer.php; then
	echo '<script src="<?=$this->asset('"'"'/js/sorting.js'"'"')?>"></script>' >> $footer
fi

installfinish $@
