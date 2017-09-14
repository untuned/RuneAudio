#!/bin/bash

# required variables
alias=back

# import heading function
wget -qN https://github.com/rern/RuneAudio_Addons/raw/master/title.sh; . title.sh; rm title.sh

installstart

wgetnc https://github.com/rern/RuneAudio/raw/master/backup-restore/uninstall_back.sh -P /usr/local/bin
chmod +x /usr/local/bin/uninstall_back.sh

echo -e "$bar Modify files ..."
dir=/srv/http/tmp
echo $dir
mkdir -p $dir

file=/srv/http/app/libs/runeaudio.php
if ! grep -q 'bsdtar -czpf' $file; then
echo $file
sed -i -e '\|/run/backup_|,+1 s|^|//|
' -e '\|/run/backup_| i\
        $filepath = "/srv/http/tmp/backup_".date("Y-m-d").".tar.gz";\
        $cmdstring = "rm -f /srv/http/tmp/backup_* &> /dev/null; ".\
            "redis-cli save; ".\
            "bsdtar -czpf $filepath".\
                " --exclude /etc/netctl/examples ".\
                "/etc/netctl ".\
                "/mnt/MPD/Webradio ".\
                "/var/lib/redis/rune.rdb ".\
                "/var/lib/mpd ".\
                "/etc/mpd.conf ".\
                "/etc/mpdscribble.conf ".\
                "/etc/spop"\
        ;
' $file
fi

file=/srv/http/app/templates/settings.php
if ! grep -q 'filebackup' $file; then
echo $file
sed -i -e '/value="backup"/ {n;n;n;n;n;n; s/method="post"/id="restore"/}
' -e 's/type="file"/& name="filebackup"/
' -e'/value="restore"/ s/name="syscmd" value="restore" //; s/type="submit" disabled>Upload/disabled>Restore/
' $file
fi

file=/srv/http/app/templates/footer.php
if ! grep -q 'restore.js' $file; then
	echo $file
	echo '<script src="<?=$this->asset('\''/js/restore.js'\'')?>"></script>' >> $file
fi

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

chmod 755 /srv/http/restore.* /srv/http/tmp
chown http:http /srv/http/restore.* /srv/http/tmp

installfinish $1

title -nt "$info Refresh browser before use."

[[ -t 1 ]] && clearcache

systemctl restart rune_SY_wrk
