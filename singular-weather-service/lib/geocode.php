<?php
/*
 * A PHP file for using Google's web services to turn
 * a human readable address into lat/lng
 */

function geocode($location, $options = []) {
  $info = curl_get('https://maps.googleapis.com/maps/api/geocode/json', [
    'address' => $location,
    'key'     => GEOCODING_API_KEY,
  ], ['ttl' => 60 * 60 * 25 * 365 * 10]);
  
  if(g($options, 'debug')) {
    var_dump($location);
    var_dump($info);
  }

  if(is_array($info)) {
    return g($info, ['results', 0, 'geometry', 'location']);
  } else {
    return false;
  }
}
?>
