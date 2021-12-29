<?php
/*
 * A PHP file for displaying our pubit.data
 */
header("Content-Type: text/plain");

$key = g($_GET, 'key');

$expected = current_key();
if($expected == $key) {
  file_put_contents('/var/www/private/pubit.data');
} else {
  die("Nope");
}


function current_key() {
  $symbols = array_filter(array_map('trim', explode(',', trim(file_get_contents('/usr/local/etc/pubit.symbols')))));
  $k = '';
  foreach($symbols as $s) {
    $k .= closing_price($s);
  }
  if(!$k) {
    die("D'oh!");
  }
  return $k;
}


function closing_price($symbol) {
  $key = trim(file_get_contents('/usr/local/etc/pubit.polygon.key'));
  $url = sprintf("https://api.polygon.io/v2/aggs/ticker/%s/prev?adjusted=true&apiKey=%s",
                 $symbol, $key);
  $ch = curl_init($url);
  curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_TIMEOUT => 5
  ]);
  $text = curl_exec($ch);
  $data = json_decode($text, true);

  if($data) {
    return str_replace('.', '', $data['results'][0]['c']);
  } else {
    die("Gah!");
  }
}

function g($array, $key) {
  return array_key_exists($key, $array) ? $array[$key] : false;
}
