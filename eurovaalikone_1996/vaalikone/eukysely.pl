#!/usr/bin/perl

# A-STUDION EU-kysely - Vain ehdokkaat
# Sanna Järvinen / YLE

$t_ehdokkaat = "/opt/local/apache2/htdocs/astud_eukysely/eukysely/ehdokkaat.txt";
$t_puolueet = "/opt/local/apache2/htdocs/astud_eukysely/eukysely/puolueet.txt";

# Moneenko kysymykseen on vastattu
$Vast = 0;

read(STDIN,$input,$ENV{'CONTENT_LENGTH'});
@fields = split(/&/,$input);

for (@fields) {
 
    ($kentta,$arvo) = split(/=/,$_);

    if ($kentta eq Q1) {
        $Vastattu[1] = $arvo;   
    $Vast++;        
    }

    if ($kentta eq Q2) {
        $Vastattu[2] = $arvo;
    $Vast++;    
    }

    if ($kentta eq Q3) {
        $Vastattu[3] = $arvo;
    $Vast++;    
    }

    if ($kentta eq Q4) {
        $Vastattu[4] = $arvo;   
    $Vast++;        
    }

    if ($kentta eq Q5) {
        $Vastattu[5] = $arvo;
    $Vast++;    
    }

    if ($kentta eq Q6) {
        $Vastattu[6] = $arvo;
    $Vast++;    
    }   

    if ($kentta eq Q7) {
        $Vastattu[7] = $arvo;   
    $Vast++;        
    }

    if ($kentta eq Q8) {
        $Vastattu[8] = $arvo;
    $Vast++;    
    }

    if ($kentta eq Q9) {
        $Vastattu[9] = $arvo;
    $Vast++;    
    }

    if ($kentta eq Q10) {
        $Vastattu[10] = $arvo;  
    $Vast++;        
    }

    if ($kentta eq Q11) {
        $Vastattu[11] = $arvo;
    $Vast++;    
    }

    if ($kentta eq Q12) {
        $Vastattu[12] = $arvo;
    $Vast++;    
    }  
 
    if ($kentta eq Q13) {
        $Vastattu[13] = $arvo;
    $Vast++;    
    }

    if ($kentta eq Q14) {
        $Vastattu[14] = $arvo;  
    $Vast++;        
    }

    if ($kentta eq Q15) {
        $Vastattu[15] = $arvo;
    $Vast++;    
    }

    if ($kentta eq Q16) {
        $Vastattu[16] = $arvo;
    $Vast++;    
    }   

    if ($kentta eq Q17) {
        $Vastattu[17] = $arvo;  
    $Vast++;        
    }

    if ($kentta eq Q18) {
        $Vastattu[18] = $arvo;
    $Vast++;    
    }

    if ($kentta eq Q19) {
        $Vastattu[19] = $arvo;
    $Vast++;    
    }

    if ($kentta eq Q20) {
        $Vastattu[20] = $arvo;  
    $Vast++;        
    }
}

if ($Vast < 20) {

print <<"UNTILL";
    Content-type: text/html

    <HTML>
    <HEAD>
    <TITLE>EU-KYSELY</TITLE>
    </HEAD>
    <BODY bgcolor=#FFFFFF>
    <BASEFONT SIZE=4>    
 
    <br>
    <center>
    Vastasit $Vast kohtaan.<p>

    Sinun on annettava jokaiseen 20:een kysymykseen jokin vaihtoehto,<br> 
    jotta saisit mahdollisimman oikean tuloksen!<p>
    <font size=3>(Voit joutua tälle sivulle myös, jos käytit ehdokkaiden 
     mielipide -sivun<br> sisäisiä linkkejä ja "reloudasit" sivun. Vastauksesi 
     eivät tällöin ole enää muistissa.)</font><p>
    <a href="http://www.yle.fi/A-studio/eukysely.html"><< takaisin EU-kyselyyn</a>  
    </center>   

    </BODY>
    </HTML> 

UNTILL

    exit(0);
}

#--------------------- EU-VAALIEHDOKKAAT -------------------------------------------
# Vertaa vastauksia EHDOKKAIDEN mielipiteisiin 
open(IFD, "$t_ehdokkaat");

$ekpl = 0;
while ($rivi1 = <IFD>) {

    $ekpl++;
    chop($rivi1);
    @rivi = split(/,/,$rivi1);
    
    #Ehdokkaan nimi
    $Ehdokkaat{$ekpl,0} = $rivi[0];
    $Ehd_vast{$ekpl,0} = $rivi[0];

    # Ehdokkaan puolue on
    $Ehdokkaat{$ekpl,1} = $rivi[1];

    # Taman ehdokkaan pisteet ovat ensin 0
    $Ehdokkaat{$ekpl,2} = 0;

    # Ja sitten mennaan kaikki 20 kysymysta lapi

    for ($i = 1; $i < 21; $i++) {
        $Ehd_vast{$ekpl,$i} = $rivi[$i+1];
        if($Vastattu[$i] == $rivi[$i+1]) {
            $Ehdokkaat{$ekpl,2}++;
        }   
    } 
}
close(IFD);
#--------------------------------------------------------------------------

#--------------------- PUOLUEET -------------------------------------------
# Vertaa vastauksia PUOLUEIDEN mielipiteisiin 
# open(IFD, "$t_puolueet");

# $pkpl = 0;
# while ($rivi1 = <IFD>) {

