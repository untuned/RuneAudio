<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>RuneAudio - Addons</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="msapplication-tap-highlight" content="no" />
    <link rel="shortcut icon" href="assets/img/favicon.ico">
	<style>
		body {
			padding: 10px 30px;
			color: #ddd;
			background: #000;
		}
		.cc {
			color: #00ffff;
			background: #00ffff;
		}
		.ky {
			color: #000;
			background: #ffff00;
		}
		.ck {
			color: #00ffff;
		}
	</style>
</head>
<body>
Addon Install ...
<pre>
<?php
//$cmd = 'wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/install.sh; chmod +x install.sh; /usr/bin/sudo ./install.sh';
//$cmd = '/usr/bin/sudo /usr/local/bin/uninstall_aria.sh';

$cmd = 'wget -qN https://github.com/rern/RuneAudio/raw/master/motd/install.sh; chmod +x install.sh; /usr/bin/sudo ./install.sh';
//$cmd = '/usr/bin/sudo /usr/local/bin/uninstall_motd.sh';

function bash($cmd) {
	while (@ ob_end_flush()); // end all output buffers if any

	$proc = popen("$cmd 2>&1", 'r');

	while (!feof($proc)) {
		$std = fread($proc, 4096);
		$std = preg_replace('/.\\[38;5;6m.\\[48;5;6m/', '<a class="cc">', $std); // bar
		$std = preg_replace('/.\\[38;5;0m.\\[48;5;3m/', '<a class="ky">', $std); // info
		$std = preg_replace('/.\\[38;5;6m.\\[48;5;0m/', '<a class="ck">', $std); // tcolor
		$std = preg_replace('/.\\[38;5;6m/', '<a class="ck">', $std); // lcolor
		$std = preg_replace('/.\\[0m/', '</a>', $std); // reset color
		echo "$std";
		@ flush();
	}

	pclose($proc);
}

bash($cmd);
?>
</pre>
</body>
</html>
