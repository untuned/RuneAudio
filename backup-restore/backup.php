<?php

$timestamp = date('Ymd-hi');
$filedest = "/tmp/backup_$timestamp.tar.gz";

$backup = exec("/usr/bin/sudo /srv/http/backup.sh $filedest; echo $?");

if ($backup == 1) die('Backup failed !');
echo 'Backup successfully.';
