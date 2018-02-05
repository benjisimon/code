<?php
/*
 * A PHP file for reading in a data file from hebcal:
 *  https://www.hebcal.com/sedrot/
 * and adding extra info, like the verse count
 */

if(count($argv) == 0 || !file_exists($argv[1])) {
  echo "Usage: {$argv[0]} input.csv\n";
  exit();
}

function lookup_verse_count($book, $chapter) {
  $book = str_replace(' ', '_', $book);
  $ch = curl_init("https://www.sefaria.org/api/texts/$book.$chapter");
  curl_setopt($ch, CURLOPT_TIMEOUT, 4);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  $info = curl_exec($ch);
  if($info === false) {
    echo "Failed to lookup verse count for $book $chapter: " . curl_error($ch);
    var_dump(curl_getinfo());
    exit();
  }
  $details = json_decode ($info, true);
  return count($details['text']);
}

$input_fd = fopen($argv[1], "r");
$output_fd = fopen("php://stdout", "w");

while($row = fgetcsv($input_fd)) {
  if(count($row) == 5 && $row[4] == '' && 
     preg_match('/([A-Z].*?) ([0-9]+):([0-9]+) - ([0-9]+):([0-9]+)/', $row[3], $matches)) {
    $book          = $matches[1];
    $start_chapter = $matches[2];
    $start_verse   = $matches[3];
    $end_chapter   = $matches[4];
    $end_verse     = $matches[5];

    if($start_chapter == $end_chapter) {
      $row[4] = $end_verse - $start_verse + 1;
    } else if($start_chapter < $end_chapter) {
      $verses = lookup_verse_count($book, $start_chapter) - $start_verse + 1;
      for($c = $start_chapter + 1; $c < $end_chapter; $c++) {
        $verses += lookup_verse_count($book, $c);
      }
      $row[4] = $verses + $end_verse;
    } else {
      echo "Don't know how to compute verse count\n";
      var_dump($matches);
      die();
    }

  }
    
  fputcsv($output_fd, $row);


}
?>