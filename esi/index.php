<?php
require('init.php');
?>
<!DOCTYPE html>
  <!--[if lt IE 7 ]> <html lang="fi" class="ie ie6"> <![endif]-->
  <!--[if IE 7 ]>    <html lang="fi" class="ie ie7"> <![endif]--> 
  <!--[if IE 8 ]>    <html lang="fi" class="ie ie8"> <![endif]--> 
  <!--[if IE 9 ]>    <html lang="fi" class="ie ie9"> <![endif]--> 
  <!--[if (gt IE 9)|!(IE)]><!--> <html lang="fi"> <!--<![endif]-->
  <head>
    <?php
    $title_text = (!empty($folder) ? $folder : '');
    $title_text = explode('/', $title_text);
    ?>
    <title><?php echo $title_text[1]?></title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta content="147925155254978" property="fb:app_id">
    <link rel="stylesheet" href="uutiset/css/styles.css" />
    <?php
    foreach ($css as $file) {
      echo '<link rel="stylesheet" href="' . $file . '" />';
    }
    ?>
    <script src="uutiset/js/script.head.min.js"></script>
  </head>
  <body class="article <?php if ($wide) echo 'wide' ?> uutiset" data-articleid="123456">
    <div id="container">
      <article class="content">
        <header>
          <div class="hgroup">
            <span class="meta">
              <a href="http://yle.fi/uutiset/">Osasto</a> 
              <time datetime="2013-02-01T12:00:00+02:00">1.2.2013 klo 12:00</time>
            </span>
            <h1>ESI-upotukset</h1>
            <h2>Ohjeistus ulkopuolisten toteutuksien upottamiseen</h2>
            <ul class="some">
              <?php
                if ($some) {
                ?>
                <li class="facebook">
                  <div id="fb-root"></div>
                  <div class="fb-like" data-href="" data-send="false" data-show-faces="false" data-action="recommend" data-font="arial"></div>
                </li>
                <?php
              }
              ?>
            </ul>
          </div>
        </header>
        <div class="text">
          <?php
          if (!empty($html) && $position == 'before') {
            require_once($html);
          }
          else {
            ?>
            <strong>NO FILENAME GIVEN</strong><br /><br />
            <?php
          }
          ?>
          <p>Tästä alkaa artikkelin leipäteksti, jonka toimittaja tekee Escenicin kautta. Toimittaja voi <u>alleviivata</u>, <strong>lihavoida</strong> tai <em>kursivoida</em> tekstiä. Myös <sup>ylä</sup>- ja <sub>alaviitteen</sub> tekeminen onnistuu.</p>

          <h3>Väliotsikko</h3>
          <blockquote>
            <p class="quote">
              Artikkelissa voi olla lainauksia
            </p>
            <p class="author">
            - Teemo Tebest
            </p>
          </blockquote>

          <p>Toimittaja voi tehdä leipätekstin sekaan kahdentyyppisiä listoja:</p>

          <ul>
            <li>Lorem ipsum dolor sit amet</li>
            <li>Quisque purus lectus</li>
            <li>Dui enim adipiscing lacus sit amet sagittis</li>
          </ul>

          <ol>
            <li>Lorem ipsum dolor sit amet</li>
            <li>Quisque purus lectus</li>
            <li>Dui enim adipiscing lacus sit amet sagittis</li>
          </ol>

          <p>Artikkelin leipäteksti loppuu tähän.</p>

          <?php
          if (!empty($html) && $position == 'after') {
            require_once($html);
          }
          else {
            ?>
            <strong>NO FILENAME GIVEN</strong><br /><br />
            <?php
          }
          ?>     
        </div>
        <footer>
          <dl class="source">
            <dt>Lähteet:</dt>
            <dd>Yle Uutiset</dd>
          </dl>
          <section class="more-on-this-topic">
            <h1>Lisää aiheesta</h1>
            <div>
              <article>
                <h1><a href="http://yle.fi/uutiset/nain_moni_tienaa_vahemman_kuin_sina_-_kokeile_itse/6358393">Näin moni tienaa vähemmän kuin sinä - kokeile itse</a></h1> <span class="meta"><time datetime="2012-11-01T06:00:46+02:00">1.11.2012</time></span>
              </article>
              <article>
                <h1><a href="http://yle.fi/urheilu/visualisointi_nain_suomalaiset_ovat_paenneet_nhln_tyosulkua_-_kuka_on_ollut_tehokkain/6385253">Visualisointi: Näin suomalaiset ovat paenneet NHL:n työsulkua - kuka on ollut tehokkain?</a></h1> <span class="meta"><time datetime="2012-11-21T13:18:07+02:00">21.11.2012</time></span>
              </article>
            </div>
          </section>
          <ul class="writers">
            <li class="with-image">
              <img alt="Oskari Blomberg" src="http://img.yle.fi/uutiset/incoming/article6500619.ece/ALTERNATES/w60h60/teemo+tebest.JPG">
              <span class="author">Teemo Tebest</span>
              <span class="organization">Yle Uutiset</span>
            </li>
          </ul>
          <ul class="some">
            <?php
            if ($some) {
              ?>
              <li class="facebook">
                <a target="_blank" class="lite" href="https://facebook.com">
                  <span>Jaa</span>
                </a>
                <div id="fb-root"></div>
                <div class="fb-like" data-href="" data-send="false" data-layout="button_count" data-show-faces="false" data-action="recommend" data-font="arial"></div>
              </li>
              <li class="google">
                <a class="lite" href="https://plus.google.com" target="_blank">G+</a>
                <div class="g-plusone" data-size="medium" data-href=""></div>
              </li>
              <li class="twitter">
                <a class="lite" href="https://twitter.com/" target="_blank">
                  <span>Twiittaa</span>
                </a>
                <a href="https://twitter.com/share" class="twitter-share-button" data-url="" data-lang="fi">Twiittaa</a>
              </li>
              <?php
            }
            ?>
          </ul>
        </footer>
      </article>
    </div>
    <script src="http://yle.fi/global/player/embed.js?autoEmbed=false"></script>
    <script src="uutiset/js/script.tail.min.js"></script>
    <?php
    foreach ($js as $file) {
      echo '<script src="' . $file . '"></script>';
    }
    ?>
  </body>
</html>