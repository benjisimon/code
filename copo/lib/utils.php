<?php
/*
 * A PHP file for powering utility functions
 */

function snippet($_name, $_params = array()) {
  extract($_params);
  ob_start();
  require(__DIR__ . "/../snippets/$_name.php");
  $content = ob_get_clean();
  return $content;
}

?>