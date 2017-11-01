#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=libr

. /srv/http/addonstitle.sh

# uninstall webradio sorting and breadcrumb
if [[ -e /usr/local/bin/uninstall_webr.sh ]]; then
	uninstall_webr.sh
	redis-cli hdel addons webr
fi
if [[ -e /usr/local/bin/uninstall_brea.sh ]]; then
	uninstall_brea.sh
	redis-cli hdel addons brea
fi
if [[ ! -e /usr/local/bin/uninstall_enha.sh ]]; then
	title "$bar RuneUI Enhancement must be installed first."
	exit
fi
installstart $@

getuninstall

echo -e "$bar Get files ..."
wgetnc https://github.com/rern/RuneAudio/raw/master/library_browsing/libraryenha.js -P /srv/http/assets/js
wgetnc https://github.com/rern/RuneAudio/raw/master/library_browsing/libraryenha.css -P /srv/http/assets/css
# modify files
echo -e "$bar Modify files ..."
file=/srv/http/app/templates/header.php
echo $file
sed -i $'/favicon.ico/ i\
    <link rel="stylesheet" href="<?=$this->asset(\'/css/libraryenha.css\')?>">
' $file

footer=/srv/http/app/templates/footer.php
echo $footer
if ! grep -q 'musiclibrary.js' /srv/http/app/templates/footer.php; then
	echo '<script src="<?=$this->asset('"'"'/js/libraryenha.js'"'"')?>"></script>' >> $footer
fi

file=/srv/http/app/templates/playback.php
echo $file
sed -i -e '/id="db-currentpath"/ {N;N; s/^/<!--libr/; s/$/libr-->/}
' -e '/id="db-level-up"/ {
i\
            <div id="db-currentpath" class="hide">\
                <i id="db-home" class="fa fa-folder-open"></i> <span>Home</span>\
                <i id="db-up" class="fa fa-arrow-left"></i>\
				<i id="db-webradio-add" class="fa fa-plus-circle hide"></i>\
            </div>
}
' -e '/id="home-blocks"/ i\
			<ul id="db-index" class="hide">\
				<li>#</li>\
				<li>A</li>\
				<li class="half">B</li>\
				<li>C</li>\
				<li class="half">D</li>\
				<li>E</li>\
				<li class="half">F</li>\
				<li>G</li>\
				<li class="half">H</li>\
				<li>I</li>\
				<li class="half">J</li>\
				<li>K</li>\
				<li class="half">L</li>\
				<li>M</li>\
				<li class="half">N</li>\
				<li>O</li>\
				<li class="half">P</li>\
				<li>Q</li>\
				<li class="half">R</li>\
				<li>S</li>\
				<li class="half">T</li>\
				<li>U</li>\
				<li class="half">V</li>\
				<li>W</li>\
				<li class="half">X</li>\
				<li>Y</li>\
				<li class="half">Z</li>\
				<li>&nbsp</li>\
				<li>&nbsp</li>\
				<li>&nbsp</li>\
				<li>&nbsp</li>\
				<li>&nbsp</li>\
			</ul>
' -e '/id="pl-manage"/,/</div>/ {s/^/<!--libr/; s/$/libr-->/}
' -e '/id="pl-count"/ i\
            <div id="pl-manage">\
                <button id="pl-manage-list" class="btn btn-default" type="button" title="Manage playlists"><i class="fa fa-file-text-o fa-lg"></i></button>\
                <button id="pl-manage-save" class="btn btn-default" type="button" title="Save current queue as playlist" data-toggle="modal" data-target="#modal-pl-save"><i class="fa fa-save fa-lg"></i></button>\
                <button id="pl-manage-clear" class="btn btn-default" type="button" title="Clear the playing queue" data-toggle="modal" data-target="#modal-pl-clear"><i class="fa fa-trash-o fa-lg"></i></button>\
            </div>
' $file

installfinish $@
