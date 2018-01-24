<?php
/*
 * A PHP file for rendering our list of poems
 */
$sep = '';
?>
<p>
  More:
  <? foreach($poems as $p) { ?>
    <?= $sep ?>
    <a href="/copo/?p=<?= $p ?>"><?= $p?></a>
    <? $sep = '|' ?>
  <? } ?>
</p>
