#!/usr/bin/perl
#use strict;
#use warnings;
use warnings;
use diagnostics;
use strict;
use CGI::Carp 'fatalsToBrowser';

# A-STUDION EUROVAALIEHDOKKAAT
# Sanna Järvinen / YLE

my $dir = "/opt/local/apache2/htdocs/astud_eukysely";
my $dir2 = "eukysely";
my $ehd_sivut = "$dir/ehd_sivut";
my $file_ehdvast = "$dir/ehdokkaat.txt";
#$file_ehdmuut = "$dir/ehd_muut.txt";
my $nel1 = "<img src=\"../$dir2/pics/nel1.gif\" alt=\"*\" width=16 height=16>";
my $nel2 = "<img src=\"../$dir2/pics/nel2.gif\" alt=\"*\" width=16 height=16>";


#------------------------- VASTAUKSET -----------------------------------
open(IFD1, "$file_ehdvast");

my $ekpl = 0;
my %Ehdokkaat;
my %Ehd_vast;
while (my $a_rivi1 = <IFD1>) {

    $ekpl++;
    chop($a_rivi1);
    my @a_rivi = split(/,/,$a_rivi1);
    
    #Ehdokkaan nimi
    $Ehdokkaat{$ekpl,0} = $a_rivi[0];
    $Ehd_vast{$ekpl,0} = $a_rivi[0];

    # Ehdokkaan puolue on
    $Ehdokkaat{$ekpl,1} = $a_rivi[1];

    # ISKULAUSE UNOHDETAAN VIELA TASSA VAIHEESSA
    # Ei viela iskulausetta 
    # $Ehdokkaat{$ekpl,2} = "";	

    # Ja sitten mennaan kaikki 20 kysymysta lapi

    for (my $i = 1; $i < 21; $i++) {
        $Ehd_vast{$ekpl,$i} = $a_rivi[$i+1];
    } 

    my @tmp = split(/ /,$Ehdokkaat{$ekpl,0});
    my $sukunimi = $tmp[0];	
    my $etunimi = $tmp[1];

# ISKULAUSE UNOHDETAAN VIELA TASSA VAIHEESSA
#----------- ISKULAUSEET ------------------------------------------------
#
#    open(IFD2, "$file_ehdmuut");
#    $loop=1;
#    while (($b_rivi1 = <IFD2>) && $loop) {
#
#       chop($b_rivi1);
#       @b_rivi = split(/,/,$b_rivi1);
#   
#       if($b_rivi[0] eq $Ehdokkaat{$ekpl,0}) {
#   	   $loop=0;
#	   $Ehdokkaat{$ekpl,2} = "\"$b_rivi[1]\"";
#       }	
#    }
#    close(IFD2);
   open(STDOUT, ">$ehd_sivut/$sukunimi.$etunimi.html") || die "Can't open file";
   &htmlkoodi;
   close(STDOUT);

}
close(IFD1);

print <<"UNTILL";
Content-Type: text/html 

<HTML>
<HEAD>
<TITLE>A-studio / Eurovaaliehdokkaiden sivujen muodostus</TITLE>
<!-- Author Sanna Järvinen (sanna.jarvinen(at)yle.fi), Aug 1996 -->
</HEAD>

<BODY bgcolor=#FFFFFF text=#000000>
<br>
<br>
<center>
<font size=4>
Ehdokkaiden sivut ovat nyt muodostettu uudelleen<br> 
seuraavan tiedoston perusteella:<p> 
<i>~a-studio/eukysely/ehdokkaat.txt</i></font><p>

<br>
<br>
<br>
<font size=3>
[ <a href="http://www.yle.fi/a-studio/" valign="_top">A-studion etusivulle</a> ]
[ <a href="http://www.yle.fi/cgi-bin/a-studio/ehdokkaat.pl" valign="_top">Ehdok. vastausten vertailuun</a> ]
[ <a href="http://www.yle.fi/a-studio/nfeukyse.html" valign="_top">EU-kyselyyn</a> ]
</font>
</center>
</BODY>
</HTML>

UNTILL

exit 0;



###########################################################################
###########################################################################

