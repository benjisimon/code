<?php
/*
 * A PHP file for implementing a simple Message Queue based
 * Message Board.
 *
 * The goal: let me leave love notes to the wife remotely
 * on an old iPad
 *
 * Pair this script with Tasker: https://taskernet.com/shares/?user=AS35m8l5RQjTRe3TULACE9yEJktuWU6aAnSRKY16uyMSAb3bzu7qeuaheX4adap2hJHO4tg%3D&id=Task%3AMq+Board+Publisher
 */

$env = [
  'host'     => 'b-fb1df8e2-cf9a-44f6-8071-40ecdc7a772c-1.mq.us-east-1.amazonaws.com',
  'port'     => 61619,
  'path'     => '/',
  'username' => 'mqboard',
  'password' => g($_GET, 'p'),
  'clientId' => 'MqBoardSubscriber',
  'topic'    => 'mqboard/1'
];

?>
<html>
  <head>
    <title>MqBoard</title>
    <link rel="Stylesheet" type="text/css" href="layout.css?ver=<?= md5_file(__DIR__ . '/layout.css') ?>"/>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.min.js" type="text/javascript"></script>
    <script>
     var Env = <?= json_encode($env); ?>;
    </script>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
  </head>
  <body>
    <div class="message">
    </div>
    <div class="seq">
    </div>
    <div class="status">
      Loading...
    </div>

  </body>
  <script src="ui.js?ver=<?= md5_file(__DIR__ . '/ui.js')?>"></script>
</html>

<?
function g($array, $key, $default = false) {
  return array_key_exists($key, $array) ? $array[$key] : $default;
}
