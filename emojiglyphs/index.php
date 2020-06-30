<?php
/*
 * A PHP file for generating emojiglyphs
 */
require_once(__DIR__ . '/lib/utils.php');

?>
<!DOCTYPE html>
<html>
  <head>
    <title>Emojiglypths</title>
    
    <script
      src="https://code.jquery.com/jquery-3.4.1.min.js"
      integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
      crossorigin="anonymous"></script>
    <script
      src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"
      integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU="
      crossorigin="anonymous"></script>
    <link rel="Stylesheet" type="text/css" href="css/layout.css?ver=<?= filemtime(__DIR__ . "/css/layout.css")?>"/>
  </head>
  
  <body>
    <div class="page">
      <input name="q" placeholder="Search for an emoji" />
      
      <div class="board">
      </div>
    </div>

    <script src="js/jquery.ui.autocomplete.html.js?ver=<?= filemtime(__DIR__ . '/js/jquery.ui.autocomplete.html.js')?>"></script>
    <script src="js/ui.js?ver=<?= filemtime(__DIR__ . '/js/ui.js')?>"></script>
      
  </body>
</html>
