<?php
/*
 * A PHP file for rendering our past photos for a day & year
 */
?>

<div class="photos">
  <? $photos = photo_date_search(['year' => $year] + $today); ?>
  <? foreach($photos as $item) { ?>
    <div class="photo">
      <a href="<?= $item->getBaseUrl() ?>=w2000-h2000">
        <img src="<?= $item->getBaseUrl() ?>=w150-h150"/>
      </a>
      <div class="controls">
        <a class="al" href="<?= $item->getProductUrl() ?>">Info</a>
        <a class="ar" href="<?= $item->getBaseUrl() ?>=d">Download</a>
      </div>
    </div>
  <? } ?>
</div>
