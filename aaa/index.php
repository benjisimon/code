<?
/*
 * aaa - Asked And Answered. This is a trivial script to pull a question and random
 * answer from a Google Spreadsheet.
 *
 * Inspired by this data: http://kk.org/cooltools/reader-survey-results/
 * Built using this approach: http://www.blogbyben.com/2015/04/slurping-in-google-spreadsheet-data-in.html
 */

// Tweak me to point to a new spreadsheet
define('DATA_URL', 'https://spreadsheets.google.com/feeds/list/1eyDNkv5BfsgzTEQZA5Sprgwj5mjyBhviXX2IN590ux0/o9b8tei/public/full');
define('DATA_COL', 'ifyouweremaroonedonadesertislandafteraplanecrashwhatistheonetoolyoudtakethatcouldpasstsascreening');
define('DATA_QUESTION', "If you were marooned on a desert island after a plane crash, what is the one tool you’d take that could pass TSA screening?");
define('DATA_CACHE_FILE', __DIR__ . '/.data.cache');
define('DATA_CACHE_TTL', 60 * 60 * 24); 
?>
<!DOCTYPE html>
<html>
 <head>
  <title>Asked-And-Answered | <?= DATA_QUESTION ?></title>
  <link href='https://fonts.googleapis.com/css?family=Montserrat|Lobster' rel='stylesheet' type='text/css'>
  <style>
   body { background-color: #15262f; color: #f0f0f0; }
   h1 { color: #0099cc; font-size: 32px; font-family: 'Lobster', cursive; }
   h2 { font-size: 54px; text-align: center; font-family: 'Montserrat', sans-serif;}
   h3 { text-align: center; font-size: 12px; }
   a { color: #006699; }
   .page { margin: 10px auto auto auto; width: 80%; min-width: 200px; }

  </style>
 </head>
 <body>
  <div class='page'>
   <h1><?= DATA_QUESTION ?></h1>
   <h2><?= random_answer(); ?></h2>
   <h3><a href='javascript:location.reload();'>See Another Answer</a> | <A href='http://blogbyben.com'>Built By Ben</a></h3>
  </div>
 </body>
</html>
<?

//
// The Code. Enjoy
//
function cache_data() {
  $fd   = fopen(DATA_CACHE_FILE, "w");
  $ch   = curl_init(DATA_URL);
  curl_setopt($ch, CURLOPT_FILE, $fd);
  curl_setopt($ch, CURLOPT_TIMEOUT, 20);
  curl_exec($ch);
  fclose($fd);
}

function xml_doc() {
  if(!file_exists(DATA_CACHE_FILE) || (filemtime(DATA_CACHE_FILE) + DATA_CACHE_TTL) < time()) {
    cache_data();
  }
  return simplexml_load_file(DATA_CACHE_FILE);
}

function random_answer() {
  $doc = xml_doc();
  $ns = $doc->getNamespaces(true);
  $gsx = $ns['gsx'];
  $index = rand(0, count($doc->entry) - 1);
  $col = DATA_COL;
  $ans = $doc->entry[$index]->children($gsx)->$col;
  return trim($ans) ? $ans : "(None Provided)";
}


?>
