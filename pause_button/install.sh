#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=paus

. /srv/http/addonstitle.sh

if [[ -e /usr/local/bin/uninstall_enha.sh ]]; then
	title "$info RuneUI Enhancement already has this feature."
	exit
fi

installstart $@

getuninstall

echo -e "$bar Modify files ..."

file=/srv/http/app/templates/header.php
echo $file
sed -i '/id="play"/ a\
        <button id="pause" class="btn btn-default btn-cmd" title="Play/Pause" data-cmd="pause"><i class="fa fa-pause"></i></button>
' $file

file=/srv/http/assets/js/runeui.js
echo $file
sed -i -e '/state === .play./ s|^|/*paus|
' -e '/#stop.).addClass/ {
s|$|paus*/|
a\
    if ( state === "play" ) { // paus0\
        $( "#play" ).addClass( "btn-primary" );\
        $( "#stop" ).removeClass( "btn-primary" );\
        if ( $( "#pause" ).hasClass( "hide" ) ) {\
            $( "i", "#play" ).removeClass( "fa fa-pause" ).addClass( "fa fa-play" );\
        } else {\
            $( "#pause" ).removeClass( "btn-primary" );\
        }\
    } else if ( state === "pause" ) {\
        $( "#playlist-position span" ).html( "Not playing" );\
        $( "#stop" ).removeClass( "btn-primary" );\
        if ( $( "#pause" ).hasClass( "hide" ) ) {\
            $( "i", "#play" ).removeClass( "fa fa-play" ).addClass( "fa fa-pause" );\
        } else {\
            $( "#play" ).removeClass( "btn-primary" );\
            $( "#pause" ).addClass( "btn-primary" );\
        }\
    } else if ( state === "stop" ) {\
        $( "#stop" ).addClass( "btn-primary" );\
        $( "#play, #pause" ).removeClass( "btn-primary" );\
        if ( $( "#pause" ).hasClass( "hide" ) ) {\
            $( "i", "#play" ).removeClass( "fa fa-pause" ).addClass( "fa fa-play" );\
        } // paus1
}
' $file

redis-cli set dev 1 &> /dev/null

installfinish $@
