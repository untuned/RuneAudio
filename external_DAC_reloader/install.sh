#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=xdac

. /srv/http/addonstitle.sh

installstart $@

getuninstall

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
		$.get( "/xdacsave.php", function() { );\
			info( "External DAC configuration saved." );\
		) }:\
	} );\
</script>
' $file

installfinish $@

echo -e "$info Menu > MPD > settings > Save DAC"
title -nt "$info Reload: Click speaker icon in top bar"
