<?php

$f = __DIR__ . '/params.txt';
$fd = fopen($f, "a+");

fputs($fd, date('r') . "\n");
foreach(array('POST' => $_POST, 'GET' => $_GET, 'SERVER' => $_SERVER) as $name => $vars) {
  fputs($fd, "$name\n");
  fputs($fd, print_r($vars, true));
  fputs($fd, "\n\n");
}
echo "OK";
?>
