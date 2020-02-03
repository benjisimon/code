<?php
/*
 * A PHP file for experimenting with stuff
 */


?>
<!DOCTYPE html>
<html>
  <head>
    <title>Sandbox time.</title>
  </head>

  <body>


    [[<canvas width="300" height="300"></canvas>]]

    <script
      src="https://code.jquery.com/jquery-3.4.1.min.js"
      integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
      crossorigin="anonymous"></script>
    
    <script>
     var ctx = $('canvas').get(0).getContext('2d');
     ctx.beginPath();
     ctx.moveTo(0, 300);
     ctx.lineTo(300, 0);
     ctx.stroke();
    </script>
  </body>
</html>
