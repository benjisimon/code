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
        </div>
      <? } ?>

      <form method="POST">
        <p>
          Enter the data you collected:
        </p>
        <textarea name="data" placeholder="Bearing, Distance, Notes"></textarea>
        <input type="submit" value="Show Map"/>
      </form>

      <h4>
        Learn about the <a href="https://www.youtube.com/watch?v=Oo_soAz26gI">P.A.U.L. Method of Map Making</a>
      </h4>

      <? if($data) { ?>
        <pre>
         renderMap(<?= json_encode($data, JSON_PRETTY_PRINT) ?>);
        </pre>
      <? } ?>
    </div>
  </body>
</html>
