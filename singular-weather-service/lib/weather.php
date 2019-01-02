<?php
/*
 * A PHP file for using the darksky API
 * get weather data
 */

function forecast($loc, $time, $attr) {
  $key = DARKSKY_API_KEY;
  $url = "https://api.darksky.net/forecast/$key/{$loc['lat']},{$loc['lng']},$time";
  $ttl = $time < time() ? true : (60*60*6);

  if($time > (time() + (60*60*24*10))) {
    $ref_times = historic_times($time, 5);
    $result    = false;
    foreach($ref_times as $t) {
      $f  = forecast($loc, $t, $attr);
      if(is_numeric($f)) {
        $result = $result === false ? $f : (($result + $f) / 2);
      } else {
        $result = ($result == false ? $f : ("$result\n\n$f"));
      }
    }
    return $result;
  } else {
    $response = curl_get($url, ['exclude' => 'hourly,currently,flags'], ['ttl' => $ttl]);
    $data = $response['daily']['data'][0];
    return $attr === 'all' ? json_encode($data, JSON_PRETTY_PRINT) : $data[$attr];
  }
}

function historic_times($future, $count) {
  $year      = date('Y');
  $collected = [];

  while(count($collected) < $count) {
    $t   = strtotime(date("{$year}-m-d H:i", $future));
    $year--;
    if($t > time()) {
      continue;
    }
    $collected[] = $t;
  }
  return $collected;
}

?>
