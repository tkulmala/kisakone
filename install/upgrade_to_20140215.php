<?php
/* Upgrade your database to version 2012.02.15
 *
 * Run this from command line, while in install/ directory.
 */

require_once('../config.php');
require_once('../data/db_init.php');

function Upgrade_20140215() {
  global $settings;

  $source = file_get_contents('upgrade_to_20140215.sql');
  $queries = explode(';', $source);
  $prefix = $settings['DB_PREFIX'];

  foreach ($queries as $query) {
    if (!trim($query))
      continue;
    if (trim($query) == 'SHOW WARNINGS')
      continue;
    $query = str_replace(':', $prefix, $query);
    if (!mysql_query($query)) {
      echo $query, "<br>";
      echo mysql_error(), "\n";
      return false;
    }
  }
  return true;
}

InitializeDatabaseConnection();
Upgrade_20140215();
?>