#--------------- HTML - KOODI ----------------------------------------------
sub htmlkoodi {

print <<"UNTILL";

<HTML>
<HEAD>
<TITLE>EUROVAALIEHDOKKAAT</TITLE>
<!-- Author Sanna Järvinen (sanna.jarvinen(at)yle.fi), Aug 1996 -->
</HEAD>
<BODY bgcolor=#FFFFFF TEXT=#000000 LINK=#0000CC VLINK=#0000EE ALINK=#CCCCFF>
<BASE TARGET="_top">

<font size=-1>
<nobr>[ <a href="http://www.yle.fi/cgi-bin/a-studio/ehdokkaat.pl" target="_top">Kaikki ehdokkaat</a> ]</nobr>
<nobr>[ <a href="http://www.yle.fi/a-studio/ab-index.html" target="_top">A-studion ohjelmasivu</a> ]</nobr>
<nobr>[ <a href="http://www.yle.fi/a-studio/nfeukyse.html" target="_top">EU-kysely</a> ]</nobr>
</font><br>

<br>
<hr noshade align=left>
<table width=100% border=0 cellspacing=0 cellpadding=0>
<tr><td align=left valign=center>
<font size=+1>EUROVAALIEHDOKKAAT / <nobr><i>henkilökohtaiset vastaukset</i></nobr></font>
<td width=45 align=middle valign=center>
<img src="../$dir2/pics/eulippu_m1.gif" alt="" width=40 height=32>
</td></tr>
</table>
<hr noshade align=left>

<br>
<table width=100% border=0 cellspacing=0 cellpadding=12 bgcolor=#CCCCFF>
<tr><td align=left valign=center>

<font size=+2 face="helvetica,times">$Ehdokkaat{$ekpl,0}</font><font size=+1 face="helvetica,times">, $Ehdokkaat{$ekpl,1}</font>

</td></tr>
</table>
<br>
<br>

UNTILL

#-- 1 ----------------------------------
print "<b>1. EU:n yhteisen valuutan nimeksi on valittu euro. Onko yhteinen valuutta hyvä ajatus?</b><br>\n";

if ($Ehd_vast{$ekpl,1} == 1) { print "$nel1 <font color=#111111>On</font><br>\n"; }
if ($Ehd_vast{$ekpl,1} != 1) { print "$nel2 <font size=-1 color=#888888>On</font><br>\n"; }

if ($Ehd_vast{$ekpl,1} == 2) { print "$nel1 <font color=#111111>Ei ole</font><br>\n"; }
if ($Ehd_vast{$ekpl,1} != 2) { print "$nel2 <font size=-1 color=#888888>Ei ole</font><br>\n"; }

if ($Ehd_vast{$ekpl,1} == 3) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,1} != 3) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

if ($Ehd_vast{$ekpl,1} == 4) { print "$nel1 <font color=#111111>Riippuu asianhaaroista</font><br>\n"; }
if ($Ehd_vast{$ekpl,1} != 4) { print "$nel2 <font size=-1 color=#888888>Riippuu asianhaaroista</font><br>\n"; }

print "<br>\n";

#-- 2 ----------------------------------
print"<b>2. Pitäisikö Suomen pyrkiä ensimmäisten joukossa yhteiseen valuuttaan?</b><br>\n";

if ($Ehd_vast{$ekpl,2} == 1) { print "$nel1 <font color=#111111>Pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,2} != 1) { print "$nel2 <font size=-1 color=#888888>Pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,2} == 2) { print "$nel1 <font color=#111111>Ei ensimmäisten joukossa</font><br>\n"; }
if ($Ehd_vast{$ekpl,2} != 2) { print "$nel2 <font size=-1 color=#888888>Ei ensimmäisten joukossa</font><br>\n"; }

if ($Ehd_vast{$ekpl,2} == 3) { print "$nel1 <font color=#111111>Ei pitäisi lainkaan</font><br>\n"; }
if ($Ehd_vast{$ekpl,2} != 3) { print "$nel2 <font size=-1 color=#888888>Ei pitäisi lainkaan</font><br>\n"; }

if ($Ehd_vast{$ekpl,2} == 4) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,2} != 4) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

print "<br>\n";

#-- 3 ----------------------------------
print"<b>3. Onko yhteinen puolustuspolitiikka hyvä tavoite?</b><br>\n";

if ($Ehd_vast{$ekpl,3} == 1) { print "$nel1 <font color=#111111>On</font><br>\n"; }
if ($Ehd_vast{$ekpl,3} != 1) { print "$nel2 <font size=-1 color=#888888>On</font><br>\n"; }

