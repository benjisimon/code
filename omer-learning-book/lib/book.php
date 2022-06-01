<?php
define('FPDF_FONTPATH', __DIR__ . '/../fonts/');

/*
 * A PHP file for generating books
 */
class Book extends FPDF {

  private $styles;
  private $current_style;
  private $margins = [
    'top' => 72,
    'bottom' => 72,
    'right' => 36,
    'left' => 36
  ];


  function __construct() {
    parent::__construct('P', 'pt', 'letter');
    $this->AddFont('oswald', 'b', 'Oswald-Bold.php');
    $this->AddFont('aller', '', 'Aller_Rg.php');

    $this->styles = [
      'default' => ['helvetica', '', 12, [0, 0, 0]],
      'book_title' => ['oswald', 'b', 48, [13, 49, 95]],
      'book_subtitle' => ['aller', '', 36, [86, 135, 194]],
      'thanks_intro' => ['oswald', 'b', 16, [0, 0, 0]],
      'h1' => ['oswald', 'b', 16, [13, 49, 95]],
      'h2' => ['aller', '', 10, [0, 0, 0]],
      'link' => ['aller', '', 12, [0, 0, 0]]
    ];
    $this->setStyle('default');
    $this->AddPage();

    $this->SetMargins($this->margins['left'], $this->margins['top'], $this->margins['right']);
    $this->SetAutoPageBreak(true, $this->margins['bottom']);
  }


  public function addTitlePage() {
    $this->SetY(72 * 2);
    $this->withStyle('book_title', function() {
      $this->Cell(0, 55, "49 Days to Greener and", 0, 2, 'C');
      $this->Cell(0, 55, "More Equitable Community", 0, 2, 'C');
    });

    $this->Ln(72);

    $this->withStyle('book_subtitle', function() {
      $this->Cell(0, 12, "Omer Learning 2022", 0, 2, 'C');
    });

    $this->Ln(72 * 3);
    $this->Image(__DIR__ . "/../images/logo.png", 72 * 3);
    $this->AddPage();
  }

  public function addThanksPage() {
    $this->withStyle('thanks_intro', function() {
      $this->Cell(0, 24, "Special thanks to this year's contributors", 0, 1, 'C');
    });

    $fd = fopen(__DIR__ . '/../data/contributors.csv', 'r');
    while($row = fgetcsv($fd)) {
      $this->Cell(0, 20, $row[0], 0, 1, 'C');
    }

    $this->AddPage();
  }

  public function withSmartBreak($generator) {

    $scratchpad = new Book();
    $generator($scratchpad);
    $height = $scratchpad->GetY();
    $remaining = $this->GetPageHeight() - $this->GetY() - $this->margins['bottom'];

    if($height > $remaining) {
      $this->AddPage();
    }

    $generator($this);
  }

  function withIndent($size, $generator) {
    $this->SetX($this->margins['left']+ $size);
    $generator();

    $this->SetX($this->margins['left']);
  }

  public function addEntry($entry) {
    $this->withSmartBreak(function($book) use($entry) {
      $book->withStyle('h1', function() use($entry,$book){
        $book->Cell(0, 16, $entry['The Count'], 0, 2);
      });

      $book->withStyle('h2', function() use($entry, $book) {
        $book->Cell(0, 20, $entry['Topic'], 0, 2);
      });

      $y_before = $book->GetY();

      $this->withIndent(15, function() use($book, $entry) {
        $book->MultiCell(0, 16, $book->scrub($entry['Content']), 0, 'L');
      });

      $this->Ln();

      $this->withIndent(15, function() use ($book, $entry) {
        if($url = trim($entry['Learn More'])) {
          $short_url = bitly_shrink($url);
          $label = str_replace('https://', '', $short_url);
          $text = "Read More at $label";
          $book->Cell($book->GetStringWidth($text), 14, $text, '', 2, 'C', false, $url);
        }
      });

      $y_after = $book->GetY();

      if($y_before < $y_after) {
        $book->SetLineWidth(3);
        $book->SetDrawColor(200, 200, 200);
        $book->Line($this->margins['left'] + 4, $y_before, $this->margins['left'] + 4, $y_after);
      }
      $book->Ln();
      $book->Ln();
    });
  }

  public function setStyle($name) {
    $this->current_style = $name;
    $this->SetFont($this->styles[$name][0],
                   $this->styles[$name][1],
                   $this->styles[$name][2],);
    [$r,$g,$b] = $this->styles[$name][3];
    $this->SetTextColor($r, $g, $b);
  }

  public function withStyle($style, $thunk) {
    $before = $this->current_style;
    $this->setStyle($style);
    $thunk();
    $this->setStyle($before);
  }

  private function scrub($text) {
    $fixes = [
      "’" => "'",
      '“' =>  '"',
      '”' =>  '"',
      '–' => '-',
    ];

    return str_replace(array_keys($fixes), array_values($fixes), $text);
  }
}
