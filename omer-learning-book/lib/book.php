<?php
define('FPDF_FONTPATH', __DIR__ . '/../fonts/');

/*
 * A PHP file for generating books
 */
class Book extends FPDF {

  private $styles;
  private $current_style;



  function __construct() {
    parent::__construct('P', 'pt', 'letter');
    $this->AddFont('oswald', 'b', 'Oswald-Bold.php');
    $this->AddFont('aller', '', 'Aller_Rg.php');

    $this->styles = [
      'default' => ['helvetica', '', 12, [0, 0, 0]],
      'book_title' => ['oswald', 'b', 48, [13, 49, 95]],
      'book_subtitle' => ['aller', '', 36, [86, 135, 194]],
      'h1' => ['oswald', 'b', 16, [13, 49, 95]],
      'h2' => ['aller', '', 10, [0, 0, 0]],
      'link' => ['aller', '', 12, [0, 0, 0]]
    ];
    $this->setStyle('default');
  }


  public function addTitlePage() {
    $this->AddPage();
    $this->SetY(72 * 2);
    $this->withStyle('book_title', function() {
      $this->Cell(0, 55, "49 Days to Greener and", 0, 2, 'C');
      $this->Cell(0, 55, "More Equitable Community", 0, 2, 'C');
    });

    $this->Ln(72);

    $this->withStyle('book_subtitle', function() {
      $this->Cell(0, 12, "Omer Learning 2022", 0, 2, 'C');
    });

    $this->Ln(72 * 4);
    $this->Image(__DIR__ . "/../images/logo.png", 72 * 3);
    $this->AddPage();
  }

  public function addEntry($entry) {
    $this->withStyle('h1', function() use($entry){
      $this->Cell(0, 16, $entry['The Count'], 0, 2);
    });

    $this->withStyle('h2', function() use($entry) {
      $this->Cell(0, 20, $entry['Topic'], 0, 2);
    });

    $y_before = $this->GetY();

    $this->SetLeftMargin(45);
    $this->SetRightMargin(45);
    $this->MultiCell(0, 16, $this->scrub($entry['Content']), 0, 'L');
    $this->SetLineWidth(3);
    $this->SetDrawColor(200, 200, 200);

    if($url = trim($entry['Learn More'])) {
      $short_url = bitly_shrink($url);
      $label = str_replace('https://', '', $short_url);
      $text = "Read More at $label";
      $this->Ln();
      $this->Cell($this->GetStringWidth($text), 14, $text, '', 2, 'C', false, $url);
    }
    $y_after = $this->GetY();
    $this->SetLeftMargin(36);
    $this->SetRightMargin(36);

    if($y_before < $y_after) {
      $this->Line(40, $y_before, 40, $y_after);
    }

    $this->Ln();
    $this->Ln();
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
      '”' =>  '”'
    ];

    return str_replace(array_keys($fixes), array_values($fixes), $text);
  }
}
