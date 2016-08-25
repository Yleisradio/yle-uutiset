#!/usr/bin/perl

# A-STUDION EUROVAALIEHDOKKAAT
# Sanna Järvinen / YLE

$dir = "/opt/local/apache2/htdocs/astud_eukysely";
$dir2 = "eukysely";
$file_ehdvast = "$dir/ehdokkaat.txt";
$file_ehdmuut = "$dir/ehd_muut.txt";
$tmp_file =  "$dir/ehd_tmp.txt";

$form_action = "ehd_sivu.pl";

#--------------------- AAKKOSJARJESTYS -------------------------------------------
# Ensin puolueen, sitten nimen mukaan

# system ("chmod 666 $file_ehdvast");
# system ("sort -t, +1 -2 +0 -1 -o $tmp_file $file_ehdvast");
# system ("cp $tmp_file $file_ehdvast");


#--------------------- EU-VAALIEHDOKKAAT -------------------------------------------
# Lue ehdokkaat tiedostosta
open(IFD, $file_ehdvast);

$ekpl = 0;
while ($rivi1 = <IFD>) {
    
    $ekpl++;  
    chop($rivi1);
    @rivi = split(/,/,$rivi1);
    
    #Ehdokkaan koko nimi
    $Ehdokkaat{$ekpl,3} = $rivi[0];  
 
    @tmp = split(/ /,$rivi[0]);
    # Sukunimi, tarvitaan vain talletettaessa 
    $Ehdokkaat{$ekpl,0} = $tmp[0];
    # Etunimi, tarvitaan vain talletettaessa 
    $Ehdokkaat{$ekpl,1} = $tmp[1];
 
    # Ehdokkaan puolue
    $Ehdokkaat{$ekpl,2} = $rivi[1];

}
close(IFD);



#--------------- HTML - KOODI ----------------------------------------------
print <<"UNTILL";
Content-type: text/html

<HTML>
<HEAD>
<meta charset="UTF-8"> 
<TITLE>EUROVAALIEHDOKKAAT</TITLE>
<!-- Author Sanna Järvinen (sanna.jarvinen@yle.fi), Aug 1996 -->
</HEAD>
<BODY bgcolor=#FFFFFF TEXT=#000000 LINK=#0000CC VLINK=#0000EE ALINK=#CCCCFF>

<font size=-1>
<nobr>[ <a href="http://www.yle.fi/a-studio/ab-index.html" target="_top">A-studion ohjelmasivu</a> ]</nobr>
<nobr>[ <a href="http://www.yle.fi/a-studio/nfeukyse.html" target="_top">EU-kysely</a> ]</nobr>
</font><br>

<br>

<hr noshade align=left>
<table width=100% border=0 cellspacing=0 cellpadding=0>
<tr><td align=left valign=center>
<font size=+1>EUROVAALIEHDOKKAAT / <i>henkilökohtaiset vastaukset</i></font>
</td><td width=45 align=middle valign=center>
<img src="$dir2/pics/eulippu_m1.gif" alt="" width=40 height=32>
</td></tr>
</table>
<hr noshade align=left>

<FORM METHOD=post ACTION=$form_action>

A-Studio tarjoaa ainutlaatuisen mahdollisuuden ehdokkaiden vertailuun
tämän uuden A-Web palvelun avulla.<p>

Valitse allaolevasta listasta <b>korkeintaan kaksi ehdokasta</b> klikkaamalla
pientä neliötä ennen nimeä. Paina sivun alaosassa olevaa "Suorita vastausten
haku" -painiketta. SAAT VERTAILUUN VALITSEMASI EHDOKKAAT "au naturel", heidän 
vastauksensa kaikkiin EU-kyselyn kysymyksiin! Voit hakea vertailuun juuri ne 
ehdokkaat joista olet eniten kiinnostunut, tai hänet, josta et oikein tiedä 
onko hän lintu vai..<p>

Palvelu on avoinna Hangosta Tenojoelle - ja kauemmaksikin- 24 tuntia
vuorokaudessa vaalipäivään 20. lokakuuta asti. Tee valistunut valinta!<p>

<br>
<table border=0> 
<tr>
<td width=50% valign=top align=left>
UNTILL

#------------ EHDOKKAAT LISTANA -----------------------

$edellinen_puolue = $Ehdokkaat{1,2};
print"<font color=220077>$Ehdokkaat{1,2}</font><br>\n";

$rows = sprintf("%.0d",$ekpl/2);

for ($i = 1; $i < $rows+1; $i++) {
   $tmp1 = substr($edellinen_puolue,0,3);
   $tmp2 = substr($Ehdokkaat{$i,2},0,3);
   if ($tmp1 ne $tmp2) {
       print"<br>\n";
       print"<font color=#220077>$Ehdokkaat{$i,2}</font><br>\n";
       $edellinen_puolue = $Ehdokkaat{$i,2};
   }

   if($Ehdokkaat{$i,3} ne "") {
       print"<input type=checkbox name=\"cb$i\" value=\"$Ehdokkaat{$i,0}.$Ehdokkaat{$i,1}\">\n";
       print"<font size=-1>";
       print"<b>$Ehdokkaat{$i,3}</b>, $Ehdokkaat{$i,2}</font><br>\n";
   }
}

print"</td>\n";
print"<td width=50% valign=top align=left>\n";

for ($i = $rows+1; $i < $ekpl+1 ; $i++) {
   $tmp1 = substr($edellinen_puolue,0,3);
   $tmp2 = substr($Ehdokkaat{$i,2},0,3);
   if ($tmp1 ne $tmp2) {
       print"<br>\n";
       print"<font color=#220077>$Ehdokkaat{$i,2}</font><br>\n";
       $edellinen_puolue = $Ehdokkaat{$i,2};
   }

   if($Ehdokkaat{$i,3} ne "") {
       print"<input type=checkbox name=\"cb$i\" value=\"$Ehdokkaat{$i,0}.$Ehdokkaat{$i,1}\">\n";
       print"<font size=-1>";
       print"<b>$Ehdokkaat{$i,3}</b>, $Ehdokkaat{$i,2}</font><br>\n";
   }
}

print <<"UNTILL";

</td>
</tr>

<tr>
<td> 
</td>
<td align=left valign=bottom> 
<br>
<INPUT type="submit" name=Button value="Suorita vastausten haku">
</td>
</tr>

</table>

<hr noshade align=left>
<br>
<font size=-1>
<nobr>[ <a href="http://www.yle.fi/a-studio/ab-index.html" target="_top">A-studion ohjelmasivu</a> ]</nobr>
<nobr>[ <a href="http://www.yle.fi/a-studio/nfeukyse.html" target="_top">EU-kysely</a> ]</nobr>
</font><br>

</FORM>

</BODY>
</HTML>
UNTILL

exit(0);


###########################################################################
