<?php
/*
 * A PHP file for dumping out our database. For testing.
 */
header("Content-Type: text/plain");
require_once('lib/siteconfig.php');

die("Disabled.");

$s = the_storage();

$entries = $s->read()->in('entries')->get();

foreach($entries as $e) {
  echo date('c', $e['created']) . "\n";
  var_dump($e);
  echo "\n\n\n\n";
}
?>