#!/bin/bash

alias=font

uninstallstart $1

rm -rv /srv/http/assets/fonts/lato
mv -v /srv/http/assets/fonts/lato{.backup,}

uninstallfinish $1

[[ -t 1 ]] && clearcache
