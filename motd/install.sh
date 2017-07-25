#!/bin/bash

rm $0

wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

title -l = "$bar Install Rune logo motd ..."

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/motd/uninstall_motd.sh; chmod +x uninstall_motd.sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/motd/motd.banner -P /etc

echo '#!/bin/bash
color=51
echo -e "\e[38;5;${color}m$( < /etc/motd.banner )\e[0m\n"
PS1='\''\u@\e[38;5;${color}m\h\e[0m:\W \$ '\'' # single quote only
' > /etc/profile.d/motd.sh

mv /etc/motd{,.original}

sed -i '/PS1=/ s/^/#/' /etc/bash.bashrc

echo -e "\nUninstall: ./uninstall_motd.sh"
title -nt "$info Relogin to see new Rune logo motd."
