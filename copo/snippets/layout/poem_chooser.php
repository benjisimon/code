<?php
/*
 * A PHP file for rendering our list of poems
 */
$sep = '';
sort($poems);
?>
<p>
  More:
  <? foreach($poems as $p) { ?>
    <?= $sep ?>
    <a href="/copo/?p=<?= $p ?>"><?= $p?></a>
    <? $sep = '|' ?>
  <? } ?>
</p>
