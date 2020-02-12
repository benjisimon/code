<?php
/*
 * A PHP file for holding onto utility functions
 */

function g($array, $key, $default = false) {
  return array_key_exists($key, $array) ? $array[$key] : $default;
}

?>
