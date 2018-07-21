var pushstreamAirplay = new PushStream( {
	host: window.location.hostname,
	port: window.location.port,
	modes: GUI.mode
} );
pushstreamAirplay.addChannel( 'airplay' );
pushstreamAirplay.onmessage = function( status ) { // on receive broadcast
	var status = status[ 0 ];
	var artist = atob( status[ '61736172' ] ); // arar = string from hex 61736172
	var song = atob( status[ '6d696e6d' ] );  // minm
	var album = atob( status[ '6173616c' ] );  // asal
	var time = atob( status[ '70726772' ] );   // prgr
	var coverart = status[ '50494354' ];       // PICT - base64 string
	var time = time.split( '/' );
	var total = Math.round( ( time[ 2 ] - time[ 1 ] ) / 44100 );
	var elapsed = Math.round( ( time[ 0 ] - time[ 1 ] ) / 44100 );

//function displayairplay() {
	$( '#menu-top, #menu-bottom' ).toggleClass( 'hide', !display.bar );
	if ( display.bar ) $( '.playback-controls' ).css( 'visibility', 'hidden' );
	
	$( '#divartist, #divsong, #divalbum' ).removeClass( 'scroll-left' );
	$( '#playlist-position span, #format-bitrate, #total' ).html( '&nbsp;' );
	$( '#currentartist' ).html( artist );
	$( '#currentsong' ).html( song );
	$( '#currentalbum' ).html( album );
	scrolltext();
	
	var imgcode = coverart.charAt[ 0 ];
	var imgtype = { '/': 'jpg', 'i': 'png', 'R': 'gif' };
	$( '#cover-art' ).css( {
		  'background-image': 'url("data:image/'+ imgtype[ imgcode ] +';base64,'+ coverart +'")'
		, 'border-radius': 0
	} );
	
	$( '#imode i, #coverartoverlay, #volume-knob, #play-group, #share-group, #vol-group' ).addClass( 'hide' );
	$( '#elapsed, #total' ).html( '&nbsp;' );
	$( '#time-knob' ).toggleClass( 'hide', !display.time );
	if ( display.time ) {
		$( '#time-knob, #play-group, #coverart, #share-group' ).css( 'width', '45%' );
		clearInterval( GUI.currentKnob );
		clearInterval( GUI.countdown );
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
	}
//}
};
pushstreamAirplay.connect();