if ($Ehd_vast{$ekpl,3} == 2) { print "$nel1 <font color=#111111>Ei ole</font><br>\n"; }
if ($Ehd_vast{$ekpl,3} != 2) { print "$nel2 <font size=-1 color=#888888>Ei ole</font><br>\n"; }

if ($Ehd_vast{$ekpl,3} == 3) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,3} != 3) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

if ($Ehd_vast{$ekpl,3} == 4) { print "$nel1 <font color=#111111>Riippuu kehityksestä Euroopassa</font><br>\n"; }
if ($Ehd_vast{$ekpl,3} != 4) { print "$nel2 <font size=-1 color=#888888>Riippuu kehityksestä Euroopassa</font><br>\n"; }

print "<br>\n";

#-- 4 ----------------------------------
print"<b>4. Pitäisikö Suomen pyrkiä WEU:n jäseneksi ja tiivistää näin sotilaallista yhteistyötä WEU:n kanssa?</b><br>\n";

if ($Ehd_vast{$ekpl,4} == 1) { print "$nel1 <font color=#111111>Pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,4} != 1) { print "$nel2 <font size=-1 color=#888888>Pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,4} == 2) { print "$nel1 <font color=#111111>Ei pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,4} != 2) { print "$nel2 <font size=-1 color=#888888>Ei pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,4} == 3) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,4} != 3) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

if ($Ehd_vast{$ekpl,4} == 4) { print "$nel1 <font color=#111111>Riippuu asioiden kehityksestä</font><br>\n"; }
if ($Ehd_vast{$ekpl,4} != 4) { print "$nel2 <font size=-1 color=#888888>Riippuu asioiden kehityksestä</font><br>\n"; }

print "<br>\n";

#-- 5 ----------------------------------
print"<b>5. Pitäisikö Suomen pyrkiä NATO:n jäseneksi?</b><br>\n";

if ($Ehd_vast{$ekpl,5} == 1) { print "$nel1 <font color=#111111>Pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,5} != 1) { print "$nel2 <font size=-1 color=#888888>Pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,5} == 2) { print "$nel1 <font color=#111111>Ei pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,5} != 2) { print "$nel2 <font size=-1 color=#888888>Ei pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,5} == 3) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,5} != 3) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

if ($Ehd_vast{$ekpl,5} == 4) { print "$nel1 <font color=#111111>Riippuu kehityksestä Euroopassa</font><br>\n"; }
if ($Ehd_vast{$ekpl,5} != 4) { print "$nel2 <font size=-1 color=#888888>Riippuu kehityksestä Euroopassa</font><br>\n"; }

if ($Ehd_vast{$ekpl,5} == 5) { print "$nel1 <font color=#111111>Riippuu kehityksestä Venäjällä</font><br>\n"; }
if ($Ehd_vast{$ekpl,5} != 5) { print "$nel2 <font size=-1 color=#888888>Riippuu kehityksestä Venäjällä</font><br>\n"; }

print "<br>\n";

#-- 6 ----------------------------------
print"<b>6. Pitäisikö Europarlamentin valtaa lisätä muiden vallanhaltijoiden kustannuksella?</b><br>\n";

if ($Ehd_vast{$ekpl,6} == 1) { print "$nel1 <font color=#111111>Pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,6} != 1) { print "$nel2 <font size=-1 color=#888888>Pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,6} == 2) { print "$nel1 <font color=#111111>Ei pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,6} != 2) { print "$nel2 <font size=-1 color=#888888>Ei pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,6} == 3) { print "$nel1 <font color=#111111>Pitäisi vähentää</font><br>\n"; }
if ($Ehd_vast{$ekpl,6} != 3) { print "$nel2 <font size=-1 color=#888888>Pitäisi vähentää</font><br>\n"; }

if ($Ehd_vast{$ekpl,6} == 4) { print "$nel1 <font color=#111111>Riippuu kokonaisjärjestelystä</font><br>\n"; }
if ($Ehd_vast{$ekpl,6} != 4) { print "$nel2 <font size=-1 color=#888888>Riippuu kokonaisjärjestelystä</font><br>\n"; }

print "<br>\n";

#-- 7 ----------------------------------
print"<b>7. Pitäisikö EU:n byrokratiaa vähentää?</b><br>\n"; 

if ($Ehd_vast{$ekpl,7} == 1) { print "$nel1 <font color=#111111>Pitäisi vähentää vähän</font><br>\n"; }
if ($Ehd_vast{$ekpl,7} != 1) { print "$nel2 <font size=-1 color=#888888>Pitäisi vähentää vähän</font><br>\n"; }

if ($Ehd_vast{$ekpl,7} == 2) { print "$nel1 <font color=#111111>Pitäisi vähentää paljon</font><br>\n"; }
if ($Ehd_vast{$ekpl,7} != 2) { print "$nel2 <font size=-1 color=#888888>Pitäisi vähentää paljon</font><br>\n"; }

if ($Ehd_vast{$ekpl,7} == 3) { print "$nel1 <font color=#111111>EU:ssa ei ole liikaa byrokratiaa</font><br>\n"; }
if ($Ehd_vast{$ekpl,7} != 3) { print "$nel2 <font size=-1 color=#888888>EU:ssa ei ole liikaa byrokratiaa</font><br>\n"; }

if ($Ehd_vast{$ekpl,7} == 4) { print "$nel1 <font color=#111111>EU:n byrokratiaa on varaa vaikka lisätä</font><br>\n"; }
if ($Ehd_vast{$ekpl,7} != 4) { print "$nel2 <font size=-1 color=#888888>EU:n byrokratiaa on varaa vaikka lisätä</font><br>\n"; }

print "<br>\n";

#-- 8 ----------------------------------
print"<b>8. Pitäisikö EU-virkamiesten jatkuva matkustaminen Brysselin ja Strassburgin välillä lopettaa?</b><br>\n";

if ($Ehd_vast{$ekpl,8} == 1) { print "$nel1 <font color=#111111>Pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,8} != 1) { print "$nel2 <font size=-1 color=#888888>Pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,8} == 2) { print "$nel1 <font color=#111111>Ei pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,8} != 2) { print "$nel2 <font size=-1 color=#888888>Ei pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,8} == 3) { print "$nel1 <font color=#111111>Ei mutta pitäisi järkevöittää</font><br>\n"; }
if ($Ehd_vast{$ekpl,8} != 3) { print "$nel2 <font size=-1 color=#888888>Ei mutta pitäisi järkevöittää</font><br>\n"; }

if ($Ehd_vast{$ekpl,8} == 4) { print "$nel1 <font color=#111111>En tiedä mistä on kysymys</font><br>\n"; }
if ($Ehd_vast{$ekpl,8} != 4) { print "$nel2 <font size=-1 color=#888888>En tiedä mistä on kysymys</font><br>\n"; }

print "<br>\n";

#-- 9 ----------------------------------
print"<b>9. Onko EU-kansanedustajan palkka (n. 40.000 mk/kk) oikean kokoinen?</b><br>\n";

if ($Ehd_vast{$ekpl,9} == 1) { print "$nel1 <font color=#111111>On</font><br>\n"; }
if ($Ehd_vast{$ekpl,9} != 1) { print "$nel2 <font size=-1 color=#888888>On</font><br>\n"; }

if ($Ehd_vast{$ekpl,9} == 2) { print "$nel1 <font color=#111111>Ei ole, se on liian suuri</font><br>\n"; }
if ($Ehd_vast{$ekpl,9} != 2) { print "$nel2 <font size=-1 color=#888888>Ei ole, se on liian suuri</font><br>\n"; }

if ($Ehd_vast{$ekpl,9} == 3) { print "$nel1 <font color=#111111>Ei ole, se on liian pieni</font><br>\n"; }
if ($Ehd_vast{$ekpl,9} != 3) { print "$nel2 <font size=-1 color=#888888>Ei ole, se on liian pieni</font><br>\n"; }

if ($Ehd_vast{$ekpl,9} == 4) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,9} != 4) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

print "<br>\n";

#-- 10 ----------------------------------
print"<b>10. Liikkuvatko tavarat ja ihmiset jo liian vapaasti yli rajojen?</b><br>\n";

if ($Ehd_vast{$ekpl,10} == 1) { print "$nel1 <font color=#111111>Liikkuvat</font><br>\n"; }
if ($Ehd_vast{$ekpl,10} != 1) { print "$nel2 <font size=-1 color=#888888>Liikkuvat</font><br>\n"; }

if ($Ehd_vast{$ekpl,10} == 2) { print "$nel1 <font color=#111111>Eivät liiku</font><br>\n"; }
if ($Ehd_vast{$ekpl,10} != 2) { print "$nel2 <font size=-1 color=#888888>Eivät liiku</font><br>\n"; }

if ($Ehd_vast{$ekpl,10} == 3) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,10} != 3) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

