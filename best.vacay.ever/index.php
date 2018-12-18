<?
/*
 * My demo code for Maryn's class
 */

define('PRIMARY_FEED','https://spreadsheets.google.com/feeds/list/195LIGTePOsGMtaqtgZEBygLo2L4gkUpx48TkEyTjF_U/olzevke/public/full');
define('ALTERNATIVE_FEED', 'https://spreadsheets.google.com/feeds/list/195LIGTePOsGMtaqtgZEBygLo2L4gkUpx48TkEyTjF_U/oqtogwg/public/full');

$selected = isset($_GET['g']) ? $_GET['g'] : false;
$recommendation = $selected ? recommend($selected) : false;
?>
<html>
  <head>
    <title>Best. Vacay. Ever.</title>
    <link rel="Stylesheet" type="text/css" href="css/layout.css?v=<?= time(); ?>"/>
  </head>
  <body>
    <div class="page">
     <h1>Best. Vacay. Ever.</h1>

     <div class='grades'>
      <? for($i = 0; $i < 10; $i++) { ?>
        <a href="?g=<?= $i+1 ?>" class="grade <?= $i+1 == $selected ? 'selected' : ''?>">Grade <?= $i+1 ?></a>
      <? } ?>
     </div>

      <div class="leading2">
        <? if($selected) { ?>
          <? if($recommendation) { ?>
            Your <b>grade <?= $selected ?> student</b> would love to:
            <div class="recommendation"><?= $recommendation['top_activity'] ?></div>

            Whatever you do, don't
            <div class="recommendation"><?= $recommendation['bottom_activity'] ?></div>
          <? } else { ?>
            Uh Oh. At this time we have no idea what your <b>grade <?= $selected ?> student</b> would like to do.
          <? } ?> 
        <? } else { ?>
          Pick a grade above to see our recommendation
        <? } ?>
      </div>


    </div>
  </body>
</html>
<?

function recommend($grade) {
  $scores = slurp($grade);
  $recs = array();
  foreach($scores as $activity => $value) {
    if(!isset($recs['top_activity'])) {
      $recs['top_activity'] = $activity;
      $recs['top_score'] = $value;
    }
    if($value > $recs['top_score']) {
      $recs['top_activity'] = $activity;
      $recs['top_score'] = $value;
    }

    if(!isset($recs['bottom_activity'])) {
      $recs['bottom_activity'] = $activity;
      $recs['bottom_score'] = $value;
    }
    if($value < $recs['bottom_score']) {
      $recs['bottom_activity'] = $activity;
      $recs['bottom_score'] = $value;
    }
  } 
  return $recs;
}


function slurp($grade) {
  $ch = curl_init(PRIMARY_FEED);
  curl_setopt($ch, CURLOPT_TIMEOUT, 3);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  $data = curl_exec($ch);
  $data = str_replace('gsx:', 'gsx_', $data);
  $dom = new SimpleXMLElement($data);
  $scores = array();
  foreach($dom->entry as $e) {
    $g = $e->gsx_whatgradeareyouin . "";
    $top = $e->gsx_whatwouldbemostfun . "";
    $second = $e->gsx_whatsyoursecondchoice . "";
    $worst = $e->gsx_whatstheworstidea . "";
    if($g == $grade) {
      if(!isset($scores[$top])) {
        $scores[$top] = 0;
      }
      if(!isset($scores[$second])) {
        $scores[$second] = 0;
      }
      if(!isset($scores[$top])) {
        $scores[$worst] = 0;
      }
      $scores[$top] += 100;
      $scores[$second] += 50;
      $scores[$worst] -= 100;
    }
  }

  return $scores;
}


?>
