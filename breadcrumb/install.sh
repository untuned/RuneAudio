#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=brea

. /srv/http/addonstitle.sh

installstart $@

getuninstall

wgetnc https://github.com/rern/RuneAudio/raw/master/breadcrumb/breadcrumb.js -P /srv/http/assets/js
chown http:http /srv/http/assets/js/breadcrumb.js

echo -e "$bar Modify files ..."

file=/srv/http/app/templates/footer.php
echo $file
echo '<script src="<?=$this->asset('"'"'/js/breadcrumb.js'"'"')?>"></script>' >> $file

file=/srv/http/app/templates/playback.php
echo $file
sed -i -e '/id="db-currentpath/,/<\/div>/ s/^/<!--enh/; s/$/-->/
' -e '/id="db-level-up"/ {
s/^/<!--brea/
s/$/brea-->/
i\
            <div id="db-currentpath" class="hide">\
                <i id="db-home" class="fa fa-folder-open"></i> <span>Home</span>\
                <i id="db-up" class="fa fa-arrow-left"></i>\
            </div>
}
' -e '/db-currentpath/ {N;N; s/^/<!--brea/; s/$/brea-->/}
}
' $file

installfinish $@