if ($Ehd_vast{$ekpl,10} == 4) { print "$nel1 <font color=#111111>Riippuu kehityksestä</font><br>\n"; }
if ($Ehd_vast{$ekpl,10} != 4) { print "$nel2 <font size=-1 color=#888888>Riippuu kehityksestä</font><br>\n"; }

print "<br>\n";

#-- 11 ----------------------------------
print"<b>11. Onko Suomen liittyminen Unioniin merkinnyt Suomelle enemmän plussaa kuin miinusta?</b><br>\n";

if ($Ehd_vast{$ekpl,11} == 1) { print "$nel1 <font color=#111111>Enemmän plussaa</font><br>\n"; }
if ($Ehd_vast{$ekpl,11} != 1) { print "$nel2 <font size=-1 color=#888888>Enemmän plussaa</font><br>\n"; }

if ($Ehd_vast{$ekpl,11} == 2) { print "$nel1 <font color=#111111>Enemmän miinusta</font><br>\n"; }
if ($Ehd_vast{$ekpl,11} != 2) { print "$nel2 <font size=-1 color=#888888>Enemmän miinusta</font><br>\n"; }

if ($Ehd_vast{$ekpl,11} == 3) { print "$nel1 <font color=#111111>Puntit ovat suurin piirtein tasan</font><br>\n"; }
if ($Ehd_vast{$ekpl,11} != 3) { print "$nel2 <font size=-1 color=#888888>Puntit ovat suurin piirtein tasan</font><br>\n"; }

