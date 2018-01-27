#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=xdac

. /srv/http/addonstitle.sh

installstart $@

getuninstall

echo -e "$bar Modify files ..."

file=/srv/http/app/templates/mpd.php
echo $file
sed -i '/This switches output/ i\
                        <button class="btn btn-primary btn-lg" style="margin: -10px 0 0 20px;" id="saveao">Save DAC</button>
' $file

installfinish $@

echo -e "$info Menu > MPD > settings > Save DAC"
title -nt "$info Reload: Click speaker icon in top bar"
