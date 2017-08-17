#!/bin/bash

# import heading function
wget -qN https://raw.githubusercontent.com/rern/title_script/master/title.sh; . title.sh; rm title.sh

title -l = "$bar Uninstall Backup-Restore update ..."

if [[ ! -e /srv/http/restore.php ]]; then
    echo -e "$info Uninstall Backup-Restore update not found."
    exit
fi

rm -r /srv/http/tmp
mv -f /srv/http/app/libs/runeaudio.php{.original,}
mv -f /srv/http/app/templates/settings.php{.original,}
mv -f /srv/http/assets/js/runeui.js{.original,}
mv -f /srv/http/assets/js/runeui.min.js{.original,}
rm /srv/http/restore.* /etc/sudoers.d/sudoers

systemctl restart rune_SY_wrk

# refresh #######################################
echo -e "$bar Clear PHP OPcache ..."
curl '127.0.0.1/clear'
echo

if pgrep midori >/dev/null; then
	killall midori
	sleep 1
	xinit &>/dev/null &
	echo 'Local browser restarted.'
fi

title -l = "$bar Backup-Restore update uninstalled successfully."

rm #0
