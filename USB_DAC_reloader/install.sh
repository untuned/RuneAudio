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

file=/srv/http/assets/js/udac.js
echo $file
echo '
function udacbutton() {
	if ( $( "#audio-output-interface" ).val().split( " " )[0] === "bcm2835" ) {
		$( "#udacsave" ).addClass( "disabled" )
	} else {
		$( "#udacsave" ).removeClass( "disabled" )
	}
}
if ( /\/mpd\//.test( location.pathname ) ) udacbutton();

var icon = "<i class=\"fa fa-info-circle fa-2x\"></i>";
var title = "USB DAC Reloader";
$( "#udac" ).click( function() {
	$.get( "/udac.php", function( data ) {
		if ( data === "x" ) {
			var msg = "No saved configuration.<br>( MPD setup > USB DAC Reloader > Save )"
			if ( /\/mpd\//.test( location.pathname ) === false ) {
				info( {
					  icon   : icon
					, title  : title
					, message: msg
					, ok     : function() {
						window.location.href = "/mpd/";
					}
				} );
			} else {
				info( {
					  icon   : icon
					, title  : title
					, message: msg
				} );
			}
		} else {
			new PNotify( {
				  title   : title
				, text    : "Configuration reloaded"
			} );
			if ( /\/mpd\//.test( location.pathname ) === true ) {
				setTimeout( function() {
					$( "#loader" ).removeClass( 'hide' );
					setTimeout( function() {
						location.reload();
					}, 3000 );
				}, 3000 );
			}
		}
	} );
} );
$( "#audio-output-interface" ).change( function() {
	udacbutton();
} );
$( "#udacsave" ).click( function() {
	$.get( "/udac.php?save=1", function() {
		info( {
			  icon   : icon
			, title  : title
			, message: "Configuration saved."
		} );
	} );
} );
' > $file

echo -e "$bar Modify files ..."

file=/srv/http/app/templates/header.php
echo $file
sed -i '/poweroff-modal/ i\
            <li style="cursor: pointer;"><a id="udac"><i class="fa fa-sign-out fa-rotate-270"></i> DAC Reloader</a></li>
' $file

file=/srv/http/app/templates/footer.php
echo $file
sed -i '$ a\
<script src="<?=$this->asset('"'"'/js/udac.js'"'"')?>"></script>
' $file

file=/srv/http/app/templates/mpd.php
echo $file
sed -i -e '/This switches output/{n;n;n;n; i\
            <div class="form-group"> <?php /* udac0 */?>\
                <label class="col-sm-2 control-label" for="audio-output-interface">USB DAC Reloader</label>\
                <div class="col-sm-10">\
                    <a class="btn btn-primary btn-lg" id="udacsave">Save</a>\
                    <span class="help-block">Save this output and configuration for <strong>reloading without reboot</strong>.</span>\
                </div>\
            </div> <?php /* udac1 */?>
}
' $file

chmod 666 /etc/mpd.conf

installfinish $@

echo -e "$info Menu > MPD > (setup) > USB DAC Reloader > Save"
title -nt "$info Reload: Menu > DAC Reloader"
