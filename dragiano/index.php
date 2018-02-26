<?php
/*
 * A PHP file for building my dragiano - basically, a music instrument
 * where you make sounds by dragging stuff around. 
 */

$bpm = 180;

?>
<!DOCTYPE html>
<html>
  <head>
    <title>Drag and Listen | Dragiano</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <script
			  src="https://code.jquery.com/jquery-3.3.1.min.js"
			  integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
			  crossorigin="anonymous"></script>
    <script src="shared/js/concrete.min.js"></script>
    <link rel="stylesheet" type="text/css" href="css/layout.css?ver=<?= filemtime(__DIR__ . "/css/layout.css")?>"/>
  </head>

  <body>
    <div class="controls">
      BPM: <input type="text" class="bpm" value="<?= $bpm ?>" size="3"/>
      <input type="button" class="go" value="Go"/>
    </div>

    <div class="surface">
    </div>

    <script src="js/sline.js?ver=<?= filemtime(__DIR__ . "/js/sline.js")?>"></script>    
    <script src="js/ui.js?ver=<?= filemtime(__DIR__ . "/js/ui.js")?>"></script>    
  </body>
</html>