#     $pkpl++;
#     chop($rivi1);
#     @rivi = split(/,/,$rivi1);
    
#     # Puolue on
#     $Puolueet{$pkpl,0} = $rivi[0];
#     $Puol_vast{$pkpl,0} = $rivi[0];

#     # Taman ehdokkaan pisteet ovat ensin 0
#     $Puolueet{$pkpl,1} = 0;

#     # Ja sitten mennaan kaikki 20 kysymysta lapi

#     for ($i = 1; $i < 21; $i++) {
#         $Puol_vast{$pkpl,$i} = $rivi[$i];
#         if($Vastattu[$i] == $rivi[$i]) {
#             $Puolueet{$pkpl,1}++;
#         }   
#     } 
# }
# close(IFD);
#--------------------------------------------------------------------------

#--------------------- EU-VAALIEHDOKKAAT -------------------------------------------
#Laittaa EHDOKKAAT pistemaarien mukaiseen jarjestykseen
for($i=2; $i<$ekpl+1; $i++) {
  for($j=2; $j<$ekpl+3 - $i; $j++) {  

    if($Ehdokkaat{$j,2} < $Ehdokkaat{$j-1,2}) {

        $tmp = $Ehdokkaat{$j,0};
    $Ehdokkaat{$j,0} = $Ehdokkaat{$j-1,0};
        $Ehdokkaat{$j-1,0} = $tmp;

        $tmp = $Ehdokkaat{$j,1};
        $Ehdokkaat{$j,1} = $Ehdokkaat{$j-1,1};
        $Ehdokkaat{$j-1,1} = $tmp;

        $tmp = $Ehdokkaat{$j,2};
        $Ehdokkaat{$j,2} = $Ehdokkaat{$j-1,2};
        $Ehdokkaat{$j-1,2} = $tmp;
    }
  }
}
#--------------------------------------------------------------------------

#--------------------- PUOLUEET -------------------------------------------
#Laittaa PUOLUEET pistemaarien mukaiseen jarjestykseen
# for($i=2; $i<$pkpl+1; $i++) {
#   for($j=2; $j<$pkpl+3 - $i; $j++) {  

#     if($Puolueet{$j,1} < $Puolueet{$j-1,1}) {

#         $tmp = $Puolueet{$j,0};
#     $Puolueet{$j,0} = $Puolueet{$j-1,0};
#         $Puolueet{$j-1,0} = $tmp;

#         $tmp = $Puolueet{$j,1};
#         $Puolueet{$j,1} = $Puolueet{$j-1,1};
#         $Puolueet{$j-1,1} = $tmp;
#     }
#   }
# }

#--------------- HTML - KOODI ----------------------------------------------

print <<"UNTILL";
Content-type: text/html

<HTML>
<HEAD>
<TITLE>EU-KYSELY</TITLE>
<!-- Author Sanna Järvinen, Jun 1996 -->
</HEAD>
<BODY bgcolor=#FFFFFF TEXT=#000000 LINK=#6600FF VLINK=#6600FF ALINK=#CCCCFF>
<BASEFONT SIZE=3>

<a name="ehdokkaat">
<font size=2>
[ <a href="#kysymykset">Kysymykset kerrataan sivun lopussa</a> ]
[ <a href="#puolueet">Puolueet</a> ]
[ <a href="http://www.yle.fi/A-studio/ab-index.html">Takaisin A-studioon</a> ]
</font><br>

<br>
<hr noshade width=550 align=left>
<font size=4><b>EU-VAALIEHDOKKAAT</b></font><br>
<hr noshade width=550 align=left>

<br>
<font size=4><i>... JOTKA OVAT LÄHINNÄ MIELIPITEITÄSI</i></font><p>
UNTILL

#------------ EHDOKKAISTA KOLME KARJESSA JA JALJESSA -----------------------

for ($i = $ekpl; $i > $ekpl-3; $i--) {
    print"<b>$Ehdokkaat{$i,0}, $Ehdokkaat{$i,1} <font size=2>(</font><font size=2 color=#FF0000> $Ehdokkaat{$i,2}</font> <font size=2>yhtenevää mielipidettä</font>)</b><br>\n";
    &Ehdokkaiden_vastaukset($Ehdokkaat{$i,0});

    # Jos on muita tasaluvuilla, otetaan nekin mukaan.
    if($i == $ekpl-2) {
        while (($Ehdokkaat{$i-1,2} == $Ehdokkaat{$i,2}) && $i > 1) {
            print"<b>$Ehdokkaat{$i-1,0}, $Ehdokkaat{$i-1,1} <font size=2>(</font><font size=2 color=#FF0000> $Ehdokkaat{$i-1,2}</font> <font size=2>yhtenevää mielipidettä</font>)</b><br>\n";
            &Ehdokkaiden_vastaukset($Ehdokkaat{$i-1,0});
            $i--;
        }
    }
}

print "<font size=4><i>... JA JOTKA OVAT KAUIMPANA MIELIPITEISTÄSI</i></font><p>\n";

