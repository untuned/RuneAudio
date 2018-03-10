function commandButton(el) {
    var dataCmd = el.data('cmd');
    var cmd;
    if (dataCmd === 'stop') {
        el.addClass('btn-primary');
        $('#play').removeClass('btn-primary');
        if ($('#section-index').length) {
            refreshTimer(0, 0, 'stop');
            window.clearInterval(GUI.currentKnob);
            $('.playlist').find('li').removeClass('active');
            $('#total').html('00:00');
            $('#total-ss').html('00:00');
        }
    }
    else if (dataCmd === 'play') {
        var state = GUI.state;
        if (state === 'play') {
            cmd = 'pause';
            if ($('#section-index').length) {
                $('#countdown-display').countdown('pause');
                $('#countdown-display-ss').countdown('pause');
            }
        } else if (state === 'pause') {
            cmd = 'play';
            if ($('#section-index').length) {
                $('#countdown-display').countdown('resume');
                $('#countdown-display-ss').countdown('resume');
            }
        } else if (state === 'stop') {
            cmd = 'play';
            if ($('#section-index').length) {
                $('#countdown-display').countdown({since: 0, compact: true, format: 'MS'});
                $('#countdown-display-ss').countdown({since: 0, compact: true, format: 'MS'});
            }
        }
        window.clearInterval(GUI.currentKnob);
        sendCmd(cmd);
        return;
    }
    else if (dataCmd === 'previous' || dataCmd === 'next') {
        if ($('#section-index').length) {
            $('#countdown-display').countdown('pause');
            $('#countdown-display-ss').countdown('pause');
            window.clearInterval(GUI.currentKnob);
        }
    }
    // step volume control
// fix: volume up/down not work on initial load/refresh
// ****************************************************************************************
    else if ( el.hasClass( 'btn-volume' ) ) {
        var vol;
        var knobvol = parseInt( $('#volume').val() );
        if ( knobvol ) GUI.volume = knobvol;
        if ( dataCmd === 'volumedn' && GUI.volume > 0 ) {
            vol = GUI.volume - 1;
            GUI.volume = vol;
        } else if ( dataCmd === 'volumeup' && GUI.volume < 100 ) {
            vol = GUI.volume + 1;
            GUI.volume = vol;
        } else if ( dataCmd === 'volumemute' ) {
            if ( knobvol !== 0 ) {
                vol = 0;
                GUI.volume = knobvol;
                var redis = { vol: { cmd: 'set', key: 'volumecurrent', value: knobvol } };
                $.post( '/redis.php', { json: JSON.stringify( redis ) } );
            } else {
            	if ( GUI.volume ) {
                	vol = GUI.volume;
                } else {
                	var redis = { 
                		vol: { cmd: 'get', key: 'volumecurrent' },
                		del: { cmd: 'del', key: 'volumecurrent' }
                };
                	$.post( '/redis.php', { json: JSON.stringify( redis ) }, function( data ) {
                		var json = JSON.parse( data );
                		vol = parseInt( json.vol );
                		$( '#volumemute' ).removeClass( 'btn-primary' );
				        sendCmd( 'setvol '+ vol );
				        $( '#volume' ).val( vol ).trigger( 'update' );
				        return;
                	} );
                }
            }
        }
        $( '#volumemute' ).toggleClass( 'btn-primary', dataCmd === 'volumemute' && vol == 0 );
        if ( vol >= 0 && vol <= 100 ) {
            sendCmd( 'setvol '+ vol );
            $( '#volume' ).val( vol ).trigger( 'update' );
        }
        return;
    }
// ****************************************************************************************
    if (el.hasClass('btn-toggle')) {
        cmd = dataCmd + (el.hasClass('btn-primary')? ' 0':' 1');
        el.toggleClass('btn-primary');
    } else {
        cmd = dataCmd;
    }
    sendCmd(cmd);
}

/*
Hammer = propagating( Hammer ); // propagating.js fix 

var $hammervolumedn = new Hammer( document.getElementById( 'volumedn' ) );
var $hammervolumemute = new Hammer( document.getElementById( 'volumemute' ) );
var $hammervolumeup = new Hammer( document.getElementById( 'volumeup' ) );

var timeoutId;
var intervalId;
var interval;
[ $hammervolumedn, $hammervolumemute, $hammervolumeup ].forEach( function( el ) {
	el.on( 'press', function( e ) {
		buttonactive = 1;
		e.stopPropagation();
		if ( el.element.id === 'volumemute' ) {
			$( '#volumemute' ).click();
			return;
		}
		timeoutId = setTimeout( volumepress( 300, el.element.id ), 500 );
	} );
} );
$( '#volumedn, #volumeup' )
	.unbind( 'mousedown' )
	.on( 'touchend mouseleave mouseout mouseup', function() {
		clearTimeout( timeoutId );
		clearInterval( intervalId );
});
function volumepress( interval, id, fast ) {
	var knobvol = parseInt( $( '#volume' ).val() );
	if ( knobvol === 0 || knobvol === 100 ) return;
	var vol = knobvol;
	var increment = ( id === 'volumeup' ) ? 1 : -1;
	var count = 0;
	intervalId = setInterval( function() {
		if ( !fast ) {
			count++;
			if ( count >= 8 ) {
				clearInterval( intervalId );
				volumepress( 50, id, 1 );
			}
		}
		vol = vol + increment;
		setvol( vol );
		$( '#volume' ).val( vol ).trigger( 'update' );
		if ( vol === 0 || vol === 100 ) clearInterval( intervalId );
	}, interval );
}
function vol_down_interval() {}
function vol_up_interval() {}
*/
