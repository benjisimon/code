<?
/*
 * A chunk of PHP code to catch an incoming file that's been posted
 * by Tasker's HTTP Post action
 */

if(isset($_SERVER['CONTENT_TYPE']) && $_SERVER['CONTENT_TYPE'] == 'application/octet-stream') {
  $out_fd = fopen(__DIR__ . "/capture.data", "w");
  $in_fd  = fopen("php://input", "r");
  while($data = fgets($in_fd)) {
    fputs($out_fd, $data);
  }
  echo "saved: " . filesize(__DIR__ . "/capture.data") . "\n";
} else {
  die("malformed request");
}
?>
