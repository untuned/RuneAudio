#!/bin/bash

alias=font

. /srv/http/addonstitle.sh

uninstallstart $@

rm -rv /srv/http/assets/fonts/lato
mv -v /srv/http/assets/fonts/lato{.backup,}

uninstallfinish $@

restartlocalbrowser