if ($Ehd_vast{$ekpl,11} == 4) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,11} != 4) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

print "<br>\n";

#-- 12 ----------------------------------
print"<b>12. Antaako EU-jäsenyys Suomelle myös turvallisuutta?</b><br>\n";

if ($Ehd_vast{$ekpl,12} == 1) { print "$nel1 <font color=#111111>Antaa</font><br>\n"; }
if ($Ehd_vast{$ekpl,12} != 1) { print "$nel2 <font size=-1 color=#888888>Antaa</font><br>\n"; }

if ($Ehd_vast{$ekpl,12} == 2) { print "$nel1 <font color=#111111>Antaa tavallaan</font><br>\n"; }
if ($Ehd_vast{$ekpl,12} != 2) { print "$nel2 <font size=-1 color=#888888>Antaa tavallaan</font><br>\n"; }

if ($Ehd_vast{$ekpl,12} == 3) { print "$nel1 <font color=#111111>Ei anna</font><br>\n"; }
if ($Ehd_vast{$ekpl,12} != 3) { print "$nel2 <font size=-1 color=#888888>Ei anna</font><br>\n"; }

if ($Ehd_vast{$ekpl,12} == 4) { print "$nel1 <font color=#111111>Jää nähtäväksi</font><br>\n"; }
if ($Ehd_vast{$ekpl,12} != 4) { print "$nel2 <font size=-1 color=#888888>Jää nähtäväksi</font><br>\n"; }

print "<br>\n";

#-- 13 ----------------------------------
print"<b>13. Pitääkö Suomen ottaa jokainen direktiivi vakavasti?</b><br>\n";

if ($Ehd_vast{$ekpl,13} == 1) { print "$nel1 <font color=#111111>Pitää</font><br>\n"; }
if ($Ehd_vast{$ekpl,13} != 1) { print "$nel2 <font size=-1 color=#888888>Pitää</font><br>\n"; }

if ($Ehd_vast{$ekpl,13} == 2) { print "$nel1 <font color=#111111>Pitää niin kuin muidenkin</font><br>\n"; }
if ($Ehd_vast{$ekpl,13} != 2) { print "$nel2 <font size=-1 color=#888888>Pitää niin kuin muidenkin</font><br>\n"; }

