<?php
/*
 * A PHP file for generating emojigraphs
 */
require_once(__DIR__ . '/lib/utils.php');

?>
<!DOCTYPE html>
<html>
  <head>
    <title>Emojigraphs</title>
    
    <script
      src="https://code.jquery.com/jquery-3.4.1.min.js"
      integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
      crossorigin="anonymous"></script>
    <script
      src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"
      integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU="
      crossorigin="anonymous"></script>
  </head>
  
  <body>
    <input name="q"/>
    
    <div class="results">

    </div>

    <script src="ui.js?ver=<?= filemtime(__DIR__ . '/ui.js')?>"></script>
      
  </body>
</html>
