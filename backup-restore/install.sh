#!/bin/bash

# install.sh

# fix restore settings

rm $0

# import heading function
wget -qN https://raw.githubusercontent.com/rern/title_script/master/title.sh; . title.sh; rm title.sh

title -l = "$bar Install Backup-Restore update ..."

if [[ -e /srv/http/restore.php ]]; then
    echo -e "$info Already installed."
    exit
fi

wget -qN --show-progress https://raw.githubusercontent.com/rern/RuneAudio/master/backup-restore/uninstall_back.sh; chmod +x uninstall_back.sh

dir=/srv/http/tmp
echo $dir
mkdir -p $dir

file=/srv/http/app/libs/runeaudio.php
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

systemctl restart rune_SY_wrk

file=/srv/http/app/templates/settings.php
echo $file
sed -i -e '/value="backup"/ {n;n;n;n;n;n; s/method="post"/id="restore"/}
' -e 's/type="file"/& name="filebackup"/
' -e'/value="restore"/ s/name="syscmd" value="restore" //; s/type="submit" disabled>Upload/disabled>Restore/
' $file

file=/srv/http/assets/js/runeui.js
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
' >> $file

file=/srv/http/assets/js/runeui.min.js
echo $file
echo '$("#restore").submit(function(){var t=new FormData($(this)[0]);return $.ajax({url:"../../restore.php",type:"POST",data:t,cache:!1,contentType:!1,enctype:"multipart/form-data",processData:!1,success:function(t){alert(t)}}),!1});
' >> $file

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
rm $1
' > $file

file=/etc/sudoers.d/sudoers
echo $file
echo 'http ALL=NOPASSWD: ALL' > $file

chmod 755 /etc/sudoers.d/sudoers /srv/http/restore.* /srv/http/tmp
chown http:http /srv/http/restore.* /srv/http/tmp

echo -e "$bar Clear PHP OPcache ..."
curl '127.0.0.1/clear'
echo

title -l = "$bar Backup-Restore update installed successfully."
echo 'Uninstall: ./uninstall_back.sh'
title -nt "$info Refresh browser before use."
