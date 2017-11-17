$( '#currentsong' ).click( function() {
	if ( lyrics !== '' ) {
		$fetching = 0;
		lyricsshow();
	} else {
		// wait for lyrics ready
		$fetching = 1;
		PNotify.removeAll();
		new PNotify( {
			  icon    : 'fa fa-refresh fa-spin fa-lg'
			, title   : 'Lyrics'
			, text    : 'Fetching ...'
			, hide    : false
			, addclass: 'pnotify_custom'
			, after_close: function() {
				$fetching = 0;
			}
		} );
	}
} );

lyricsshow = function() {
	$lyrics = 1;
	PNotify.removeAll();
	// need new 'pnotify.custom.min.js' with 'button', confirm', 'callback', 'css'
	new PNotify( {
		  icon    : false
		, title   : $( '#currentsong' ).text()
		, text    : lyrics +'\n\n&#8226;&#8226;&#8226;\n\n\n\n\n\n\n\n'
		, hide    : false
		, addclass: 'pnotify_lyrics pnotify_custom'
		, buttons : {
			  closer_hover: false
			, sticker     : false
		}
		, before_open: function() {
			$( '#lyricsfade' ).removeClass( 'hide' );
			$( '#menu-bottom' ).addClass( 'lyrics-menu-bottom' );
		}
		, after_close: function() {
			$( '#lyricsfade' ).addClass( 'hide' );
			$( '#menu-bottom' ).removeClass( 'lyrics-menu-bottom' );
			$( '.ui-pnotify' ).remove();
			$lyrics = 0;
		}
	} );
}

var refreshState_old = refreshState;
var $fetching = 0;
var $lyrics = 0;
var lyrics = '';
refreshState = function() {
// ****************************************************************************************
	lyrics = '';
	if ( GUI.json.currentsong.slice( 0, 3 ) != '[no' ) {
		$.get( 'lyrics.php',   
			{ artist: GUI.json.currentartist, song: GUI.json.currentsong },
			function( data ) {
				if ( data ) {
					lyrics = data;
					if ( $fetching || $lyrics ) lyricsshow();
				} else {
					PNotify.removeAll();
					new PNotify( {
						  icon    : 'fa fa-info-circle fa-lg'
						, title   : 'Lyrics'
						, text    : 'Lyrics not available.'
						, addclass: 'pnotify_custom'
					} );
				}
			}
		);
	}
	refreshState_old();
}
