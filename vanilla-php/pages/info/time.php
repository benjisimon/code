<?php
/*
 * A PHP file for showing the current time.
 */

?>

<? start_snippet('layout/shell') ?>

<p>
  It's currently <?= time() ?>, or for mere mortals: <?= date('c', time())?>.
</p>

<?= end_snippet() ?>
