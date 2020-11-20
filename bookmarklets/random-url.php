<?php
/*
 * A PHP file for creating a simple interface where you can create a random url
 * bookmarklet
 */
?>
<!DOCTYPE html>
<html>
  <head>
    <title>Random URL Bookmarklet Generator</title>
    <link rel="Stylesheet" type="text/css"
          href="random-url.css?ver=<?= md5_file(__DIR__ . '/random-url.css')?>"/>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

  </head>

  <body>
    <div class="page">
      <p>
        List of URLs:
      </p>

      <textarea id="urls"></textarea>

      <p>
        The bookmarklet:
      </p>
      <input type="text" id="output"/>
    </div>
    <script src="random-url.js?ver=<?= md5_file(__DIR__ . '/random-url.js')?>">
    </script>
  </body>
</html>
