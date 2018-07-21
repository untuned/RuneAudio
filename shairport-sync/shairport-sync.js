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
	var total = converthms( ( time[ 2 ] - time[ 1 ] ) / 44100 );
	var elapsed = converthms( ( time[ 0 ] - time[ 1 ] ) / 44100 );

//function displayairplay() {
	$( '.playback-controls' ).css( 'visibility', 'hidden' );
	$( '#divartist, #divsong, #divalbum' ).removeClass( 'scroll-left' );
	$( '#playlist-position span, #format-bitrate, #total' ).html( '&nbsp;' );
	$( '#currentartist' ).html( artist );
	$( '#currentsong' ).html( song );
	$( '#currentalbum' ).html( album );
	var imgcode = coverart.charAt[ 0 ];
	var imgtype = { '/': 'jpg', 'i': 'png', 'R': 'gif' };
	$( '#cover-art' ).css( {
		  'background-image': 'url("data:image/'+ imgtype[ imgcode ] +';base64,'+ coverart +'")'
		, 'border-radius': 0
	} );
	scrolltext();
	$( '#menu-top, #menu-bottom' ).toggleClass( 'hide', !display.bar );
	$( '#playback-row' ).removeClass( 'hide' );
	$( '#imode i, #coverartoverlay, #volume-knob, #play-group, #share-group, #vol-group' ).addClass( 'hide' );
	$( '#playsource-mpd' ).addClass( 'inactive' );
	$( '#playsource-airplay' ).removeClass( 'inactive' );
	$( '#elapsed, #total' ).html( '&nbsp;' );
	$( '#time-knob' ).toggleClass( 'hide', !display.time );
	if ( display.time ) {
		$( '#time-knob, #play-group, #coverart, #share-group' ).css( 'width', '45%' );
		clearInterval( GUI.currentKnob );
		clearInterval( GUI.countdown );
		$( '#time' ).roundSlider( 'setValue', 0 );
		$( '#elapsed' ).css( 'color', '#e0e7ee' );
		$( '#total' ).text( '' );
		$( '#iplayer' ).addClass( 'fa-airplay' ).removeClass( 'hide' );
		var elapsed = 0;
		GUI.countdown = setInterval( function() {
			elapsed++
			mmss = converthms( elapsed );
			$( '#elapsed' ).text( mmss );
		}, 1000 );
	} else {
		$( '#coverart, #share-group' ).css( 'width', '60%' );
	}
//}
};
pushstreamAirplay.connect();
