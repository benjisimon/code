<?php
/*
 * Generate a life calendar per https://www.ted.com/talks/tim_urban_inside_the_mind_of_a_master_procrastinator
 */

$num_weeks = 90 * 52;

?>
<!DOCTYPE html>
<html>
 <head>
  <title>Life Calendar | Enjoy the Panic Monster</title>
  <link href='https://fonts.googleapis.com/css?family=Slabo+27px' rel='stylesheet' type='text/css'>
  <link href='https://fonts.googleapis.com/css?family=Montserrat' rel='stylesheet' type='text/css'>
  <link rel="stylesheet" href="style.css" type="text/css"/>
 </head>
 <body>
  <form class='page'>
   <p>
     Inspired by Tim Urban's <A href='https://www.ted.com/talks/tim_urban_inside_the_mind_of_a_master_procrastinator'>TED Talk</a>, I give you, your Life Calendar.
     Trust me, one day you'll thank me for this.
   </p>
   <p>
    Your birthday:
    <input type='text' placeholder='MM/DD/YYYY' id='dob'/> <input type='button' value='refresh'/>
   </p>

   <div class='calendar'>
     <? for($i = 0; $i < $num_weeks; $i++) { ?>
       <? $r = floor(floor($i / 52) / 10); ?>
       <div class='w w<?= $i ?> r<?=$r?>'></div>
     <? } ?>
     <div class='clear'></div>
   </div>
  </form>
  <script src='shared/js/jquery-1.12.2.min.js'></script>
  <script src='shared/js/moment.min.js'></script>
  <script src='js/ui.js?xcache=<?= filemtime("js/ui.js"); ?>'></script>
 </body>
</html>
