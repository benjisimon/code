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
    die("Future time asked for!");
  } else {
    $response = curl_get($url, ['exclude' => 'hourly,currently,flags'], ['ttl' => $ttl]);
    $data = $response['daily']['data'][0];
    return $attr === 'all' ? json_encode($data, JSON_PRETTY_PRINT) : $data[$attr];
  }
}

?>
