(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: IMAGES.PAS                                                     *)
(*  Obsah: univerzalni jednotka pro praci s rastrovymi obrazky             *)
(*         (kompatibilni s VESA.TPU i VGA.TPU)                             *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*         castecne zalozeno na jednotce Textures / Nashorn & soul_draco   *)
(*  Posledni uprava: 15.12.2011                                            *)
(*  Pro kompilaci: PALETA2.TPU, NFSUP.TPU                                  *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit Images;
{$R-,B-,I-,G+}

{Jednotka zpracovava 256barevne rastrove bitmapy ve formatu, s jakym pracuji
procedury _getimage, _putimage, _puttimage a _putrtimage z jednotky VESA.TPU
a procedury vgagetimage, vgaputimage a vgaputtimage z VGA.TPU, tj. obdelnikove
2D pole jednobytovych pixelu razene po radcich zleva doprava a odshora dolu
bez jakychkoli pridavnych informaci (rozmery apod.) nebo komprese.
Dale tu jsou procedury pro prevod na sprite a zpet a procedury pro praci s
nekolika beznymi grafickymi soubory (CUT, BMP, PCX a ORF).

Krome funkce SaveImageToFile, ktera za urcitych okolnosti nacita aktualni
paletu z obrazovky, je cela jednotka na obrazovce nezavisla a tedy pouzitelna
naprosto kdykoli, treba i v textovem rezimu.

*** POZOR! ***  Vsechny procedury, ktere ukladaji vysledek pod ukazatel
NovyObrazek, pocitaji s tim, ze tento ukazatel ukazuje na jiz pripravenou,
alokovanou pamet. SAMY NIC AUTOMATICKY NEALOKUJI!

Bitmapa predavana jako parametr PuvodniObrazek nikdy nebude ovlivnena.

Veskere souradnice pouzite v parametrech procedur a funkci se pocitaji tak,
ze levy horni roh bitmapy je 0,0, x pribyva smerem doprava a y smerem dolu.}

interface

uses paleta2;

(***************** obecne rutiny pro praci s bitmapami: *********************)

procedure ResizeImage(PuvodniObrazek:pointer; PuvodniSirka,PuvodniVyska:word;
                      NovyObrazek:pointer; NovaSirka,NovaVyska:word);
{Smrskne nebo natahne PuvodniObrazek z Puvodnich rozmeru na Nove.}

procedure Subimage(PuvodniObrazek:pointer; PuvodniSirka,PuvodniVyska:word;
                   LHX,LHY:integer; BarvaOkoli:byte;
                   NovyObrazek:pointer; NovaSirka,NovaVyska:word);
{Z bitmapy pod ukazatelem PuvodniObrazek o rozmerech PuvodniSirka x
PuvodniVyska vezme vyrez o rozmerech NovaSirka x NovaVyska s levym hornim
rohem na souradnicich LHX,LHY (pocitano od leveho horniho rohu puvodniho
obrazku) a ulozi ho do bitmapy NovyObrazek. Pokud vyrez nekde vycuhuje mimo
puvodni obrazek (coz je povoleno), bude vycuhujici cast vyplnena BarvouOkoli.}

procedure FlipImageHorizontally(PuvodniObrazek:pointer; Sirka,Vyska:word; NovyObrazek:pointer);
{Vezme PuvodniObrazek o dane Sirce a Vysce, zrcadlove ho prevrati okolo svisle
osy (prohodi se leva a prava strana) a vysledek ulozi do NovehoObrazku
o stejnych rozmerech.}

procedure FlipImageVertically(PuvodniObrazek:pointer; Sirka,Vyska:word; NovyObrazek:pointer);
{Podobne, ale zrcadli se okolo vodorovne osy (prohodi se horni a dolni
strana).}

procedure TurnImage1(PuvodniObrazek:pointer; Sirka,Vyska:word;
                     NovyObrazek:pointer;
                     OKolik:integer);
{Otoci PuvodniObrazek o dane Sirce a Vysce o OKolik ctvrtotocek po smeru
hodinovych rucicek (nebo proti, kdyz date zaporne cislo) a vysledek ulozi
do NovehoObrazku (jeho velikost je stejna jako velikost Puvodniho, jenom se
pri liche hodnote OKolik prohodi sirka a vyska).}

procedure TurnImage2(PuvodniObrazek:pointer; PuvodniSirka,PuvodniVyska:word;
                     PuvodniStredX,PuvodniStredY:integer;
                     NovyObrazek:pointer; NovaSirka,NovaVyska:word;
                     NovyStredX,NovyStredY:integer;
                     OKolik:integer;
                     BarvaOkoli:byte);
{Otoci PuvodniObrazek o dane PuvodniSirce a PuvodniVysce o OKolik stupnu po
smeru hodinovych rucicek (nebo proti, kdyz date zaporne cislo) a vysledek
ulozi do NovehoObrazku o NoveSirce a NoveVysce. PuvodniObrazek se otaci kolem
bodu PuvodniStredX, PuvodniStredY (pocitano relativne od jeho leveho horniho
rohu, stred otaceni muze lezet i mimo obrazek). Tento bod se do NovehoObrazku
promitne na souradnice NovyStredX, NovyStredY (relativne od leveho horniho
rohu NovehoObrazku, opet muze lezet i mimo). Nezalezi na tom, jestli bude
NovyObrazek vetsi nebo mensi nez Puvodni. Co by precuhovalo, to se orizne, a
kde by chybelo, tam se to vyplni BarvouOkoli.}

procedure BevelVertically(PuvodniObrazek:pointer; Sirka,Vyska:word;
                          NovyObrazek:pointer;
                          LH,PH,LD,PD:integer;
                          BarvaOkoli:byte);
{Zkosi PuvodniObrazek a vysledek ulozi do NovehoObrazku o stejnych rozmerech.
Parametry LH, PH, LD a PD rikaji, o kolik pixelu se ma obrazek v danem rohu
vertikalne zdrcnout:       _________    _________
       _-~|  |~-_         |         |  |         |
LH  _-~   |  |   ~-_  PH  |_        |  |        _|
v_-~      |  |      ~-_v  ^ ~-_     |  |     _-~ ^
|         |  |         |  LD   ~-_  |  |  _-~   PD
|_________|  |_________|          ~-|  |-~

Da se zkosit i vic rohu soucasne, jenom pozor na to, aby soucet zkoseni
u dvou vrcholu nad sebou nepresahl celkovou vysku obrazku (neni to nijak
automaticky zabezpeceno).
Vznikle prazdne misto se vyplni BarvouOkoli.}

procedure BevelHorizontally(PuvodniObrazek:pointer; Sirka,Vyska:word;
                            NovyObrazek:pointer;
                            LH,PH,LD,PD:integer;
                            BarvaOkoli:byte);
{Podobne, ale obrazek zdrcne ve vodorovnem smeru:
 LH >_____    _____< PH    _________    _________
    /     |  |     \       \        |  |        /
   /      |  |      \       \       |  |       /
  /       |  |       \       \      |  |      /
 /        |  |        \       \     |  |     /
/_________|  |_________\   LD >\____|  |____/< PD   }

procedure HorizontalFog(PuvodniObrazek:pointer; Sirka,Vyska:word;
                        NovyObrazek:pointer;
                        var paleta:rgbpal256;
                        JasVlevo,JasVpravo:integer);
{Gradientni ztmaveni obrazku. Na levem okraji bude JasVlevo, na pravem
JasVpravo (oboje v procentech, 0 = uplne cerno .. 100 = bez ztmaveni), mezi
tim bude plynuly prechod. Pozor na pomerne velkou casovou narocnost
(radove nekolik vterin podle velikosti obrazku, rychlosti procesoru a podle
nastaveni direktivy $define Eukl v jednotce Paleta2).}

procedure VerticalFog(PuvodniObrazek:pointer; Sirka,Vyska:word;
                      NovyObrazek:pointer;
                      var paleta:rgbpal256;
                      JasNahore,JasDole:integer);
{Podobna, ale prechod jasu je mezi hornim a dolnim okrajem.}

procedure UniformFog(PuvodniObrazek:pointer; Sirka,Vyska:word;
                     NovyObrazek:pointer;
                     var paleta:rgbpal256;
                     Jas:word);
{Rovnomerne ztmaveni obrazku po cele plose, hodnota Jas je opet v procentech
(0..100). Neni tolik casove narocna jako predchozi dve procedury.}

procedure ReplaceColor(Obrazek:pointer; Sirka,Vyska:word;
                       PuvodniBarva,NovaBarva:byte);
{V Obrazku vsechny pixely v PuvodniBarve prebarvi na NovouBarvu.}

procedure CropImage(PuvodniObrazek:pointer; PuvodniSirka,PuvodniVyska:word;
                    NovyObrazek:pointer; var NovaSirka,NovaVyska:word;
                    BarvaKOriznuti:byte);
{Z PuvodnihoObrazku orizne vsechny okrajove radky a sloupce, ktere obsahuji
pouze BarvuKOriznuti, a vysledek ulozi do NovehoObrazku.}
procedure SetImageSize(PuvodniObrazek:pointer; PuvodniSirka,PuvodniVyska:word;
                       NovyObrazek:pointer; NovaSirka,NovaVyska:word;
                       BarvaOkraju:byte; ZarovnaniX,ZarovnaniY:char);
{K PuvodnimuObrazku prida okraje v dane BarveOkraju tak siroke, aby se dostal
na celkove rozmery NovaSirka*NovaVyska. Nove rozmery musi byt vetsi nebo
alespon stejne jako puvodni; jestli date mensi, procedura nic neudela.
 ZarovnaniX: 'L'      - vLevo / Left
             'P', 'R' - vPravo / Right
             'S', 'C' - na Stred / Center
 ZarovnaniY: 'H', 'U' - naHoru / Up
             'D'      - Dolu / Down
             'S', 'C' - na Stred / Center
 Pismena muzou byt i mala, je to jedno.}

(********************** funkce pro praci se sprity: *************************)

function ImageToSprite(Obrazek:pointer; Sirka,Vyska:word; Kam:pointer;
                       MaxVelikost:word; PruhlednaBarva:byte):boolean;
{Prevede obrazek na specialni "pruhledny" tvar, ktery se vykresluje mnohem
rychleji nez bezny obdelnikovy rastr (podrobnejsi informace najdete na konci
teto jednotky).
 Obrazek - ukazatel na puvodni bitmapu
 Sirka, Vyska - jeji rozmery
 Kam - ukazatel na predem alokovane misto, do ktereho se prevedeny obrazek
       ulozi
 MaxVelikost - sem zadejte, jak velke to alokovane misto je, resp. kolik mista
               v nem jste ochotni funkci poskytnout - velikost obrazku totiz
               neni nijak jednoduse predem spocitatelna.
 PruhlednaBarva - ktera barva v obrazku se ma povazovat za pruhlednou
Pokud se obrazek podari prevest cely, funkce vrati true. Pokud ne (tedy pokud
by jeho velikost presahla zadanou hodnotu MaxVelikost), bude prevedena jenom
cast (bez problemu zobrazitelna) a vrati se false. Vysledna velikost nacteneho
obrazku v bytech je ulozena na zacatku Kam^ ve formatu word (velikost je
pocitana vcetne tohohle wordu).}

procedure SpriteToImage(Odkud:pointer; Kam:pointer; Sirka,Vyska:word;
                        x,y:integer; PruhlednaBarva:byte);
{Prevod v opacnem smeru: obrazek v "pruhlednem" tvaru pod ukazatelem Odkud
zobrazi do rastroveho obrazku o dane Sirce a Vysce pod ukazatelem Kam na
souradnice x a y (pocitano od leveho horniho rohu ciloveho obrazku).
"Pruhledna" mista vyplni PruhlednouBarvou. Pokud se obrazek do rastru nevejde,
bude bezpecne oriznut podle jeho okraju.}

procedure MoveSpriteOrigin(Sprite:pointer; DeltaX,DeltaY:integer);
{Dany Sprite posune o DeltaX vodorovne a DeltaY svisle vzhledem k referencnimu
bodu.}

(******** funkce pro ukladani a nacitani ve standardnich formatech: *********)
{Podrobny popis techto formatu najdete na konci zdrojaku.}

function SaveImageToFile(Obrazek:pointer; Sirka,Vyska:word;
                         JmenoSouboru:string; Paleta,DalsiInfo:pointer):byte;
{Univerzalni funkce pro ukladani obrazku do souboru. Parametry:
 Obrazek, Sirka, Vyska - obrazek, ktery se ma ulozit
 JmenoSouboru - piste vcetne koncovky, v pripade potreby s cestou. Koncovka
                urcuje format, v jakem se ma obrazek ulozit. Funkce zvlada
                typy CUT, BMP, PCX a ORF a uklada vzdy v 8 bpp (256 barev).
 Paleta - kdyz chcete obrazek ulozit i s paletou, nasmerujte tenhle ukazatel
          na prislusnou promennou typu Rgbpal. Jestli chcete ukladat bez ni,
          nastavte ho na nil (pokud dany typ paletu vyzaduje, bude nactena
          aktualni paleta z obrazovky, coz ovsem vyzaduje, aby byla zapnuta
          grafika - POZOR!!!).
 DalsiInfo - obvykle nil, ale jestli chcete obrazku nastavit nejake dalsi
             parametry, ktere funkce v hlavicce nema (DPI, popisy apod.),
             nasmerujte ho na vyplnenou promennou nasledujiciho typu:}
type infotyp = record
               {pro BMP a PCX:}
               xDPI,yDPI:word; {rozliseni v px/inch; vychozi = 96 pro obe}
               {pro CUT:}
               CUTRezerva:word; {co se ma zapsat do rezervovaneho wordu v hlavicce (normalne 0)}
               CUTExtraData:string; {co se ma vpasovat za konec posledniho radku obrazku
                                  (tahle jednotka to pak muze zase nacist, jine ctecky si toho nevsimnou)}
               CUTPopisPalety:string[20]; {popis, ktery se ulozi do hlavicky souboru s paletou
                                          (pri ukladani bez palety nema zadny efekt)}
               {pro BMP:}
               BMPverzeDIB:byte; {1 (OS/2) nebo 3 (Windows); vychozi = 1}
                   {tohle funguje jen s verzi 3:}
               BMPPocetBarev:word; {pocet polozek palety, 0 = vsechny (podle bitove hloubky) = vychozi
                                 Tohle ovlivnuje jenom velikost palety, ne bitovou hloubku.}
               BMPPocetPlatnychBarev:word; {kolik barev je opravdu dulezitych, 0 = vsechny = vychozi
                                            (jen informativni hodnota pro prohlizece)}
               {pro PCX:}
               PCXpopis:string[57]; {text, ktery se ma vlozit do rezervovaneho mista v hlavicce; vychozi = same #0}
               end;
{Navratova hodnota funkce:}
const siOK=0; {obrazek je v poradku ulozen}
      siJakzTakz=4; {obrazek je ulozen, ale neco mu chybi nebo byl nejak
                     vyrazneji automaticky upraven (napr. nebyla poskytnuta
                     paleta, ale vybrany typ ji vyzaduje, tak byla naplnena
                     vychozimi barvami)}
      siChybaFormatu=8; {obrazek se nepovedlo ulozit kvuli omezenim vybraneho
                         formatu (napr. pri pokusu ulozit do formatu ORF
                         obrazek o jinych rozmerech nez 320x200 px)}
      siChybaParametru=12; {obrazek se nepovedlo ulozit kvuli spatne zadanym
                            parametrum (neplatne jmeno souboru, neznama
                            koncovka apod.)}
      siMaloPameti=16; {obrazek se nepovedlo ulozit kvuli nedostatku pameti
                        (nebylo misto na nezbytne pomocne buffery)}
      siChybaIO=20; {obrazek se nepovedlo ulozit kvuli chybe I/O
                     (plny nebo zamceny disk apod.)}
      siPrvniChyba=8; {pro pohodlne testovani uspesnosti: kdyz je hodnota
                       mensi nez tohle, je obrazek ulozen}

{Funkce Saveimagetofile se da pouzit i na ukladani obrazku z obrazovky nebo
obecne odkudkoli. Jedine, co je k tomu potreba, je nasmerovat tuto promennou:}
var GetLine:function(P:pointer; S,Y:word):pointer;
{na funkci, kterou si za tim ucelem napisete. V parametru P ji bude predana
hodnota parametru Obrazek, v S jeho sirka a v Y cislo radku (pocitano od 0).
Vratit musi ukazatel na zacatek Yteho radku obrazku.
Standardne tato promenna odkazuje na nasledujici funkci:}
function GetImageLine(Obrazek:pointer; Sirka,y:word):pointer;
{Vrati ukazatel na zacatek yteho radku v danem Obrazku o dane Sirce.}

function LoadImageFromFile(var Obrazek:pointer; var Sirka,Vyska:word;
                           var Soubor:file; Typ:byte; Paleta,DalsiInfo:pointer):byte;
{Univerzalni funkce pro nacitani obrazku ze souboru. Parametry:
 Obrazek - pod timto ukazatelem bude automaticky alokovana bitmapa pro obrazek
           (nic nealokujte predem!).
 Sirka, Vyska - v nich budou bud skutecne rozmery bitmapy v pixelech (i v
                pripade, ze se bitmapu nepovede alokovat nebo nacist), nebo
                nuly (to kdyby se nepovedlo nacist ani ty rozmery).
 Soubor - beztypovy soubor otevreny pro cteni s velikosti bloku 1
          (tj. reset(soubor,1);). "Kurzor" dojede presne za konec obrazku a
          soubor se nezavre, takze je mozne jich mit v jednom souboru nasypano
          vic za sebou a cist je jeden po druhem.
 Typ - urcuje format obrazku. Mozne hodnoty:} const _CUT=1;
                                                    _BMP=2;
                                                    _PCX=3;
                                                    _ORF=4;   {
       Format BMP je podporovan ve verzi 1 (OS/2) i 3 (Windows) a ve vsech
       barevnych hloubkach (1, 4, 8 i 24 bpp). Po nacteni bude v pameti ulozen
       vzdy jako 8 bpp. Obrazky ve 24 bpp se spravne nactou pouze v pripade,
       ze obsahuji max. 256 ruznych barev (barvy se berou jak jsou, neprobiha
       zadne prevzorkovavani); pokud jich je vic, dostanete navratovy kod 4
       a prislusne pixely budou vyplneny barvou 0.
       Format PCX je podporovan pouze v 8 bpp.
 Paleta - bud ukazuje na promennou typu Rgbpal256, do ktere se ma ulozit
          paleta nactena z obrazku, nebo je nil a pak se paleta ignoruje.
          U obrazku typu CUT tato funkce paletu necte.
          U 24 bpp BMP je paleta povinna.
 DalsiInfo - bud ukazuje na promennou vyse uvedeneho typu Infotyp, do ktere
             se maji ulozit prislusne informace nactene ze souboru, nebo je
             nil a pak se tyto informace nikam neulozi.
Navratova hodnota funkce:}
const liOK=0; {vse v poradku, obrazek je nacteny}
      liChybiPaleta=4; {obrazek je nacteny, ale paleta ne}
      liChybaVSouboru=8; {data v souboru jsou chybna, obrazek se nepodarilo rozkodovat}
      liMaloPameti=12; {nestacila pamet na alokaci bitmapy nebo na pomocne buffery}
      liChybaIO=16; {chyba pri cteni ze souboru (predcasny konec, chyba na disku apod.),
                     obrazek se asi nenacetl}
      liNeumime=20; {tenhle format funkce nacist neumi (napr. komprimovane BMP apod.)}
      liChybaParametru=24; {chybna hodnota Typu}
      liSouborNeexistuje=28; {nevyuzito}

      liPrvniChyba=8; {odtud vys jsou to zavazne chyby, obrazek asi neni nacteny}

function LoadImageFromFile2(var Obrazek:pointer; var Sirka,Vyska:word;
                            JmenoSouboru:string; Paleta,DalsiInfo:pointer):byte;
{Opet nacitani obrazku ze souboru, ale tentokrat ciste jenom z grafickych
souboru s jednim obrazkem, zadne knihovny ani slozeniny. Parametry:
 Obrazek, Sirka, Vyska - viz vyse
 JmenoSouboru - jmeno souboru, ze ktereho se ma nacitat, vcetne koncovky a
                pripadne cesty. Funkce si soubor otevre, precte a zase zavre.
                Typ obrazku se urci podle koncovky, podporovany jsou stejne
                typy jako u predchozich dvou funkci.
 Paleta - viz vyse. U obrazku typu neco.CUT se paleta nacte z oddeleneho
          souboru neco.PAL, pri jakekoli chybe dostanete navratovy kod 4.
 DalsiInfo - viz vyse.
Navratove kody: viz vyse. liChybaParametru tentokrat muze znamenat i neplatne
                JmenoSouboru, liSouborNeexistuje rika, ze zadany soubor
                neexistuje (jak necekane :-) ).}

implementation
uses nfsup;

type polebytu=array[0..767] of byte; {pomocny typ pro pristup k jednotlivym bytum bitmap
                 (rozsah 768 B je zvolen jenom proto, aby slo pole pretypovat
                  na takhle velkou paletu, ale obecne na nem vubec nezalezi)}


procedure ResizeImage(PuvodniObrazek:pointer; PuvodniSirka,PuvodniVyska:word;
                      NovyObrazek:pointer; NovaSirka,NovaVyska:word);
var i,j:longint; {indexy pro pohyb v novem obrazku; longint je jenom pojistka proti pretekani pri nasobeni}
    ZacatekRadku:word; {pomocna hodnota}
Begin
for i:=0 to novavyska-1 do {pro kazdy radek noveho obrazku}
 begin
 {tohle cislo je pro cely radek stejne, tak si ho predpocitame jenom jednou:}
 zacatekradku:=((puvodnivyska*i) div novavyska)*puvodnisirka;
 for j:=0 to novasirka-1 do {pro kazdy pixel v radku}
  polebytu(novyobrazek^)[i*novasirka+j]:=polebytu(puvodniobrazek^)[zacatekradku+(puvodnisirka*j) div novasirka];
 end;
End;{resizeimage}

(*Nasledujici procedura funguje podobne jako ta predchozi, ale umi jenom
zmensovat, a to navic max. do poloviny rozmeru originalu (potom zacne zprava
a zdola orezavat). Jedina vyhoda je, ze je nepatrne rychlejsi a vysledny
obrazek vypada trochu lip (pouziva se Bresenhamuv algoritmus a ne * a div).
Vyrazeno pro zbytecnost.

procedure ZmensiObrazekB(PuvodniObrazek:pointer; PuvodniSirka,PuvodniVyska:word;
                         NovyObrazek:pointer; NovaSirka,NovaVyska:word);
var rozdil,pom,i,PolohaNaVstupu,PolohaNaVystupu:word;
    mezipamet:pointer;
    velikost:longint;
Begin
if (puvodnisirka=novasirka)and(puvodnivyska=novavyska)
  then begin
       move32(puvodniobrazek^,novyobrazek^,puvodnisirka*puvodnivyska);
       exit;
       end;
if (puvodnisirka<>novasirka)and(puvodnivyska<>novavyska)
  then begin
       velikost:=puvodnisirka*novavyska;
       if (velikost>65528)or(velikost>maxavail) then exit;
       getmem(mezipamet,velikost);
       end
  else if puvodnivyska=novavyska then mezipamet:=puvodniobrazek
                                 else mezipamet:=novyobrazek;{puvodnisirka=novasirka}
{Bresenham:}
{vynechavani radku:}
if puvodnivyska<>novavyska
  then begin
       rozdil:=puvodnivyska-novavyska;
       pom:=novavyska shr 1;
       polohanavstupu:=0; polohanavystupu:=0;
        repeat
        move32(polebytu(puvodniobrazek^)[puvodnisirka*polohanavstupu],
               polebytu(mezipamet^)[puvodnisirka*polohanavystupu],
               puvodnisirka);
        inc(polohanavstupu); inc(polohanavystupu);
        inc(pom,rozdil);
        if pom>novavyska then begin
                              dec(pom,novavyska);
                              inc(polohanavstupu); {kvuli tomuhle to nejde udelat for-cyklem}
                              end;
        until polohanavystupu>novavyska;
       end;
{vynechavani sloupcu:}
if puvodnisirka<>novasirka
  then begin
       rozdil:=puvodnisirka-novasirka;
       pom:=novasirka shr 1;
       polohanavstupu:=0; polohanavystupu:=0;
        repeat
        for i:=0 to novavyska-1 do
          polebytu(novyobrazek^)[novasirka*i+polohanavystupu]:=polebytu(mezipamet^)[puvodnisirka*i+polohanavstupu];
        inc(polohanavstupu); inc(polohanavystupu);
        inc(pom,rozdil);
        if pom>novasirka then begin
                              dec(pom,novasirka);
                              inc(polohanavstupu);
                              end;
        until polohanavystupu>novasirka;
       end;
if (puvodnisirka<>novasirka)and(puvodnivyska<>novavyska) then freemem(mezipamet,velikost);
End;{zmensiobrazekb}*)

procedure HorizontalFog(PuvodniObrazek:pointer; Sirka,Vyska:word;
                        NovyObrazek:pointer;
                        var paleta:rgbpal256;
                        JasVlevo,JasVpravo:integer);
var x,y,jas:word;
    PuvodniBarva:byte;
Begin
for x:=0 to sirka-1 do
 begin
 jas:=jasvlevo+((jasvpravo-jasvlevo)*x) div (sirka-1);
 for y:=0 to vyska-1 do
  begin
  puvodnibarva:=polebytu(puvodniobrazek^)[y*sirka+x];
  polebytu(novyobrazek^)[y*sirka+x]:=
    najdinejblizsibarvu(paleta,(paleta[puvodnibarva,1]*jas) div 100,  {tohle nejvic zdrzuje}
                               (paleta[puvodnibarva,2]*jas) div 100,
                               (paleta[puvodnibarva,3]*jas) div 100);
  end;
 end;
End;{horizontalfog}

procedure VerticalFog(PuvodniObrazek:pointer; Sirka,Vyska:word;
                      NovyObrazek:pointer;
                      var paleta:rgbpal256;
                      JasNahore,JasDole:integer);
var x,y,jas:word;
    PuvodniBarva:byte;
Begin
for y:=0 to vyska-1 do
 begin
 jas:=jasnahore+((jasdole-jasnahore)*y) div (vyska-1);
 for x:=0 to sirka-1 do
  begin
  puvodnibarva:=polebytu(puvodniobrazek^)[y*sirka+x];
  polebytu(novyobrazek^)[y*sirka+x]:=
    najdinejblizsibarvu(paleta,(paleta[puvodnibarva,1]*jas) div 100,
                               (paleta[puvodnibarva,2]*jas) div 100,
                               (paleta[puvodnibarva,3]*jas) div 100);
  end;
 end;
End;{verticalfog}

procedure UniformFog(PuvodniObrazek:pointer; Sirka,Vyska:word;
                     NovyObrazek:pointer;
                     var paleta:rgbpal256;
                     Jas:word);
var NoveBarvy:prevodnipole;
    w:word;
Begin
{priprava tabulky:}
for w:=0 to 255 do
 novebarvy[w]:=najdinejblizsibarvu(paleta,(paleta[w,1]*jas) div 100,
                                          (paleta[w,2]*jas) div 100,
                                          (paleta[w,3]*jas) div 100);
{prebarveni obrazku:}
for w:=0 to sirka*vyska-1 do polebytu(novyobrazek^)[w]:=novebarvy[polebytu(puvodniobrazek^)[w]];
End;{uniformfog}

{pro sprity:}
type HlavickaRadku = record
                     x,y:integer; {souradnice od referencniho bodu}
                     delka:word; {delka radku v px}
                     data:array[0..0] of byte; {obrazova data radku (delka je dynamicka)}
                     end;

function ImageToSprite(Obrazek:pointer; sirka,vyska:word; Kam:pointer; MaxVelikost:word; PruhlednaBarva:byte):boolean;
var buffer:^polebytu; {pomocny ukazatel pro snadnejsi pristup k radkum puvodniho obrazku}
    hr:^hlavickaradku; {podobne pro pristup k datum spritu}
    y:integer; {cislo radku puvodniho obrazku, ktery prave zpracovavame}
    zacatek,konec, {indexy pro pohyb ve zpracovavanem radku (maji vyznam xovych souradnic)}
    index:word; {index pro pohyb ve vystupnich datech}
Begin
imagetosprite:=false;
if maxvelikost<=2 then exit; {nedostatek pridelene pameti => konec}
word(kam^):=0; {pri neuspechu tam ta nula zustane}
index:=2; {na zacatku si nechavame 2 B na ulozeni velikosti}
y:=0;
 repeat {cyklus pro radky}
 buffer:=@(polebytu(obrazek^)[y*sirka]); {adresa zacatku yteho radku v obrazku}
 zacatek:=0;
  repeat {zpracovani jednoho radku}
  while (zacatek<sirka)and(buffer^[zacatek]=pruhlednabarva) do inc(zacatek);{nalezeni prvniho nepruhledneho pixelu}
  if zacatek<sirka then begin {OK, jeste jsme na radku}
                        {nalezeni konce useku:}
                        konec:=zacatek;
                        while (konec<sirka-1)and(buffer^[konec+1]<>pruhlednabarva) do inc(konec);
                        if index+konec-zacatek+7>maxvelikost
                          then begin {koncime, dosla pamet}
                               word(kam^):=index; {delku je potreba ulozit tak jako tak}
                               exit;
                               end;
                        {ulozeni useku:}
                        hr:=@(polebytu(kam^)[index]); {adresa ciloveho radku ve spritu}
                        hr^.x:=zacatek;
                        hr^.y:=y;
                        hr^.delka:=konec-zacatek+1;
                        move32(buffer^[zacatek],hr^.data[0],hr^.delka);
                        {posun za zpracovany usek:}
                        inc(index,6+hr^.delka); {6 je delka hlavicky useku}
                        zacatek:=konec+1;
                        end;
  until zacatek>=sirka;
 inc(y);
 until y>=vyska;
imagetosprite:=true; {jestli jsme jeste tady, podarilo se nacist vsechno}
word(kam^):=index; {na zacatek vystupu ulozime spocitanou delku}
End;{imagetosprite}

procedure SpriteToImage(Odkud:pointer; Kam:pointer; Sirka,Vyska:word; x,y:integer; PruhlednaBarva:byte);
var index,OriznutiVlevo:word;
    SkutX,SkutY,SkutDelka,pom:integer;
    hr:^hlavickaradku;
Begin
fillchar32(kam^,sirka*vyska,pruhlednabarva);
index:=2; {pozice za udajem o celkove delce}
while index<word(odkud^) do {dokud nejsme na konci spritu}
 begin
 hr:=@(polebytu(odkud^)[index]); {adresa radku ve spritu}
 skuty:=y+hr^.y; {na jake y se do ciloveho obrazku tento usek promitne}
 if (skuty>=0)and(skuty<vyska) {pokud je uvnitr rastru}
   then begin
        skutx:=x+hr^.x; {na jakem x bude zacinat}
        if skutx<sirka {pokud neni cely usek za pravym okrajem rastru}
          then begin
               skutdelka:=hr^.delka; {zatim neorizla delka useku}
               if skutx<0 then begin {pokud usek vycuhuje z rastru vlevo}
                               oriznutivlevo:=-skutx;
                               dec(skutdelka,oriznutivlevo);
                               skutx:=0;
                               end
                          else oriznutivlevo:=0; {kdyz vlevo nevycuhuje}
               if skutdelka>0 {pokud jeste z useku neco zbylo}
                 then begin
                      pom:=skutx+skutdelka-sirka; {kolik vycuhuje vpravo}
                      if pom>0 then dec(skutdelka,pom); {neco jo, tak to urizneme}
                      if skutdelka>0 {pokud stale jeste neco zbylo, muzeme to konecne zkopirovat}
                        then move32(hr^.data[oriznutivlevo],
                                    polebytu(kam^)[skuty*sirka+skutx],
                                    skutdelka);
                      end;
               end;
        end;
 inc(index,6+hr^.delka); {jdeme na dalsi usek}
 end;
End;{spritetoimage}

procedure MoveSpriteOrigin(sprite:pointer; deltaX,deltaY:integer);
var index:word; {pro pohyb uvnitr spritu}
    hr:^hlavickaradku;
Begin
index:=2; {zacatek prvniho radku za uvodnim wordem s celkovou delkou}
while index<word(sprite^) do {dokud nejsme na konci spritu}
  begin
  hr:=@(polebytu(sprite^)[index]); {namapovani hlavicky na data}
  inc(hr^.x,deltax); {\ posun souradnic radku }
  inc(hr^.y,deltay); {/                       }
  inc(index,6+hr^.delka); {posun na dalsi radek}
  end;
End;{movespriteorigin}

procedure Subimage(PuvodniObrazek:pointer; PuvodniSirka,PuvodniVyska:word;
                   LHX,LHY:integer; BarvaOkoli:byte;
                   NovyObrazek:pointer; NovaSirka,NovaVyska:word);
var SkutecnaSirka,SkutecnaVyska,VstupniIndex,VystupniIndex,i:word;
Begin
fillchar32(novyobrazek^,novasirka*novavyska,barvaokoli);
if (lhx>=puvodnisirka)or(lhy>=puvodnivyska)or(lhx+novasirka<=0)or(lhy+novavyska<=0)
  then exit; {zadany vyrez je uplne mimo puvodni obrazek}
{jak velkou oblast budeme kopirovat:}
skutecnasirka:=novasirka;
if lhx<0 then inc(skutecnasirka,lhx);{vycuhuje vlevo?}
if lhx+skutecnasirka>puvodnisirka then dec(skutecnasirka,lhx+skutecnasirka-puvodnisirka);{vycuhuje vpravo?}
if skutecnasirka>puvodnisirka then skutecnasirka:=puvodnisirka;{neni nahodou puvodni obrazek uzsi?}
skutecnavyska:=novavyska;
if lhy<0 then inc(skutecnavyska,lhy);{vycuhuje nahore?}
if lhy+skutecnavyska>puvodnivyska then dec(skutecnavyska,lhy+skutecnavyska-puvodnivyska);{vycuhuje dole?}
if skutecnavyska>puvodnivyska then skutecnavyska:=puvodnivyska;{neni puvodni obrazek nizsi?}
{adresy leveho horniho rohu vyrezu v puvodnim a novem obrazku:}
if lhy<0 then begin
              vstupniindex:=0;
              vystupniindex:=-lhy*novasirka;
              end
         else begin
              vstupniindex:=lhy*puvodnisirka;
              vystupniindex:=0;
              end;
if lhx<0 then dec(vystupniindex,lhx)
         else inc(vstupniindex,lhx);
for i:=0 to skutecnavyska-1 do begin
                               {prekopirovani radku:}
                               move32(polebytu(puvodniobrazek^)[vstupniindex],
                                      polebytu(novyobrazek^)[vystupniindex],
                                      skutecnasirka);
                               {o radek niz:}
                               inc(vstupniindex,puvodnisirka);
                               inc(vystupniindex,novasirka);
                               end;
End;{subimage}

procedure FlipImageHorizontally(PuvodniObrazek:pointer; Sirka,Vyska:word; NovyObrazek:pointer);
var x,y:word;
Begin
for x:=0 to sirka-1 do
 for y:=0 to vyska-1 do polebytu(novyobrazek^)[y*sirka+x]:=polebytu(puvodniobrazek^)[(y+1)*sirka-1-x];
End;{flipimagehorizontally}

procedure FlipImageVertically(PuvodniObrazek:pointer; Sirka,Vyska:word; NovyObrazek:pointer);
var y:word;
Begin
for y:=0 to vyska-1 do move32(polebytu(puvodniobrazek^)[(vyska-1-y)*sirka],
                              polebytu(novyobrazek^)[y*sirka], sirka);
End;{flipimagevertically}

procedure TurnImage1(PuvodniObrazek:pointer; Sirka,Vyska:word; NovyObrazek:pointer; OKolik:integer);
var x,y:word;
Begin
{prevod poctu ctvrtotocek na interval 0..3:}
while okolik<0 do inc(okolik,4);
okolik:=okolik and 3;
{otaceni a kopirovani:}
case okolik of
 1:for y:=0 to sirka-1 do
    for x:=0 to vyska-1 do
     polebytu(novyobrazek^)[y*vyska+x]:=polebytu(puvodniobrazek^)[(vyska-1-x)*sirka+y];
 2:for y:=0 to vyska-1 do
    for x:=0 to sirka-1 do
     polebytu(novyobrazek^)[y*sirka+x]:=polebytu(puvodniobrazek^)[(vyska-1-y)*sirka+sirka-1-x];
 3:for y:=0 to sirka-1 do
    for x:=0 to vyska-1 do
     polebytu(novyobrazek^)[y*vyska+x]:=polebytu(puvodniobrazek^)[x*sirka+sirka-1-y];
 else move32(puvodniobrazek^,novyobrazek^,sirka*vyska); {bez otaceni}
 end;
End;{turnimage1}

procedure TurnImage2(PuvodniObrazek:pointer; PuvodniSirka,PuvodniVyska:word;
                     PuvodniStredX,PuvodniStredY:integer;
                     NovyObrazek:pointer; NovaSirka,NovaVyska:word;
                     NovyStredX,NovyStredY:integer;
                     OKolik:integer;
                     BarvaOkoli:byte);
var sx,cx:longint;
    px,py:integer;
    nx,ny:word;
Begin
fillchar32(novyobrazek^,novasirka*novavyska,barvaokoli);
sx:=-rychlysin(okolik); {je potreba tocit o minusovy uhel; sinus je licha funkce, takze minus...}
cx:=rychlycos(okolik); {...a cosinus je suda, takze znamenko nemeni}
for ny:=0 to novavyska-1 do
 for nx:=0 to novasirka-1 do
  begin {pro kazdy pixel noveho obrazku}
  {jaky bod v puvodnim obrazku mu odpovida:}
  px:=(cx*(nx-novystredx)-sx*(ny-novystredy)) div 10000+puvodnistredx;
  py:=(sx*(nx-novystredx)+cx*(ny-novystredy)) div 10000+puvodnistredy;
  if (px>=0)and(px<puvodnisirka)and(py>=0)and(py<puvodnivyska) {kdyz jsme uvnitr puvodniho obrazku}
    then polebytu(novyobrazek^)[ny*novasirka+nx]:=polebytu(puvodniobrazek^)[py*puvodnisirka+px];
    {sem by slo dat else a vybarveni barvou okraje, ale vychazelo by to pomalejsi nez s tim fillcharem na zacatku}
  end;
End;{turnimage2}

procedure BevelVertically(PuvodniObrazek:pointer; Sirka,Vyska:word;
                          NovyObrazek:pointer;
                          LH,PH,LD,PD:integer;
                          BarvaOkoli:byte);
var x,y:longint;
    PocatecniY,KoncoveY:word;
Begin
fillchar32(novyobrazek^,sirka*vyska,barvaokoli);
for x:=0 to sirka-1 do {pro kazdy sloupec}
 begin
 pocatecniy:=lh+((ph-lh)*x)div(sirka-1);
 koncovey:=vyska-1-ld+((ld-pd)*x)div(sirka-1);
 for y:=pocatecniy to koncovey do {pro kazdy pixel ve sloupci}
  polebytu(novyobrazek^)[y*sirka+x]:=
    polebytu(puvodniobrazek^)[(((y-pocatecniy)*vyska)div(koncovey-pocatecniy+1))*sirka+x];
 end;
End;{bevelvertically}

procedure BevelHorizontally(PuvodniObrazek:pointer; Sirka,Vyska:word;
                            NovyObrazek:pointer;
                            LH,PH,LD,PD:integer;
                            BarvaOkoli:byte);
var x,y:longint;
    PocatecniX,KoncoveX:word;
Begin
fillchar32(novyobrazek^,sirka*vyska,barvaokoli);
for y:=0 to vyska-1 do {pro kazdy radek}
 begin
 pocatecnix:=lh+((ld-lh)*y)div(vyska-1);
 koncovex:=sirka-1-ph+((ph-pd)*y)div(vyska-1);
 for x:=pocatecnix to koncovex do {pro kazdy pixel v radku}
  polebytu(novyobrazek^)[y*sirka+x]:=
    polebytu(puvodniobrazek^)[y*sirka+(((x-pocatecnix)*sirka)div(koncovex-pocatecnix+1))];
 end;
End;{bevelhorizontally}

procedure ReplaceColor(Obrazek:pointer; Sirka,Vyska:word;
                       PuvodniBarva,NovaBarva:byte);
var w:word;
Begin
for w:=0 to sirka*vyska-1 do {pro kazdy pixel obrazku}
 if polebytu(obrazek^)[w]=puvodnibarva then polebytu(obrazek^)[w]:=novabarva;
End;{replacecolor}

procedure CropImage(PuvodniObrazek:pointer; PuvodniSirka,PuvodniVyska:word;
                    NovyObrazek:pointer; var NovaSirka,NovaVyska:word;
                    BarvaKOriznuti:byte);
var vlevo,vpravo,nahore,dole:word; {kolik se z ktereho okraje urizne}
    i:word; {pocitadlo pro for-cykly}
    koncime:boolean; {true, pokud narazime na pixel, ktery uz se orezavat nema}
Begin
{horni okraj:}
nahore:=0; koncime:=false;
 repeat
 for i:=0 to puvodnisirka-1 do
  if polebytu(puvodniobrazek^)[nahore*puvodnisirka+i]<>barvakoriznuti
    then begin koncime:=true; break; end;
 if not koncime then inc(nahore);
 until koncime or (nahore=puvodnivyska);
if nahore=puvodnivyska then begin {cely obrazek je prazdny => muzeme to rovnou zabalit}
                            novasirka:=0;
                            novavyska:=0;
                            exit;
                            end;
{dolni okraj:}
dole:=0; koncime:=false;
 repeat
 for i:=0 to puvodnisirka-1 do
  if polebytu(puvodniobrazek^)[(puvodnivyska-1-dole)*puvodnisirka+i]<>barvakoriznuti
    then begin koncime:=true; break; end;
 if not koncime then inc(dole);
 until koncime; {ted uz je jasne, ze obrazek prazdny neni, tak dalsi podminky nejsou potreba}
{levy okraj:}
vlevo:=0; koncime:=false;
 repeat
 for i:=0 to puvodnivyska-1 do
  if polebytu(puvodniobrazek^)[i*puvodnisirka+vlevo]<>barvakoriznuti
    then begin koncime:=true; break; end;
 if not koncime then inc(vlevo);
 until koncime;
{pravy okraj:}
vpravo:=0; koncime:=false;
 repeat
 for i:=0 to puvodnivyska-1 do
  if polebytu(puvodniobrazek^)[i*puvodnisirka+(puvodnisirka-1-vpravo)]<>barvakoriznuti
    then begin koncime:=true; break; end;
 if not koncime then inc(vpravo);
 until koncime;
novasirka:=puvodnisirka-vlevo-vpravo;
novavyska:=puvodnivyska-nahore-dole;
subimage(puvodniobrazek,puvodnisirka,puvodnivyska,
         vlevo,nahore, 0{na tehle barve nezalezi, nepouzije se},
         novyobrazek,novasirka,novavyska);
End;{cropimage}

procedure SetImageSize(PuvodniObrazek:pointer; PuvodniSirka,PuvodniVyska:word;
                       NovyObrazek:pointer; NovaSirka,NovaVyska:word;
                       BarvaOkraju:byte; ZarovnaniX,ZarovnaniY:char);
var lhx,lhy,y:word; {poloha leveho horniho rohu puvodniho obrazku v novem}
Begin
if (novasirka<puvodnisirka)or(novavyska<puvodnivyska) then exit; {orezavat nechceme}
case upcase(zarovnanix) of 'L':lhx:=0;
                           'S','C':lhx:=(novasirka-puvodnisirka) shr 1;
                           'P','R':lhx:=novasirka-puvodnisirka;
                           end;
case upcase(zarovnaniy) of 'H','U':lhy:=0;
                           'S','C':lhy:=(novavyska-puvodnivyska) shr 1;
                           'D':lhy:=novavyska-puvodnivyska;
                           end;
fillchar32(novyobrazek^,novasirka*novavyska,barvaokraju); {podklad}
for y:=0 to puvodnivyska-1 do {vlozeni puvodniho obrazku}
 move32(polebytu(puvodniobrazek^)[y*puvodnisirka],
        polebytu(novyobrazek^)[(lhy+y)*novasirka+lhx],
        puvodnisirka);
End;{setimagesize}

(************************ veci pro praci se soubory: ************************)

type hlavickaPCX = record
                   znacka:byte; {signatura souboru PCX (=10)}
                   verze:byte; {obvykle =5, nizsi verze nepodporuji 256barevnou paletu}
                   kodovani:byte; {=1 (RLE)}
                   BituNaPixel:byte; {pro 256barevne obrazky =8}
                   LHX,LHY, {souradnice leveho horniho rohu obrazku}
                   PDX,PDY:word; {souradnice praveho dolniho rohu obrazku}
                   rozliseniX,rozliseniY:word; {rozliseni v pixelech na palec (DPI)}
                   prvnich16barev:array[0..15,1..3] of byte;
                    {zacatek palety. Slozky jsou v poradi B,G,R a v rozsahu 0..255. Vyuzilo by se to u 16barevnych obrazku}
                   rezervovano1:byte; {k nicemu}
                   PocetBitovychRovin:byte; {pro 256barevne obrazky =1}
                   BytuNaRadek:word; {kolik bytu ma jeden radek obrazku (rozkodovany);
                                      musi to byt sude cislo: pokud je sirka obrazku licha, je tohle o 1 vyssi
                                      (jine programy sice snesou i lichou hodnotu, ale generuji vzdy sudou
                                      a s tim se musi pocitat)}
                   ObsahujePaletu:word; {1 - na konci souboru je 256barevna paleta, 0 - neni tam}
                   rezervovano2:string[57]; {58 zbytecnych bytu, ktere se daji vyuzit treba pro vlozeni textoveho komentare.}
                   end;

     HlavickaHaloPAL = record           {(PSP = vygenerovano Paintshopem Pro)}
                       signatura:array [1..2] of char; {='AH'}
                       verze:word; {PSP: $00E3}
                       velikost:word; {velikost souboru bez hlavicky v B (PSP: 0)}
                       TypSouboru:byte; {=10}
                       PodtypSouboru:byte; {=0 pro vseobecnou paletu (nebo 1 pro hardwarove specializovanou)}
                       KodGrafKarty,       {na jake karte a v jakem rezimu byl obrazek vytvoren }
                       KodGrafRezimu:word; { (asi neco jako GD,GM); PSP: oboje 0                }
                       MaxBarva:word; {pocet barev v palete - 1 (pocitano od nuly) (PSP: $FF)}
                       MaxR,MaxG,MaxB:word; {maximalni hodnoty barevnych slozek (PSP: vse $FF)}
                       popis:array[1..20] of char; {cokoli, nepouzite znaky vyplnit #0 (PSP: same #0)}
                       end;

     HlavickaBMP = record
                   znacka:array[1..2] of char; {'BM'}
                   VelikostSouboru:longint; {uplne celeho}
                   rezervovano:longint; {k nicemu}
                   OfsetBitmapy:longint; {adresa prvniho bytu bitmapy, poc. od 0 od zacatku souboru}
                   end;

     HlavickaDIBv1 = record {od OS/2 nahoru}
                     VelikostHlavicky:longint; {=12}
                     _sirka, {sirka bitmapy [px]}
                     _vyska:word; {vyska [px]}
                     PocetBitovychRovin:word; {=1 (vzdy)}
                     BituNaPixel:word; {=1, 4, 8 nebo 24}
                     end;

     HlavickaDIBv3 = record {od Windows 3.0 nahoru, nejpouzivanejsi}
                     VelikostHlavicky:longint; {=40}
                     _sirka, {sirka bitmapy [px]}
                     _vyska:longint; {vyska [px]}
                     PocetBitovychRovin:word; {=1 (vzdy)}
                     BituNaPixel:word; {=1, 4, 8, 16, 24 nebo 32}
                     komprese:longint; {0=zadna, 1=RLE pro 8 b/px, 2=RLE pro 4 b/px, 3=bitove pole (?), 4=JPG, 5=PNG}
                     VelikostBitmapy:longint; {=vyska * zaokrouhlena sirka (nahoru na nasobek 4)}
                     rozliseniX,rozliseniY:longint; {[px/m]}
                     PocetBarevVPalete:longint; {pocet polozek palety, 0 = vsechny podle bpp}
                     PocetPlatnychBarev:longint; {kolik barev je opravdu dulezitych, 0 = vsechny}
                     end;

function PrectiKoncovku(CeleJmeno:string):string;
{vrati koncovku z daneho jmena souboru prevedenou na velka pismena, max. 3 znaky}
var b:byte;
    vysledek:string[3];
Begin
vysledek:='';
b:=length(celejmeno); {pojedeme od konce}
if b<>0 then while (celejmeno[b]<>'.')and(vysledek[0]<#3) do
              begin
              vysledek:=upcase(celejmeno[b])+vysledek;
              dec(b);
              end;
prectikoncovku:=vysledek;
End;{prectikoncovku}

function LoadImageFromFile(var obrazek:pointer; var Sirka,Vyska:word;
                           var soubor:file; typ:byte; Paleta,DalsiInfo:pointer):byte;
{*} {Tohle znamena: odtud az do konce radku jde o kod pro osetreni chyb, pro
     pochopeni dekodovaciho algoritmu neni potreba ho cist (vetsinou jsou
     tyto radky vkladane dost prasacky, aby zbytecne nezvetsovaly odsazeni,
     takze stejne moc citelne nejsou :-) ).}
var RC:byte; {navratovy kod}
    buffer:^polebytu; {univerzalni dynamicky odkladaci prostor}
    l:longint;
    r,g,b,pixel,bpp:byte;
    x,y,delkaradku:word;
    i:integer;
    NaslaSe:boolean;
    VstupniIndex,VystupniIndex:word;
    hbmp:hlavickabmp;
    hpcx:hlavickaPCX;
    hdib3:hlavickadibv3 absolute hpcx; {ulozena na stejnem miste jako hpcx, aby se setrilo pameti}
    hdib1:hlavickadibv1 absolute hpcx; {ulozena na stejnem miste jako hdib3 - nutne pro spravnou funkci!}
Begin
RC:=0; {zatim v poradku}
sirka:=0; vyska:=0; {jestli se neco nepovede, tohle tu zustane jako indikator}
case typ of
_CUT:
 begin
 {hlavicka:}
 blockread(soubor,sirka,2);
 blockread(soubor,vyska,2);
 if dalsiinfo=nil then blockread(soubor,x,2) {k nicemu}
                  else blockread(soubor,infotyp(dalsiinfo^).cutrezerva,2);
 {*}if ioresult<>0 then RC:=lichybaio else begin
 {alokace obrazku:}
 l:=sirka*vyska;
 {*}if (l>65528)or(l>maxavail) then RC:=limalopameti else begin
 getmem(obrazek,l);
 {nacteni obrazku:}
 l:=0; {aktualni velikost bufferu (bude se alokovat podle potreby)}
 for y:=0 to vyska-1 do
  begin
  vystupniindex:=y*sirka; {zacatek radku v obrazku}
  blockread(soubor,x,2); {velikost radku v souboru}
  if x>l then begin {alokace vetsiho bufferu}
              {*}if (x>65528)or(x>maxavail) then begin RC:=limalopameti; break; end;
              freemem(buffer,l);
              getmem(buffer,x);
              l:=x;
              end;
  blockread(soubor,buffer^,x);
  {*}if ioresult<>0 then begin RC:=lichybaio; break; end;
  vstupniindex:=0;
  b:=buffer^[vstupniindex];
  inc(vstupniindex);
  while (b<>0)and(RC<liprvnichyba) do
   begin
   r:=b and $7F;
   {*}if (vstupniindex>=x)or(vystupniindex+r>sirka*vyska) then RC:=lichybavsouboru else
   if (b and 128)=0 then begin {nekomprimovany usek}
                         move32(buffer^[vstupniindex],polebytu(obrazek^)[vystupniindex],b);
                         inc(vstupniindex,b);
                         end
                    else begin {komprimovany usek}
                         fillchar32(polebytu(obrazek^)[vystupniindex],r,buffer^[vstupniindex]);
                         inc(vstupniindex);
                         end;
   inc(vystupniindex,r);
   b:=buffer^[vstupniindex];
   inc(vstupniindex);
   end;
  {ted pripadna data za poslednim radkem:}
  if (y=vyska-1)and(dalsiinfo<>nil)and(RC<liprvnichyba)and(vstupniindex<x)
    then begin
         {x je delka radku, vstupniindex je na prvnim bytu pridavnych dat}
         infotyp(dalsiinfo^).cutextradata[0]:=char(x-vstupniindex);
         move32(buffer^[vstupniindex],infotyp(dalsiinfo^).cutextradata[1],byte(x-vstupniindex));
         end;
  end;
 freemem(buffer,l);
 {paleta se nacita pouze ve funkci loadimagefromfile2}
 {*}end;
 {*}end;
 end;{CUT}
_BMP:
 begin
 blockread(soubor,hbmp,sizeof(hlavickabmp));
 {*}if hbmp.znacka<>'BM' then RC:=lichybavsouboru else begin
 blockread(soubor,hdib1.velikosthlavicky,4); {prvni 4 B = velikost hlavicky DIB}
 {*}if (hdib1.velikosthlavicky<>12)and(hdib1.velikosthlavicky<>40) then RC:=lichybavsouboru else begin
 blockread(soubor,hdib1._sirka,hdib1.velikosthlavicky-4); {zbytek hlavicky DIB}
 {*}if ioresult<>0 then RC:=lichybaio else begin
 {vsechny hlavicky jsou nactene; vytahneme z nich, co potrebujeme:}
 if hdib1.velikosthlavicky=12
   then begin
        with hdib1 do begin {verze 1}
                      sirka:=_sirka;
                      vyska:=_vyska;
                      bpp:=bitunapixel;
                      end;
        if dalsiinfo<>nil then infotyp(dalsiinfo^).bmpverzedib:=1;
        y:=1 shl bpp; {pocet polozek palety}
        end
   else begin
        with hdib3 do begin {verze 3}
                      if (_sirka>$FFFF)or(_vyska>$FFFF)or(komprese<>0)
                        then RC:=lineumime
                        else begin sirka:=_sirka; vyska:=_vyska; end;
                      bpp:=bitunapixel;
                      if bpp>8 then y:=255 else y:=1 shl bpp;
                      end;
        if dalsiinfo<>nil then with infotyp(dalsiinfo^) do
                                begin
                                bmpverzedib:=3;
                                xdpi:=round(hdib3.rozlisenix*(25.4/1000));
                                ydpi:=round(hdib3.rozliseniy*(25.4/1000));
                                bmppocetbarev:=word(hdib3.pocetbarevvpalete);
                                if bmppocetbarev<>0 then y:=bmppocetbarev;
                                bmppocetplatnychbarev:=hdib3.pocetplatnychbarev;
                                end;
       end;
 if (bpp>8)and(paleta=nil) then RC:=lichybaparametru; {pri 24 bpp je paleta nutna}
 {nacteni palety (jestli tu nejaka je):}
 if (RC<liprvnichyba)and(bpp<=8)
   then begin
        if paleta=nil
          then begin {necist, jenom preskocit}
               if hdib1.velikosthlavicky=12 then x:=3*y else x:=4*y; {x = velikost palety v B}
               seek(soubor,filepos(soubor)+x);
               end
          else begin {cist}
               if hdib1.velikosthlavicky=12 then x:=3 else x:=4; {x = pocet B na jednu barvu}
               for b:=0 to y-1 do begin
                                  blockread(soubor,l,x);
                                  rgbpal256(paleta^)[b,3]:=polebytu(addr(l)^)[0] shr 2;
                                  rgbpal256(paleta^)[b,2]:=polebytu(addr(l)^)[1] shr 2;
                                  rgbpal256(paleta^)[b,1]:=polebytu(addr(l)^)[2] shr 2;
                                  end;
               {vycerneni pripadneho zbytku:}
               if y<255 then fillchar32(rgbpal256(paleta^)[y,1],(256-y)*x,0);
               end;
        if ioresult<>0 then RC:=lichybaio;
        end;
 {alokace obrazku:}
 {*}if RC<liprvnichyba then begin
 l:=sirka*vyska;
 {*}if (l>65528)or(l>maxavail) then RC:=limalopameti else
 getmem(obrazek,l);
 {*}end;
 {priprava bufferu:}
 delkaradku:=(sirka*bpp) shr 3 + ord((sirka*bpp) and 7<>0);
 while (delkaradku and 3)<>0 do inc(delkaradku); {zaokrouhleni nahoru na nasobek 4}
 if (delkaradku>maxavail) then RC:=limalopameti
                          else getmem(buffer,delkaradku);
 {nacteni obrazku:}
 {*}if RC<liprvnichyba then begin
 i:=0; {vyuzije se pro pocitani barev pri prevodu z 24 bpp}
 for y:=vyska-1 downto 0 do
  begin
  blockread(soubor,buffer^,delkaradku);
  if ioresult<>0 then RC:=lichybaio;
  case bpp of 1:for x:=0 to sirka-1 do
                 polebytu(obrazek^)[y*sirka+x]:=(buffer^[x shr 3] shr (7-(x and 7))) and 1;
              4:for x:=0 to sirka-1 do
                 polebytu(obrazek^)[y*sirka+x]:=(buffer^[x shr 1] shr (4*ord(not odd(x)))) and 15;
              8:move32(buffer^,polebytu(obrazek^)[y*sirka],sirka); {tohle je nejjednodussi :-)}
              24:for x:=0 to sirka-1 do
                  begin
                  b:=buffer^[3*x] shr 2;
                  g:=buffer^[3*x+1] shr 2;
                  r:=buffer^[3*x+2] shr 2;
                  naslase:=false;
                  if i<>0 then for pixel:=0 to i-1 do
                   if (r=rgbpal256(paleta^)[pixel,1])
                      and(g=rgbpal256(paleta^)[pixel,2])
                      and(b=rgbpal256(paleta^)[pixel,3])
                     then begin {tahle barva uz v palete je}
                          polebytu(obrazek^)[y*sirka+x]:=pixel;
                          naslase:=true;
                          break;
                          end;
                  if not naslase
                    then if i<256 then begin {barva jeste v palete neni, pridame ji tam}
                                       rgbpal256(paleta^)[i,1]:=r;
                                       rgbpal256(paleta^)[i,2]:=g;
                                       rgbpal256(paleta^)[i,3]:=b;
                                       polebytu(obrazek^)[y*sirka+x]:=i;
                                       inc(i);
                                       end
                                  else begin {nalezeno vic nez 256 barev, dame tam nulu a nahlasime varovani}
                                       polebytu(obrazek^)[y*sirka+x]:=0;
                                       if RC<liprvnichyba then RC:=lichybipaleta;
                                       end;
                  end;
              else RC:=lineumime; {nejaky divny pocet bpp}
              end;
  if RC>=liprvnichyba then break;
  end;
 {*}end;
 freemem(buffer,delkaradku);
 {*}end;
 {*}end;
 {*}end;
 end;{BMP}
_PCX:
 begin
 blockread(soubor,hpcx,sizeof(hlavickapcx));
 if ioresult<>0 then RC:=lichybaio
  else if hpcx.znacka<>10 then RC:=lichybavsouboru
   else if (hpcx.bitunapixel<>8)or(hpcx.pocetbitovychrovin<>1)
          then RC:=lineumime
          else begin
               sirka:=hpcx.pdx-hpcx.lhx+1;
               vyska:=hpcx.pdy-hpcx.lhy+1;
               end;
 if (RC=0)and(dalsiinfo<>nil) then with infotyp(dalsiinfo^) do begin
                                                               xdpi:=hpcx.rozlisenix;
                                                               ydpi:=hpcx.rozliseniy;
                                                               pcxpopis:=hpcx.rezervovano2;
                                                               end;
 {*}if RC=0 then begin
 l:=sirka*vyska;
 if (l>65528)or(l>maxavail) then RC:=limalopameti else begin
 getmem(obrazek,l);
 {nacteni obrazku:}
 for y:=0 to vyska-1 do
  begin
  x:=0;
   repeat
   blockread(soubor,b,1); {*}if ioresult<>0 then begin RC:=lichybaio; break; end;
   if (b and $C0)=$C0 then begin {komprimovano => rozbalit}
                           b:=b and $3F;
                           blockread(soubor,pixel,1); {*}if ioresult<>0 then RC:=lichybaio;
                           {*}if x+b>sirka then RC:=lichybavsouboru else
                           fillchar32(polebytu(obrazek^)[y*sirka+x],b,pixel);
                           inc(x,b);
                           end
                      else begin {nekomprimovany pixel => zkopirovat, jak je}
                           {*}if x>sirka then RC:=lichybavsouboru else
                           polebytu(obrazek^)[y*sirka+x]:=b;
                           inc(x);
                           end;
   if (x=sirka) and (hpcx.bytunaradek>sirka) then blockread(soubor,b,1); {pripadny vyplnovy byte}
   until (RC>=liprvnichyba)or(x>=sirka);
  if RC>=liprvnichyba then break;
  end;
 {ted bychom teoreticky meli v souboru byt na prvnim bytu za obrazkem,
 kde by mela zacinat paleta:}
 {*}if RC<liprvnichyba then begin
 if (hpcx.verze=5)and(hpcx.obsahujepaletu=1)
   then begin {paletu nacteme nebo aspon preskocime}
        blockread(soubor,b,1); {*}if ioresult<>0 then RC:=lichybaio else begin
        if b=$0C then if paleta=nil then seek(soubor,filepos(soubor)+768)
                                    else begin
                                         blockread(soubor,paleta^,768); {*}if ioresult<>0 then RC:=lichybaio;
                                         for x:=0 to 767 do
                                          polebytu(paleta^)[x]:=polebytu(paleta^)[x] shr 2;
                                         end
                 else if paleta<>nil then RC:=lichybipaleta;
        {*}end;
        end
   else if paleta<>nil then RC:=lichybipaleta; {paletu jsme chteli, ale zadna tu neni}
 {*}end;
 {*}end;
 {*}end;
 end;{PCX}
_ORF:
 begin
 sirka:=320; vyska:=200;
 {*}if maxavail<64000 then RC:=limalopameti else begin
 getmem(obrazek,64000);
 blockread(soubor,obrazek^,64000);
 {*}if ioresult<>0 then RC:=lichybaio else begin
 if paleta=nil then seek(soubor,filepos(soubor)+768)
               else blockread(soubor,paleta^,768);
 {*}if ioresult<>0 then RC:=lichybaio;
 {*}end;
 {*}end;
 end;{ORF}
else RC:=lichybaparametru; {neznama koncovka}
end;
loadimagefromfile:=RC;
End;{loadimagefromfile}

function LoadImageFromFile2(var obrazek:pointer; var Sirka,Vyska:word;
                            JmenoSouboru:string; Paleta,DalsiInfo:pointer):byte;
var f:file;
    koncovka:string[3];
    typ,b:byte;
    RC:byte;
    w:word;
    i:integer;
    hp:hlavickahalopal;
Begin
RC:=0;
{co to je za format:}
koncovka:=prectikoncovku(jmenosouboru);
if koncovka='CUT' then typ:=_CUT
 else if koncovka='BMP' then typ:=_BMP
  else if koncovka='PCX' then typ:=_PCX
   else if koncovka='ORF' then typ:=_ORF
    else RC:=lichybaparametru;
{*}if RC=0 then begin
{soubor:}
assign(f,jmenosouboru);
reset(f,1);
i:=ioresult;
if i=2 then RC:=lisouborneexistuje
       else if i<>0 then RC:=lichybaio;
{nacteni obrazku:}
if RC=0 then RC:=LoadImageFromFile(obrazek,sirka,vyska,f,typ,Paleta,DalsiInfo);
close(f);
{*}if ioresult<>0 then RC:=lichybaio else begin
{pripadne nacteni palety u typu CUT:}
if (typ=_CUT)and(paleta<>nil)
  then begin
       dec(jmenosouboru[0],3); {uriznuti koncovky - je urcite triznakova, tak nemusime hledat tecku}
       assign(f,jmenosouboru+'PAL');
       reset(f,1);
       {*}if ioresult<>0 then RC:=lichybipaleta else begin
       blockread(f,hp,sizeof(hlavickahalopal));
       {*}if (ioresult<>0)or(hp.signatura<>'AH')or(hp.typsouboru<>10)
       {*}   or(hp.podtypsouboru<>0) then RC:=lichybipaleta else begin
       if dalsiinfo<>nil then begin {zkopirovani popisu palety}
                              b:=0;
                              while (b<20)and(hp.popis[succ(b)]<>#0) do inc(b);
                              infotyp(dalsiinfo^).cutpopispalety[0]:=char(b);
                              if b<>0 then move32(hp.popis,infotyp(dalsiinfo^).cutpopispalety[1],b);
                              end;
       for i:=0 to (hp.maxbarva+1)-1 do begin
                                        {opicarna kvuli 512bytovym blokum:}
                                        w:=filepos(f) and 511;
                                        if w>512-6 {jestli uz se do bloku cela barva nevejde...}
                                          then blockread(f,koncovka[0],512-w); {...docteme zbyle max. 4 B}
                                        for b:=1 to 3 do
                                         begin
                                         blockread(f,w,2);
                                         {*}if ioresult<>0 then begin RC:=lichybipaleta; break; end;
                                         rgbpal256(paleta^)[i,b]:=byte(w shr 2);
                                         {predpokladam, ze barevne slozky jsou v rozsahu 0..255
                                          (coz sice nemusi platit obecne, ale na to kasle PSP i ja)}
                                         end;
                                        end;
       {*}end;
       close(f); i:=ioresult;
       {*}end;
       end;
{*}end;
{*}end;
loadimagefromfile2:=RC;
End;{loadimagefromfile2}

function GetImageLine(obrazek:pointer; sirka,y:word):pointer;
Begin
getimageline:=addr(polebytu(obrazek^)[sirka*y]);
End;{getimageline}

function SaveImageToFile(Obrazek:pointer; Sirka,Vyska:word;
                         JmenoSouboru:string; Paleta,DalsiInfo:pointer):byte;
var koncovka:string[3];
    r,g,b,pixel:byte;
    f:file;
    i:integer;
    x,y,pocet,VstupniIndex,VystupniIndex:word;
    l:longint;
    radek, {adresa prave zpracovavaneho radku}
    buffer:^polebytu; {univerzalni dynamicky odkladaci prostor}
    RC:byte; {navratovy kod - prubezne se do nej ukladaji chyby a nakonec ho funkce vrati}
{pro PCX:}
    hpcx:hlavickaPCX; {128 B}
{pro CUT:}
    buffer2:array[1..127] of byte absolute hpcx; {127 B}
    hpal:hlavickahalopal absolute hpcx; {40 B, buffer2 uz neni potreba}
    palf:file;
{pro BMP:}
    hbmp:hlavickabmp;
    hdib1:hlavickadibv1 absolute hpcx; {12 B}
    hdib3:hlavickadibv3 absolute hpcx; {40 B}
    delkaradku:word;
Begin
RC:=0; {zatim v poradku}
koncovka:=prectikoncovku(jmenosouboru);
{priprava vystupniho souboru:}
assign(f,jmenosouboru);
rewrite(f,1);
i:=ioresult;
if (i=2)or(i=3) then RC:=sichybaparametru {chybne jmeno souboru nebo cesta}
 else if i>0 then RC:=sichybaio {plny nebo zamceny disk apod.}
  else begin
{dalsi postup je ruzny podle konkretniho formatu:}
if koncovka='CUT' then
 begin
 {hlavicka:}
 blockwrite(f,sirka,2);
 blockwrite(f,vyska,2);
 if dalsiinfo=nil then begin
                       x:=0;
                       blockwrite(f,x,2);
                       end
                  else blockwrite(f,infotyp(dalsiinfo^).cutrezerva,2);
 {priprava bufferu (l bude jeho velikost):}
 l:=sirka+(sirka div 127)+4; {vysledna delka radku pri naprosto nezkomprimovatelnych datech}
 if (l>65528)or(l>maxavail) then RC:=simalopameti else begin
 getmem(buffer,l);
 {radky obrazku:}
 for y:=0 to vyska-1 do
  begin
  radek:=getline(obrazek,sirka,y); {adresa zacatku radku}
  pocet:=0; vstupniindex:=0; vystupniindex:=0; b:=0; {b je pocet bytu v pomocnem bufferu}
   repeat {dokud neni hotovy cely radek}
    repeat {dokud mame misto v pomocnem bufferu a nejsme na konci radku}
    if pocet=0 then begin {jestli nejsou zadne zbytky od minula, spocitame souvisle pixely:}
                    pixel:=radek^[vstupniindex];
                    pocet:=1;
                    x:=vstupniindex;
                    while (x<sirka-1)and(pocet<127)and(radek^[x+1]=pixel) do
                     begin inc(x); inc(pocet); end;
                    {ted mame souvisly usek vstupniindex..x}
                    end;
    if pocet<=2 then if b=126 then begin {2 pixely uz se do bufferu nevejdou, ulozime jenom jeden}
                                   inc(b);
                                   buffer2[b]:=pixel;
                                   inc(vstupniindex); dec(pocet);
                                   end
                              else begin {ulozime oba dva}
                                   fillchar(buffer2[succ(b)],pocet,pixel);
                                   inc(b,pocet);
                                   vstupniindex:=succ(x);
                                   pocet:=0;
                                   end
                else begin {3 nebo vic stejnych pixelu => komprese se vyplati}
                     if b<>0 then begin {uloz buffer2 do hlavniho bufferu}
                                  buffer^[vystupniindex]:=b; {infobyte: nasleduje b nezkomprimovanych pixelu}
                                  inc(vystupniindex);
                                  move32(buffer2,buffer^[vystupniindex],b);
                                  inc(vystupniindex,b);
                                  b:=0;
                                  end;
                     {uloz zkomprimovany usek:}
                     buffer^[vystupniindex]:=byte(pocet) or $80; {infobyte: nasledujici pixel zopakuj pocetkrat}
                     inc(vystupniindex);
                     buffer^[vystupniindex]:=pixel;
                     inc(vystupniindex);
                     pocet:=0;
                     vstupniindex:=succ(x);
                     end;
    until (b=127) or (vstupniindex=sirka);
   if b<>0 then begin {jestli neco zbylo v bufferu2, uloz to do hlavniho bufferu}
                buffer^[vystupniindex]:=b;
                inc(vystupniindex);
                move32(buffer2,buffer^[vystupniindex],b);
                inc(vystupniindex,b);
                b:=0;
                end;
   until vstupniindex=sirka; {az do konce radku}
  {radek je hotovy, pridame ukoncovaci byte:}
  buffer^[vystupniindex]:=0;
  inc(vystupniindex);
  x:=vystupniindex;
  if (y=vyska-1)and(dalsiinfo<>nil) then inc(x,length(infotyp(dalsiinfo^).cutextradata));
  {zapiseme radek do souboru:}
  blockwrite(f,x,2);
  blockwrite(f,buffer^,vystupniindex);
  if (y=vyska-1)and(dalsiinfo<>nil)
    then with infotyp(dalsiinfo^) do if cutextradata<>'' then blockwrite(f,cutextradata[1],length(cutextradata));
  if ioresult<>0 then begin {doslo misto na disku nebo neco takoveho}
                      RC:=sichybaio;
                      break;
                      end;
  end;
 freemem(buffer,l);
 end;
 if (paleta<>nil)and(RC<siprvnichyba)
   then begin
        {soubor pro paletu:}
        dec(jmenosouboru[0],3);
        assign(palf,jmenosouboru+'PAL'); {stejne jmeno s jinou koncovkou}
        rewrite(palf,1);
        if ioresult<>0 then RC:=sichybaio else begin
        {hlavicka:}
        with hpal do begin
                     signatura:='AH';
                     verze:=$00E3;
                     velikost:=2048-sizeof(hlavickahalopal); {0 by mozna stacila}
                     TypSouboru:=$0A;
                     PodtypSouboru:=0;
                     KodGrafKarty:=0;
                     KodGrafRezimu:=0;
                     MaxBarva:=255;
                     MaxR:=255; MaxG:=255; MaxB:=255;
                     fillchar32(popis,20,0);
                     if (dalsiinfo<>nil)and(infotyp(dalsiinfo^).cutpopispalety<>'')
                       then move32(infotyp(dalsiinfo^).cutpopispalety[1],popis,
                                   length(infotyp(dalsiinfo^).cutpopispalety));
                     end;
        blockwrite(palf,hpal,sizeof(hlavickahalopal));
        if ioresult<>0 then RC:=sichybaio else begin
        {data palety:}
        l:=0; {vypln pro zarovnavani na 512 B bloky}
        for y:=0 to 255 do begin
                           {opicarna kvuli 512bytovym blokum:}
                           x:=filepos(palf) and 511;
                           if x>512-6 {jestli uz se do bloku cela barva nevejde,...}
                             then blockwrite(palf,l,512-x); {...dopiseme zbyle max. 4 B}
                           for b:=1 to 3 do begin
                                            r:=rgbpal256(paleta^)[y,b];
                                            x:=r shl 2; {prevod na word a rozsah 0..255}
                                            blockwrite(palf,x,2);
                                            end;
                           end;
        {vypln do 2 KB snadno a rychle:}
        seek(palf,2047);
        blockwrite(palf,b,1);
        end;
        close(palf);
        if ioresult<>0 then RC:=sichybaio;
        end;
        end;
 end{CUT}
else if koncovka='BMP' then
 begin
 delkaradku:=sirka;
 while (delkaradku and 3)<>0 do inc(delkaradku); {zaokrouhleni nahoru na nasobek 4}
 with hbmp do begin
              znacka:='BM';
              rezervovano:=0;
              VelikostSouboru:=sizeof(hbmp)+delkaradku*vyska; {zatim}
              OfsetBitmapy:=sizeof(hbmp); {zatim}
              end;
 if (dalsiinfo=nil)or(infotyp(dalsiinfo^).bmpverzedib=1)
   then begin {hlavicka DIB verze 1}
        with hdib1 do begin
                      VelikostHlavicky:=12;
                      _sirka:=sirka;
                      _vyska:=vyska;
                      PocetBitovychRovin:=1;
                      BituNaPixel:=8;
                      end;
        with hbmp do begin
                     inc(VelikostSouboru,sizeof(hdib1)+3*256);
                     inc(OfsetBitmapy,sizeof(hdib1)+3*256);
                     end;
        blockwrite(f,hbmp,sizeof(hbmp));
        blockwrite(f,hdib1,sizeof(hdib1));
        end
   else if infotyp(dalsiinfo^).bmpverzedib=3
          then begin {hlavicka DIB verze 3}
               with hdib3 do begin
                             VelikostHlavicky:=40;
                             _sirka:=sirka;
                             _vyska:=vyska;
                             PocetBitovychRovin:=1;
                             BituNaPixel:=8;
                             komprese:=0;
                             VelikostBitmapy:=vyska*delkaradku;
                             rozliseniX:=round(infotyp(dalsiinfo^).xDPI*(1000/25.4));
                             rozliseniY:=round(infotyp(dalsiinfo^).yDPI*(1000/25.4));
                             PocetBarevVPalete:=infotyp(dalsiinfo^).bmppocetbarev;
                             x:=pocetbarevvpalete; if x=0 then x:=256;
                             PocetPlatnychBarev:=infotyp(dalsiinfo^).bmppocetplatnychbarev;
                             end;
               with hbmp do begin
                            inc(VelikostSouboru,sizeof(hdib3)+x shl 2);
                            inc(OfsetBitmapy,sizeof(hdib3)+x shl 2);
                            end;
               blockwrite(f,hbmp,sizeof(hbmp));
               blockwrite(f,hdib3,sizeof(hdib3));
               end
          else RC:=sichybaparametru; {spatne cislo verze}
 if ioresult<>0 then RC:=sichybaio;
 if RC=0 then begin
 {paleta (docasne x = pocet barev, y = pocet slozek, pocet = velikost palety):}
 if (dalsiinfo=nil) or (infotyp(dalsiinfo^).bmpverzedib=1)
   then begin x:=256; y:=3; end
   else begin
        y:=4;
        if infotyp(dalsiinfo^).bmppocetbarev=0 then x:=256
                                               else x:=infotyp(dalsiinfo^).bmppocetbarev;
        end;
 pocet:=x*y;
 if maxavail<pocet then RC:=simalopameti else begin
 getmem(buffer,pocet);
 if paleta=nil then begin
                    RC:=sijakztakz;
                    for i:=0 to x-1 do begin
                                       getrgbpal(i,r,g,b);
                                       buffer^[i*y]:=b shl 2;
                                       buffer^[i*y+1]:=g shl 2;
                                       buffer^[i*y+2]:=r shl 2;
                                       if y=4 then buffer^[i*y+3]:=0;
                                       end;
                    end
               else for i:=0 to x-1 do begin
                                       buffer^[i*y]:=rgbpal256(paleta^)[i,3] shl 2;
                                       buffer^[i*y+1]:=rgbpal256(paleta^)[i,2] shl 2;
                                       buffer^[i*y+2]:=rgbpal256(paleta^)[i,1] shl 2;
                                       if y=4 then buffer^[i*y+3]:=0;
                                       end;
 blockwrite(f,buffer^,pocet);
 if ioresult<>0 then RC:=sichybaio;
 freemem(buffer,pocet);
 end;
 end;
 if RC<siprvnichyba then begin
 {bitmapa:}
 l:=0; {na vypln}
 for y:=vyska-1 downto 0 do
  begin {v souboru je to od leveho dolniho rohu po radcich nahoru}
  radek:=getline(obrazek,sirka,y);
  blockwrite(f,radek^,sirka); {obrazova data}
  if delkaradku<>sirka then blockwrite(f,l,delkaradku-sirka); {pripadna vypln}
  end;
 if ioresult<>0 then RC:=sichybaio;
 end;
 end{BMP}
else if koncovka='PCX' then
 begin
 if maxavail<2*sirka then RC:=simalopameti {konec, pokud nestaci pamet pro pomocny buffer}
 else begin
 getmem(buffer,2*sirka); {velikost bufferu pro nejnepriznivejsi pripad (kdy se radek pri kompresi nafoukne na dvojnasobek)}
 with hpcx do begin
              znacka:=10;
              verze:=5;
              kodovani:=1;
              BituNaPixel:=8;
              LHX:=0; LHY:=0;
              PDX:=sirka-1; PDY:=vyska-1;
              for y:=0 to 15 do begin
                                if paleta=nil then getrgbpal(y,r,g,b)
                                              else begin
                                                   r:=rgbpal256(paleta^)[y,1];
                                                   g:=rgbpal256(paleta^)[y,2];
                                                   b:=rgbpal256(paleta^)[y,3];
                                                   end;
                                prvnich16barev[y,1]:=b shl 2; {prepocet rozsahu z 0..63 na 0..255}
                                prvnich16barev[y,2]:=g shl 2;
                                prvnich16barev[y,3]:=r shl 2;
                                end;
              rezervovano1:=0;
              PocetBitovychRovin:=1;
              BytuNaRadek:=sirka;
              if odd(bytunaradek) then inc(bytunaradek);
              ObsahujePaletu:=ord(paleta<>nil);
              fillchar32(rezervovano2,sizeof(rezervovano2),0);
              if dalsiinfo=nil then begin
                                    rozliseniX:=96; rozliseniY:=96;
                                    end
                               else begin
                                    rozliseniX:=infotyp(dalsiinfo^).xdpi;
                                    rozliseniY:=infotyp(dalsiinfo^).ydpi;
                                    rezervovano2:=infotyp(dalsiinfo^).pcxpopis;
                                    end;
              end;
 blockwrite(f,hpcx,sizeof(hpcx));
 b:=0; {pomocny vyplnovy byte, vyuzije se pouze pri liche sirce obrazku}
 for y:=0 to vyska-1 do {pro kazdy radek obrazku}
  begin
  radek:=getline(obrazek,sirka,y);
  vstupniindex:=0; vystupniindex:=0;
   repeat
   pixel:=radek^[vstupniindex];
   pocet:=1;
   inc(vstupniindex);
   while (vstupniindex<sirka)and(pocet<63)and(radek^[vstupniindex]=pixel) do
    begin inc(pocet); inc(vstupniindex); end;
   {ted je pixel=barva pixelu a pocet=kolikrat tam je, vstupniindex je za timto usekem}
   if (pocet>=3)or(pixel>=$C0)
     then begin {komprese se vyplati nebo je nutna => zapsat ve formatu pocet+barva}
          buffer^[vystupniindex]:=pocet or $C0;
          buffer^[vystupniindex+1]:=pixel;
          inc(vystupniindex,2);
          end
     else begin {komprese se nevyplati a neni nutna => zapsat primo}
          fillchar(buffer^[vystupniindex],pocet,pixel);
          inc(vystupniindex,pocet);
          end;
   until vstupniindex>=sirka; {az do konce radku}
  {zapis zpracovaneho radku do souboru:}
  blockwrite(f,buffer^,vystupniindex);
  if odd(sirka) then blockwrite(f,b,1); {pripadna vypln do sude delky radku}
  if ioresult<>0 then begin {doslo misto na disku nebo neco takoveho}
                      RC:=sichybaio;
                      break;
                      end;
  end;
 freemem(buffer,2*sirka);
 {obrazova data jsou zapsana, ted paletu:}
 if (RC=0)and(paleta<>nil)
   then begin
        if maxavail<768 then RC:=simalopameti else begin
        getmem(buffer,768);
        {prepocitani rozsahu slozek barev z 0..63 na 0..255:}
        for y:=0 to 767 do polebytu(buffer^)[y]:=polebytu(paleta^)[y] shl 2;
        b:=$0C; {identifikator "bude tady paleta"}
        blockwrite(f,b,1);
        blockwrite(f,buffer^,768);
        if ioresult<>0 then RC:=sichybaio;
        freemem(buffer,768);
        end;
        end;
 end;
 end{PCX}
else if koncovka='ORF' then
 begin
 if (sirka<>320)or(vyska<>200) then RC:=sichybaformatu
  else begin
       {ulozeni obrazku:}
       for y:=0 to 199 do begin
                          radek:=getline(obrazek,320,y);
                          blockwrite(f,radek^,320);
                          end;
       {*}if ioresult<>0 then RC:=sichybaio else begin
       {ulozeni palety:}
       if paleta=nil then if maxavail<768 then RC:=simalopameti
                                          else begin {nacteme paletu z obrazovky}
                                               RC:=sijakztakz;
                                               getmem(buffer,768);
                                               zjistipaletu(rgbpal256(buffer^));
                                               blockwrite(f,buffer^,768);
                                               freemem(buffer,768);
                                               end
                     else blockwrite(f,paleta^,768); {rovnou zapiseme zadanou}
       if ioresult<>0 then RC:=sichybaio;
       {*}end;
       end;
 end{ORF}
else RC:=sichybaparametru; {neznama koncovka}
       {zaver je zase spolecny:}
       close(f);
       if (ioresult<>0)and(RC<siprvnichyba) then RC:=sichybaio;
       saveimagetofile:=RC;
       end;
End;{saveimagetofile}

BEGIN
getline:=getimageline;
END.

{*********** Popisy grafickych formatu pouzivanych touto jednotkou ***********
Drive definovane hlavicky uz tu nerozebiram, najdete si je nahore.
[Takhle] znacim casti, ktere se daji vynechat.
"bpp" znamena "pocet bitu na pixel".}


(*Format ORF
-------------
Extremne jednoduchy format pro VGA grafiku; prakticky nepouzivany, ale obcas
se muze hodit. Struktura souboru:
 obrazek (array[1..200,1..320] of byte)    - obrazovka vyklopena do souboru
 paleta (array[1..256,1..3] of byte)       - stejny format jako rgbpal256
*)


(*Format Dr. Halo (CUT + PAL)
------------------------------
Jeden obrazek se sklada ze dvou oddelenych souboru: *.CUT (obrazova data)
a *.PAL (paleta). CUT je jednoduchy format se slusnou RLE kompresi a moznosti
rychleho cteni a dekomprese. PAL je na muj vkus trochu prekombinovany a
zbytecne velky, ale nastesti neni nutne ho pouzivat.
Podpora je dost vzacna (dokonce ani uzasny IrfanView ho neprecte), zatim vim
o jedinem programu: Paintshop Pro.

Struktura souboru *.CUT:
 sirka v px (word)
 vyska v px (word)
 rezervovano (word)  =0
 obrazova data (array[1..vyska] of radek)

Radek:
 velikost radku v B (word)  (tenhle word se do velikosti nezapocitava)
 infobyte (byte)
 pixely (1 nebo vic bytu)
 ...dalsi infobyte, dalsi pixely atd....
 kod konce radku (byte)  =0 nebo $80  (zapocitava se do velikosti radku)

Infobyte (binarne):
 1xxxxxxx - nasleduje jeden pixel, ktery se ma 0xxxxxxxkrat zopakovat
 0xxxxxxx - nasleduje 0xxxxxxx nezkomprimovanych pixelu

Pixely:
 Vzdy plati, ze 1 pixel = 1 byte (i pro obrazky s mene nez 8 bpp). Bitova
hloubka se pozna az podle palety.

Pozn.: Kazdy radek ma na zacatku ulozenu svoji delku (coz umoznuje blokove
nacitani) a zaroven je ukoncen nulovym infobytem, takze je teoreticky mozne
delku trochu zvetsit a do vznikleho prostoru mezi ukoncovacim bytem a koncem
radku po paseracku vecpat nejaka dalsi data (a presne to taky delam - viz
polozku CUTExtraData v typu Infotyp). Dekompresni algoritmus skonci na
ukoncovacim bytu, takze pridana data obrazek nepokazi, a pokud je takhle
upraven az uplne posledni radek, nevadi to ani cteckam, ktere ocekavaji
zacatek dalsiho radku hned za koncem predchoziho.

Struktura souboru *.PAL:
 hlavicka (HlavickaHaloPAL)
 paleta
 vypln

Paleta:
 jedna trojice barevnych slozek za druhou (record R,G,B:word end)
Pozor na drobny hacek: soubor je rozkouskovany do 512bytovych bloku.
Kdyz se nejaka trojice barev do jednoho bloku nevejde cela, vyplni se zbyle
2 nebo 4 B na konci bloku vyplnovymi byty (pravdepodobne s hodnotou 0) a cela
trojice barev prijde na zacatek bloku nasledujiciho. Bloky se pocitaji od
zacatku souboru, ne od zacatku palety. Tenhle system ma vyhodu v tom, ze se
soubor da v pripade potreby zpracovavat vyhradne po 512 B blocich a nehrozi,
ze by se treba jedna barva roztahla pres dva bloky.

Vypln:
 Jakakoli data v takovem mnozstvi, aby zarovnala velikost posledniho bloku
na 512 B (neboli velikost celeho souboru na nasobek teto hodnoty, pro
256barevnou paletu to dela rovne 2 KB).

Pokud k souboru CUT neni prilozen soubor PAL, prohlizece ho berou jako obrazek
ve 256 stupnich sedi (barva 0 = cerna, barva 255 = bila).

*)


(*Format BMP
-------------
Velmi jednoduchy a univerzalni format, obvykle bez komprese. Siroce rozsireny
a podporovany ve vsech Microsoftich systemech a programech, i jinde.
Soubor:
 hlavicka BMP (hlavickabmp)
 hlavicka DIB (HlavickaDIBv1 nebo HlavickaDIBv3)
 [paleta]       (u 1..8 bpp povinna, u 24 bpp neni)
 bitmapa

Hlavicka BMP je vzdy stejna, typ hlavicky DIB se pozna podle velikosti
ulozene v jeji prvni polozce (12 B pro verzi 1, 40 B pro verzi 3).

Paleta:
U DIB verze 1 ma paleta pevnou delku (podle bitove hloubky) a vypada takto:
 array[1..2^bpp] of record B,G,R:byte end
U verze 3 se pocet polozek palety da nastavit libovolne od 2 do 2^bpp:
 array[1..pocet] of record B,G,R,P:byte end
Slozka P se da vyuzit na ulozeni alfa kanalu (castecne pruhlednosti), ale
obvykle se nechava nulova.
Barevne slozky i P maji v obou pripadech rozsah 0..255.

Bitmapa je ulozena po radcich, zleva doprava a odspoda nahoru. Kazdy radek je
v pripade potreby doplnen vyplnovymi byty, aby byla jeho celkova delka
delitelna 4.
Organizace dat bitmapy:
 1 bpp: 1 B = 8 pixelu, nejvyssi bit = pixel nejvic vlevo
 4 bpp: 1 B = 2 pixely, vyssi nibble = pixel vic vlevo
 8 bpp: 1 B = 1 pixel
 24 bpp (bez palety): 1 pixel = 3 B v poradi BGR
*)


(*Format PCX
-------------
Mene prakticky format, dnes uz se moc casto nepouziva. Windows ho podporuji
jenom asi do verze 98 (98 jo, XP ne, to mezi tim nevim). Kompresni pomer nic
moc a kvuli absenci udaju o delce dat se ze souboru neda cist moc rychle, ale
kompresni i dekompresni algoritmus je velice jednoduchy.
Soubor:
 hlavicka (hlavickapcx)
 obrazova data
 [indikator palety (byte)  =12
 paleta]

Obrazova data (binarne):
 11xxxxxx - nasledujici byte je pixel, ktery se ma 00xxxxxxkrat zopakovat
 yyxxxxxx, kde yy<>11 - tenhle byte je primo pixel s hodnotou yyxxxxxx
Takhle to pokracuje az do konce obrazku; pres konce radku komprese nejde.
Pixely s hodnotou >=$C0 se nedaji zapsat nezkomprimovane, coz je trochu
nevyhoda (v extremnim pripade muzou nafouknout obrazek az na dvojnasobnou
velikost).
Pokud je sirka obrazku licha, musi se za kazdy radek pridat jeste jeden
vyplnovy pixel (obvykle s hodnotou 0), aby se delka radku dostala na hodnotu
BytuNaRadek uvedenou v hlavicce.

Paleta:
 array[0..255] of record R,G,B:byte end
Rozsah barevnych slozek je 0..255. *)


(*Sprite (neoficialni)
---------
Muj format pro ukladani obrazku s pruhlednymi oblastmi, ktery umozni jejich co
nejrychlejsi zobrazovani. Princip: obrazek se neuklada cely, pruhledne oblasti
se vynechaji. Nepruhledne oblasti jsou ulozeny po radcich, u kazdeho je
informace o jeho poloze a delce. Kazdy tento radek je souvisly, takze ho
muzeme vykreslovat tim nejrychlejsim algoritmem, jaky mame po ruce.
 Vhodne predevsim pro velke a nepravidelne sprity, kolem kterych by pri
klasickem bitmapovem pristupu zustavalo spousta pruhledneho prostoru (ktery by
se musel jak ukladat do pameti, tak pri zobrazovani prochazet).
 Nevhodne pro obrazky tvorene velkym mnozstvim malych shluku pixelu rovnomerne
rozprostrenych po nejake obdelnikove oblasti (v takovem pripade by se 32bitove
kresleni nestacilo poradne rozjet a udaje o souradnicich a delce pred kazdym
pixelem by zvetsovaly spotrebu pameti) - tam je vyhodnejsi konvencni bitmapa
a zobrazeni procedurou typu *puttimage.

Struktura spritu (na disku i v pameti):

 celkova velikost v B (word) (pocitano vcetne tohohle wordu)
 seznam radku

struktura jednoho radku:

 xova souradnice leveho konce radku relativne od referencniho bodu (integer)
 yova souradnice radku relativne od referencniho bodu (integer)
 delka radku (word)
 obrazova data radku (array[1..delka] of byte) - rada pixelu zleva doprava,
                                                 bez jakekoli komprese

Referencni bod jsou souradnice, na kterych sprite zobrazujeme.*)

{EOF}