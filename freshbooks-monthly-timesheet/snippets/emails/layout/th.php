<?php
/*
 * A PHP file for laying out our table headings
 */
$th_style = "text-align: left; color: white; background-color: #000969; border: 1px solid #CCCCCC; padding: 4px";
?>
<tr>
  <? foreach($cols as $c) { ?>
    <th style='<?= $th_style ?>'><?= $c ?></th>
  <? } ?>
</tr>