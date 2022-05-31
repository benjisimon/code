<?php
define('FPDF_FONTPATH', __DIR__ . '/../fonts/');

/*
 * A PHP file for generating books
 */
class Book extends FPDF {

  function __construct() {
    parent::__construct('P', 'pt', 'letter');
    $this->SetFont('Helvetica');
  }


  public function addTitlePage() {
    $this->AddPage();
    $this->Cell(0, 12, "49 Days to Greener and More Equitable Community", 0, 2);
    $this->Cell(0, 12, "Omer Learning 2022", 0, 2);
    $this->AddPage();
  }

  public function addEntry($entry) {
    $this->Cell(0, 12, $entry['The Count'], 0, 2);
    $this->Cell(0, 12, $entry['Topic'], 0, 2);
    $this->MultiCell(0, 12, $entry['Content']);
    if($url = trim($entry['Learn More'])) {
      $short_url = bitly_shrink($url);
      $this->Cell(0, 12, "Learn More at " . $short_url);
    }
    $this->Ln();
    $this->Ln();
    $this->Ln();
  }

}
