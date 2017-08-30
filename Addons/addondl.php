<?php
$result = exec('wget -qN https://github.com/rern/RuneAudio/raw/master/Addons/addons.php -O /srv/http/addons.php; echo $?');
echo $result;
