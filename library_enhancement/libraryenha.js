function populateDB(options){
    var data = options.data || '',
        path = options.path || '',
        uplevel = options.uplevel || 0,
        keyword = options.keyword || '',
        plugin = options.plugin || '',
        querytype = options.querytype || '',
        args = options.args || '',
        content = '',
        i = 0,
        row = [];

    if (plugin !== '') {
        if (plugin === 'Spotify') {
            $('#database-entries').removeClass('hide');
            $('#db-level-up').removeClass('hide');
            $('#home-blocks').addClass('hide');
            if (path) {
                GUI.currentpath = path;
            }
            document.getElementById('database-entries').innerHTML = '';
            data = (querytype === 'tracks') ? data.tracks : data.playlists;

            data.sort(function(a, b){
                if (path === 'Spotify' && querytype === '') {
                    nameA = a.hasOwnProperty('name') ? a.name : '';
                    nameB = b.hasOwnProperty('name') ? b.name : '';
                } else if (querytype === 'tracks') {
                    nameA = a.hasOwnProperty('title') ? a.title : '';
                    nameB = b.hasOwnProperty('title') ? b.title : '';
                } else {
                    return 0;
                }
// ****************************************************************************************
// replace - fix sorting
                return nameA.localeCompare(nameB);
// ****************************************************************************************
            });
            for (i = 0; (row = data[i]); i += 1) {
                content += parseResponse({
                    inputArr: row,
                    respType: 'Spotify',
                    i: i,
                    querytype: querytype,
                    inpath: args
                });
            }
            document.getElementById('database-entries').innerHTML = content;
        }
        if (plugin === 'Dirble') {
            $('#database-entries').removeClass('hide');
            $('#db-level-up').removeClass('hide');
            $('#home-blocks').addClass('hide');
            if (path) {
                if (querytype === 'search') {
                    GUI.currentpath = 'Dirble';
                } else {
                    GUI.currentpath = path;
                }
            }
            if (querytype === 'childs-stations') {
                content = document.getElementById('database-entries').innerHTML;
            } else {
                document.getElementById('database-entries').innerHTML = '';
            }            
            data.sort(function(a, b){
                if (querytype === 'childs' || querytype === 'categories') {
                    nameA = a.hasOwnProperty('title') ? a.title : '';
                    nameB = b.hasOwnProperty('title') ? b.title : '';
                } else if (querytype === 'childs-stations' || querytype === 'stations') {
                    nameA = a.hasOwnProperty('name') ? a.name : '';
                    nameB = b.hasOwnProperty('name') ? b.name : '';
                } else {
                    return 0;
                }
// ****************************************************************************************
// replace - fix sorting
                return nameA.localeCompare(nameB);
// ****************************************************************************************
            });

            for (i = 0; (row = data[i]); i += 1) {
                content += parseResponse({
                    inputArr: row,
                    respType: 'Dirble',
                    i: i,
                    querytype: querytype
                });
            }
            document.getElementById('database-entries').innerHTML = content;
        }
        if (plugin === 'Jamendo') {
            $('#database-entries').removeClass('hide');
            $('#db-level-up').removeClass('hide');
            $('#home-blocks').addClass('hide');
            if (path) {
                GUI.currentpath = path;
            }
            document.getElementById('database-entries').innerHTML = '';

            data.sort(function(a, b){
                if (path === 'Jamendo' && querytype === '') {
                    nameA = a.hasOwnProperty('dispname') ? a.dispname : '';
                    nameB = b.hasOwnProperty('dispname') ? b.dispname : '';
                } else {
                    return 0;
                }
// ****************************************************************************************
// replace - fix sorting
                return nameA.localeCompare(nameB);
// ****************************************************************************************
            });
            for (i = 0; (row = data[i]); i += 1) {
                content += parseResponse({
                    inputArr: row,
                    respType: 'Jamendo',
                    i: i,
                    querytype: querytype
                });
            }
            document.getElementById('database-entries').innerHTML = content;
        }
    } else {
    // normal MPD browsing
        if (path === '' && keyword === '') {
            renderLibraryHome();
            return;
        } else {
        // browsing
            $('#database-entries').removeClass('hide');
            $('#db-level-up').removeClass('hide');
            $('#home-blocks').addClass('hide');
            if (path) {
                GUI.currentpath = path;
            }
            document.getElementById('database-entries').innerHTML = '';
            if (keyword !== '') {
            // search results
                var results = (data.length) ? data.length : '0';
                var s = (data.length === 1) ? '' : 's';
                $('#db-level-up').addClass('hide');
                $('#db-search-results').removeClass('hide').html('<i class="fa fa-times sx"></i><span class="visible-xs-inline">back</span><span class="hidden-xs">' + results + ' result' + s + ' for "<span class="keyword">' + keyword + '</span>"</span>');
            }
            data.sort(function(a, b){
                if (path === 'Artists' || path === 'AlbumArtists'|| path === 'Various Artists') {
                    nameA = a.hasOwnProperty('artist') ? a.artist : '';
                    nameB = b.hasOwnProperty('artist') ? b.artist : '';
                } else if (path === 'Albums') {
                    nameA = a.hasOwnProperty('album') ? a.album : '';
                    nameB = b.hasOwnProperty('album') ? b.album : '';
                } else if (path === 'Webradio') {
                    nameA = a.hasOwnProperty('playlist') ? a.playlist : '';
                    nameB = b.hasOwnProperty('playlist') ? b.playlist : '';
                } else if (path === 'Genres') {
                    nameA = a.hasOwnProperty('genre') ? a.genre : '';
                    nameB = b.hasOwnProperty('genre') ? b.genre : '';
                } else {
// ****************************************************************************************
// replace - fix sorting
                    nameA = a.hasOwnProperty('directory') ? a.directory : '';
                    nameB = b.hasOwnProperty('directory') ? b.directory : '';
                }
                return nameA.localeCompare(nameB);
// ****************************************************************************************
            });
            if (path === 'Webradio') {
// ****************************************************************************************
// breadcrumb replace - modify add webradio button
				$('#db-up').addClass('hide');
				$('#db-webradio-add').removeClass('hide')
					.click(function() {
						$('#modal-webradio-add').modal();
					}
				);
            } else {
				$('#db-up').removeClass('hide');
				$('#db-webradio-add').addClass('hide');
// ****************************************************************************************
			}
            for (i = 0; (row = data[i]); i += 1) {
                content += parseResponse({
                    inputArr: row,
                    respType: 'db',
                    i: i,
                    inpath: path
                });
            }
            document.getElementById('database-entries').innerHTML = content;
        }
    }
    var breadcrumb = $('span', '#db-currentpath');
    if (GUI.browsemode === 'album') {
        if (path === 'Albums') {
            breadcrumb.html('ALBUMS');
        } else {
            breadcrumb.html('ALBUMS / ' + path);
        }
    } else if (GUI.browsemode === 'artist') {
        if (path === 'Artists') {
            breadcrumb.html('ARTISTS');
        } else {
            breadcrumb.html('ARTISTS / ' + path);
        }
    } else if (GUI.browsemode === 'genre') {
        if (path === 'Genres') {
            breadcrumb.html('GENRES');
        } else {
            breadcrumb.html('GENRES / ' + path);
        }
    } else {
// ****************************************************************************************
// breadcrumb add - library directory path link
        var folder = path.split( '/' );
        var folderPath = '';
        var folderCrumb = '';
        for ( i = 0; i < folder.length; i++ ) {
            if ( i !== 0 ) {
            	folderPath += '/';
            	folderCrumb += ' / ';
            }
            folderPath += folder[ i ];
            folderCrumb += '<a data-path="'+ folderPath +'">'+ folder[ i ] +'</a>';
        }
        breadcrumb.html( folderCrumb );
// ****************************************************************************************
    }
// ****************************************************************************************
    $( '#db-currentpath, #db-index' ).removeClass( 'hide' );
// ****************************************************************************************
    $('#db-homeSetup').addClass('hide');
	
    if (uplevel) {
        var position = GUI.currentDBpos[GUI.currentDBpos[10]];
        $('#db-' + position).addClass('active');
        customScroll('db', position, 0);
    } else {
        customScroll('db', 0, 0);
    }
    if (querytype != 'childs') {
        loadingSpinner('db', 'hide');
    }
}

