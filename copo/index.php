<?
require_once(__DIR__ . '/lib/siteconfig.php');

$poems = array_map(
  function($f) {
    return basename($f, '.js');
  }, 
  files_in_dir(__DIR__ . '/js/poems', 
               array('filter' => function($f) { return strpos($f, '.js') !== false; })));

$poem = isset($_GET['p']) && in_array($_GET['p'], $poems) ? $_GET['p'] : 'helloworld';
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8"/>
    <title>Digital Poetry Thingy</title>
    <style>
     body {
       background-color: #222;
       font-family: arial;
       color: #EEE;
       font-size: 14px;
     }
     p {
       text-align: center;
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
    <canvas id="canvas" width="500" height="500">
    </canvas>
    <p>
      Computational Poetry. 
      Inspired by <A href="https://www.youtube.com/watch?v=bmztlO9_Wvo">Zach Liberman</a>. 
      Built by <A href='http://www.blogbyben.com/2018/01/the-joy-of-poetic-computation.html'>Ben</a>.
    </p>

    <?= snippet('layout/poem_chooser', array('poems' => $poems)); ?>

    <?= snippet('layout/script', array('src' => 'js/lib/drawing.js')); ?>
    <?= snippet('layout/script', array('src' => "js/poems/$poem.js")); ?>

  </body>
</html>

