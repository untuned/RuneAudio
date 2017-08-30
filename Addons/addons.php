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
    <link rel="stylesheet" href="assets/css/runeui.css">
    <link rel="stylesheet" href="assets/css/gpiosettings.css">
    <link rel="shortcut icon" href="assets/img/favicon.ico">
<style>
	#addons .boxed-group {
		padding: 20px;
	}
	#addons .btn {
		text-transform: capitalize;
	}
	i {
		margin-right: 10px;
	}
</style>
</head>
<body>

<div id="addons" class="container">

<h1>ADDONS</h1><a id="close" href="/"><i class="fa fa-times fa-lg"></i></a>

<?php
$redis = new Redis(); 
$redis->pconnect('127.0.0.1');
$installed = $redis->hGetAll('addons');

function addonblock($pkg) {
	global $installed;
	$alias = $pkg['alias'];
	if ($installed[$alias]) {
		$check = '<i class="fa fa-check blue"></i>';
		$disablein = ' disabled';
		$disableun = '';
	} else {
		$check = '';
		$disablein = '';
		$disableun = ' disabled';
	}
		echo '
			<div class="boxed-group">
			<legend>'.$check.$pkg['head'].'</legend>
			<form class="form-horizontal">
				<p>'.$pkg['description'].' ( More detail on <a href="'.$pkg['link'].'">GitHub</a> )</p>
				<a id="in'.$alias.'" class="btn btn-default'.$disablein.'">Install</a> &nbsp; ';
		if (!isset($pkg['nouninstall']))
		echo '<a id="un'.$alias.'" class="btn btn-default'.$disableun.'">Uninstall</a>';
		echo
			'</form>
			</div>';
}

$package = array(
	'alias'       => 'aria',
	'head'        => 'Aria2',
	'description' => 'Download utility that supports HTTP(S), FTP, BitTorrent, and Metalink.',
	'link'        => 'https://github.com/rern/RuneAudio/tree/master/aria2',
);
addonblock($package);

$package = array(
	'alias'       => 'back',
	'head'        => 'Backup-Restore Update',
	'description' => 'Enable backup-restore settings and databases.',
	'link'        => 'https://github.com/rern/RuneAudio/tree/master/backup-restore',
);
addonblock($package);

$package = array(
	'alias'       => 'expa',
	'head'        => 'Expand Partition',
	'description' => 'Expand default 2GB partition to full capacity of SD card.',
	'link'        => 'https://github.com/rern/RuneAudio/tree/master/expand_partition',
	'nouninstall' => '1',
);
addonblock($package);

$package = array(
	'alias'       => 'font',
	'head'        => 'Fonts - Extended characters',
	'description' => 'Font files replacement for Extended Latin-based, Cyrillic-based, Greek and IPA phonetics.',
	'link'        => 'https://github.com/rern/RuneAudio/tree/master/font_extended',
);
addonblock($package);

$package = array(
	'alias'       => 'motd',
	'head'        => 'motd - RuneAudio Logo for SSH Terminal',
	'description' => 'Message of the day - RuneAudio Logo and dimmed command prompt.',
	'link'        => 'https://github.com/rern/RuneAudio/tree/master/motd',
);
addonblock($package);

$package = array(
	'alias'       => 'rank',
	'head'        => 'Rank Mirror Packages Servers',
	'description' => 'Fix packages download errors caused by unreachable servers.',
	'link'        => 'https://github.com/rern/RuneAudio/tree/master/rankmirrors',
	'nouninstall' => '1',
);
addonblock($package);

$package = array(
	'alias'       => 'enha',
	'head'        => 'RuneUI Enhancements',
	'description' => 'More minimalism and more fluid layout.',
	'link'        => 'https://github.com/rern/RuneUI_enhancement',
);
addonblock($package);

$package = array(
	'alias'       => 'gpio',
	'head'        => 'RuneUI GPIO',
	'description' => 'GPIO connected relay module control.',
	'link'        => 'https://github.com/rern/RuneUI_enhancement',
);
addonblock($package);

$package = array(
	'alias'       => 'pass',
	'head'        => 'RuneUI Password',
	'description' => 'RuneUI access restriction.',
	'link'        => 'https://github.com/rern/RuneUI_password',
);
addonblock($package);

$package = array(
	'alias'       => 'samb',
	'head'        => 'Samba Upgrade',
	'description' => 'Faster and more customized shares.',
	'link'        => 'https://github.com/rern/RuneAudio/tree/master/samba',
);
addonblock($package);

$package = array(
	'alias'       => 'tran',
	'head'        => 'Transmission',
	'description' => 'Fast, easy, and free BitTorrent client.',
	'link'        => 'https://github.com/rern/RuneAudio/tree/master/transmission',
);
addonblock($package);

$package = array(
	'alias'       => 'webr',
	'head'        => 'Webradio Import',
	'description' => 'Webradio files import.',
	'link'        => 'https://github.com/rern/RuneAudio/tree/master/twebradio',
	'nouninstall' => '1',
);
addonblock($package);
?>

</div>

<script>
var btn = document.getElementsByClassName('btn');
for (var i = 0; i < btn.length; i++) {
	btn[i].onclick = function(e) {
		window.location.href = 'addonbash.php?id='+ this.id;
	}
}
</script>

</body>
</html>
