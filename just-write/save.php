<?php
/*
 * A PHP file for saving our database entry
 */
require_once('lib/siteconfig.php');

$db = the_storage();

$db->insert()->in('test')->set(['access' => time(), 'foo' => g($_GET, 'foo')])->execute();

var_dump($db->read()->in('test')->get());
?>
