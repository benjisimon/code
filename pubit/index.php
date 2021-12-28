<?php
/*
 * A PHP file for publishing content to this server. Done with extreme care, of course.
 */

$body = g($_POST, 'body');
$key  = g($_POST, 'key');

if($key == trim(file_get_contents('/usr/local/etc/pubit.key'))) {
  $path = trim(file_get_contents('/usr/local/etc/pubit.path'));
  file_put_contents($path, $body);
  echo "OK\n";
} else {
  echo "Nope\n";
}



function g($array, $key) {
  return array_key_exists($key, $array) ? $array[$key] : false;
}

