<?php
/*
 * A PHP file for implementing our snippet or HTML template
 * capability
 */


function snippet($_name, $_params = array()) {
  ob_start();
  extract($_params);
  require(__DIR__ . "/../../snippets/{$_name}.php");
  return ob_get_clean();
}


$_snippet_stack = A();
global $_snippet_stack;
function start_snippet($name, $params = array()) {
  global $_snippet_stack;

  array_push($_snippet_stack, array('name' => $name, 'params' => $params));
  ob_start();
}

function end_snippet() {
  global $_snippet_stack;
  
  $body = ob_get_clean();
  $snippet = array_pop($_snippet_stack);
  return snippet($snippet['name'], $snippet['params'] + array('body' => $body));
}


?>
