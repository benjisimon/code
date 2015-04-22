<?
/*
 * Demonstrate easy access to a Google Spreadsheet
 *
 * Before getting into the code, you'll want to:
 * (a) make sure the document is published to the web
 * (b) figure out the worksheet URL by running something like
 */
 //    curl -s 'https://spreadsheets.google.com/feeds/worksheets/[id]/public/full' | xmllint.exe  -format -|\
 //       grep '2006#list' | sed -e 's/^.*href="//' -e '/".*//' 
/*
 * Once you've got the worksheet_url, you can get to work
 */
$worksheet_url = 'https://spreadsheets.google.com/feeds/list/1IR4JAaJWcScBONP4R3O_IbO4ecyVF5kOBEBzoExjM7E/od6/public/full';


$ch   = curl_init($worksheet_url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$xml  = curl_exec($ch);
$doc  = new SimpleXMLElement($xml);
$ns = $doc->getNamespaces(true);
$gsx = $ns['gsx'];


header("Content-Type: text/plain");


$nsamples = 0;
$max = false;
$avg = false;

foreach($doc->entry as $e) {
 $nsamples++;
 if($max === false) {
   $max = array('ts' => $e->children($gsx)->timestamp . "", 
                'val' => $e->children($gsx)->pressure);
 } else {
   if(($e->children($gsx)->pressure . "") > $max['val']) {
     $max['ts']  = $e->children($gsx)->timestamp . "";
     $max['val'] = $e->children($gsx)->pressure . "";
   }
 }
 if($avg === false) {
   $avg = $e->children($gsx)->pressure . "";
 } else {
   $avg = (($e->children($gsx)->pressure . "") + $avg) / 2;
 }
}


echo "Num Samples: $nsamples\n";
echo "Max: {$max['ts']} = {$max['val']}\n";
echo "Avg: $avg\n";


?>
