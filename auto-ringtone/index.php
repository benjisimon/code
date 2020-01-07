<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8"/>
    <title>Auto Ringtone</title>

    <script
      src="https://code.jquery.com/jquery-3.4.1.min.js"
      integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
      crossorigin="anonymous"></script>
    
    <script src="code.js?ver=<?= filemtime(__DIR__ . '/code.js') ?>"></script>
    <link rel="stylesheet" type="text/css" href="style.css?ver=<?= filemtime(__DIR__ . '/style.css') ?>"/>
    <link href="https://fonts.googleapis.com/css?family=Stoke&display=swap" rel="stylesheet">

  </head>
  
  <body>
    <input type="text" name="subject" placeholder="John Smith"/>
    <div class="feedback"></div>
  </body>
</html>

