<?php
/*
 * A PHP file for showing our fallback results.
 */
?>
<? start_snippet('layout/shell') ?>

<p>
  Sorry, but I don't know how to <?= implode(',', $_ARGS) ?> yet.
</p>

<?= end_snippet()?>

