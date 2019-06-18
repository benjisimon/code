<?php
/*
 * A PHP file for rendering a GOAP - Gift-of-a-Playlist
 */
require_once(__DIR__ . '/lib/siteconfig.php');
$doc_id = g($_GET, 'd',
            (($doc_url = g($_GET, 'doc_url')) ? gsheet_doc_url_to_id($doc_url) : false));
$sheet_id = g($_GET, 's');
$playlist = $doc_id && $sheet_id ? gsheet_playlist($doc_id, $sheet_id) : false;
?>
<!DOCTYPE>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title>Gift-of-a-Playlist</title>
    <link rel="Stylesheet" 
          href="css/layout.css?v=<?= filemtime(__DIR__ . '/css/layout.css') ?>"
          type="text/css"/>
          
  </head>

  <body>
    <div class="header">
      <h1>Gift of a Playlist</h1>
      
      <h2>
        Proving the best things in life aren't things.
      </h2>

    </div>
    <div class="body">
      <? if($sheet_id) { ?>
        <?= snippet('playlist/render', ['playlist' => $playlist]) ?>
      <? } else if($doc_id) { ?>
        <?= snippet('prompts/sheet', ['doc_id' => $doc_id]) ?>
      <? } else { ?>
        <?= snippet('prompts/doc') ?>
      <? } ?>
    </div>
    <div class="footer">
      Powered by <i><a href="index.php">Gift-of-a-Playlist</a></i>
    </div>
  </body>
</html>
