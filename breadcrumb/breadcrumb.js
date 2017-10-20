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
                    nameA=a.title.toLowerCase(), nameB=b.title.toLowerCase();
                } else if (querytype === 'childs-stations' || querytype === 'stations') {
                    nameA=a.name.toLowerCase(), nameB=b.name.toLowerCase();
                } else {
                    return 0;
                }
                if (nameA < nameB) //sort string ascending
                    return -1;
                if (nameA > nameB)
                    return 1;
                return 0; //default return value (no sorting)
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
        if (path === '' && keyword === '') {
            renderLibraryHome();
            return;
        } else {
            $('#database-entries').removeClass('hide');
            $('#db-level-up').removeClass('hide');
            $('#home-blocks').addClass('hide');
            if (path) {
                GUI.currentpath = path;
            }
            document.getElementById('database-entries').innerHTML = '';
            if (keyword !== '') {
                var results = (data.length) ? data.length : '0';
                var s = (data.length === 1) ? '' : 's';
                $('#db-level-up').addClass('hide');
                $('#db-search-results').removeClass('hide').html('<i class="fa fa-times sx"></i><span class="visible-xs-inline">back</span><span class="hidden-xs">' + results + ' result' + s + ' for "<span class="keyword">' + keyword + '</span>"</span>');
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
            breadcrumb.html(path);
        } else {
            breadcrumb.html('Albums/' + path);
        }
    } else if (GUI.browsemode === 'artist') {
        if (path === 'Artists') {
            breadcrumb.html(path);
        } else {
            breadcrumb.html('Artists/' + path);
        }
    } else if (GUI.browsemode === 'genre') {
        if (path === 'Genres') {
            breadcrumb.html(path);
        } else {
            breadcrumb.html('Genres/' + path);
        }
    } else {
// ****************************************************************************************
// add usb directory path link
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
    }
	$( '#db-currentpath' ).removeClass( 'hide' );
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
