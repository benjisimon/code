<?php
/*
 * A PHP file for generating our fake news, which is real news but
 * with fake info applied.
 */
require_once(__DIR__ . '/.auth.php');

$ago = rand(2, 30);
$day = date('Y-m-d', time() - ($ago * (60*60*24)));
$headlines = headlines($day);
?>
<!DOCTYPE html>
<html>
  <head>
    <title>Imaginary Clinton News</title>
    <link href="https://fonts.googleapis.com/css?family=Oswald|Quicksand" rel="stylesheet">
    <style>
     body {
       font-famly: Quicksand;
       color: #333;
     }

     .page {
       max-width: 800px;
       margin: 20px auto;
     }
     
     h1 {
       font-size: 55px;
       text-align: center;
       font-family: Oswald;
       color: #666;
     }

     .refresh {
       text-align: center;
     }
     .refresh a {
       color: white;
       background-color: #444;
       border: 1px solid #222;
       border-radius: 10px;
       padding: 5px 10px;
       font-size: 13px;
     }

     .article {
       margin-bottom: 40px;
     }

    </style>
  </head>

  <body>
    <div class='page'>
      <h1>Imaginary News from <?= $ago ?> Days Ago</h1>
      <p class='refresh'>
        <a href='index.php'>Refresh</a>
      </p>
      <div class='articles'>
        <? foreach($headlines as $h) { ?>
          <? if(stripos($h['title'], 'Trump') === false) { ?>
            <? continue; ?>
          <? } ?>
          <div class='article'>
          <h2><?= imagine($h['title']) ?></h2>
          <p>
            <?= imagine($h['content']) ?>
          </p>
          <a class='source' href='<?= $h['url']?>'><?= $h['url'] ?></a>
          </div>
        <? } ?>
      </div>
    </div>
  </body>
</html>

<?php
function headlines($day) {
  $sources = ['the-washington-post', 'the-washington-times'];
  $qs = [
    'q' => 'trump',
    'sources' => implode(',', $sources),
    'from' => $day,
    'to' => $day,
    'apiKey' => NEWS_API_KEY
  ];

  $ch = curl_init('https://newsapi.org/v2/everything?' . http_build_query($qs));
  curl_setopt($ch, CURLOPT_TIMEOUT, 10);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  $text = curl_exec($ch);
  $info = curl_getinfo($ch);

  if($info['http_code'] == 200) {
    $data = json_decode($text, true);
    return $data['articles'];
  } else {
    return [];
  }
}

function imagine($text) {
  return str_ireplace(['Donald', 'Trump'], 
                      ['<abbr title="Donald">Hillary</abbr>', '<abbr title="Trump">Clinton</abbr>'], 
                      $text);
}
?>
