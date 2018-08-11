#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=back

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

echo -e "$bar Modify files ..."

file=/srv/http/app/templates/settings.php

commentH -n -2 'Restore configuration'

string=$( cat <<'EOF'
    <form class="form-horizontal">
EOF
)
appendH -n -2 'Restore configuration'

commentH 'value="backup"'

string=$( cat <<'EOF'
                    <a id="backup" class="btn btn-primary btn-lg">Backup</a>
					<iframe id="download" style="display:none"></iframe>
EOF
)
appendH 'value="backup"'

commentH -n -3 'Restore player config'
	
string=$( cat <<'EOF'
	    <form class="form-horizontal" id="restore">
EOF
)
appendH -n -3 'Restore player config'
	
commentH 'type="file"'
	
string=$( cat <<'EOF'
                            Browse... <input type="file" name="filebackup">
EOF
)
appendH 'type="file"'
	
commentH 'value="restore"'
	
string=$( cat <<'EOF'
                    <button id="btn-backup-upload" class="btn btn-primary btn-lg" disabled>Restore</button>
EOF
)
appendH 'value="restore"'

file=/srv/http/app/templates/footer.php

string=$( cat <<'EOF'
<?=( $this->uri(1) === 'settings' ? '<script src="'.$this->asset('/js/backuprestore.js').'"></script>' : '' ) ?>
EOF
)
appendH '$'

echo -e "$bar Add new files ..."

dir=/srv/http/tmp
echo $dir
mkdir -p $dir

file=/srv/http/assets/js/backuprestore.js
echo $file
string=$( cat <<'EOF'
$( '#backup' ).click( function( e ) {
	$.post( '/backuprestore.php', { backup: 1 }, function( file ) {
		$( '#download' ).attr( 'src', '/tmp/'+ file );
	} );
});
$( '#restore' ).submit( function() {
    var formData = new FormData( $( this )[ 0 ] );
    $.ajax( {
        url: "../../restore.php",
        type: "POST",
        data: formData,
        cache: false,
        contentType: false,
        enctype: "multipart/form-data",
        processData: false,
        success: function( response ) {
            info( response );
        }
    });
    return false
});
EOF
)
echo "$string" > $file

file=/srv/http/backuprestore.php
echo $file

string=$( cat <<'EOF'
<?php
if ( isset( $_POST[ 'backup' ] ) ) {
	$file = exec( 'sudo /srv/http/backuprestore.sh' );
	echo basename( $file );
	exit();
}

$file = $_FILES[ 'filebackup' ];
$filename = $file[ 'name' ];
$filetmp = $file[ 'tmp_name' ];
$filedest = "/srv/http/tmp/$filename";
$filesize = filesize( $filetmp );

if ( $filesize === 0 ) die( 'File upload error !' );

exec( 'rm -f /srv/http/tmp/backup_*' );
if ( ! move_uploaded_file( $filetmp, $filedest ) ) die( 'File move error !' );

$restore = exec( 'sudo /srv/http/restore.sh $filedest; echo $?' );

if ( $restore == 0 ) {
	echo 'Restored successfully.';
} else {
	echo 'Restore failed !';
}
EOF
)
echo "$string" > $file

file=/srv/http/backuprestore.sh
echo $file
string=$( cat <<'EOF'
#!/bin/bash

if (( $# = 0 )); then #  backup
	file=/srv/http/tmp/backup_$( date +%Y%m%d ).tar.gz
	rm -f /srv/http/tmp/backup_* &> /dev/null
	redis-cli save
	bsdtar -czpf $file --exclude /etc/netctl/examples /etc/netctl /mnt/MPD/Webradio /var/lib/redis/rune.rdb /var/lib/mpd /etc/mpd.conf /etc/mpdscribble.conf /etc/spop
	
	echo $file
	exit
fi

# restore
systemctl stop mpd redis
bsdtar -xpf $1 -C /
systemctl start mpd redis
mpc update Webradio
hostnamectl set-hostname $( redis-cli get hostname )
sed -i 's/opcache.enable=./opcache.enable=$( redis-cli get opcache )/' /etc/php/conf.d/opcache.ini

rm $1
EOF
)
echo "$string" > $file

file=/etc/sudoers.d/http-backup
echo $file
echo 'http ALL=NOPASSWD: ALL' > $file

installfinish $@
