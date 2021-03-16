<!DOCTYPE html>
<html>
 <head>
  <title>WriteOnly</title>
  <script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
  <link rel="Stylesheet" href="layout.css" type="text/css"/>
 </head>
 <body>
  <div class='feedback'></div>
  <div class='writeonly' tabindex="1">_</div>
  <div class='footer'>
   By <a href='http://blogbyben.com'>Ben</a>
  </div>
  <script src="writeonly.js?ver=<?= md5_file(__DIR__ . "/writeonly.js")?>"></script>
 </body>
</html> 
