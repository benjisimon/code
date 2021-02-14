<?php
/*
 * A PHP file for implementing a simple Message Queue based
 * Message Board.
 *
 * The goal: let me leave love notes to the wife remotely
 * on an old iPad
 */
?>
<html>
  <title>MqBoard</title>
  <link rel="Stylesheet" type="text/css" href="layout.css?ver=<?= md5_file(__DIR__ . '/layout.css') ?>"/>
  <meta name=”apple-mobile-web-app-capable” content=”yes”>
  <body>
    <div class="message">
      Hello World
    </div>
  </body>
</html>
