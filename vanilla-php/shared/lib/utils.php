<?php
/*
 * A PHP file for implementing site utilities
 */

function g($array, $key, $default = false) {
  return isset($array[$key]) ? $array[$key] : $default;
}

function A() {
  $array = func_get_args();
  return $array;
}

?>
