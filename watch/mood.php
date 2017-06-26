<?
/*
 * Set the mood of my watch.
 */
$feedback = false;
$mood     = false;
if(!empty($_POST)) {
  if(preg_match('/^#?([A-Fa-f0-9]{6})$/', $_POST['mood'], $matches)) {
    $mood = $matches[1];
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
    <style>
      body {
         background-color: #0b3760;
      }
      h1 {
        text-align: center;
        color: white;
        font-size: 24px; 
        font-family: Arial;
      }
      form {
        max-width: 400px;
        margin: auto;
      }
      input {
        display: block;
        width: 100%;
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
    <? if($mood) { ?>
      <div class='swatch' style='background-color: #<?= $mood ?>'></div>
    <? } ?>
  </body>
</html>
