<?
require_once(__DIR__ . '/lib/siteconfig.php');
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8"/>
    <title>Digital Poetry Thingy</title>
    <style>
     body {
       background-color: #222;
     }
     p {
       color: #EEE;
       text-align: center;
       font-size: 10px;
     }
     a {
       color: #00DD00;
     }
     canvas {
       border: 4px solid #666;
       background-color: white;
       display: block;
       margin: auto;
     }
    </style>
  </head>
  
  <body>
    <p>
      Computational Poetry. Inspired by <A href="https://www.youtube.com/watch?v=bmztlO9_Wvo">Zach Liberman</a>
    </p>
    <canvas id="canvas" width="500" height="500">
    </canvas>

    <?= snippet('layout/script', array('src' => 'js/lib/drawing.js')); ?>
    <?= snippet('layout/script', array('src' => 'js/poems/helloworld.js')); ?>

  </body>
</html>

