<?php
/*
 * Implement a concept like Artist Pages as described in the Artist's Way.
 *
 * Goal is to write to fill a particular amount of space with text. Do this 
 * frequently enough, and your brain gets a workout/outlet.
 */
?>
<!DOCTYPE>
<html>
  <head>
    <title>Just Write. Seriously. What are you doing? Just Write.</title>
    <link rel="Stylesheet" type="text/css" 
          href="css/layout.css?ver=<?= filemtime(__DIR__ . '/css/layout.css') ?>"/>
  </head>

  <body>
    <div class="editor">
      <textarea></textarea>
      <input type="button" value="Just Write." class="save" disabled="true"/>
    </div>

    <script
			  src="https://code.jquery.com/jquery-3.3.1.min.js"
			  integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
			  crossorigin="anonymous"></script>
    <script type="text/javascript" src="js/ui.js?ver=<?= filemtime(__DIR__ . '/js/ui.js') ?>"></script>
  </body>
</html>
