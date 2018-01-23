<?php
/*
 * A PHP file for rendering a script tag
 */
$version = file_exists(__DIR__ . "/../../$src") ? filemtime(__DIR__ . "/../../$src") : time();
?>
<script  src="<?= $src ?>?ver=<?= $version ?>"></script>
