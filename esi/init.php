<?php
  $full = isset($_GET['full']) ? true : false;
  $wide = isset($_GET['wide']) ? true : false;
  // Whether to use the show some buttons layout.
  $some = isset($_GET['s']) ? true : false;
  // Whether to show the vis before or after.
  $position = isset($_GET['p']) ? $_GET['p'] : 'before';

  // Get version. This is from preventing cache.
  $version = isset($_GET['v']) ? $_GET['v'] : '';
  // Get the user defined folder.
  $folder = isset($_GET['f']) ? $_GET['f'] : false;
  if ($folder) {
    // Remove possible trailing slash.
    $folder = rtrim($folder, '/');
    // Get user defined html, css and js parameters if available.
    // Otherwise use default values.
    if (isset($_GET['h'])) {
      $html = array($folder . '/' . $_GET['h']);
    }
    else {
      $html = glob($folder . '/index.*');
    }
    if (file_exists('./' . $folder . '/init.php')) {
      require_once('./' . $folder . '/init.php');
    }
    else {
      $css = array($folder . '/css/styles.css?v=' . $version);
      $js = array($folder . '/js/script.js?v=' . $version);
    }
  }
  else {
    $css = array();
    $js = array();
    $html = array();
  }
?>