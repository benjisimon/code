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
      'book_title' => ['oswald', 'b', 24, [60, 60, 60]],
      'book_subtitle' => ['aller', '', 18, [0, 0, 0]],
      'h1' => ['oswald', 'b', 16, [90, 90, 90]],
      'h2' => ['aller', '', 14, [0, 0, 0]],
      'link' => ['aller', '', 12, [0, 0, 0]]
    ];
    $this->setStyle('default');
  }


  public function addTitlePage() {
    $this->AddPage();
    $this->withStyle('book_title', function() {
      $this->Cell(0, 12, "49 Days to Greener and More Equitable Community", 0, 2);
    });

    $this->withStyle('book_subtitle', function() {
      $this->Cell(0, 12, "Omer Learning 2022", 0, 2);
    });
    $this->AddPage();
  }

  public function addEntry($entry) {
    $this->withStyle('h1', function() use($entry){
      $this->Cell(0, 12, $entry['The Count'], 0, 2);
    });

    $this->withStyle('h2', function() use($entry) {
      $this->Cell(0, 12, $entry['Topic'], 0, 2);
    });

    $this->MultiCell(0, 12, $entry['Content'], 1, 'L');

    $this->withStyle('link', function() use($entry) {
      if($url = trim($entry['Learn More'])) {
        $short_url = bitly_shrink($url);
        $label = str_replace('https://', '', $short_url);
        $text = "Learn More at $label";
        $this->Cell($this->GetStringWidth($text), 14, $text, 'B', 2, 'C', false, $url);
      }
    });
    $this->Ln();
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

}
