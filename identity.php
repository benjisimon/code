<?php
/*
 * A PHP file for spitting out what was sent in
 */
header("Content-Type: application/json");

echo json_encode([
  'GET' => $_GET,
  'POST' => $_POST,
  'COOKIE' => $_COOKIE
]);
