<?php
/*
 * A PHP file for implementing helper code to work with the 
 * google photos api
 */
use Google\Photos\Library\V1\PhotosLibraryClient;
use Google\Photos\Library\V1\Filters;
use Google\Photos\Library\V1\FiltersBuilder;
use Google\Photos\Library\V1\DateFilter;
use Google\Type\Date;


function photo_date_search($date, $options = []) {
  $client = new PhotosLibraryClient(['credentials' => $_SESSION['pics_credentials']]);

  $builder = new FiltersBuilder();
  $builder->addDate(new Date($date));
  
  $response = $client->searchMediaItems(['filters' => $builder->build(),
                                         'pageSize' => g($options, 'limit', 20)]);
  return $response->getPage();
}