// library directory path link
$( '#db-home' ).click( function() {
	renderLibraryHome();
	$( '#db-currentpath, #db-index' ).addClass( 'hide' );
} );
$( '#db-currentpath' ).on( 'click', 'a', function() {
	getDB( { path: $( this ).attr( 'data-path' ) } );
} );
$( '#db-up' ).click( function() {
	$( '#db-level-up' ).click();
	setTimeout( function() {
		if ( $( '#home-blocks' ).hasClass( 'hide' ) ) {
			$( '#db-currentpath, #db-index' ).removeClass( 'hide' );
		} else {
			$( '#db-currentpath, #db-index' ).addClass( 'hide' );
		}
	}, 200 );
} );

// index link
$( '#db-index li' ).click( function() {
	var topoffset = $( '#menu-top' ).css( 'top') === '0px' ? 80 : 40;
	var indextext = $( this ).text();
	if ( indextext === '#' ) {
		$( document ).scrollTop( 0 );
		return
	}
	if ( GUI.browsemode === 'file' ) {
		var datapatharray = $( '#database-entries li' ).attr( 'data-path' ).split('/');
		var path = datapatharray.slice( 0, -1 ).join( '/' );
		var datapathindex = path +'/'+ indextext;
	} else {
		var datapathindex = '^'+ indextext;
	}
	var matcharray = $( '#database-entries li' ).filter( function() {
		return $( this ).attr( 'data-path' ).match( new RegExp( datapathindex ) );
	} );
	if ( matcharray.length ) $( document ).scrollTop( matcharray[0].offsetTop - topoffset );
} );
// index link height
function indexheight() {
	var indexoffset = ( $( window ).width() > 500 && $( window ).height() ) > 500 ? 160 : 80
	if ( $( window ).height() > 500 ) {
		var indexline = 26;
		$( '.half' ).show();
	} else {
		var indexline = 13;
		$( '.half' ).hide();
	}
	$( '#db-index' ).css( 'line-height', ( $( window ).height() - indexoffset ) / indexline +'px' );
}
indexheight();
window.addEventListener( 'orientationchange', function() {
	setTimeout( indexheight(), 200 );
} );
