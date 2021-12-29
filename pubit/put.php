<?php
/*
 * A PHP file for publishing content to this server. Done with extreme care, of course.
 */

$body = g($_POST, 'body');
$key  = g($_POST, 'key');
$path = '/var/www/private/pubit.data';

if($key == trim(file_get_contents('/usr/local/etc/pubit.key'))) {
  file_put_contents($path, $body);
  echo "OK\n";
} else {
  echo "Nope\n";
}



function g($array, $key) {
  return array_key_exists($key, $array) ? $array[$key] : false;
}