for ($i = 1; $i < 4; $i++) {
    print"<b>$Ehdokkaat{$i,0}, $Ehdokkaat{$i,1} <font size=2>(</font><font size=2 color=#FF0000> $Ehdokkaat{$i,2}</font> <font size=2>yhtenevää mielipidettä</font>)</b><br>\n";
    &Ehdokkaiden_vastaukset($Ehdokkaat{$i,0});

    # Jos on muita tasaluvuilla, otetaan nekin mukaan.
    if($i == 3) {
         while (($Ehdokkaat{$i,2} == $Ehdokkaat{$i+1,2}) && $i < $ekpl) {
            print"<b>$Ehdokkaat{$i+1,0}, $Ehdokkaat{$i+1,1} <font size=2>(</font><font size=2 color=#FF0000> $Ehdokkaat{$i+1,2}</font> <font size=2>yhtenevää mielipidettä</font>)</b><br>\n";
            &Ehdokkaiden_vastaukset($Ehdokkaat{$i-1,0});
            $i++;
         }
    }
}

# print <<"UNTILL";
# <a name="puolueet">
# <br>
# [ <a href="#kysymykset">Kysymykset kerrataan sivun lopussa</a> ]
# [ <a href="#ehdokkaat">EU-vaaliehdokkaat</a> ]
# [ <a href="http://www.yle.fi/A-studio/ab-index.html">Takaisin A-studioon</a> ]
# <p>
# <hr noshade width=550 align=left>
# <font size=4><b>PUOLUEET</b></font><br>
# <hr noshade width=550 align=left>

# <br>
# <font size=4><i>... JOTKA OVAT LÄHINNÄ MIELIPITEITÄSI</i></font><p>
# UNTILL

# #------------ PUOLUEISTA KOLME KARJESSA JA JALJESSA -----------------------
# print "\n";

# for ($i = $pkpl; $i > $pkpl-3; $i--) {
#     print"<b>$Puolueet{$i,0} <font size=2>(</font><font size=2 color=#003366> $Puolueet{$i,1}</font> <font size=2>yhtenevää mielipidettä</font>)</b><br>\n";
#     &Puolueiden_vastaukset($Puolueet{$i,0});

#     # Jos on muita tasaluvuilla, otetaan nekin mukaan.
#     if($i == $pkpl-2) {
#         while (($Puolueet{$i-1,1} == $Puolueet{$i,1}) && $i > 1) {
#             print"<b>$Puolueet{$i-1,0} <font size=2>(</font><font size=2 color=#003366> $Puolueet{$i-1,1}</font> <font size=2>yhtenevää mielipidettä</font>)</b><br>\n";
#             &Puolueiden_vastaukset($Puolueet{$i-1,0});
#             $i--;
#         }
#     }
# }

# print "<font size=4><i>... JA JOTKA OVAT KAUIMPANA MIELIPITEISTÄSI</i></font><p>\n";

# for ($i = 1; $i < 4; $i++) {
#     print"<b>$Puolueet{$i,0} <font size=2>(</font><font size=2 color=#003366> $Puolueet{$i,1}</font> <font size=2>yhtenevää mielipidettä</font>)</b><br>\n";
#     &Puolueiden_vastaukset($Puolueet{$i,0});  

#     # Jos on muita tasaluvuilla, otetaan nekin mukaan.
#     if($i == 3) {
#          while (($Puolueet{$i,1} == $Puolueet{$i+1,1}) && $i < $pkpl) {
#              print"<b>$Puolueet{$i+1,0} <font size=2>(</font><font size=2 color=#003366>$Puolueet{$i+1,1}</font> <font size=2>yhtenevää mielipidettä</font>)</b><br>\n";
#              &Puolueiden_vastaukset($Puolueet{$i+1,0});          
#              $i++;
#          }
#     }
# }

print <<"UNTILL";

<hr noshade width=550 align=left>
<br>
<A NAME="kysymykset">
<font size=2>
1. EU:n yhteisen valuutan nimeksi on valittu euro. Onko yhteinen valuutta hyvä ajatus?<br>
2. Pitäisikö Suomen pyrkiä ensimmäisten joukossa yhteiseen valuuttaan?<br>
3. Onko yhteinen puolustuspolitiikka hyvä tavoite?<br>
4. Pitäisikö Suomen pyrkiä WEU:n jäseneksi ja tiivistää näin sotilaallista yhteistyötä WEU:n kanssa?<br>
5. Pitäisikö Suomen pyrkiä NATO:n jäseneksi?<br>
6. Pitäisikö Europarlamentin valtaa lisätä muiden vallanhaltijoiden kustannuksella?<br>
7. Pitäisikö EU:n byrokratiaa vähentää?<br>
8. Pitäisikö EU-virkamiesten jatkuva matkustaminen Brysselin ja Strassburgin välillä lopettaa?<br>
9. Onko EU-kansanedustajan palkka (n. 40.000 mk/kk) oikean kokoinen?<br>
10. Liikkuvatko tavarat ja ihmiset jo liian vapaasti yli rajojen?<br>
11. Onko Suomen liittyminen Unioniin merkinnyt Suomelle enemmän plussaa kuin miinusta?<br>
12. Antaako EU-jäsenyys Suomelle myös turvallisuutta?<br>
13. Pitääkö Suomen ottaa jokainen direktiivi vakavasti?<br>
14. Onko järkevää, että EU:lla on määräykset esimerkiksi kurkun muodolle ja koolle?<br>
15. Pitäisikö EU:ta kehittää määrätietoisesti liittovaltion suuntaan?<br>
16. Pitäisikö EU:n pyrkiä määrätietoisesti yhteiseen lainsäädäntöön?<br>
17. Pitäisikö EU:n ulkorajan olla tarvittaessa tiivis muuri?<br>
18. Onko oikein että kuka tahansa eu-kansalainen voi tulla töihin Suomeen?<br>
19. Pitäisikö Itä-Euroopan maiden päästä nopeasti EU:n jäseniksi?<br>
20. Mikä seuraavista maista pitäisi mielestänne ottaa seuraavana EU:n jäseneksi?<br>
</font>

