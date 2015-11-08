<?
/*
 * Generate the HTML behind our monthly timesheet
 */
$total = array_reduce($entries,
                      function($c, $e) { return $c + $e['hours']; },
                      0);
?>
<p>
 Total Hours for <?= fmt_date($from) ?> - <?= fmt_date($to) ?>: <?= $total ?>
</p>

<ul>
  <? foreach($entries as $e) { ?>
    <li><?= fmt_date($e['date']) ?> <?= fmt_hours($e['hours']) ?>: <?= $e['notes'] ?></li> 
  <? } ?>
</ul>
