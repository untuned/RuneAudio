#!/bin/bash

rm $0

wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

title -l = "$bar Install Rune logo motd ..."
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/motd/uninstall_motd.sh; chmod +x uninstall_motd.sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/motd/motd.banner -P /etc
echo '#!/bin/bash
echo -e "$( < /etc/motd.banner )"
' > /etc/profile.d/motd.sh

mv /etc/motd{,.original}

echo "Uninstall: ./uninstall_motd.sh
title -nt "$info Relogin to see new Rune logo motd."
