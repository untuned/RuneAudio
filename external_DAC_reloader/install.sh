#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=xdac

. /srv/http/addonstitle.sh

if [[ -e /usr/local/bin/uninstall_gpio.sh ]]; then
	title "$info RuneUI GPIO already has this feature."
	exit
fi

installstart $@

getuninstall

echo -e "$bar Add files ..."

file=/srv/http/xdac.php
echo $file
echo '
<?php
$redis = new Redis(); 
$redis->pconnect( "127.0.0.1" );

if ( isset( $_GET[ "save" ] ) {
	$aogpio = $redis->get( "ao" );
	$volume = $redis->get( "volume" );
	$acards = $redis->hGetAll( "acards" );
	$mpdconf = $redis->hGetAll( "mpdconf" );
	
	$redis->set( "aogpio", $aogpio );
	$redis->set( "volumegpio", $volume );
	$redis->hMset( "acardsgpio", $acards );
	$redis->hMset( "mpdconfgpio", $mpdconf );
	
	die();
}
$aogpio = $redis->get( "aogpio" );
$volumegpio = $redis->get( "volumegpio" );
$acardsgpio = $redis->hGetAll( "acardsgpio" );
$mpdconfgpio = $redis->hGetAll( "mpdconfgpio" );

$redis->set( "ao", $aogpio );
$redis->set( "volume", $volumegpio );
$redis->hMset( "acards", $acardsgpio );
$redis->hMset( "mpdconf", $mpdconfgpio );

include( "/srv/http/app/libs/runeaudio.php" );

wrk_mpdconf( $redis, "switchao", $aogpio );
' > $file

file=/srv/http/assets/js/xdac.js
echo $file
echo '
$( "#xdac" ).click( function() {
	$.get( "/xdac.php", function() {
		info( "External DAC configuration loaded." );
	} );
} );
' > $file

echo -e "$bar Modify files ..."

file=/srv/http/app/templates/header.php
echo $file
sed -i -e '/class="home"/ a\
    <button id="xdac" class="btn btn-default btn-cmd"><i class="fa fa-volume-off fa-lg"></i></button>
' $file

file=/srv/http/app/templates/mpd.php
echo $file
sed -i -e '/This switches output/ i\
                        <a class="btn btn-primary btn-lg" style="margin: -10px 0 0 20px;" id="saveao">Save Ext. DAC</a>
' -e '$ a\
<script>\
	$( "#xdacsave" ).click( function() {\
		$.get( "/xdacsave.php?save=1", function() { );\
			info( "External DAC configuration saved." );\
		) }:\
	} );\
</script>
' $file

chmod 666 /etc/mpd.conf

installfinish $@

echo -e "$info Menu > MPD > settings > Save DAC"
title -nt "$info Reload: Click speaker icon in top bar"
