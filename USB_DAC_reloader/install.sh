#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=udac

. /srv/http/addonstitle.sh

if [[ -e /usr/local/bin/uninstall_gpio.sh ]]; then
	title "$info RuneUI GPIO already has this feature."
	exit
fi

installstart $@

getuninstall

echo -e "$bar Add files ..."

file=/srv/http/acardsreload.php
echo $file
echo '<?php
$redis = new Redis(); 
$redis->pconnect( "127.0.0.1" );

include( '/srv/http/app/libs/acardsreload.php' );

wrk_audioOutput($redis, 'refresh');
' > $file

file=/srv/http/assets/js/acardsreload.js
echo $file
echo '
$( '#acardsreload' ).click( function() {
	$.get( '/dacrefresh.php', function() {
		location.reload();
	} );
} );
' > $file

echo -e "$bar Modify files ..."

file=/srv/http/app/templates/footer.php
echo $file
sed -i '$ a\
<script src="<?=$this->asset('"'"'/js/acardsreload.js'"'"')?>"></script>
' $file

file=/srv/http/app/templates/mpd.php
echo $file
sed -i -e '/This switches output/ i\
						<a class="btn btn-primary btn-lg" id="acardsreload"><i class="fa fa-refresh fa-lg"></i></a>
' -e 's/id="log-level"\( name="conf\[user\]"\)/id="user"\1/
' -e 's/id="log-level"\( name="conf\[state_file\]"\)/id="state"\1/
' $file

installfinish $@

title -nt "$info Reload: Menu > MPD > refresh button (next to Audio output)"
