<?php
/*
 * A PHP file for rendering the look and feel of our page
 */


?>
<!DOCTYPE>
<html>
  <head>
    <title>Vanilla-PHP. Yum!</title>
    <link rel="Stylesheet" type="text/css"
          href="<?= app_url('css/layout.css', array('ver' => filemtime(__DIR__ . '/../../css/layout.css'))) ?>"/>
  </head>

  <body>
    <div class="nav">
      <?= snippet('layout/nav') ?>
    </div>

    <div class="body">
      <?= $body ?>
    </div>

    <div class="footer">
      <p>
        --By Ben.
      </p>
    </div>
  </body>
</html>
