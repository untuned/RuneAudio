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
echo '<?php
$redis = new Redis(); 
$redis->pconnect( "127.0.0.1" );

if ( isset( $_GET[ "save" ] ) ) {
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
if ( !$aogpio ) die( "x" );

$volumegpio = $redis->get( "volumegpio" );
$acardsgpio = $redis->hGetAll( "acardsgpio" );
$mpdconfgpio = $redis->hGetAll( "mpdconfgpio" );

$redis->set( "ao", $aogpio );
$redis->set( "volume", $volumegpio );
$redis->hMset( "acards", $acardsgpio );
$redis->hMset( "mpdconf", $mpdconfgpio );

include( "/srv/http/app/libs/runeaudio.php" );

wrk_mpdconf( $redis, "switchao", $aogpio );
wrk_mpdconf( $redis, "restart" );
' > $file

file=/srv/http/assets/js/xdac.js
echo $file
echo '
function xdacbutton() {
	if ( $( "#audio-output-interface" ).val().split( " " )[0] === "bcm2835" ) {
		$( "#xdacsave" ).addClass( "disabled" )
	} else {
		$( "#xdacsave" ).removeClass( "disabled" )
	}
}
if ( /\/mpd\//.test( location.pathname ) ) xdacbutton();

$( "#xdac" ).click( function() {
	$.get( "/xdac.php", function( data ) {
		if ( data === "x" ) {
			info( {
				  icon   : "<i class=\"fa fa-info-circle fa-2x\"></i>"
				, title  : "DAC Reloader"
				, message: "No saved configuration.<br>"
						+"( MPD setup > Save )"
				, ok     : function() {
					window.location.href = "/mpd/";
				}
			} );
		} else {
			new PNotify( {
				  title   : "DAC Reloader"
				, text    : "Configuration reloaded"
			} );
		}
	} );
} );
$( "#audio-output-interface" ).change( function() {
	xdacbutton();
} );
$( "#xdacsave" ).click( function() {
	$.get( "/xdac.php?save=1", function() {
		info( {
			  icon   : "<i class=\"fa fa-info-circle fa-2x\"></i>"
			, title  : "DAC Reloader"
			, message: "Configuration saved."
		} );
	} );
} );
' > $file

echo -e "$bar Modify files ..."

file=/srv/http/app/templates/header.php
echo $file
sed -i '/poweroff-modal/ i\
            <li style="cursor: pointer;"><a id="xdac"><i class="fa fa-sign-out fa-rotate-270"></i> DAC Reloader</a></li>
' $file

file=/srv/http/app/templates/footer.php
echo $file
sed -i '$ a\
<script src="<?=$this->asset('"'"'/js/xdac.js'"'"')?>"></script>
' $file

file=/srv/http/app/templates/mpd.php
echo $file
sed -i -e '/This switches output/{n;n;n; i\
                <label class="col-sm-2 control-label" for="audio-output-interface">Ext. Dac Reloader</label>\
                <div class="col-sm-10">\
                    <a class="btn btn-primary btn-lg" id="xdacsave">Save</a>\
                    <span class="help-block">Save this output and configuration for <strong>reloading without reboot</strong>.</span>\
                </div>
}
' $file

chmod 666 /etc/mpd.conf

installfinish $@

echo -e "$info Menu > MPD > (setup) > Save Ext. DAC"
title -nt "$info Reload: Menu > DAC Reloader"
