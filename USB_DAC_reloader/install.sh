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

file=/srv/http/udac.php
echo $file
echo '<?php
$redis = new Redis(); 
$redis->pconnect( "127.0.0.1" );

include( "/srv/http/app/libs/runeaudio.php" );

wrk_audioOutput($redis, "refresh");

$analog = $redis->hGet( "acards", "bcm2835 ALSA_1" );
$hdmi = $redis->hGet( "acards", "bcm2835 ALSA_2" );
$redis->hSet( "acards", "bcm2835 ALSA_1", str_replace( "hw:0,", "hw:0,0", $analog ) );
$redis->hSet( "acards", "bcm2835 ALSA_2", str_replace( "hw:0,", "hw:0,1", $hdmi ) );
' > $file

file=/srv/http/assets/js/udac.js
echo $file
echo '
$( "#acardsreload" ).click( function() {
	$.get( "/udac.php", function() {
		location.reload();
	} );
} );
' > $file

echo -e "$bar Modify files ..."

file=/srv/http/app/templates/footer.php
echo $file
sed -i '$ a\
<script src="<?=$this->asset('"'"'/js/udac.js'"'"')?>"></script>
' $file

file=/srv/http/app/templates/mpd.php
echo $file
sed -i -e '/This switches output/ i\
						<a class="btn btn-primary btn-lg" id="udac"><i class="fa fa-refresh fa-lg" style="margin-top: -10px;"></i></a>
' -e 's/id="log-level"\( name="conf\[user\]"\)/id="user"\1/
' -e 's/id="log-level"\( name="conf\[state_file\]"\)/id="state"\1/
' $file

installfinish $@

title -nt "$info Reload: Menu > MPD > refresh button (next to Audio output)"
