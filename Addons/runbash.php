<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>RuneAudio - Addon Install</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="msapplication-tap-highlight" content="no" />
    <link rel="stylesheet" href="assets/css/runeui.css">
    <link rel="stylesheet" href="assets/css/gpiosettings.css">
    <link rel="shortcut icon" href="assets/img/favicon.ico">
<style>
	p {
		color: #7795b4;
	}
	pre {
		color: #ddd;
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
	#addons .boxed-group {
		padding: 20px;
	}
	#addons .btn {
		text-transform: capitalize;
	}
</style>
</head>
<body>
<div id="addons" class="container">
<h1>Addon Install ...</h1><a id="close"><i class="fa fa-times fa-lg"></i></a>
<p>Please wait until finished.</p>
<pre>
<?php
$addon = array(
'inaria' => 'wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/aria2/install.sh; chmod +x install.sh; /usr/bin/sudo ./install.sh 1',
'inmotd' => 'wget -qN https://github.com/rern/RuneAudio/raw/master/motd/install.sh; chmod +x install.sh; /usr/bin/sudo ./install.sh',
'unaria' => '/usr/bin/sudo /usr/local/bin/uninstall_aria.sh',
'unmotd' => '/usr/bin/sudo /usr/local/bin/uninstall_motd.sh'
);

function bash($cmd) {
	while (@ ob_end_flush()); // end all output buffers if any

	$proc = popen("$cmd 2>&1", 'r');

	while (!feof($proc)) {
		$std = fread($proc, 4096);
		if (strpos($std, '.....') === false) { // suppress repetitive progress bars
			$std = preg_replace('/.\\[38;5;6m.\\[48;5;6m/', '<a class="cc">', $std); // bar
			$std = preg_replace('/.\\[38;5;0m.\\[48;5;3m/', '<a class="ky">', $std); // info
			$std = preg_replace('/.\\[38;5;6m.\\[48;5;0m/', '<a class="ck">', $std); // tcolor
			$std = preg_replace('/.\\[38;5;6m/', '<a class="ck">', $std); // lcolor
			$std = preg_replace('/.\\[0m/', '</a>', $std); // reset color
			echo "$std";
		}
		@ flush();
	}

	pclose($proc);
}

bash($addon[$_GET['id']]);
?>
</pre>
</div>
<script src="assets/js/vendor/jquery-2.1.0.min.js"></script>
<script>
$(document).ready(function() {

$('#close').click(function() {
	window.location.href = 'addons.php';
});

});
</script>

</body>
</html>
