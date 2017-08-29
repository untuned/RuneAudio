#!/bin/bash

# install.sh

# addons menu for web based installation

rm $0

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

title -l = "$bar Install Addons menu ..."

if grep -q 'Addons' /srv/http/app/templates/header.php; then
    echo -e "$info Already installed."
    exit
fi

wgetnc https://github.com/rern/RuneAudio/raw/master/Addons/uninstall_addo.sh -P /usr/local/bin
chmod +x /usr/local/bin/uninstall_addo.sh
