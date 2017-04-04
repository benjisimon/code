<?
/*
 * Answer the question: what's the current tide level of a given station. Return a very terse response
 * for use in other applications.
 *
 * Pulling data from NOAA. See also:
 * https://tidesandcurrents.noaa.gov/waterlevels.html?id=8594900&units=standard&bdate=20170323&edate=20170324&timezone=GMT&datum=MLLW&interval=6&action=
 */
header("Content-Type: text/plain");

$station = isset($_GET['station']) ? $_GET['station'] : die("Missing station identifier");
$time    = isset($_GET['time']) ? strtotime($_GET['time']) : time();
$start   = gmdate('Ymd', $time - (60*60*24*2));
$end     = gmdate('Ymd', $time);
$fmt      = isset($_GET['fmt']) ? $_GET['fmt'] : 'txt';
$url     = 'https://tidesandcurrents.noaa.gov/api/datagetter?' . 
            http_build_query(array('product' => 'predictions',
                                   'application' => 'NOS.COOPS.TAC.WL',
                                   'station' => $station,
                                   'begin_date' => $start,
                                   'end_date' => $end,
                                   'datum' => 'MLLW',
                                   'units' => 'english',
                                   'time_zone' => 'GMT',
                                   'format' => 'csv'));
$buffer = tmpfile();

$ch = curl_init($url);
curl_setopt($ch, CURLOPT_FILE, $buffer);
curl_setopt($ch, CURLOPT_TIMEOUT, 5);
$result = curl_exec($ch);
if($result === false) {
  echo "Failed to download data: $url\n";
  var_dump(curl_error($ch));
  var_dump(curl_getinfo($ch));
  die();
} else {
  fseek($buffer, 0);
  $header = fgetcsv($buffer);
  $high     = 0;
  $low      = 1000;
  $current  = 0;
  $offset   = time();

  while(list($ts, $level) = fgetcsv($buffer)) {
    if($level > $high) {
      $high = $level;
    }
    if($level < $low) {
      $low = $level;
    }
    if(abs(strtotime($ts) - $time) < $offset) {
      $offset = abs(strtotime($ts) - $time);
      $current = $level;
    }
  }
  switch($fmt) {
    case 'text':
    case 'txt':
      echo "{$low}L/{$high}H/{$current}C\n";
      break;
    case 'json':
      header("Content-Type: application/json");
      echo json_encode(array('high' => $high, 'low' => $low, 'current' => $current, 'offset' => $offset));
      break;
     default:
      die("Unknown format: $as");
  }
  exit();
}



?>
