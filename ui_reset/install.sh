#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=uire

[[ ! -e /srv/http/addonstitle.sh ]] && wget -qN --no-check-certificate https://github.com/rern/RuneAudio_Addons/raw/$branch/srv/http/addonstitle.sh -P /srv/http
. /srv/http/addonstitle.sh

title -l '=' "$bar Reset RuneUI ..."
timestart

# addo
rm -f /srv/http/assets/css/addons*
rm -f /srv/http/assets/fonts/addons.*,Inconsolata.*
rm -f /srv/http/assets/js/addons*
rm -f /srv/http/assets/js/vendor/{hammer.min.js,propagating.js}
rm -f /srv/http/addons*
rm -fr /srv/http/assets/addons
crontab -l | { cat | sed '/addonsupdate.sh/ d'; } | crontab -

# enha
rm -f /srv/http/app/templates/enhanceplayback.php
rm -f /srv/http/enhance*
rm -f /srv/http/assets/css/{enhance.css,midori.css,roundslider.min.css}
rm -f /srv/http/assets/fonts/enhance*
rm -f /srv/http/assets/img/{controls*,runelogo.svg,turntable*}
rm -f /srv/http/assets/js/enhance.js
rm -f /srv/http/assets/js/vendor/{jquery-ui.min.js,modernizr-custom.js,roundslider.min.js}
rm -f /usr/share/bootsplash/{start,reboot,shutdown}-runeaudio.png

# gpio
rm -f /root/gpio*.py
rm -f /srv/http/gpio*.php
rm -f /srv/http/assets/css/gpio*
rm -f /srv/http/assets/img/RPi3_GPIO.svg
rm -f /srv/http/assets/js/gpio*
rm -f /srv/http/assets/js/vendor/bootstrap-select-1.12.1.min.js

# lyri
rm -f /srv/http/{lyrics.php,lyricssave.php,simple_html_dom.php}
rm -f /srv/http/assets/{js/lyrics.js,css/lyrics.css}

# back
rm -f /etc/sudoers.d/http-backup
rm -f /srv/http/restore.*
rm -f /srv/http/assets/js/restore.js
rm -fr /srv/http/tmp

# font
rm -fr /srv/http/assets/fonts/lato*

#motd
rm -f /etc/motd.logo /etc/profile.d/motd.sh

version=$( redis-cli get buildversion )
if [[ $version == 20170229 ]]; then
	file=ui_reset.tar.xz
else
	file=ui_reset03.tar.xz
	# pass
	rm -f /srv/http/log*
	# spla
	systemctl disable ply-image
	systemctl enable getty@tty1.service
	rm -f /etc/systemd/system/ply-image.service
	rm -f /usr/local/bin/ply-image
	rm -fr /usr/share/ply-image
fi

wgetnc https://github.com/rern/RuneAudio/raw/$branch/ui_rest/$file
bsdtar -xvf $file -C /srv/http
rm $file

redis-cli del addons volumemute webradios pathlyrics

clearcache

timestop

title "$bar RuneUI reset succesfully."
title -nt "$info RuneUI may need a reboot."
