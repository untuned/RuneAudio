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
                    nameA = a.hasOwnProperty('name')?a.name:'';
                    nameB = b.hasOwnProperty('name')?b.name:'';
                } else if (querytype === 'tracks') {
                    nameA = a.hasOwnProperty('title')?a.title:'';
                    nameB = b.hasOwnProperty('title')?b.title:'';
                } else {
                    return 0;
                }
                return nameA.localeCompare(nameB);
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
                    nameA = a.hasOwnProperty('title')?a.title:'';
                    nameB = b.hasOwnProperty('title')?b.title:'';
                } else if (querytype === 'childs-stations' || querytype === 'stations') {
                    nameA = a.hasOwnProperty('name')?a.name:'';
                    nameB = b.hasOwnProperty('name')?b.name:'';
                } else {
                    return 0;
                }
                return nameA.localeCompare(nameB);
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
                    nameA = a.hasOwnProperty('dispname')?a.dispname:'';
                    nameB = b.hasOwnProperty('dispname')?b.dispname:'';
                } else {
                    return 0;
                }
                return nameA.localeCompare(nameB);
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
                    nameB = b.hasOwnProperty('genre') ? b.genre :n'';
                } else {
                    nameA = a.hasOwnProperty('directory') ? a.directory : '';
                    nameB = b.hasOwnProperty('directory') ? b.directory : '';
                }
                return nameA.localeCompare(nameB);
            });
            if (path === 'Webradio') {
                content += '<li id="webradio-add" class="db-webradio-add"><i class="fa fa-plus-circle db-icon"></i><span class="sn"><em>add new</em></span><span class="bl">add a webradio to your library</span></li>';
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
    } else if (GUI.browsemode === 'composer') {
        if (path === 'Composer') {
            breadcrumb.html(path);
        } else {
            breadcrumb.html('Composer/' + path);
        }
    } else if (GUI.browsemode === 'genre') {
        if (path === 'Genres') {
            breadcrumb.html(path);
        } else {
            breadcrumb.html('Genres/' + path);
        }
    } else {
        breadcrumb.html(path);
    }
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
