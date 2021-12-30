<?php
/*
 * A PHP file for displaying our pubit.data
 */
header("Content-Type: text/plain");

$key = preg_replace('/[^0-9]/', '', g($_GET, 'key'));

$expected = current_key();
if($expected == $key) {
  echo file_get_contents('/var/www/private/pubit.data');
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
  $value = cache_get($symbol);
  if($value) {
    return $value;
  } else {
    
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
    
    if(isset($data['results'])) {
      $value = str_replace('.', '', $data['results'][0]['c']);
      return cache_put($symbol, $value);
    } else {
      die("Gah!");
    }
  }
}

function g($array, $key) {
  return array_key_exists($key, $array) ? $array[$key] : false;
}

function cache_get($symbol) {
  $path = "/var/www/private/cache/pubit.$symbol";
  if(file_exists($path)) {
    $today = date('Y-m-d', strtotime('today EST'));
    $data = trim(file_get_contents($path));
    if($data) {
      if(strpos($data, "$today:") === 0) {
        return preg_replace('/^.*:/', '', $data);
      }
    }
  }
  
  return false;
}

function cache_put($symbol, $value) {
  $today = date('Y-m-d', strtotime('today EST'));
  file_put_contents("/var/www/private/cache/pubit.$symbol", "$today:$value");
  return $value;
}
