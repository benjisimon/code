<?php
/*
 * A PHP file for generating a PDF book with our Omer Learning
 * content.
 */
require_once(getenv("HOME") . "/.config/bitly/profile.php");
require_once(__DIR__ . '/lib/arrays.php');
require_once(__DIR__ . '/lib/bitly.php');
require_once(__DIR__ . '/lib/fpdf.php');
require_once(__DIR__ . '/lib/book.php');

php_sapi_name() == PHP_SAPI || die("Only via cli.");

$fd = fopen(__DIR__ . "/content.csv", 'r');
$headers = fgetcsv($fd);

$book = new Book();

$book->addTitlePage();

while($row = fgetcsv($fd)) {
  $entry = array_combine($headers, $row);
  $book->addEntry($entry);
}

$book->Output('F', __DIR__ . "/book.pdf");
