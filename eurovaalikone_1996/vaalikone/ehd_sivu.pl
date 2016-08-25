#!/usr/bin/perl

# A-STUDION EUROVAALIEHDOKKAAT
# Sanna Järvinen / YLE

$dir = "/opt/local/apache2/htdocs/astud_eukysely";
$ehd_sivut = "ehd_sivut";
$file_ehdvast = "$dir/ehdokkaat.txt";
$tmp_file =  "$dir/tmp.txt";

$max_kpl = 2;

#--------------------- EU-VAALIEHDOKKAAT TIEDOSTOSTA ------------------------
# Lue ehdokkaat tiedostosta
open(IFD, $file_ehdvast);

$ekpl = 0;
while ($rivi1 = <IFD>) {

    $ekpl++;  
    chop($rivi1);
    @rivi = split(/,/,$rivi1);
    
    #Ehdokkaan nimi
    @tmp = split(/ /,$rivi[0]);
    # Sukunimi
    $Ehdokkaat{$ekpl,0} = $tmp[0];
    # Etunimi
    $Ehdokkaat{$ekpl,1} = $tmp[1];
   
    # Ehdokkaan puolue
    $Ehdokkaat{$ekpl,2} = $rivi[1];

}
close(IFD);

#--------------- KAYTTAJAN VALITSEMAT EHDOKKAAT ---------------------------

read(STDIN,$input,$ENV{'CONTENT_LENGTH'});
@fields = split(/&/,$input);

$kpl = 0;
for (@fields) {
 
    ($kentta,$arvo) = split(/=/,$_);

    for ($i = 1; $i < 500; $i++) {
        if ($kentta eq "cb$i") {
	    $kpl++;
            $Ehdokas[$kpl] = $arvo;
	    break;
	}  
    }    
}




#--------------- HTML - KOODI ----------------------------------------------

if($kpl == 0) { print "Location:ehdokkaat.pl\n\n"; }

if($kpl == 1) { print "Location:$ehd_sivut/$Ehdokas[1].html\n\n"; }

if($kpl > 1) {

print <<"UNTILL";
Content-type: text/html

<HTML>
<HEAD>
<meta charset="UTF-8"> 
<TITLE>EUROVAALIEHDOKKAAT</TITLE>
<!-- Author Sanna Järvinen (sanna.jarvinen@yle.fi), Aug 1996 -->
</HEAD>

<FRAMESET cols="50%,50%" FRAMEBORDER=1 BORDER=1>
<FRAME SRC="$ehd_sivut/$Ehdokas[1].html" NAME="vasen" MARGINHEIGHT=8 MARGINWIDTH=7 SCROLLING=yes>
<FRAME SRC="$ehd_sivut/$Ehdokas[2].html" NAME="oikea" MARGINHEIGHT=8 MARGINWIDTH=7 SCROLLING=yes>
</FRAMESET>

<NOFRAME>
</NOFRAME>
</HTML>
UNTILL
}

exit(0);


###########################################################################
