How To
---
**Issues**  
- RuneAudio 'Backup' works but `redis-cli save` was missing before backup
- Restore with 'Upload' was disabled for pending code

**Fixes**  
- Backup:
    - exclude unnecessary `/etc/netctl/examples`
    - include `/mnt/MPD/Webradio`
    - add `redis-cli save`
- Restore:
    - remove default form event to avoid page change
    - upload file by ajax instead
    - use new php script to upload file
- Write permission:
    - http user cannot write outside `./http`
    - allow no password sudo in `/etc/sudoers.d`
    - http user cannot sudo commands directly
    - use external bash script to restore
<hr>

**modify backup**  
`/srv/http/app/libs/runeaudio.php`  
- exculde unnecessary `/etc/netctl/examples`
- include `/mnt/MPD/Webradio`
- add `redis-cli save`
```php
/*function wrk_backup($bktype)
{
    if ($bktype === 'dev') {
        $filepath = "/run/totalbackup_".date('Y-m-d').".tar.gz";
        $cmdstring = "tar -czf ".$filepath." /var/lib/mpd /boot/cmdline.txt /var/www /etc /var/lib/redis/rune.rdb";
    } else {
        $filepath = "/run/backup_".date('Y-m-d').".tar.gz";*/
        $cmdstring = "redis-cli save; ";
        $cmdstring .= "tar -czf ".$filepath." --exclude /etc/netctl/examples /mnt/MPD/Webradio /var/lib/mpd /etc/mpd.conf /var/lib/redis/rune.rdb /etc/netctl /etc/mpdscribble.conf /etc/spop";
/*    }
    sysCmd($cmdstring);
    return $filepath;
}*/
```

**modify upload**  
`/srv/http/app/templates/settings.php`  
- remove form default: method, name-value-type
- use ajax instead: add form id, enctype
```html
    <form id="restore" enctype="multipart/form-data" class="form-horizontal">
<!--<form class="form-horizontal" method="post">
    <fieldset>
            <div class="form-group">
                <label class="control-label col-sm-2">Restore player config</label>
                <div class="col-sm-10">
                    <p>
                        <span id="btn-backup-browse" class="btn btn-default btn-lg btn-file">
                            Browse... <input type="file" name="filebackup">
                        </span> 
                        <span id="backup-file"></span>
                        <span class="help-block">Restore a previously exported backup</span>
                    </p>-->
                    <button id="btn-backup-upload" class="btn btn-primary btn-lg" disabled>Restore</button>
<!--                <button id="btn-backup-upload" name="syscmd" value="restore" class="btn btn-primary btn-lg" type="submit" disabled>Upload</button>
                </div>
            </div>
		</fieldset>
    </form>-->
```
 
**add restore script**  
`/srv/http/restore.php`  
(php, http user, cannot save file outside ./http)
```php
<?php
$file = $_FILES['filebackup'];
$filename = $file['name'];
$filetmp = $file['tmp_name'];
$filedest = '/srv/http/'.$filename;
$filesize = filesize($filetmp);

if ($filesize === 0) die('File upload error !');
if (! move_uploaded_file($filetmp, $filedest)) die('File move error !');

$restore = exec("sudo /srv/http/restore.sh $filedest; echo $?");

if ($restore == 0) {
	echo 'Restored successfully.';
} else {
	echo 'Restore failed !';
}
```
 
`/srv/http/restore.sh`  
(php, http user, cannot sudo bash command directly.)
```sh
#!/bin/bash

systemctl stop mpd redis
bsdtar -xf $1 -C /
systemctl start mpd redis
mpc update Webradio
hostnamectl set-hostname $( redis-cli get hostname )
rm $1
```

**add sudoers.d**  
`/etc/sudoers/sudoers`  
```sh
http ALL=NOPASSWD: ALL
```
