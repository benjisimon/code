<?
/*
 * Set the mood of my watch.
 */
$feedback = false;
$mood     = false;
$background = '0b3760';
if(!empty($_POST)) {
  if(preg_match('/^#?([A-Fa-f0-9]{6})$/', $_POST['mood'], $matches)) {
    $mood = $background = $matches[1];
    $url = "https://autoremotejoaomgcd.appspot.com/sendmessage?" .
           "key=APA91bHLATsKgcU0GFd9bpfejmouw9PpwFqz7bzLqwuO_LuBYgp9c3XiBHFoOh96yc23iZUEqkuqyairALK13Uwuj7cSzoI8HlAvjJaK8sCwZmCXI7XkUCDVNsdy0B6a0cwDR1v9Zvr-&" .
           "message=mood=:=" . strtolower($mood);
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 8);
    $feedback = "Watch Said: " . curl_exec($ch);
  } else {
    $feedback = "Yeah, not a valid mood. Try again.";
  }
}
?>
<!DOCTYPE html>
<html>
  <head>
    <title>Set The Mood</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <style>
      body {
         background-color: #<?= $background ?>;
      }
      h1 {
        text-align: center;
        color: white;
        font-size: 48px; 
        font-family: Arial;
      }
      form {
        max-width: 400px;
        margin: auto;
        font-size: 24px;
      }
      input {
        display: block;
        width: 100%;
        font-size: 24px;
        margin: 5px 0px;
      }
      pre {
        text-align: center;
        color: #EEE;
        font-style: italic;
      }
      .swatch {
        width: 100px;
        height: 100px;
        margin: 10px auto;
      }
    </style>
  </head>
  <body>
    <h1>Set The Mood</h1>
    <? if($feedback) { ?>
      <pre class='feedback'><?= $feedback?></pre>
    <? } ?>
    <form method='POST' action='mood.php'>
      <input type='text' name='mood'/>
      <input type='submit' value='Go'/>
    </form>
  </body>
</html>
