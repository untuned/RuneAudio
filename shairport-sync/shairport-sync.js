var pushstreamAirplay = new PushStream( {
	host: window.location.hostname,
	port: window.location.port,
	modes: GUI.mode
} );
pushstreamAirplay.addChannel( 'airplay' );
pushstreamAirplay.onmessage = function( status ) { // on receive broadcast
	$( '#menu-top, #menu-bottom' ).toggleClass( 'hide', !display.bar );
	if ( display.bar ) $( '.playback-controls' ).css( 'visibility', 'hidden' );
	
	$( '#divartist, #divsong, #divalbum' ).removeClass( 'scroll-left' );
	$( '#playlist-position span, #format-bitrate, #total' ).html( '&nbsp;' );
	$( '#currentartist' ).html( status[ 'artist' ] );
	$( '#currentsong' ).html( status[ 'song'] );
	$( '#currentalbum' ).html( status[ 'album'] );
	scrolltext();
	
	$( '#cover-art' ).css( {
		  'background-image': 'url("'+ status[ 'cover' ] +'")'
		, 'border-radius': 0
	} );
	
	$( '#imode i, #coverartoverlay, #volume-knob, #play-group, #share-group, #vol-group' ).addClass( 'hide' );
	$( '#elapsed, #total' ).html( '&nbsp;' );
	$( '#time-knob' ).toggleClass( 'hide', !display.time );
	if ( display.time ) {
		$( '#time-knob, #play-group, #coverart, #share-group' ).css( 'width', '45%' );
		clearInterval( GUI.currentKnob );
		clearInterval( GUI.countdown );
		var elapsed = status[ 'elapsed' ];
		var time = status[ 'time' ];
		var position = Math.round( elapsed / time * 1000 );
		$( '#elapsed' ).text( converthms( elapsed ) ).css( 'color', '#e0e7ee' );
		$( '#total' ).text( converthms( time ) );
		GUI.currentKnob = setInterval( function() {
			position = position + 1;
			if ( position === 1000 ) {
				clearInterval( GUI.currentKnob );
				clearInterval( GUI.countdown );
				$( '#elapsed' ).text( '' );
			}
			$( '#time' ).roundSlider( 'setValue', position );
		}, time );
		
		GUI.countdown = setInterval( function() {
			elapsed++
			mmss = converthms( elapsed );
			$( '#elapsed' ).text( mmss );
		}, 1000 );
		$( '#iplayer' ).addClass( 'fa-airplay' ).removeClass( 'hide' );
		
		$( '#playback-row' ).removeClass( 'hide' );
		$( '#playsource-mpd' ).addClass( 'inactive' );
		$( '#playsource-airplay' ).removeClass( 'inactive' );
	} else {
		$( '#coverart, #share-group' ).css( 'width', '60%' );
		clearInterval( GUI.currentKnob );
		clearInterval( GUI.countdown );
	}
};
pushstreamAirplay.connect();