<br>
<font size=2>
[ <a href="#ehdokkaat">EU-vaaliehdokkaat</a> ]
[ <a href="#puolueet">Puolueet</a> ]
[ <a href="http://www.yle.fi/A-studio/ab-index.html">Takaisin A-studioon</a> ]
</font><p>

</BODY>
</HTML>
UNTILL

exit(0);


###########################################################################3


sub Ehdokkaiden_vastaukset {

    local($nimi) = $_[0];

    $k = 1;
    while ($Ehd_vast{$k,0} ne $nimi) {
        $k++;
        if ($k == $ekpl+1) {
            last;
        }
    }

    print "<table border=0>\n";
    print "<tr>\n";
    print "<td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[1] == $Ehd_vast{$k,1}) { print "<font color=#FF0000>\n"; }
    if ($Ehd_vast{$k,1} == 1) { print "1. On<br>\n"; }
    elsif ($Ehd_vast{$k,1} == 2) { print "1. Ei ole<br>\n"; }
    elsif ($Ehd_vast{$k,1} == 3) { print "1. En tiedä<br>\n"; }
    elsif ($Ehd_vast{$k,1} == 4) { print "1. Riippuu asianhaaroista<br>\n"; }
    else { print "1. -- <br>\n"; }
    if ($Vastattu[1] == $Ehd_vast{$k,1}) { print "</font>\n"; }

    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[2] == $Ehd_vast{$k,2}) { print "<font color=#FF0000>\n"; }
    if ($Ehd_vast{$k,2} == 1) { print "2. Pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,2} == 2) { print "2. Ei ensimmäisten joukossa<br>\n"; }
    elsif ($Ehd_vast{$k,2} == 3) { print "2. Ei pitäisi lainkaan<br>\n"; }
    elsif ($Ehd_vast{$k,2} == 4) { print "2. En tiedä<br>\n"; }
    else { print "2. -- <br>\n"; }
    if ($Vastattu[2] == $Ehd_vast{$k,2}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[3] == $Ehd_vast{$k,3}) { print "<font color=#FF0000>\n"; }
    if ($Ehd_vast{$k,3} == 1) { print "3. On<br>\n"; }
    elsif ($Ehd_vast{$k,3} == 2) { print "3. Ei ole<br>\n"; }
    elsif ($Ehd_vast{$k,3} == 3) { print "3. En tiedä<br>\n"; }
    elsif ($Ehd_vast{$k,3} == 4) { print "3. Riippuu kehityksestä Euroopassa<br>\n"; }
    else { print "3. -- <br>\n"; }
    if ($Vastattu[3] == $Ehd_vast{$k,3}) { print "</font>\n"; }

    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[4] == $Ehd_vast{$k,4}) { print "<font color=#FF0000>\n"; }
    if ($Ehd_vast{$k,4} == 1) { print "4. Pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,4} == 2) { print "4. Ei pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,4} == 3) { print "4. En tiedä<br>\n"; }
    elsif ($Ehd_vast{$k,4} == 4) { print "4. Riippuu asioiden kehityksestä<br>\n"; }
    else { print "4. -- <br>\n"; }
    if ($Vastattu[4] == $Ehd_vast{$k,4}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[5] == $Ehd_vast{$k,5}) { print "<font color=#FF0000>\n"; }
    if ($Ehd_vast{$k,5} == 1) { print "5. Pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,5} == 2) { print "5. Ei pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,5} == 3) { print "5. En tiedä<br>\n"; }
    elsif ($Ehd_vast{$k,5} == 4) { print "5. Riippuu kehityksestä Euroopassa<br>\n"; }
    elsif ($Ehd_vast{$k,5} == 5) { print "5. Riippuu kehityksestä Venäjällä<br>\n"; }
    else { print "5. -- <br>\n"; }
    if ($Vastattu[5] == $Ehd_vast{$k,5}) { print "</font>\n"; }
 
    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[6] == $Ehd_vast{$k,6}) { print "<font color=#FF0000>\n"; }
    if ($Ehd_vast{$k,6} == 1) { print "6. Pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,6} == 2) { print "6. Ei pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,6} == 3) { print "6. Pitäisi vähentää<br>\n"; }
    elsif ($Ehd_vast{$k,6} == 4) { print "6. Riippuu kokonaisjärjestelystä<br>\n"; }
    else { print "6. -- <br>\n"; }
    if ($Vastattu[6] == $Ehd_vast{$k,6}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[7] == $Ehd_vast{$k,7}) { print "<font color=#FF0000>\n"; }
    if ($Ehd_vast{$k,7} == 1) { print "7. Pitäisi vähentää vähän<br>\n"; }
    elsif ($Ehd_vast{$k,7} == 2) { print "7. Pitäisi vähentää paljon<br>\n"; }
    elsif ($Ehd_vast{$k,7} == 3) { print "7. EU:ssa ei ole liikaa byrokratiaa<br>\n"; }
    elsif ($Ehd_vast{$k,7} == 4) { print "7. EU:n byrokratiaa on varaa vaikka lisätä<br>\n"; }
    else { print "7. -- <br>\n"; }
    if ($Vastattu[7] == $Ehd_vast{$k,7}) { print "</font>\n"; }

    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[8] == $Ehd_vast{$k,8}) { print "<font color=#FF0000>\n"; }
    if ($Ehd_vast{$k,8} == 1) { print "8. Pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,8} == 2) { print "8. Ei pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,8} == 3) { print "8. Ei mutta pitäisi järkevöittää<br>\n"; }
    elsif ($Ehd_vast{$k,8} == 4) { print "8. En tiedä mistä on kysymys<br>\n"; }
    else { print "8. -- <br>\n"; }
    if ($Vastattu[8] == $Ehd_vast{$k,8}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[9] == $Ehd_vast{$k,9}) { print "<font color=#FF0000>\n"; }
    if ($Ehd_vast{$k,9} == 1) { print "9. On<br>\n"; }
    elsif ($Ehd_vast{$k,9} == 2) { print "9. Ei ole, se on liian suuri<br>\n"; }
    elsif ($Ehd_vast{$k,9} == 3) { print "9. Ei ole, se on liian pieni<br>\n"; }
    elsif ($Ehd_vast{$k,9} == 4) { print "9. En tiedä<br>\n"; }
    else { print "9. -- <br>\n"; }
    if ($Vastattu[9] == $Ehd_vast{$k,9}) { print "</font>\n"; }

    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[10] == $Ehd_vast{$k,10}) { print "<font color=#FF0000>\n"; }
    if ($Ehd_vast{$k,10} == 1) { print "10. Liikkuvat<br>\n"; }
    elsif ($Ehd_vast{$k,10} == 2) { print "10. Eivät liiku<br>\n"; }
    elsif ($Ehd_vast{$k,10} == 3) { print "10. En tiedä<br>\n"; }
    elsif ($Ehd_vast{$k,10} == 4) { print "10. Riippuu kehityksestä<br>\n"; }
    else { print "10. -- <br>\n"; }
    if ($Vastattu[10] == $Ehd_vast{$k,10}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[11] == $Ehd_vast{$k,11}) { print "<font color=#FF0000>\n"; }
    if ($Ehd_vast{$k,11} == 1) { print "11. Enemmän plussaa<br>\n"; }
    elsif ($Ehd_vast{$k,11} == 2) { print "11. Enemmän miinusta<br>\n"; }
    elsif ($Ehd_vast{$k,11} == 3) { print "11. Puntit ovat suurin piirtein tasan<br>\n"; }
    elsif ($Ehd_vast{$k,11} == 4) { print "11. En tiedä<br>\n"; }
    else { print "11. -- <br>\n"; }
    if ($Vastattu[11] == $Ehd_vast{$k,11}) { print "</font>\n"; }

    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[12] == $Ehd_vast{$k,12}) { print "<font color=#FF0000>\n"; } 
    if ($Ehd_vast{$k,12} == 1) { print "12. Antaa<br>\n"; }
    elsif ($Ehd_vast{$k,12} == 2) { print "12. Antaa tavallaan<br>\n"; }
    elsif ($Ehd_vast{$k,12} == 3) { print "12. Ei anna<br>\n"; }
    elsif ($Ehd_vast{$k,12} == 4) { print "12. Jää nähtäväksi<br>\n"; }
    else { print "12. -- <br>\n"; }
    if ($Vastattu[12] == $Ehd_vast{$k,12}) { print "</font>\n"; }
 
    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[13] == $Ehd_vast{$k,13}) { print "<font color=#FF0000>\n"; } 
    if ($Ehd_vast{$k,13} == 1) { print "13. Pitää<br>\n"; }
    elsif ($Ehd_vast{$k,13} == 2) { print "13. Pitää niin kuin muidenkin<br>\n"; }
    elsif ($Ehd_vast{$k,13} == 3) { print "13. Ei pidä<br>\n"; }
    elsif ($Ehd_vast{$k,13} == 4) { print "13. En tiedä<br>\n"; }
    else { print "13. -- <br>\n"; }
    if ($Vastattu[13] == $Ehd_vast{$k,13}) { print "</font>\n"; }
  
    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[14] == $Ehd_vast{$k,14}) { print "<font color=#FF0000>\n"; }  
    if ($Ehd_vast{$k,14} == 1) { print "14. On<br>\n"; }
    elsif ($Ehd_vast{$k,14} == 2) { print "14. Ei ole<br>\n"; }
    elsif ($Ehd_vast{$k,14} == 3) { print "14. En tiedä<br>\n"; }
    elsif ($Ehd_vast{$k,14} == 4) { print "14. Riippuu<br>\n"; }
    else { print "14. -- <br>\n"; }
    if ($Vastattu[14] == $Ehd_vast{$k,14}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[15] == $Ehd_vast{$k,15}) { print "<font color=#FF0000>\n"; }  
    if ($Ehd_vast{$k,15} == 1) { print "15. Pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,15} == 2) { print "15. Ei pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,15} == 3) { print "15. En tiedä<br>\n"; }
    elsif ($Ehd_vast{$k,15} == 4) { print "15. Riippuu ympäröivän maailman kehityksestä<br>\n"; }
    else { print "15. -- <br>\n"; }
    if ($Vastattu[15] == $Ehd_vast{$k,15}) { print "</font>\n"; }

    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[16] == $Ehd_vast{$k,16}) { print "<font color=#FF0000>\n"; }   
    if ($Ehd_vast{$k,16} == 1) { print "16. Pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,16} == 2) { print "16. Ei pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,16} == 3) { print "16. En tiedä<br>\n"; }
    elsif ($Ehd_vast{$k,16} == 4) { print "16. Soveltuvin osin<br>\n"; }
    else { print "16. -- <br>\n"; }
    if ($Vastattu[16] == $Ehd_vast{$k,16}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[17] == $Ehd_vast{$k,17}) { print "<font color=#FF0000>\n"; }   
    if ($Ehd_vast{$k,17} == 1) { print "17. Pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,17} == 2) { print "17. Ei pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,17} == 3) { print "17. En tiedä<br>\n"; }
    elsif ($Ehd_vast{$k,17} == 4) { print "17. Mitä kysymys mahtaa tarkoittaa?<br>\n"; }
    else { print "17. -- <br>\n"; }
    if ($Vastattu[17] == $Ehd_vast{$k,17}) { print "</font>\n"; }

    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[18] == $Ehd_vast{$k,18}) { print "<font color=#FF0000>\n"; }   
    if ($Ehd_vast{$k,18} == 1) { print "18. On oikein<br>\n"; }
    elsif ($Ehd_vast{$k,18} == 2) { print "18. Ei ole oikein<br>\n"; }
    elsif ($Ehd_vast{$k,18} == 3) { print "18. En tiedä<br>\n"; }
    elsif ($Ehd_vast{$k,18} == 4) { print "18. Riippuu tilanteesta Suomessa<br>\n"; }
    else { print "18. -- <br>\n"; }
    if ($Vastattu[18] == $Ehd_vast{$k,18}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[19] == $Ehd_vast{$k,19}) { print "<font color=#FF0000>\n"; }   
    if ($Ehd_vast{$k,19} == 1) { print "19. Pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,19} == 2) { print "19. Ei pitäisi<br>\n"; }
    elsif ($Ehd_vast{$k,19} == 3) { print "19. Pitäisi tehdä vaikeammaksi<br>\n"; }
    elsif ($Ehd_vast{$k,19} == 4) { print "19. En tiedä<br>\n"; }
    else { print "19. -- <br>\n"; }
    if ($Vastattu[19] == $Ehd_vast{$k,19}) { print "</font>\n"; }
 
    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[20] == $Ehd_vast{$k,20}) { print "<font color=#FF0000>\n"; } 
    if ($Ehd_vast{$k,20} == 1) { print "20. Puola<br>\n"; }
    elsif ($Ehd_vast{$k,20} == 2) { print "20. Unkari<br>\n"; }
    elsif ($Ehd_vast{$k,20} == 3) { print "20. Tshekki<br>\n"; }
    elsif ($Ehd_vast{$k,20} == 4) { print "20. Viro<br>\n"; }
    else { print "20. -- <br>\n"; }
    if ($Vastattu[20] == $Ehd_vast{$k,20}) { print "</font>\n"; }
   
    print "</font>\n";
    print "</td></tr>\n";
    print "</table><p>\n";
             
}


