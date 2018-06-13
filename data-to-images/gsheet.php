<?php
/*
 * A PHP file for converting a specific google sheet to images via gd.
 */

$xml = file_get_contents('https://spreadsheets.google.com/feeds/list/1A81v08xokyf5DiXQrVkIjeMc27-wf094a5I4TP4P15g/oy6u2k1/public/full');
$xml = str_replace('gsx:', 'g_', $xml);
$doc = simplexml_load_string($xml);

$img_w       = 1024 * 2;
$img_h       = round($img_w * .75);
$font        = __DIR__ . '/fonts/Gabriola.ttf';
$font_size   = 60;
$line_height = round($font_size * 2);

foreach($doc->entry as $entry) {
  echo $entry->g_page . ":\n";
  $img = imagecreatetruecolor($img_w, $img_h);

  $bg_color   = imagecolorallocate($img, 255, 255, 255);
  $text_color = imagecolorallocate($img, 0, 27, 94);

  imagefilledrectangle($img, 0, 0, $img_w, $img_h, $bg_color);
  $lines      = explode("\n", wordwrap($entry->g_text, 35));
  foreach($lines as $i => $line) {
    add_text($img, $i, count($lines), $line, 
             $font, $font_size, $line_height, $text_color, 
             $img_w, $img_h);
  }

  $qr_dimen = getimagesize($entry->g_qr);
  $qr_img = imagecreatefrompng($entry->g_qr);
  
  imagecopy($img, $qr_img, 20, $img_h - 20 - $qr_dimen[1], 0, 0, $qr_dimen[0], $qr_dimen[1]);
  

  imagepng($img, "output/" . sprintf('%02d', $entry->g_page) . ".png");
  imagedestroy($img);
  echo "\n";
}


function add_text($img, $row, $row_count, $text, $font, $font_size, $line_height, $text_color,
                  $img_w, $img_h) {

  $text_dimen = imagettfbbox($font_size, 0, $font, $text);
  
  $text_w     = $text_dimen[4] - $text_dimen[0];
  $x          = ($img_w - $text_w) / 2;
  $y          = (($img_h - ($row_count * $line_height)) / 2) + ($row * $line_height);

  imagettftext($img, $font_size, 0, $x, $y, $text_color, $font, $text);
  echo "  {$x}x{$y} " . substr($text, 0, 15) . "...\n";
}

?>