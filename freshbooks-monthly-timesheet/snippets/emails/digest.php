<?php
/*
 * A PHP file for laying our weekly digest
 */
$total = array_reduce($entries,
                      function($c, $e) { return $c + $e['hours']; },
                      0);
$month = date('F Y', strtotime($from));
?>


<p>
  Time accrued for <?= $month ?>: <u><?= $total ?></u> hours
</p>

<p>
  Activity for <?= $month?>:
</p>

<?= snippet('emails/detail', array('entries' => $entries)); ?>
