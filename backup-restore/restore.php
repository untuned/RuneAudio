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
