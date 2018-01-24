<?php
/*
 * A PHP file for rendering a style tag
 */
$version = file_exists(__DIR__ . "/../../$src") ? filemtime(__DIR__ . "/../../$src") : time();
?>
<link rel="Stylesheet" type="text/css"  href="<?= $src ?>?ver=<?= $version ?>"/>
