#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=back

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

echo -e "$bar Modify files ..."

file=/srv/http/app/libs/runeaudio.php
echo $file

comment -n +1 '/run/backup_'

string=$( cat <<'EOF'
        $filepath = "/srv/http/tmp/backup_".date("Y-m-d").".tar.gz";
        $cmdstring = "rm -f /srv/http/tmp/backup_* &> /dev/null; ".
            "redis-cli save; ".
            "bsdtar -czpf $filepath".
            " --exclude /etc/netctl/examples ".
            "/etc/netctl ".
            "/mnt/MPD/Webradio ".
            "/var/lib/redis/rune.rdb ".
            "/var/lib/mpd ".
            "/etc/mpd.conf ".
            "/etc/mpdscribble.conf ".
            "/etc/spop"
        ;
EOF
)
insert  '/run/backup_'

file=/srv/http/app/templates/settings.php
echo $file
	
commentH -n +6 'value="backup"'
	
string=$( cat <<'EOF'
	    <form class="form-horizontal" id="restore">
EOF
)
appendH -n +6 'value="backup"'
	
commentH 'type="file"'
	
string=$( cat <<'EOF'
                            Browse... <input name="filebackup">
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
echo $file

string=$( cat <<'EOF'
<script src="<?=$this->asset('/js/restore.js')?>"></script>
EOF
)
appendH '$'

echo -e "$bar Add new files ..."
file=/srv/http/assets/js/restore.js
echo $file
echo '
$("#restore").submit(function() {
    var formData = new FormData($(this)[0]);
    $.ajax({
        url: "../../restore.php",
        type: "POST",
        data: formData,
        cache: false,
        contentType: false,
        enctype: "multipart/form-data",
        processData: false,
        success: function (response) {
            alert(response);
        }
    });
    return false
});
' > $file

file=/srv/http/restore.php
echo $file
echo '<?php
$file = $_FILES["filebackup"];
$filename = $file["name"];
$filetmp = $file["tmp_name"];
$filedest = "/srv/http/tmp/$filename";
$filesize = filesize($filetmp);

if ($filesize === 0) die("File upload error !");

exec("rm -f /srv/http/tmp/backup_*");
if (! move_uploaded_file($filetmp, $filedest)) die("File move error !");

$restore = exec("sudo /srv/http/restore.sh $filedest; echo $?");

if ($restore == 0) {
	echo "Restored successfully.";
} else {
	echo "Restore failed !";
}
' > $file

file=/srv/http/restore.sh
echo $file
echo '#!/bin/bash

systemctl stop mpd redis
bsdtar -xpf $1 -C /
systemctl start mpd redis
mpc update Webradio
hostnamectl set-hostname $( redis-cli get hostname )
sed -i "s/opcache.enable=./opcache.enable=$( redis-cli get opcache )/" /etc/php/conf.d/opcache.ini

rm $1
' > $file

file=/etc/sudoers.d/http-backup
echo $file
echo 'http ALL=NOPASSWD: ALL' > $file

installfinish $@

title -nt "Please wait 5 seconds before continue."

systemctl restart rune_SY_wrk
