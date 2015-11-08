<?php
/*
 * A PHP file for laying out column data
 */
$td_style = 'border: 1px solid #CCCCCC; padding: 4px;'
?>
<tr>
  <? foreach($cols as $i => $c) { ?>
    <? $value = in_array($i, $nbsp) ? str_replace(' ', '&nbsp;', $c) : $c; ?>
    <td style='<?= $td_style ?>'><?= $value ?></td>
  <? }?>
</tr>