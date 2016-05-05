<?
/*
 * Spit out the result of Unix fortune cleaned up and optimized
 * for small UI's
 */
header("Content-Type: text/plain");

$fortune = shell_exec("/usr/bin/fortune -s");
$fortune = str_replace("\t\t--", "  --", $fortune);

echo $fortune;

?>
