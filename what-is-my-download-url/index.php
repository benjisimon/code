<?
/*
 * A PHP script to help you determine what your Google Sheet's
 * WP-All-Import download url is.
 *
 * Basically: what's the public URL to a sheet's xml data?
 */
$fail       = false;
$discovered = array();
$title      = false;

if(isset($_REQUEST['spreadsheet_url'])) {
  $u = $_REQUEST['spreadsheet_url'];
  if(preg_match('|^https://docs.google.com/spreadsheets/d/(.*)/edit|', $u, $matches)) {
    $id = $matches[1];
    $ch = curl_init("https://spreadsheets.google.com/feeds/worksheets/$id/public/full");
    curl_setopt($ch, CURLOPT_TIMEOUT, 6);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $xml = curl_exec($ch);
    if(curl_error($ch)) {
      $fail = curl_error($ch);
    } else {
      $feed = simplexml_load_string($xml);
      $title = $feed->title . "";
      foreach($feed->entry as $entry) {
        if(preg_match('|^.*/public/full/(.*)|', $entry->id . "", $matches)) {
          $discovered[$entry->title . ""] = $matches[1];
        }
      }
      if(!$discovered) {
        $fail = "No public sheets found. Did you publish the sheets in your document?";
      }
    }
  } else {
    $fail = "URL provided doesn't look like a valid Google Sheets URL. Try again.";
  }
}
?>
<!DOCTYPE html>
<html>
 <head>
  <title>What's my Download URL?</title>
  <style>
    body {
      background-color:  #e0f3fd;
    }

    h1 {
      text-align: center; 
    }

    input {
      margin: 15px auto;
      display: block;
    }

    input[type=text] { 
      width: 100%;
      max-width: 800px;
    }

    .fail {
      max-width: 800px;
      margin: auto;
      padding: 10px;
      font-style: italic;
      color: red;
    }

    textarea {
      width: 100%;
    }

    .discovered {
      max-width: 800px;
      margin: 15px auto;
      padding: 20px;
      background-color: white;
      border: 1px solid #21a3e7;
    }

    .discovered input {
      width: 100%;
      padding: 3px;
      margin: auto;
    }

    .discovered h3 {
     margin: 20px 0px 5px 0px;
    }

    .discovered p a {
      font-size: 10px;
    }

    .discovered p {
      text-align: center;
    }

  </style>
 </head>
 <body>
  <h1>What's my download URL?</h1>

  <? if($fail) { ?>
    <div class='fail'><?= $fail ?></div>
  <? } ?>

  <? if($discovered) { ?>
     <div class='discovered'>
       <h2>Here are the download URLs we found in <a href='https://docs.google.com/spreadsheets/d/<?= $id ?>/edit'><?= $title ?></a></h2>
       <? foreach($discovered as $tab_title => $tab_id) { ?>
         <h3>Tab: <i><?= $tab_title ?></i></h3>
         <input onclick="this.select()" value="https://spreadsheets.google.com/feeds/list/<?= $id ?>/<?= $tab_id ?>/public/full" class="result"/>
       <? } ?>

       <p>
         <a href='index.php'>Try Again</a>
       </p>
     </div>
  <? } ?>

  <form method='GET' action='index.php'>
   <input type='text' name='spreadsheet_url' placeholder="Enter Your Google Spreadsheet URL"/>
   <input type='submit' value="Please Tell Me"/>
  </form>
 </body>
</html>
