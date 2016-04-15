<?
/*
 * Spit out our list of icons
 */

$icons = explode("\n", file_get_contents(__DIR__ . "/../lib/icons.txt"));
?>
<? foreach($icons as $icon) { ?>
 <i class='fa fa-<?= $icon ?>'></i>
<? } ?>
