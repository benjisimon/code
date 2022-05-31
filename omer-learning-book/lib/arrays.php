<?php
/*
 * A PHP file for working with arrays
 */

function g($array, $key, $default = false){
  if(!is_array($array)) {
    throw new Exception(print_r($array, true) . " is not an array");
  }
  return array_key_exists($key, $array) ? $array[$key] : $default;
}
