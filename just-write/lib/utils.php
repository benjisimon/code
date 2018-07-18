<?php
/*
 * A PHP file for working with utilities
 */

function g($array, $key, $default = false) {
  return isset($array[$key]) ? $array[$key] : $default;
}

function A() {
  $x = func_get_args();
  return $x;
}

?>
