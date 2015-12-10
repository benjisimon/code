#!/bin/php
<?php
/*
 * Given an arbitrary page of HTML, toss out the junk, but keep as much as possible of the valuable
 * contents (text, links, etc.)
 */

require_once(__DIR__ . '/lib/siteconfig.php');
$cmd = array_shift($argv);

foreach($argv as $f) {
  echo "<!-- File: $f -->\n";
  echo sift($f);
}

?>