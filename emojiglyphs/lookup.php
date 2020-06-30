<?php
/*
 * A PHP file for looking up emjois in our dictionary
 */

require_once(__DIR__ . '/lib/utils.php');
require_once(__DIR__ . '/lib/emoji.php');

$term = g($_GET, 'term');

$found = array_map(function($e) { return $e['html']; },
                  best_emoji($term));

header("Content-Type: application/json");
echo json_encode($found);

?>
