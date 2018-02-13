<?
require_once(__DIR__ . '/lib/siteconfig.php');

$poems = array_map(
  function($f) {
    return basename($f, '.js');
  }, 
  files_in_dir(__DIR__ . '/js/poems', 
               array('filter' => function($f) { return strpos($f, '.js') !== false; })));

$poem = isset($_GET['p']) && in_array($_GET['p'], $poems) ? $_GET['p'] : $poems[array_rand($poems)];
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8"/>
    <title>Computationl Poetry Playground</title>
    <?= snippet('layout/style', array('src' => 'css/layout.css')) ?>
  </head>
  
  <body>
    <p>
      <a href="#" id="show-code">Show Code</a>
    </p>
    <div id="poem">
    </div>

    <?= snippet('layout/code', array('poem' => $poem)) ?>
    <p>
      Computational Poetry. 
      Inspired by <A href="https://www.youtube.com/watch?v=bmztlO9_Wvo">Zach Liberman</a>. 
      Built by <A href='http://www.blogbyben.com/2018/01/the-joy-of-poetic-computation.html'>Ben</a>.
    </p>

    <?= snippet('layout/poem_chooser', array('poems' => $poems)); ?>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script> 
    <?= snippet('layout/script', array('src' => 'js/lib/drawing.js')); ?>
    <?= snippet('layout/script', array('src' => 'js/lib/notes.js')); ?>
    <?= snippet('layout/script', array('src' => 'js/lib/music.js')); ?>
    <?= snippet('layout/script', array('src' => 'js/lib/audio.js')); ?>
    <?= snippet('layout/script', array('src' => 'js/lib/ui.js')); ?>
    <?= snippet('layout/script', array('src' => "js/poems/$poem.js")); ?>

  </body>
</html>

