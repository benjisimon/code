<?
/*
 * Render a javascript link
 */
$version = filemtime(__DIR__ . "/../../$path");
?>
<script type='text/javascript' src='<?= $path ?>?xcache=<?= $version ?>'></script>
