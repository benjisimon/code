<?php
/*
 * A PHP file for reading in a rtl_power CSV file and printing out any blips
 */
if(count($argv) != 2) {
  echo "Usage: php -f {$argv[0]} data.csv\n";
  exit;
}

$last_snap      = array();
$data_col_start = 6;
$blip_threshold = 6;
$fd             = fopen($argv[1], "r");


while($row = fgetcsv($fd)) {
  $row = array_map('trim', $row);

  for($col_i = $data_col_start; $col_i < count($row); $col_i++) {
    $bin  = $col_i - $data_col_start;
    $freq = number_format(($row[2] + ($row[4] * $bin)) / 1000000, 4);
    $level = $row[$col_i];

    if(isset($last_snap[$freq])) {
      $diff = abs($last_snap[$freq] - $level);
      if($diff > $blip_threshold) {
        echo "$freq:$bin:$diff:$level\n";
      }
    }

    $last_snap[$freq] = $level;
  }
}

?>