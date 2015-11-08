<?php
/*
 * A PHP file for rendering our hourly detail
 */
?>
<table width='100%' style='border-collapse: collapse'>
  <?= snippet('emails/layout/th', array('cols' => A("Date", "Duration", "Notes"))); ?>

  <? foreach($entries as $e) { ?>
    <?= snippet('emails/layout/td', array('cols' => A(fmt_date($e['date']),
                                                      fmt_hours($e['hours']),
                                                      $e['notes']),
                                          'nbsp' => A(0, 1))); ?>
  <? }?>
  <? if(empty($entries)) { ?>
    <tr>
      <td colspan="3">No activity yet for <?= $month ?></td>
    </tr> 
  <?} ?>
</table>
