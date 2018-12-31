<?php
require_once('lib/config.php');
header("Content-Type: text/plain");
$debug = g($_GET, 'debug') == 'on';

($loc  = g($_GET, 'loc')) || die("Must provide location");
($loc  = geocode($loc, ['debug' => $debug]))  || die("Unable to geocode provided location");
($attr = g($_GET, 'attr')) || die("Must provide attribute");
($date = g($_GET, 'd')) || die("Must provide date");
($date = strtotime($date)) || die("Invalidate date provided");

var_dump($loc);
var_dump($attr);
var_dump($date);

?>
