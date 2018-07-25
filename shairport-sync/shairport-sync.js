function displayairplay() {
	$( '.playback-controls' ).css( 'visibility', 'hidden' );
	$( '#divartist, #divsong, #divalbum' ).removeClass( 'scroll-left' );
	$( '#playlist-position span, #format-bitrate, #total' ).html( '&nbsp;' );
	$( '#currentartist' ).html( GUI.json.currentartist );
	$( '#currentsong' ).html( GUI.json.currentsong );
	$( '#currentalbum' ).html( GUI.json.currentalbum );
	$( '#cover-art' ).css( {
		  'background-image': 'url("'+ GUI.json.cover +'")'
		, 'border-radius': 0
	} );
	scrolltext();
	$( '#menu-top, #menu-bottom' ).toggleClass( 'hide', !display.bar );
	$( '#playback-row' ).removeClass( 'hide' );
	$( '#time-knob' ).toggleClass( 'hide', !display.time );
	$( '#imode i, #coverartoverlay, #volume-knob, #play-group, #share-group, #vol-group' ).addClass( 'hide' );
	$( '#playsource-mpd' ).addClass( 'inactive' );
	$( '#playsource-airplay' ).removeClass( 'inactive' );
	if ( display.time ) {
		$( '#time-knob, #play-group, #coverart, #share-group' ).css( 'width', '45%' );
		clearInterval( GUI.currentKnob );
		clearInterval( GUI.countdown );
		var elapsed = GUI.json.elapsed;
		var time = GUI.json.time';
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
		clearInterval( GUI.currentKnob );
		clearInterval( GUI.countdown );
		$( '#coverart, #share-group' ).css( 'width', '60%' );
	}
}

var pushstreamAirplay = new PushStream( {
	host: window.location.hostname,
	port: window.location.port,
	modes: GUI.mode
} );
pushstreamAirplay.addChannel( 'airplay' );
pushstreamAirplay.onmessage = function( data ) {
	GUI.json = JSON.parse( data );
	displayairplay;
}
pushstreamAirplay.connect();