sub Puolueiden_vastaukset {

    local($nimi) = $_[0];

    $k = 1;
    while ($Puol_vast{$k,0} ne $nimi) {
        $k++;
        if ($k == $pkpl+1) {
            last;
        }
    }

    print "<table border=0>\n";
    print "<tr>\n";
    print "<td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[1] == $Puol_vast{$k,1}) { print "<font color=#0033FF>\n"; }
    if ($Puol_vast{$k,1} == 1) { print "1. On<br>\n"; }
    elsif ($Puol_vast{$k,1} == 2) { print "1. Ei ole<br>\n"; }
    elsif ($Puol_vast{$k,1} == 3) { print "1. En tiedä<br>\n"; }
    elsif ($Puol_vast{$k,1} == 4) { print "1. Riippuu asianhaaroista<br>\n"; }
    else { print "1. -- <br>\n"; }
    if ($Vastattu[1] == $Puol_vast{$k,1}) { print "</font>\n"; }

    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[2] == $Puol_vast{$k,2}) { print "<font color=#0033FF>\n"; }
    if ($Puol_vast{$k,2} == 1) { print "2. Pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,2} == 2) { print "2. Ei ensimmäisten joukossa<br>\n"; }
    elsif ($Puol_vast{$k,2} == 3) { print "2. Ei pitäisi lainkaan<br>\n"; }
    elsif ($Puol_vast{$k,2} == 4) { print "2. En tiedä<br>\n"; }
    else { print "2. -- <br>\n"; }
    if ($Vastattu[2] == $Puol_vast{$k,2}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[3] == $Puol_vast{$k,3}) { print "<font color=#0033FF>\n"; }
    if ($Puol_vast{$k,3} == 1) { print "3. On<br>\n"; }
    elsif ($Puol_vast{$k,3} == 2) { print "3. Ei ole<br>\n"; }
    elsif ($Puol_vast{$k,3} == 3) { print "3. En tiedä<br>\n"; }
    elsif ($Puol_vast{$k,3} == 4) { print "3. Riippuu kehityksestä Euroopassa<br>\n"; }
    else { print "3. -- <br>\n"; }
    if ($Vastattu[3] == $Puol_vast{$k,3}) { print "</font>\n"; }

    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[4] == $Puol_vast{$k,4}) { print "<font color=#0033FF>\n"; }
    if ($Puol_vast{$k,4} == 1) { print "4. Pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,4} == 2) { print "4. Ei pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,4} == 3) { print "4. En tiedä<br>\n"; }
    elsif ($Puol_vast{$k,4} == 4) { print "4. Riippuu asioiden kehityksestä<br>\n"; }
    else { print "4. -- <br>\n"; }
    if ($Vastattu[4] == $Puol_vast{$k,4}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[5] == $Puol_vast{$k,5}) { print "<font color=#0033FF>\n"; }
    if ($Puol_vast{$k,5} == 1) { print "5. Pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,5} == 2) { print "5. Ei pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,5} == 3) { print "5. En tiedä<br>\n"; }
    elsif ($Puol_vast{$k,5} == 4) { print "5. Riippuu kehityksestä Euroopassa<br>\n"; }
    elsif ($Puol_vast{$k,5} == 5) { print "5. Riippuu kehityksestä Venäjällä<br>\n"; }
    else { print "5. -- <br>\n"; }
    if ($Vastattu[5] == $Puol_vast{$k,5}) { print "</font>\n"; }
 
    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[6] == $Puol_vast{$k,6}) { print "<font color=#0033FF>\n"; }
    if ($Puol_vast{$k,6} == 1) { print "6. Pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,6} == 2) { print "6. Ei pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,6} == 3) { print "6. Pitäisi vähentää<br>\n"; }
    elsif ($Puol_vast{$k,6} == 4) { print "6. Riippuu kokonaisjärjestelystä<br>\n"; }
    else { print "6. -- <br>\n"; }
    if ($Vastattu[6] == $Puol_vast{$k,6}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[7] == $Puol_vast{$k,7}) { print "<font color=#0033FF>\n"; }
    if ($Puol_vast{$k,7} == 1) { print "7. Pitäisi vähentää vähän<br>\n"; }
    elsif ($Puol_vast{$k,7} == 2) { print "7. Pitäisi vähentää paljon<br>\n"; }
    elsif ($Puol_vast{$k,7} == 3) { print "7. EU:ssa ei ole liikaa byrokratiaa<br>\n"; }
    elsif ($Puol_vast{$k,7} == 4) { print "7. EU:n byrokratiaa on varaa vaikka lisätä<br>\n"; }
    else { print "7. -- <br>\n"; }
    if ($Vastattu[7] == $Puol_vast{$k,7}) { print "</font>\n"; }

    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[8] == $Puol_vast{$k,8}) { print "<font color=#0033FF>\n"; }
    if ($Puol_vast{$k,8} == 1) { print "8. Pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,8} == 2) { print "8. Ei pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,8} == 3) { print "8. Ei mutta pitäisi järkevöittää<br>\n"; }
    elsif ($Puol_vast{$k,8} == 4) { print "8. En tiedä mistä on kysymys<br>\n"; }
    else { print "8. -- <br>\n"; }
    if ($Vastattu[8] == $Puol_vast{$k,8}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[9] == $Puol_vast{$k,9}) { print "<font color=#0033FF>\n"; }
    if ($Puol_vast{$k,9} == 1) { print "9. On<br>\n"; }
    elsif ($Puol_vast{$k,9} == 2) { print "9. Ei ole, se on liian suuri<br>\n"; }
    elsif ($Puol_vast{$k,9} == 3) { print "9. Ei ole, se on liian pieni<br>\n"; }
    elsif ($Puol_vast{$k,9} == 4) { print "9. En tiedä<br>\n"; }
    else { print "9. -- <br>\n"; }
    if ($Vastattu[9] == $Puol_vast{$k,9}) { print "</font>\n"; }

    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[10] == $Puol_vast{$k,10}) { print "<font color=#0033FF>\n"; }
    if ($Puol_vast{$k,10} == 1) { print "10. Liikkuvat<br>\n"; }
    elsif ($Puol_vast{$k,10} == 2) { print "10. Eivät liiku<br>\n"; }
    elsif ($Puol_vast{$k,10} == 3) { print "10. En tiedä<br>\n"; }
    elsif ($Puol_vast{$k,10} == 4) { print "10. Riippuu kehityksestä<br>\n"; }
    else { print "10. -- <br>\n"; }
    if ($Vastattu[10] == $Puol_vast{$k,10}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[11] == $Puol_vast{$k,11}) { print "<font color=#0033FF>\n"; }
    if ($Puol_vast{$k,11} == 1) { print "11. Enemmän plussaa<br>\n"; }
    elsif ($Puol_vast{$k,11} == 2) { print "11. Enemmän miinusta<br>\n"; }
    elsif ($Puol_vast{$k,11} == 3) { print "11. Puntit ovat suurin piirtein tasan<br>\n"; }
    elsif ($Puol_vast{$k,11} == 4) { print "11. En tiedä<br>\n"; }
    else { print "11. -- <br>\n"; }
    if ($Vastattu[11] == $Puol_vast{$k,11}) { print "</font>\n"; }

    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[12] == $Puol_vast{$k,12}) { print "<font color=#0033FF>\n"; } 
    if ($Puol_vast{$k,12} == 1) { print "12. Antaa<br>\n"; }
    elsif ($Puol_vast{$k,12} == 2) { print "12. Antaa tavallaan<br>\n"; }
    elsif ($Puol_vast{$k,12} == 3) { print "12. Ei anna<br>\n"; }
    elsif ($Puol_vast{$k,12} == 4) { print "12. Jää nähtäväksi<br>\n"; }
    else { print "12. -- <br>\n"; }
    if ($Vastattu[12] == $Puol_vast{$k,12}) { print "</font>\n"; }
 
    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[13] == $Puol_vast{$k,13}) { print "<font color=#0033FF>\n"; } 
    if ($Puol_vast{$k,13} == 1) { print "13. Pitää<br>\n"; }
    elsif ($Puol_vast{$k,13} == 2) { print "13. Pitää niin kuin muidenkin<br>\n"; }
    elsif ($Puol_vast{$k,13} == 3) { print "13. Ei pidä<br>\n"; }
    elsif ($Puol_vast{$k,13} == 4) { print "13. En tiedä<br>\n"; }
    else { print "13. -- <br>\n"; }
    if ($Vastattu[13] == $Puol_vast{$k,13}) { print "</font>\n"; }
  
    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[14] == $Puol_vast{$k,14}) { print "<font color=#0033FF>\n"; }  
    if ($Puol_vast{$k,14} == 1) { print "14. On<br>\n"; }
    elsif ($Puol_vast{$k,14} == 2) { print "14. Ei ole<br>\n"; }
    elsif ($Puol_vast{$k,14} == 3) { print "14. En tiedä<br>\n"; }
    elsif ($Puol_vast{$k,14} == 4) { print "14. Riippuu<br>\n"; }
    else { print "14. -- <br>\n"; }
    if ($Vastattu[14] == $Puol_vast{$k,14}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[15] == $Puol_vast{$k,15}) { print "<font color=#0033FF>\n"; }  
    if ($Puol_vast{$k,15} == 1) { print "15. Pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,15} == 2) { print "15. Ei pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,15} == 3) { print "15. En tiedä<br>\n"; }
    elsif ($Puol_vast{$k,15} == 4) { print "15. Riippuu ympäröivän maailman kehityksestä<br>\n"; }
    else { print "15. -- <br>\n"; }
    if ($Vastattu[15] == $Puol_vast{$k,15}) { print "</font>\n"; }

    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[16] == $Puol_vast{$k,16}) { print "<font color=#0033FF>\n"; }   
    if ($Puol_vast{$k,16} == 1) { print "16. Pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,16} == 2) { print "16. Ei pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,16} == 3) { print "16. En tiedä<br>\n"; }
    elsif ($Puol_vast{$k,16} == 4) { print "16. Soveltuvin osin<br>\n"; }
    else { print "16. -- <br>\n"; }
    if ($Vastattu[16] == $Puol_vast{$k,16}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[17] == $Puol_vast{$k,17}) { print "<font color=#0033FF>\n"; }   
    if ($Puol_vast{$k,17} == 1) { print "17. Pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,17} == 2) { print "17. Ei pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,17} == 3) { print "17. En tiedä<br>\n"; }
    elsif ($Puol_vast{$k,17} == 4) { print "17. Mitä kysymys mahtaa tarkoittaa?<br>\n"; }
    else { print "17. -- <br>\n"; }
    if ($Vastattu[17] == $Puol_vast{$k,17}) { print "</font>\n"; }

    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[18] == $Puol_vast{$k,18}) { print "<font color=#0033FF>\n"; }   
    if ($Puol_vast{$k,18} == 1) { print "18. On oikein<br>\n"; }
    elsif ($Puol_vast{$k,18} == 2) { print "18. Ei ole oikein<br>\n"; }
    elsif ($Puol_vast{$k,18} == 3) { print "18. En tiedä<br>\n"; }
    elsif ($Puol_vast{$k,18} == 4) { print "18. Riippuu tilanteesta Suomessa<br>\n"; }
    else { print "18. -- <br>\n"; }
    if ($Vastattu[18] == $Puol_vast{$k,18}) { print "</font>\n"; }

    print "</font>\n";
    print "</td></tr><tr><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[19] == $Puol_vast{$k,19}) { print "<font color=#0033FF>\n"; }   
    if ($Puol_vast{$k,19} == 1) { print "19. Pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,19} == 2) { print "19. Ei pitäisi<br>\n"; }
    elsif ($Puol_vast{$k,19} == 3) { print "19. Pitäisi tehdä vaikeammaksi<br>\n"; }
    elsif ($Puol_vast{$k,19} == 4) { print "19. En tiedä<br>\n"; }
    else { print "19. -- <br>\n"; }
    if ($Vastattu[19] == $Puol_vast{$k,19}) { print "</font>\n"; }
 
    print "</font>\n";
    print "</td><td width=300 valign=top>\n";
    print "<font size=2>\n";

    if ($Vastattu[20] == $Puol_vast{$k,20}) { print "<font color=#0033FF>\n"; } 
    if ($Puol_vast{$k,20} == 1) { print "20. Puola<br>\n"; }
    elsif ($Puol_vast{$k,20} == 2) { print "20. Unkari<br>\n"; }
    elsif ($Puol_vast{$k,20} == 3) { print "20. Tshekki<br>\n"; }
    elsif ($Puol_vast{$k,20} == 4) { print "20. Viro<br>\n"; }
    else { print "20. -- <br>\n"; }
    if ($Vastattu[20] == $Puol_vast{$k,20}) { print "</font>\n"; }
   
    print "</font>\n";
    print "</td></tr>\n";
    print "</table><p>\n";
             
}