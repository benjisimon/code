<?
/*
 * Render a css include link
 */

$version = filemtime(__DIR__ . "/../../$path");
?>
<link rel='Stylesheet' type='text/css' href='<?= $path ?>?xcache=<?= $version ?>'/>
