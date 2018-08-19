#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=back

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

echo -e "$bar Modify files ..."

dir=/srv/http/tmp
echo $dir
mkdir -p $dir
#----------------------------------------------------------------------------------
file=/srv/http/app/libs/runeaudio.php
echo $file

comment -n +1 '/run/backup_'

string=$( cat <<'EOF'
        $filepath = '/srv/http/tmp/backup_'.date( 'Ymd' ).'.tar.gz';
        $cmdstring = 'rm -f /srv/http/tmp/backup_* &> /dev/null; '.
            'redis-cli save; '.
            'bsdtar -czpf $filepath '.
                '--exclude /etc/netctl/examples '.
                '/etc/netctl '.
                '/mnt/MPD/Webradio '.
                '/var/lib/redis/rune.rdb '.
                '/var/lib/mpd '.
                '/etc/mpd.conf '.
                '/etc/mpdscribble.conf '.
                '/etc/spop';
EOF
)
insert -n +1 '/run/backup_'
#----------------------------------------------------------------------------------
file=/srv/http/app/templates/settings.php
echo $file

commentH -n -3 'Restore player config'

string=$( cat <<'EOF'
    <form class="form-horizontal" id="restore">
EOF
)
appendH -n -3 'Restore player config'

commentH 'Browse...'

string=$( cat <<'EOF'
                            Browse... <input type="file" accept=".tar.gz" name="filebackup">
EOF
)
appendH 'Browse...'

commentH 'id="btn-backup-upload"'

string=$( cat <<'EOF'
                    <button id="btn-backup-upload" class="btn btn-primary btn-lg" disabled>Restore</button>
EOF
)
appendH 'id="btn-backup-upload"'
#----------------------------------------------------------------------------------
file=/srv/http/app/templates/footer.php
echo $file

[[ -e $file.backup ]] && file=$file.backup

string=$( cat <<'EOF'
<script src="<?=$this->asset('/js/restore.js')?>"></script>
EOF
)
appendH '$'
#----------------------------------------------------------------------------------

echo -e "$bar Add new files ..."

#----------------------------------------------------------------------------------
file=/srv/http/assets/js/restore.js
echo $file

string=$( cat <<'EOF'
$( '#restore' ).submit( function() {
    var formData = new FormData( $( this )[ 0 ] );
    $.ajax( {
        url: '../../restore.php',
        type: 'POST',
        data: formData,
        cache: false,
        contentType: false,
        enctype: 'multipart/form-data',
        processData: false,
        success: function ( response ) {
			info( {
				  icon    : response == 0 ? 'info-circle' : 'warning'
				, title   : 'Restore Settings' 
				, message : 'Settings restored '+ response == 0 ? 'successfully.' : 'failed.'
			} );
        }
    });
    return false
} );
$( '#btn-backup-upload' ).click( function() {
	$( '#restore' ).submit();
} );
EOF
)
echo "$string" > $file
#----------------------------------------------------------------------------------
file=/srv/http/restore.php
echo $file

string=$( cat <<'EOF'
<?php
$file = $_FILES[ 'filebackup' ];
$filename = $file[ 'name' ];
$filetmp = $file[ 'tmp_name' ];
$filedest = '/srv/http/tmp/$filename';
$filesize = filesize( $filetmp );

if ( !$filesize ) die( '-1' );

exec( 'rm -f /srv/http/tmp/backup_*' );
if ( ! move_uploaded_file( $filetmp, $filedest ) ) die( 'File move error !' );

echo exec( 'sudo /srv/http/restore.sh "$filedest"; echo $?' );
EOF
)
echo "$string" > $file
#----------------------------------------------------------------------------------
file=/srv/http/restore.sh
echo $file

string=$( cat <<'EOF'
#!/bin/bash

systemctl stop mpd redis
bsdtar -xpf "$1" -C /
rm "$1"
systemctl start mpd redis
mpc update Webradio
hostnamectl set-hostname $( redis-cli get hostname )
sed -i "s/opcache.enable=./opcache.enable=$( redis-cli get opcache )/" /etc/php/conf.d/opcache.ini
EOF
)
echo "$string" > $file
#----------------------------------------------------------------------------------
file=/etc/sudoers.d/http-backup
echo $file

string=$( cat <<'EOF'
http ALL=NOPASSWD: ALL
EOF
)
echo "$string" > $file
#----------------------------------------------------------------------------------
chmod 755 /srv/http/restore.* /srv/http/tmp
chown http:http /srv/http/restore.* /srv/http/tmp

installfinish $@

title -nt "Please wait 5 seconds before continue."

systemctl restart rune_SY_wrk
