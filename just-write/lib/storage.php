<?php
/*
 * A PHP file for wokring with our storage. I'm experimenting with using
 * flat files here. Just because.
 */


function storage_dir() {
  $abs_path = "/var/www/private/code.benjisimon.com/just-write/";
  if(!is_dir($abs_path)) {
    mkdir($abs_path, 0700, true);
  }

  if(!is_dir($abs_path)) {
    trigger_error("Can't create local storage dir: $abs_path");
  }

  return $abs_path;
}

function the_storage() {
  $storage = new Flatbase\Storage\Filesystem(storage_dir());
  $flatbase = new Flatbase\Flatbase($storage);
  return $flatbase;
}

?>
