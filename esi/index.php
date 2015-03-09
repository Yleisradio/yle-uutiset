<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
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
    $folder = explode('/', $folder);
    ?>
    <title><?=!empty($folder[1]) ? $folder[1] : 'No filename given'; ?></title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta content="147925155254978" property="fb:app_id">
    <link rel="stylesheet" href="uutiset/css/styles.css" />
    <link rel="stylesheet" href="http://yle.fi/global/api/load.php?version=5&amp;modules=css/headerfooter,css/wide" />
    <?php
    if ($full) {
      ?>
      <style type="text/css">
        .article #container {
          margin-bottom: 0;
          max-width: 100%;
          width: 100%;
        }
        .article #container .content {
          margin-bottom: 0;
          max-width: 100%;
          width: 100%;
        }
        .article #container .permanent {
          display: none !important;
        }
        .article .content>.text figure {
          margin-bottom: 0;
        }
      </style>
      <?php
    }
    foreach ($css as $file) {
      echo '<link rel="stylesheet" href="' . $file . '" />';
    }
    ?>
    <script src="uutiset/js/script.head.min.js"></script>
  </head>
  <body class="article <?php if ($wide) echo 'wide' ?> <?php if ($full) echo 'full' ?> uutiset" data-articleid="123456">
    <?php
    include('uutiset/html/header.html');
    ?>
    <div id="container">
      <article class="content">
        <?php
        if (!$full) {
          ?>
          <header>
            <div class="hgroup">
              <span class="meta">
                <a href="http://yle.fi/uutiset/">Osasto</a> 
                <time datetime="2013-02-01T12:00:00+02:00">1.2.2013 klo 12:00</time>
              </span>
              <h1>Otsikko</h1>
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
          <?php
        }
        ?>
        <div class="text">
          <?php
          if ($html && $position == 'before') {
            require_once($html[0]);
          }
          ?>
          <?php
          if (!$full) {
            ?>
            <aside class="fact wRelatedContent vFacts">
              <h1>Vuosituhannen vähähiilisin vuosi 2005</h1>
              <div class="wrap">
                <ul>
                  <li>&nbsp;lämmin</li>
                  <li>&nbsp;teollisuudessa hiljainen</li>
                  <li>&nbsp;pohjoismaissa sateinen</li>
                </ul>
              </div>
            </aside>
            <?php
            if (empty($folder[1])) {
              echo '<h3>Projektit 2014</h3>';
              echo '<ul>';
              foreach(glob('2015/*', GLOB_ONLYDIR) as $dir) {
                $blacklist = array('.', '..', 'node_modules', 'esi-template');
                $dir = str_replace('2015/', '', $dir);
                if (!in_array($dir, $blacklist)) {
                  echo '<li><a href="?f=2015/' . $dir . '">' . $dir . '</a></li>';
                }
              }
              echo '</ul>';
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
            if ($html && $position == 'after') {
              require_once($html[0]);
            }
          }
          ?>
        </div>
        <?php
        if (!$full) {
          ?>
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
              <li class="with-image" itemtype="http://schema.org/Person" itemscope="" itemprop="author">
                <img src="http://yle.fi/embed/2014/01_vanhustenhuolto/img/60x60ali_hokka.png" alt="Stina Tuominen" itemprop="image">
                <a rel="author" class="author">Anne Ali-Hokka</a>
                <span class="organization" itemtype="http://schema.org/Organization" itemscope="" itemprop="worksFor">A-studio</span>
              </li>
              <li class="with-image" itemtype="http://schema.org/Person" itemscope="" itemprop="author">
                <img src="http://yle.fi/embed/2014/01_vanhustenhuolto/img/60x60orispaa.png" alt="Anne Ali-Hokka" itemprop="image">
                <a rel="author" class="author">Oili Orispää</a>
                <span class="organization" itemtype="http://schema.org/Organization" itemscope="" itemprop="worksFor">A-studio</span>
              </li>
              <li class="with-image" itemtype="http://schema.org/Person" itemscope="" itemprop="author">
                <img src="http://yle.fi/embed/2014/01_vanhustenhuolto/img/60x60tebest.png" alt="Oili Orispää" itemprop="image">
                <a rel="author" class="author">Teemo Tebest</a>
                <span class="organization" itemtype="http://schema.org/Organization" itemscope="" itemprop="worksFor">Yle Uutiset</span>
              </li>
              <li class="with-image" itemtype="http://schema.org/Person" itemscope="" itemprop="author">
                <img src="http://yle.fi/embed/2014/01_vanhustenhuolto/img/60x60tuominen.png" alt="Teemo Tebest" itemprop="image">
                <a rel="author" class="author">Stina Tuominen</a>
                <span class="organization" itemtype="http://schema.org/Organization" itemscope="" itemprop="worksFor">Yle Uutiset</span>
              </li>
              <li class="with-image" itemtype="http://schema.org/Person" itemscope="" itemprop="author">
                <img src="http://yle.fi/embed/2014/01_vanhustenhuolto/img/60x60rissanen.png" alt="Juha Rissanen" itemprop="image">
                <a rel="author" class="author">Juha Rissanen</a>
                <span class="organization" itemtype="http://schema.org/Organization" itemscope="" itemprop="worksFor">Yle Uutiset</span>
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
          <?php
        }
        ?>
      </article>
      <?php 
      if (!$wide && !$full) {
        ?>
        <div class="mini-frontpage">
          <section class="liftup-headlines " data-comscore-area="paauutiset">
          <h1>Pääuutiset</h1>
          <article class="with-image">
            <span class="meta">
              <a href="http://yle.fi/uutiset/politiikka/">Politiikka</a>
              <time datetime="2014-09-17T19:18:23+03:00">klo 19:18</time>
            </span>
            <a href="http://yle.fi/uutiset/suojelupoliisi_harkitsee_yhdysmiesta_turkkiin/7477358">
              <h1>Suojelupoliisi harkitsee yhdysmiestä Turkkiin</h1>
              <figure class="max-320">
                <img src="1418107644863.jpg" alt="Kuva kyltistä Suojelupoliisin ovessa Helsingin Kruununhaassa.">
              </figure>
              <p>Mikäli rahoitus löytyy, tavoitteena on lähettää yhdysmies paikalle mitä pikimmin, ehkä jo alkuvuodesta.</p>
            </a>
          </article>
          <article>
            <span class="meta">
              <a href="http://yle.fi/uutiset/ulkomaat/">Ulkomaat</a>
              <time datetime="2014-09-17T07:00:14+03:00">klo 7:00</time>
            </span>
            <a href="http://yle.fi/uutiset/skotlanti_sailytti_itsenaisyytensa_taistellen_mutta_menetti_sen_siirtomaahaaveisiin/7474673">
              <h1>Skotlanti säilytti itsenäisyytensä taistellen, mutta menetti sen siirtomaahaaveisiin</h1>
              <p>Kesällä Skotlannissa muisteltiin Bannockburnin taistelua, jossa skottijoukot löivät Englannin kuninkaan Edvard II:n armeijan vuonna 1314. Skotlanti säilytti itsenäisyytensä, mutta menetti sen myöhemmin epäonnisen siirtomaaseikkailun jälkimainingeissa.</p>
              </a>
            </article>
          </section>
        </div>
        <?php
      }
      ?>
      <?php
      if (!$full) {
        ?>
        <div class="permanent">
          <section class="liftup-most-popular" data-vr-zone="Luetuimmat">
            <h1>Luetuimmat</h1>
            <article data-vr-contentbox="">
              <p class="most-popular-count">1</p>
              <h1><a href="http://yle.fi/uutiset/stubb_ville_niiniston_suomettumispuheet_ihmeellisia/7477301">Stubb: Ville Niinistön suomettumispuheet ihmeellisiä</a>
              </h1>
            </article>
            <article data-vr-contentbox="">
              <p class="most-popular-count">2</p>
              <h1><a href="http://yle.fi/uutiset/microsoftin_paaluottamusmies_tyonantajalla_kiire_paasta_porukasta_eroon/7476668">Microsoftin pääluottamusmies: Työnantajalla kiire päästä porukasta eroon</a></h1>
            </article>
            <article data-vr-contentbox="">
              <p class="most-popular-count">3</p>
              <h1><a href="http://yle.fi/uutiset/facebook-ohitusvideojutussa_sakkoja_ja_ajokieltoa__katso_tuomitun_kuvaama_video/7476263">Facebook-ohitusvideojutussa sakkoja ja ajokieltoa – katso tuomitun kuvaama video</a></h1>
            </article>
            <article data-vr-contentbox="">
              <p class="most-popular-count">4</p>
              <h1><a href="http://yle.fi/uutiset/joka_iikka_tarkkana__lahihoitaja_hoksasi_muistisairaat_vanhukset_rollaattorireissulla_kadulla/7473691">Joka iikka tarkkana – lähihoitaja hoksasi muistisairaat vanhukset rollaattorireissulla kadulla</a></h1>
            </article>
            <article data-vr-contentbox="">
              <p class="most-popular-count">5</p>
              <h1><a href="http://yle.fi/uutiset/sari_helin_miksi_lestadiolaisten_ihmisoikeusrikokseen_ei_puututa/7475477">Sari Helin: Miksi lestadiolaisten ihmisoikeusrikokseen ei puututa?</a></h1>
            </article>
          </section>
          <section class="liftup-list " data-vr-zone="Tuoreimmat" data-comscore-area="julkaisun_tuoreimmat">
            <h1>Tuoreimmat</h1>
            <article data-vr-contentbox="">
            <time datetime="2014-09-17T20:21:00+03:00">20:21</time>
              <h1><a href="http://yle.fi/uutiset/tutkija_vaihtoehtojen_puute_ajaa_lapsia_pois_urheilusta/7477269">Tutkija: "Vaihtoehtojen puute ajaa lapsia pois urheilusta"</a></h1>
            </article>
            <article data-vr-contentbox="">
              <time datetime="2014-09-17T20:07:42+03:00">20:07</time>
              <h1><a href="http://yle.fi/uutiset/obama_yhdysvallat_ei_sodi_uutta_sotaa_irakissa/7477405">Obama: Yhdysvallat ei sodi uutta sotaa Irakissa</a></h1>
            </article>
            <article data-vr-contentbox="">
              <time datetime="2014-09-17T19:18:23+03:00">19:18</time>
              <h1><a href="http://yle.fi/uutiset/suojelupoliisi_harkitsee_yhdysmiesta_turkkiin/7477358">Suojelupoliisi harkitsee yhdysmiestä Turkkiin</a></h1>
            </article>
          </section>
        </div>
        <?php
      }
      ?>
    </div>
    <?php
    include('uutiset/html/footer.html');
    ?>
    <script src="http://yle.fi/global/player/embed.js?autoEmbed=false"></script>
    <script src="uutiset/js/script.tail.min.js"></script>
    <?php
    foreach ($js as $file) {
      echo '<script src="' . $file . '"></script>';
    }
    ?>
  </body>
</html>