<?php
// Whether to use the wide layout.
$wide = !empty($_GET['w']) ? TRUE : FALSE;
// Whether to use the show some buttons layout.
$some = !empty($_GET['s']) ? TRUE : FALSE;
// Whether to show the vis before or after.
$position = 'before';
// Get the user defined folder.
$folder = !empty($_GET['f']) ? ($_GET['f']): FALSE;
if ($folder != FALSE) {
  // Remove possible trailing slahs.
  $folder = rtrim($folder, '/');

  // Get user defined html, css and js parameters if available.
  // Otherwise use default values.
  $filenames = glob($folder . '/*.html');
  $html = !empty($_GET['h']) ? $folder . '/' . ($_GET['h']) : $filenames[0];
  // Handle css.
  file_exists ('./' . $folder . '/styles.php') ? require_once('./' . $folder . '/styles.php') : $css = array($folder . '/css/styles.css');
  // Handle javascript.
  file_exists ('./' . $folder . '/script.php') ? require_once('./' . $folder . '/script.php') : $js = array($folder . '/js/script.js');
}
else {
  $css = array();
  $js = array();
  $html = '';
}
?>