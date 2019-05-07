<?php
/*
 * A PHP file for rendering our visual encryption demo.
 * Visual Encryption is described here:
 * https://en.wikipedia.org/wiki/Visual_cryptography	
 * https://cs.uwaterloo.ca/~dstinson/visual.html
 */
require_once('lib/siteconfig.php');

?>
<!DOCTYPE html>
<html>
  <head>
    <title>Visual Cryptography</title>
    
    <script
      src="https://code.jquery.com/jquery-3.4.1.js"
      integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
      crossorigin="anonymous"></script>
    <link rel="Stylesheet" href="<?= resource_url('css/layout.css')?>" type="text/css"/>
  </head>
  
  <body>
    <div class="page">
      <canvas id="source" width="400" height="300"></canvas>
      <div class="bounds hidden">
        <canvas id="share-1" width="400" height="300"></canvas>
        <canvas id="share-2" width="400" height="300"></canvas> 
      </div>
     
      <div class="controls">
        <button class="decrypt hidden">Decrypt</button>
        <button class="encrypt">Encrypt</button>
        <button class="reset">Start Over</button>
      </div>
    </div>

    <script src="<?= resource_url('js/draw.js') ?>"></script>
    <script src="<?= resource_url('js/controls.js') ?>"></script>
  </body>
</html>
