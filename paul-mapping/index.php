<?php
/*
 * A PHP file for rendering render a PAUL map
 */
require_once(__DIR__ . '/utils.php');
require_once(__DIR__ . '/mapping.php');

if(($data = g($_POST, 'data'))) {
  $data = normalize_xy(add_xy(parse_data($data)));
}

?>
<!DOCTYPE html>
<html>
  <head>
    <title>P.A.U.L. Mapping</title>
    <link rel="Stylesheet" type="text/css" href="style.css?ver=<?= filemtime(__DIR__ . "/style.css")?>"
  </head>

  <body>
    <div class="page">
      <h1>P.A.U.L Mapping</h1>

      <? if($data) { ?>
        <div class="map">
          <canvas></canvas>
        </div>
      <? } ?>

      <form method="POST">
        <p>
          Enter the data you collected:
        </p>
        <textarea name="data" placeholder="Bearing, Distance, Notes"><?= g($_POST, 'data')?></textarea>
        <input type="submit" value="Show Map"/>
      </form>

      <h4>
        Learn about the <a href="https://www.youtube.com/watch?v=Oo_soAz26gI">P.A.U.L. Method of Map Making</a>
      </h4>

      <script
        src="https://code.jquery.com/jquery-3.4.1.min.js"
        integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
        crossorigin="anonymous"></script>

      <script
        src="code.js?ver=<?= filemtime(__DIR__ . "/code.js")?>"></script>

      <? if($data) { ?>
        <script>
         $(document).ready(function() {
           renderMap(<?= json_encode($data, JSON_PRETTY_PRINT) ?>);
         });
        </script>
      <? } ?>
    </div>
  </body>
</html>
