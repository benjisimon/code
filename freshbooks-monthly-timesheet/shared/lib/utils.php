<?
/*
 * Generic utility code goes here.
 */

function A() {
  $array = func_get_args();
  return $array;
}

function g($array, $key, $default = false) {
  return isset($array[$key]) ? $array[$key] : $default;
}

function hop() {
  $args = func_get_args();
  $obj  = array_shift($args);
  if(!is_array($obj)) {
    trigger_error("hop passed a non-array arg: " . print_r($obj, true), E_USER_ERROR);
  }
  foreach($args as $attr) {
    if(isset($obj[$attr])) {
      $obj = $obj[$attr]; 
    } else {
      trigger_error("Attr [$attr] not found in " . print_r($obj, true), E_USER_ERROR);
    }
  }
  return $obj;
}

?>
