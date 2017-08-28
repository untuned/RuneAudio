<?php

$cmd = 'wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/install.sh; chmod +x install.sh; /usr/bin/sudo ./install.sh';
//$cmd = '/usr/bin/sudo /usr/local/bin/uninstall_aria.sh';

function bash($cmd) {
	while (@ ob_end_flush());

	$proc = popen("$cmd 2>&1", 'r');
	$std = '';

	echo '<pre>';
	while (!feof($proc)) {
		$std = fread($proc, 4096);
		$std = preg_replace('/.\\[.*?m/', '', $std);
		$std = preg_replace('/ \.  | i  /', '', $std);
		echo "$std";
		@ flush();
	}
	echo '</pre>';

	pclose($proc);
}

bash($cmd);