if ($Ehd_vast{$ekpl,13} == 3) { print "$nel1 <font color=#111111>Ei pidä</font><br>\n"; }
if ($Ehd_vast{$ekpl,13} != 3) { print "$nel2 <font size=-1 color=#888888>Ei pidä</font><br>\n"; }

if ($Ehd_vast{$ekpl,13} == 4) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,13} != 4) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

print "<br>\n";

#-- 14 ----------------------------------
print"<b>14. Onko järkevää, että EU:lla on määräykset esimerkiksi kurkun muodolle ja koolle?</b><br>\n";

if ($Ehd_vast{$ekpl,14} == 1) { print "$nel1 <font color=#111111>On</font><br>\n"; }
if ($Ehd_vast{$ekpl,14} != 1) { print "$nel2 <font size=-1 color=#888888>On</font><br>\n"; }

if ($Ehd_vast{$ekpl,14} == 2) { print "$nel1 <font color=#111111>Ei ole</font><br>\n"; }
if ($Ehd_vast{$ekpl,14} != 2) { print "$nel2 <font size=-1 color=#888888>Ei ole</font><br>\n"; }

if ($Ehd_vast{$ekpl,14} == 3) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,14} != 3) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

if ($Ehd_vast{$ekpl,14} == 4) { print "$nel1 <font color=#111111>Riippuu</font><br>\n"; }
if ($Ehd_vast{$ekpl,14} != 4) { print "$nel2 <font size=-1 color=#888888>Riippuu</font><br>\n"; }

print "<br>\n";

#-- 15 ----------------------------------
print"<b>15. Pitäisikö EU:ta kehittää määrätietoisesti liittovaltion suuntaan?</b><br>\n";

