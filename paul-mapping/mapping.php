<?php
/*
 * A PHP file for working with mapping functions
 */

function parse_data($data) {
  return array_map(function($row) {
    $cols = array_map('trim', explode(",", $row));
    return [
      'heading' => g($cols, 0),
      'distance' => g($cols, 1),
      'notes' => g($cols, 2)
    ];
  }, array_filter(array_map('trim', explode("\n", $data))));
}

function add_xy($data) {

  $points = [
    [ 'heading' => 0,
      'distance' => 0,
      'notes' => 'Start',
      'x' => 0,
      'y' => 0 ]
  ];

  foreach($data as $i => $row) {
    $last_point = $points[count($points) - 1];
    $rad = deg2rad($row['heading']);
    $walked_x = round($row['distance'] * cos($rad), 1);
    $walked_y = round($row['distance'] * sin($rad), 1);
    $row['x'] = $last_point['x'] + $walked_x;
    $row['y'] = $last_point['y'] + $walked_y;

    $points[] = $row;
  }

  return $points;
}

function normalize_xy($points) {
  $min_x = array_reduce($points, function($carry, $point) {
    return min($carry, $point['x']);
  }, 0);

  $min_y = array_reduce($points, function($carry, $point) {
    return min($carry, $point['y']);
  }, 0);

  $x_padding = abs($min_x);
  $y_padding = abs($min_y);
  foreach($points as $i => $point) {
    $points[$i]['x'] += $x_padding;
    $points[$i]['y'] += $y_padding;
  }

  $max_x = $max_y = 0;
  foreach($points as $i => $p) {
    $max_x = max($max_x, $p['x']);
    $max_y = max($max_y, $p['y']);
  }

  foreach($points as $i => $p) {
    $points[$i]['max_x'] = $max_x;
    $points[$i]['max_y'] = $max_y;
  }

  return $points;
}

?>
