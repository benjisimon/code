<?
/*
 * Spit out a random Piet Hein poem.
 *
 * Source: http://www.sophilos.net/GrooksofPietHein.htm
 */
header("Content-Type: text/plain");

$poems = explode("--", file_get_contents(__DIR__ . "/poems.txt"));

echo trim($poems[array_rand($poems)]) . "\n";
