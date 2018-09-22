#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=paus

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

echo -e "$bar Add files ..."

file=/srv/http/assets/css/pausebutton.css
echo $file

string=$( cat <<'EOF'
.playback-controls {
    width: 240px;
}
@media (min-width: 480px) {
    #menu-top .playback-controls {
        left: 50%;
        width: 240px;
        margin: 0 0 0 -120px
    }
}
EOF
)
echo "$string" > $file

echo -e "$bar Modify files ..."

file=/srv/http/app/templates/header.php
echo $file

string=$( cat <<'EOF'
    <link rel="stylesheet" href="<?=$this->asset('/css/pausebutton.css')?>">
EOF
)
appendH 'runeui.css'

string=$( cat <<'EOF'
        <button id="pause" class="btn btn-default btn-cmd" title="Play/Pause" data-cmd="pause"><i class="fa fa-pause"></i></button>
EOF
)		
appendH 'id="play"'

file=/srv/http/assets/js/runeui.js
echo $file

comment -n +1 'function refreshState' '$(.#stop.).addClass(.btn-primary.)'

string=$( cat <<'EOF'
    if ( state === 'play' ) {
        $( '#play' ).addClass( 'btn-primary' );
        $( '#stop' ).removeClass( 'btn-primary' );
        if ( $( '#pause' ).hasClass( 'hide' ) ) {
            $( 'i', '#play' ).removeClass( 'fa fa-pause' ).addClass( 'fa fa-play' );
        } else {
            $( '#pause' ).removeClass( 'btn-primary' );
        }
    } else if ( state === 'pause' ) {
        $( '#playlist-position span' ).html( 'Not playing' );
        $( '#stop' ).removeClass( 'btn-primary' );
        if ( $( '#pause' ).hasClass( 'hide' ) ) {
            $( 'i', '#play' ).removeClass( 'fa fa-play' ).addClass( 'fa fa-pause' );
        } else {
            $( '#play' ).removeClass( 'btn-primary' );
            $( '#pause' ).addClass( 'btn-primary' );
        }
    } else if ( state === 'stop' ) {
        $( '#stop' ).addClass( 'btn-primary' );
        $( '#play, #pause' ).removeClass( 'btn-primary' );
        if ( $( '#pause' ).hasClass( 'hide' ) ) {
            $( 'i', '#play' ).removeClass( 'fa fa-pause' ).addClass( 'fa fa-play' );
        }
EOF
)
append '$(.#stop.).addClass(.btn-primary.)'

redis-cli set dev 1 &> /dev/null # avoid edit runeui.min.js

installfinish $@

restartlocalbrowser
