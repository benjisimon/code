<?php
/*
 * A PHP file for providing a simple service: what photos were taken on this
 * day in your album?
 */


require_once(__DIR__ . '/lib/siteconfig.php');


$num_years = 11;
$is_authenticated = handle_oauth2();
$today = ['month' => date('m', time()),
          'day'   => date('d', time())];

?>
<html>
  <head>
    <title>On This Day</title>
    <link rel="Stylesheet" type="text/css"
          href="<?= app_url('layout.css', ['version' => md5_file(__DIR__ . '/layout.css')])?>"
  </head>

  <body>
    <div class="main">
      <h1>On This Day | Pics</h1>
      
      <? if($is_authenticated) { ?>
        <? foreach(range(date('Y') - $num_years, date('Y')) as $year) { ?>
          <h2><?= date('F, jS') ?> <?= $year ?></h2>

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
        <? }  ?>

        <p>
          <a href="<?= app_url('', ['code' => 'clear'])?>">Log Out</a></a>
        </p>
      <? } else { ?>
        <p>
          Welcome. To continue
          <a href="<?= app_url('', ['code' => 'create'])?>">grant access.</a>
        </p>
      <? } ?>
    </div>

    <div class="footer">
      Built By <a href="https://blogbyben.com/">Ben</a>
    </div>
  </body>
</html>



