<?php
/*
 * A PHP file for implementing a simple Message Queue based
 * Message Board.
 *
 * The goal: let me leave love notes to the wife remotely
 * on an old iPad
 */

$env = [
  'wss_url' => 'wss://b-fb1df8e2-cf9a-44f6-8071-40ecdc7a772c-1.mq.us-east-1.amazonaws.com:61619/mqboard/1'
];

?>
<html>
  <title>MqBoard</title>
  <link rel="Stylesheet" type="text/css" href="layout.css?ver=<?= md5_file(__DIR__ . '/layout.css') ?>"/>
  <script>
   var Env = <?= json_encode($env); ?>;
  </script>
  <meta name=”apple-mobile-web-app-capable” content=”yes”>
  <body>
    <div class="message">
      Hello World
    </div>
    <div class="seq">
      3
    </div>
  </body>
  <script src="ui.js?ver=<?= md5_file(__DIR__ . '/ui.js')?>"></script>
</html>
