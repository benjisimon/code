<?php
/*
 * A PHP file for providing a simple service: what photos were taken on this
 * day in your album?
 */


require_once(__DIR__ . '/lib/siteconfig.php');


$is_authenticated = handle_oauth2();
$subject = g($_GET, 'subject');
$now = g($_GET, 'date', "now");
$now = ($t = strtotime($now)) ? $t : time();
$today = ['month' => date('m', $now),
          'day'   => date('d', $now)];

?>
<html>
  <head>
    <title>On This Day</title>
    <link rel="Stylesheet" type="text/css"
          href="<?= app_url('layout.css', ['version' => md5_file(__DIR__ . '/layout.css')])?>"
  </head>

  <body>
    <div class="main">
      <? if(in_array($subject, ['pics', 'posts'])) { ?>
        <h1>
          <a href="<?= app_url()?>">on this day</a> | <?= $subject ?>
        </h1>
        
        <? if($is_authenticated) { ?>
          <? foreach(range(2005, date('Y')) as $year) { ?>
            <h2><?= fmt_date($today, $year) ?></h2>
            <?= snippet($subject, ['today' => $today, 'year' => $year]) ?>
          <? }  ?>
          
          <p>
            <a href="<?= app_url('', ['code' => 'clear', 'subject' => $subject])?>">Log Out</a></a>
          </p>
        <? } else { ?>
          <p>
            Welcome. To continue
            <a href="<?= app_url('', ['code' => 'create', 'subject' => $subject])?>">grant access.</a>
          </p>
        <? } ?>
      <? } else { ?>
        <p>
          To get started, pick:
        </p>
        <h1>
          <a href="<?= app_url('', ['subject' => 'pics'])?>">Pics</a> or
          <a href="<?= app_url('', ['subject' => 'posts'])?>">Posts</a>
        </h1>
      <? } ?>
    </div>

    <div class="footer">
      Built By <a href="https://blogbyben.com/">Ben</a>
    </div>
  </body>
</html>



