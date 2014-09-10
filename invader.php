<?
/*
 * Some code to explore: http://www.levitated.net/daily/levInvaderFractal.html
 */

function cell($y,$x) {
  return "<div class='cell' pos='p-$x-$y'></div>";
}

function shell() {
  $cells = array();
  for($row = 0; $row < 5; $row++) {
    for($col = 0; $col < 5; $col++) {
      $cells[] = cell($row, $col);
    }
  }  
  return "<div class='invader'>" . implode("\n", $cells) . "<div class='clear'></div></div>";
}
?>
<!DOCTYPE html>
<html>
  <head>
    <title>Invader</title>
    <script type='text/javascript' src='//code.jquery.com/jquery-2.1.1.min.js'></script>
    <script type='text/javascript' src='//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.6.0/underscore-min.js'></script>
    <style>
      .invader {
        width: 100px;
        border: 1px solid #666;
        cursor: pointer;
        float: left;
        margin: 0px 10px 10px 0px;
      }

      .cell {
        width: 20px;
        height: 20px;
        float: left;
      }
      .cell.on {
        background-color: #DD0000;
      }
      .clear { clear: both; }
    </style>
  </head>
  <body>
   <p>
    This code implments this very slick <A href='http://www.levitated.net/daily/levInvaderFractal.html'>concept</a>. All credits goes to
    that author.
   </p>
   <script type='text/javascript'>
     function rand(min,max) {
       return Math.floor(Math.random()*(max-min+1)+min);
     }
     // Generate the invader's DNA
     function dna() {
       var n = rand(1, 15);
       var seq = _.map(_.range(0, 15), function() { return false; });
       for(var i = 0; i < n; i++) {
         seq[rand(0,14)] = true;
       }
       return seq;
     }

     function render(root, seq) {
       var nrows = 5;
       var ncols = 3;
       for(var row = 0; row < nrows; row++) {
         for(var col = 0; col < ncols ;col++) {
           var index = (row * ncols) + col;
           var cssClass = seq[index] ? "on" : "";
           var xPos1 = 2 - col;
           var xPos2 = 2 + col;
           var yPos  = row;
           $(root).find('.cell[pos=p-' + xPos1 + '-' + yPos + ']').removeClass('on').addClass(cssClass);
           $(root).find('.cell[pos=p-' + xPos2 + '-' + yPos + ']').removeClass('on').addClass(cssClass);
         }
       }
     }


     $(document).ready(function() {
       function spawn() {
         $('.invader').each(function() { render(this, dna()); });
       }

       spawn();
       setInterval(spawn, 1000);
     });
   </script>

   <? for($i = 0; $i < 300; $i++) { ?>
     <?= shell(); ?>
   <? } ?>

  </body>
</html> 
