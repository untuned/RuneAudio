#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=sort

. /srv/http/addonstitle.sh

if [[ -e /usr/local/bin/uninstall_libr.sh ]]; then
	uninstall_libr.sh
	redis-cli hdel addons libr
fi

installstart $@

getuninstall

echo -e "$bar Get files ..."
wgetnc https://github.com/rern/RuneAudio/raw/master/library_browsing/musiclibrary.js -P /srv/http/assets/js
# modify files
echo -e "$bar Modify files ..."
footer=/srv/http/app/templates/footer.php
echo $footer
if ! grep -q 'musiclibrary.js' /srv/http/app/templates/footer.php; then
	echo '<script src="<?=$this->asset('"'"'/js/musiclibrary.js'"'"')?>"></script>' >> $footer
fi

installfinish $@
