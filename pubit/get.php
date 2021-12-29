<?php
/*
 * A PHP file for displaying our pubit.data
 */
header("Content-Type: text/plain");

$key = g($_GET, 'key');

if(strlen($key) >= 8 && strpos(current_key(), $key) === 0) {
  echo file_get_contents('/var/www/private/pubit.data');
} else {
  echo "Nope";
}


function current_key() {
  $url = 'http://rss.cnn.com/rss/cnn_topstories.rss';
  $buffer = file_get_contents($url);
  $xml = simplexml_load_string($buffer);
  $item = $xml->channel->item[0];
  $u = parse_url($item->link . "");
  $path = explode('/', $u['path']);
  array_pop($path);
  return array_pop($path);
}

function g($array, $key) {
  return array_key_exists($key, $array) ? $array[$key] : false;
}
