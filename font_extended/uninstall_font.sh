#!/bin/bash

# required variables
alias=font
title='Fonts - Extended Characters'

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

uninstallstart $1

rm -rv /srv/http/assets/fonts/lato
mv -v /srv/http/assets/fonts/lato{.backup,}

uninstallfinish $1

clearcache
