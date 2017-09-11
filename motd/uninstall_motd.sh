#!/bin/bash

wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

if [[ ! -e /etc/motd.logo ]]; then
  echo -e "$info Rune logo motd not found."
  exit 1
fi

type=Uninstall
[[ ${@:$#} == -u ]] && update=1; type=Update

title -l = "$bar $type Rune logo motd ..."

echo -e "$bar Restore files ..."

mv -v /etc/motd{.original,}
rm -v /etc/motd.logo /etc/profile.d/motd.sh

file=/etc/bash.bashrc
echo $file
sed -i -e '/^PS1=/ d
' -e '/^#PS1=/ s/^#//
' $file

redis-cli hdel addons motd &> /dev/null

title -l = "$bar Rune logo motd uninstalled successfully."
[[ ! $update ]] && title -nt "\n$info Relogin to see original motd."

rm $0
