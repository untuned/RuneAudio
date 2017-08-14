**modify upload**  
`/srv/http/app/templates/settings.php`  
```html
<!--    <form class="form-horizontal" method="post">-->
    <form class="form-horizontal" method="post" action="../../upload.php">
        <fieldset>
            <div class="form-group">
                <label class="control-label col-sm-2">Restore player config</label>
                <div class="col-sm-10">
                    <p>
                        <span id="btn-backup-browse" class="btn btn-default btn-lg btn-file">
                            Browse... <input type="file" name="fileToUpload">
                        </span> 
                        <span id="backup-file"></span>
                        <span class="help-block">Restore a previously exported backup</span>
                    </p>
<!--                    <button id="btn-backup-upload" name="syscmd" value="restore" class="btn btn-primary btn-lg" type="submit" disabled>Upload</button>-->
                    <input type="submit" id="restore" class="btn btn-primary btn-lg" value="Restore">
                </div>
            </div>
		</fieldset>
    </form>
```
 
**add restore files**  
`/srv/http/restore.php`  
```php
<?php
$file = $_FILES['filebackup'];
$filename = $file['name'];
$filetmp = $file['tmp_name'];
$filedest = '/srv/http/'.$filename;
$filesize = filesize($filetmp);

echo '<br>name = '.$filename;
echo '<br>tmp_name = '.$filetmp;
echo '<br>dest = '.$filedest;
echo '<br>size = '.$filesize;
echo '<br>';

if ($filesize === 0) die('File upload error !');
if (! move_uploaded_file($filetmp, $filedest)) die('File move error !');

$restore = exec("sudo /srv/http/restore.sh $filedest; echo $?");

if ($restore == 1) die('Restore failed !');
```
 
`/srv/http/restore.sh`  
(php cannot sudo bash command directly.)
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
