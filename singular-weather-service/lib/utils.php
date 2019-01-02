<?php
/*
 * A PHP file for implementing various utilities
 */

function g($array, $key, $default = false) {
  if(is_array($key)) {
    if(count($key) == 1) {
      return g($array, $key[0], $default);
    } else {
      $next_key = array_shift($key);
      if(is_array($next_array = g($array, $next_key))) {
        return g($next_array, $key, $default);
      }
    }
  } else {
    return isset($array[$key]) ? $array[$key] : $default;
  }
}

function strtotime_tz($text, $tz) {
  $orig_tz = date_default_timezone_get();
  date_default_timezone_set($tz);
  $t = strtotime($text);
  date_default_timezone_set($orig_tz);
  return $t;
}

?>
