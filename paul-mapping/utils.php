<?php
/*
 * A PHP file for being utilities
 */

function g($array, $key, $default = false) {
  return array_key_exists($key, $array) ? $array[$key] : $default;
}

?>
