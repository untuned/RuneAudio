#!/bin/bash

# install.sh

# fix restore settings issue
# must 'systemctl restart rune_SY_wrk' after modify
# or menu > development > restart rune_SY_wrk

mkdir -p /srv/http/tmp
chown http:http /srv/http/tmp

sed -i -e '\|/run/backup_|,+1 s|^|//|
' -e '\|/run/backup_| a\
    \$filepath = "/srv/http/tmp/backup_".date("Y-m-d").".tar.gz";\
    \$cmdstring = "rm -f /srv/http/tmp/backup_\* &> /dev/null; "\.\
        "redis-cli save; "\.\
        "tar -czf \$filepath"\.\
            " --exclude /etc/netctl/examples "\.\
            "/etc/netctl "\.\
            "/mnt/MPD/Webradio "\.\
            "/var/lib/redis/rune\.rdb "\.\
            "/var/lib/mpd "\.\
            "/etc/mpd\.conf "\.\
            "/etc/mpdscribble\.conf "\.\
            "/etc/spop"\
    ;
' /srv/http/app/libs/runeaudio.php

sed -i -e '/value="backup"/ {n;n;n;n;n;n; s/method="post"/id="restore"/}
' -e 's/type="file"/& name="filebackup"/
' -e'/value="restore"/ s/name="syscmd" value="restore" //; s/type="submit" disabled>Upload/disabled>Restore/
' /srv/http/app/templates/settings.php

jsrestore="
$('#restore').submit(function() {
	var formData = new FormData($(this)[0]);
	$.ajax({
		url: '../../restore.php',
		type: 'POST',
		data: formData,
		cache: false,
		contentType: false,
		enctype: 'multipart/form-data',
		processData: false,
		success: function (response) {
			alert(response);
		}
	});
	return false
});
" 
echo "$jsrestore" >> /srv/http/assets/js/runeui.js
echo "$jsrestore" >> /srv/http/assets/js/runeui.min.js

echo '<?php
$file = $_FILES["filebackup"];
$filename = $file["name"];
$filetmp = $file["tmp_name"];
$filedest = "/srv/http/tmp/$filename";
$filesize = filesize($filetmp);

if ($filesize === 0) die("File upload error !");
if (! move_uploaded_file($filetmp, $filedest)) die("File move error !");

$restore = exec("sudo /srv/http/restore.sh $filedest; echo $?");

if ($restore == 0) {
	echo "Restored successfully.";
} else {
	echo "Restore failed !";
}
' > /srv/http/restore.php

echo '#!/bin/bash

systemctl stop mpd redis
bsdtar -xpf $1 -C /
systemctl start mpd redis
mpc update Webradio
hostnamectl set-hostname $( redis-cli get hostname )
rm $1
' > /srv/http/restore.sh

echo 'http ALL=NOPASSWD: ALL' > /etc/sudoers.d/sudoers
chmod 755 -R /etc/sudoers.d/