if ($Ehd_vast{$ekpl,15} == 1) { print "$nel1 <font color=#111111>Pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,15} != 1) { print "$nel2 <font size=-1 color=#888888>Pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,15} == 2) { print "$nel1 <font color=#111111>Ei pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,15} != 2) { print "$nel2 <font size=-1 color=#888888>Ei pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,15} == 3) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,15} != 3) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

if ($Ehd_vast{$ekpl,15} == 4) { print "$nel1 <font color=#111111>Riippuu ympäröivän maailman kehityksestä</font><br>\n"; }
if ($Ehd_vast{$ekpl,15} != 4) { print "$nel2 <font size=-1 color=#888888>Riippuu ympäröivän maailman kehityksestä</font><br>\n"; }

print "<br>\n";

#-- 16 ----------------------------------
print"<b>16. Pitäisikö EU:n pyrkiä määrätietoisesti yhteiseen lainsäädäntöön?</b><br>\n";

if ($Ehd_vast{$ekpl,16} == 1) { print "$nel1 <font color=#111111>Pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,16} != 1) { print "$nel2 <font size=-1 color=#888888>Pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,16} == 2) { print "$nel1 <font color=#111111>Ei pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,16} != 2) { print "$nel2 <font size=-1 color=#888888>Ei pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,16} == 3) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,16} != 3) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

if ($Ehd_vast{$ekpl,16} == 4) { print "$nel1 <font color=#111111>Soveltuvin osin</font><br>\n"; }
if ($Ehd_vast{$ekpl,16} != 4) { print "$nel2 <font size=-1 color=#888888>Soveltuvin osin</font><br>\n"; }

print "<br>\n";

#-- 17 ----------------------------------
print"<b>17. Pitäisikö EU:n ulkorajan olla tarvittaessa tiivis muuri?</b><br>\n";

if ($Ehd_vast{$ekpl,17} == 1) { print "$nel1 <font color=#111111>Pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,17} != 1) { print "$nel2 <font size=-1 color=#888888>Pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,17} == 2) { print "$nel1 <font color=#111111>Ei pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,17} != 2) { print "$nel2 <font size=-1 color=#888888>Ei pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,17} == 3) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,17} != 3) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

if ($Ehd_vast{$ekpl,17} == 4) { print "$nel1 <font color=#111111>Mitä kysymys mahtaa tarkoittaa?</font><br>\n"; }
if ($Ehd_vast{$ekpl,17} != 4) { print "$nel2 <font size=-1 color=#888888>Mitä kysymys mahtaa tarkoittaa?</font><br>\n"; }

print "<br>\n";

#-- 18 ----------------------------------
print"<b>18. Onko oikein että kuka tahansa eu-kansalainen voi tulla töihin Suomeen?</b><br>\n";

if ($Ehd_vast{$ekpl,18} == 1) { print "$nel1 <font color=#111111>On oikein</font><br>\n"; }
if ($Ehd_vast{$ekpl,18} != 1) { print "$nel2 <font size=-1 color=#888888>On oikein</font><br>\n"; }

if ($Ehd_vast{$ekpl,18} == 2) { print "$nel1 <font color=#111111>Ei ole oikein</font><br>\n"; }
if ($Ehd_vast{$ekpl,18} != 2) { print "$nel2 <font size=-1 color=#888888>Ei ole oikein</font><br>\n"; }

if ($Ehd_vast{$ekpl,18} == 3) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,18} != 3) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

if ($Ehd_vast{$ekpl,18} == 4) { print "$nel1 <font color=#111111>Riippuu tilanteesta Suomessa</font><br>\n"; }
if ($Ehd_vast{$ekpl,18} != 4) { print "$nel2 <font size=-1 color=#888888>Riippuu tilanteesta Suomessa</font><br>\n"; }

print "<br>\n";

#-- 19 ----------------------------------
print"<b>19. Pitäisikö Itä-Euroopan maiden päästä nopeasti EU:n jäseniksi?</b><br>\n";

if ($Ehd_vast{$ekpl,19} == 1) { print "$nel1 <font color=#111111>Pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,19} != 1) { print "$nel2 <font size=-1 color=#888888>Pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,19} == 2) { print "$nel1 <font color=#111111>Ei pitäisi</font><br>\n"; }
if ($Ehd_vast{$ekpl,19} != 2) { print "$nel2 <font size=-1 color=#888888>Ei pitäisi</font><br>\n"; }

if ($Ehd_vast{$ekpl,19} == 3) { print "$nel1 <font color=#111111>Pitäisi tehdä vaikeammaksi</font><br>\n"; }
if ($Ehd_vast{$ekpl,19} != 3) { print "$nel2 <font size=-1 color=#888888>Pitäisi tehdä vaikeammaksi</font><br>\n"; }

if ($Ehd_vast{$ekpl,19} == 4) { print "$nel1 <font color=#111111>En tiedä</font><br>\n"; }
if ($Ehd_vast{$ekpl,19} != 4) { print "$nel2 <font size=-1 color=#888888>En tiedä</font><br>\n"; }

print "<br>\n";

#-- 20 ----------------------------------
print"<b>20. Mikä seuraavista maista pitäisi mielestänne ottaa seuraavana EU:n jäseneksi?</b><br>\n";

if ($Ehd_vast{$ekpl,20} == 1) { print "$nel1 <font color=#111111>Puola</font><br>\n"; }
if ($Ehd_vast{$ekpl,20} != 1) { print "$nel2 <font size=-1 color=#888888>Puola</font><br>\n"; }

if ($Ehd_vast{$ekpl,20} == 2) { print "$nel1 <font color=#111111>Unkari</font><br>\n"; }
if ($Ehd_vast{$ekpl,20} != 2) { print "$nel2 <font size=-1 color=#888888>Unkari</font><br>\n"; }

if ($Ehd_vast{$ekpl,20} == 3) { print "$nel1 <font color=#111111>Tshekki</font><br>\n"; }
if ($Ehd_vast{$ekpl,20} != 3) { print "$nel2 <font size=-1 color=#888888>Tshekki</font><br>\n"; }

if ($Ehd_vast{$ekpl,20} == 4) { print "$nel1 <font color=#111111>Viro</font><br>\n"; }
if ($Ehd_vast{$ekpl,20} != 4) { print "$nel2 <font size=-1 color=#888888>Viro</font><br>\n"; }

print "<br>\n";



print <<"UNTILL";

<hr noshade align=left>

<br>
<font size=-1>
<nobr>[ <a href="http://www.yle.fi/cgi-bin/a-studio/ehdokkaat.pl" target="_top">Kaikki ehdokkaat</a> ]</nobr>
<nobr>[ <a href="http://www.yle.fi/a-studio/ab-index.html" target="_top">A-studion ohjelmasivu</a> ]</nobr>
<nobr>[ <a href="http://www.yle.fi/a-studio/nfeukyse.html" target="_top">EU-kysely</a> ]</nobr>
</font><p>

</BODY>
</HTML>
UNTILL

}


