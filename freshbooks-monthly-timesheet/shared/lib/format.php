<?
/*
 * A library of formatting functions
 */

function fmt_hours($v) {
  $hh = floor($v);
  $mm = floor(($v - $hh) * 60);
  return sprintf("%d:%02d", $hh, $mm);
}

function fmt_date($d) {
  $t = is_numeric($d) ? $d : strtotime($d);
  return date('m/d/Y', $t);
}
