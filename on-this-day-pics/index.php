<?php
/*
 * A PHP file for providing a simple service: what photos were taken on this
 * day in your album?
 */
require_once(__DIR__ . '/lib/siteconfig.php');

$num_years = 10;
$is_authenticated = handle_oauth2();
$today = ['month' => date('m', time()),
          'day'   => date('d', time())];

?>
<html>
  <head>
    <title>On This Day</title>
  </head>

  <body>
    <? if($is_authenticated) { ?>
      <? foreach(range(date('Y') - $num_years, date('Y')) as $year) { ?>
        <h2><?= $year ?></h2>

        <div class="photos">
          <? $photos = photo_date_search(['year' => $year] + $today); ?>
          <? foreach($photos as $item) { ?>
            <a href="<?= $item->getProductUrl() ?>">
              <img src="<?= $item->getBaseUrl() ?>=w300-h300"/>
            </a>
          <? } ?>
        </div>
      <? }  ?>

      <p>
        <a href="<?= app_url('', ['code' => 'clear'])?>">Log Out</a></a>
      </p>
    <? } else { ?>
      <a href="<?= app_url('', ['code' => 'create'])?>">Authenticate</a></a>
    <? } ?>
  </body>
</html>



