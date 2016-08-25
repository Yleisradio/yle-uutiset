# Ylen eurovaalikone 1996

Maailman tiettävästi ensimmäinen vaalikone toteutettiin Ylellä vuoden 1996 eurovaaleihin.

Juttu Yle Areenassa: http://areena.yle.fi/1-3062186?start=23min
Juttu Yle Uutisissa: http://yle.fi/uutiset/9115786

## Rakenne

**ehdokkaat.pl**
Eurovaaliehdokkaat näyttävä sivu, josta voidaan valita enintään kahden ehdokkaan vastaukset vertailuun.

**ehd_sivu.pl**
Kokoava sivu, jossa voidaan näyttää joko yhden tai kahden ehdokkassivun vastaukset kootusti.

**ehd_sivut**
Kansio, jossa yksittäisten ehdokkaiden sivut.

**lomake.html**
Käyttäjä vastaa vaalikoneen kysymyksiin. (Tämä ei ole alkuperäinen, vaan on toteutettu vaalikoneesta olevien kuvankaappausten perusteella).

**eukysely.pl**
Näyttää käyttäjälle vastauksiinsa perustuen hänelle soveltuvimmat ja ei-soveltuvimmat ehdokkaat. Eli lasketaan kenen kanssa eniten yhteisiä vastauksia.

**ehdokkaat.txt**
Ehdokkaiden vastausdata.

**tee_ehd_sivu.pl**
Scripti jolla luodaan ehd_sivut kansiosta löytyvät ehdokassivut ehdokasdatan perusteella.

**eukysely**
Enemmän tai vähemmän tarpeeton kansio.

## Toteuttamattomat ominaisuudet

Vaalikoneesta löytyy kaksi toiminnallisuutta, joita ei ole ilmeisesti otettu käyttöön. Ensimmäinen on ehdokkaiden mietelauseet (sloganit). Toinen on vastausten vertailu puolueiden vastauksiin.

## Käyttöönotto

Kone on toteutettu PERL-ohjelmointikielellä. Tarvitset siis web-palvelimen, jossa on PERL-tulkki.

Ohjeita:
http://httpd.apache.org/docs/current/howto/cgi.html

Lisäksi polut täytyy asettaa kuntoon .pl-tiedostojen alussa. Eli muuta tämä vastaamaan omaa ympäristöäsi:

<code>
$dir = "/opt/local/apache2/htdocs/astud_eukysely";
</code>

## Alkuperäinen toteutus

Erkki Vihtonen, Yle

Sanna Rönnblad, Yle

## Lisenssi

Kaikki oikeudet pidätetään.

## Lisätiedot

Teemo Tebest, teemo.tebest@yle.fi