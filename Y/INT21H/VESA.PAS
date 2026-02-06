(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: VESA.PAS                                                       *)
(*  Obsah: kompletni jednotka pro 256barevnou SVGA (VESA) grafiku          *)
(*  Autori puvodni jednotky SVGA 4: Asp/VR group, 1996-99                  *)
(*                     Virtual Research independent group production, 1999 *)
(*  Prevzal, upravil, opravil, rozsiril, vylepsil: Mircosoft               *)
(*                                             (http://mircosoft.mzf.cz)   *)
(*   Nastavovani frekvence castecne vychazi z Laacovy jednotky VenomGFX.   *)
(*  Posledni uprava: 19.4.2013                                             *)
(*  Pro kompilaci: ERRMSG.TPU, KLAVESY2.TPU, CFG.TPU                       *)
(*  Pro spusteni: pokud chcete zobrazovat texty, potrebujete nejaky soubor *)
(*                s fontem typu *.FNT (vytvareji se mym programem          *)
(*                FNTEDIT, neni to zadny oficialni format)                 *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit VESA;
{$G+,N+,R-,B-,I-} {dulezite - nechat}
{$E-,S-,Q-,V-,X-} {podruzne - jak je libo}

{...$define Blbuvzdornost} {nechte definovat, pokud chcete zapnout kontrolu
poradi parametru pro _Hline, Vline, Rectangle, Bar, Box, Maskedbar a
Maskedbox. Pri vypnute kontrole si musite davat pozor, abyste souradnice
neprohodili (jinak nastanou potize). __Xorrectangle a __Hline se automaticky
kontroluji vzdy.}

{...$define debug} {dalsi ladici informace, ktere se za behu programu vypisuji
                    na obrazovku, a ruzne diagnosticke procedury}

interface

(*********************** verejne globalni promenne: *************************)

var {tyto dve promenne se automaticky vyplni pri spusteni programu:}
    _VerzeVESA:word; {verze VESA BIOSu vasi graficke karty. Vyssi byte je ta
                  cislice pred teckou, nizsi ta za teckou
                  (napr. $0102 = verze 1.2)}
    _8bitovaPaleta:boolean; {jestli je vase graficka karta schopna prepnuti
                  do rezimu, kdy jsou jednotlive slozky barev v palete (RGB)
                  vyjadrene plnymi 8 bity misto standardnich 6}

    {nasledujici promenne se automaticky vyplnuji pri spusteni grafiky:}
    _VGAkompatibilni:boolean; {jestli je graficka karta kompatibilni s VGA.
                  Pokud neni, nelze pouzivat standardni porty VGA, tj. cekani
                  na navrat paprsku nebo primou manipulaci s paletou!}
    _PujdeStrankovani:boolean; {jestli je pri aktualnim rozliseni dost
                  videopameti aspon na jednu virtualni obrazovku}
    _MaxX,_MaxY:word; {souradnice praveho dolniho rohu obrazovky}
    _MinClipX,_MinClipY,_MaxClipX,_MaxClipY:integer; {orezavaci okno,
                  normalne je nastaveno na celou obrazovku}


(************************** spusteni grafiky: *******************************)

procedure _SetMode(mode:word);
{Nastavi prislusny graficky (nebo textovy) rezim. Moznosti jsou:}
const _Textak=0; {rezim, ktery byl nastaven pred spustenim programu
                  (obvykle 16barevny textovy rezim 80x25),
                  tuto hodnotu zadejte pro ukonceni grafiky.}
      _640x350=$11C;
      _640x400=$100;
      _640x480=$101;
      _800x600=$103;
      _1024x768=$105;

{Jestli vam nevyhovuje vychozi vychozi obnovovaci frekvence monitoru a mate
VESA VBE verze 3.0 nebo novejsi, muzete si pomoci teto promenne nastavit
neco lepsiho:}
      _frekvence:word=0;
{Pozadovanou hodnotu frekvence zde nastavte PRED zavolanim procedury _setmode,
ve ktere se tato promenna nasledne vyhodnoti.
Mozne hodnoty jsou: 0 = pouzije se vychozi frekvence graficke karty
                    nenulove cislo = primo hodnota vertikalni obnovovaci
                                     frekvence v Hz (doporucuji cca 80)
 60 Hz je docela hruza (u soucasnych grafickych karet je to vychozi hodnota).
Pri 70 Hz si blikani vsimnete jen pri svetlem obrazu na velkych monitorech a
od 75 Hz vys uz je obraz vicemene v pohode.
 Pokud monitor podporuje DDC (a je zaveden prislusny ovladac), bude nejdrive
zkontrolovano, jestli je vubec schopen zadanou frekvenci pouzit, a jestli ne,
tak se mu frekvence automaticky prizpusobi, aby nedoslo k jeho poskozeni.
Pokud DDC podporovano neni, dostane uzivatel na vyber, jestli to chce risknout
se zadanou frekvenci nebo radsi necha vychozi frekvenci adapteru. Po skonceni
procedury _setmode bude v promenne _frekvence ulozena vysledna prizpusobena
hodnota, ktera byla skutecne nastavena.
 Nastavena frekvence se automaticky uklada do konfiguracniho souboru
(Cfgsoubor z jednotky CFG), kde si ji muzete zkontrolovat a pripadne rucne
prepsat. Pri kazdem spusteni grafiky si jednotka tuto hodnotu nacte a pokusi
se ji pouzit (samozrejme s kontrolou a prizpusobenim moznostem monitoru).}


(*************** rucni prepinani bank pro pripad potreby: *******************)

{Pro zapisovaci okno:}
procedure _SwitchBank(bank:word);
{Prepne do zadane banky (cislovani zacina od 0, kazda dalsi banka zacina vzdy
za koncem te predchozi). Obvykle se o bankovani nemusite vubec starat, protoze
ho maji vsechny kreslici procedury zabudovenae. Nekdy se ale primy pristup k
bankam hodi, napr. v kombinaci s tou nasledujici procedurou do procedur
bezicich na pozadi.}
function _GetBank:word;
{Vrati cislo aktualne nastavene banky.}

{Pro cteci okno:}
procedure _SwitchRBank(bank:word);
function _getrbank:word;
{Podobny ucinek. Od procedur pro zapisovaci okno se lisi tim, ze si aktualni
banku neukladaji do (ani nectou z) zadne promenne.}

{O jakych oknech se tu vlastne mluvi: jde o pristupove cesty k VRAM.
99% vsech existujicich grafickych karet pracuje pouze s jednim oknem (A).
Jeho segmentova adresa je prakticky vzdy $A000 a sluzba pro prepinani bank ho
zna pod cislem 0. Nektere karty maji jeste druhe okno (B) s cislem 1.
A nektere hodne divoke maji jedno z tech oken pouze pro zapis a druhe pouze
pro cteni. Tato jednotka si dostupnost a vlastnosti obou oken detekuje pri
spousteni grafickeho rezimu a je schopna provozu i v pripade, ze by byly
segmentove adresy obou oken navzajem ruzne nebo i jine nez $A000.
Pozn.: jedine dva pripady, kdy se vyuziva cteci okno, jsou funkce _Getpixel
a procedura _Getimage.}

(***** kreslici procedury bez orezavani (nesmi vycuhovat z obrazovky!): *****)

procedure _PutPixel(x,y:word; barva:byte);
{nakresli pixel}
function _GetPixel(x,y:word):byte;
{vrati barvu pixelu na danych souradnicich}
procedure _HLine(x1,x2,y:word; barva:word);
{velmi rychla (32b) vodorovna cara. Barva je word jenom kvuli tomu, aby se
s ni pak lip pracovalo, hodnoty davejte normalne 0..255.}
procedure _VLine(x,y1,y2:word; barva:byte);
{svisla cara}
procedure _Line(x1,y1,x2,y2:word; barva:byte);
{obecna cara z bodu x1,y1 do bodu x2,y2}
procedure _MaskedLine(x1,y1,x2,y2:integer; barva:byte; maska:word);
{Vzorkovana (prerusovana) cara. Maska je podobna jako pri nastavovani
SetLineStyle v BGI. Vykresli se jen ty bity, ve kterych je 1. Nejvyssi bit
masky se promitne do bodu x1,y1.}
procedure _Ellipse(stredX,stredY,rx,ry:word; barva:byte);
{Prazdna elipsa.
 stredX, stredY - souradnice stredu
 rx, ry - polomery ve smeru x a y}
procedure _FilledEllipse(stredX,stredY,rx,ry:word; barva:byte);
{vyplnena elipsa}
procedure _Rectangle(x1,y1,x2,y2:word; barva:byte);
{Prazdny obdelnik.
 x1,y1 - levy horni roh
 x2,y2 - pravy dolni roh}
procedure _Bar(x1,y1,x2,y2:word; barva:word);
{Vyplneny obdelnik, dost rychly (32b). K barve stejny komentar jako u _HLine}
type _pole8bytu=array[0..7]of byte; {pomocny typ pro zadavani vzorku do nasledujici procedury}
procedure _MaskedBar(x1,y1,x2,y2,barva:word; var vzorek);
{Obdelnik s dvojbarevnou vyplni, podobny tomu z BGI se vzorkem nastavenym
procedurou Setfillpattern. Navazovani vzorku pri kresleni nekolika obdelniku
pres sebe je zaruceno, rychlost je pomerne slusna (64b kopirovani pres FPU).
 barva - ve vyssim bytu je barva pozadi, v nizsim barva popredi
 vzorek - pole osmi bytu. Kazdy byte je jeden radek, bity s hodnotou 1 se
          vykresli barvou popredi a bity 0 barvou pozadi. Nejvyssi bit bude
          nejvic vlevo, byte (radek) s indexem 0 bude nejvic nahore.
          V podstate je to ctverec 8x8 bitu.
Nejake preddefinovane vzorky:}
const _RidkeSikmeSrafy:_pole8bytu=($01,$02,$04,$08,$10,$20,$40,$80);{/}
      _HusteSikmeSrafy:_pole8bytu=($11,$22,$44,$88,$11,$22,$44,$88);{/}
      _RidkeKosmeSrafy:_pole8bytu=($80,$40,$20,$10,$08,$04,$02,$01);{\} {"kosme" je oficialni termin z heraldiky,}
      _HusteKosmeSrafy:_pole8bytu=($88,$44,$22,$11,$88,$44,$22,$11);{\} { nevymyslel jsem si ho :-)              }
      _SikmePruhy:     _pole8bytu=($78,$F0,$E1,$C3,$87,$0F,$1E,$3C);{/}
      _KosmePruhy:     _pole8bytu=($3C,$1E,$0F,$87,$C3,$E1,$F0,$78);{\}
      _KolmaMrizka:    _pole8bytu=($22,$22,$FF,$22,$22,$22,$FF,$22);{+}
      _SikmaMrizka:    _pole8bytu=($11,$0A,$04,$0A,$11,$A0,$40,$A0);{x}
      _VelmiRidkeTecky:_pole8bytu=($00,$02,$00,$00,$00,$20,$00,$00);{3%}
      _RidkeTecky:     _pole8bytu=($00,$22,$00,$00,$00,$22,$00,$00);{6%}
      _StredniTecky:   _pole8bytu=($00,$22,$00,$88,$00,$22,$00,$88);{13%}
      _HusteTecky:     _pole8bytu=($00,$AA,$00,$AA,$00,$AA,$00,$AA);{25%}
      _VelmiHusteTecky:_pole8bytu=($55,$AA,$55,$AA,$55,$AA,$55,$AA);{50%}

procedure _Box(x1,y1,x2,y2:word; LHbarva,PDbarva,Vbarva:word);
{Obdelnik s obrysem. Dost rychly (32b).
 LHbarva - barva leveho a horniho okraje obrysu
 PDbarva - barva praveho a dolniho okraje obrysu
 Vbarva - barva vyplne. Pokud je 0, vypln se nekresli (vnitrek tedy nebude
          v barve 0, ale zustane prazdny!).}
procedure _MaskedBox(x1,y1,x2,y2:word; lhbarva,pdbarva,vbarva:word; var vzorek:_pole8bytu);
{Vysledek je podobny jako u _Box, ale vnitrek se kresli procedurou _MaskedBar.
Kdyz je vbarva=0, vnitrek se nekresli.}
procedure _Triangle(x1,y1,x2,y2,x3,y3:word; barva:byte);
{prazdny trojuhelnik (slozeny ze tri car)}
procedure _FilledTriangle(x1,y1,x2,y2,x3,y3:integer; barva:byte);
{Vyplneny trojuhelnik. Je nutne zapnout direktivu Blbuvzdornost (viz nahore),
protoze je tam par nedostatku, takze parametry se caram predavaji obracene
nez by bylo potreba. Bezpecnejsi je __filledtriangle.}
procedure _FilledPolygon(var SeznamVrcholu; PocetVrcholu,barva:byte);
{Vyplneny mnohouhelnik. SeznamVrcholu je pole souradnic jednotlivych vrcholu
(dvojic cisel typu integer, x je prvni. Napriklad array[1..10] of
 record x,y:integer end; nebo array[1..10,1..2]of integer;).
Nutnou a postacujici podminkou pro spravne vykresleni je, aby kazda (pomyslna)
usecka vedena z prvniho vrcholu do libovolneho jineho lezela cela uvnitr
obrysu mnohouhelniku. Postacujici podminkou tedy je, aby byl mnohouhelnik
konvexni.}

procedure _XorPixel(x,y:word; barva:byte);
procedure _XorLine(x1,y1,x2,y2:word; barva:byte);
procedure _XorHLine(x1,x2,y:word; barva:word);
procedure _XorVLine(x,y1,y2:word; barva:byte);
procedure _XorMaskedLine(x1,y1,x2,y2:integer; barva:byte; maska:word);
procedure _XorEllipse(stredX,stredY,rx,ry:word; barva:byte);
procedure _XorRectangle(x1,y1,x2,y2:word; barva:byte);
procedure _XorBar(x1,y1,x2,y2:word; barva:byte);
procedure _XorTriangle(x1,y1,x2,y2,x3,y3:word; barva:byte);
{podobne vyse uvedenym, ale jejich barva se xoruje s pozadim}

procedure _Fill(barva:word);
{Vyplni celou obrazovku danou barvou (32bitove).
Funguje jen pri normalnim zobrazeni, ne pri strankovani!}
procedure _Fill2(barva:word);
{Stejny efekt, ale funguje i pri strankovani, protoze je to jenom _bar
pres celou obrazovku.}
procedure _vycerni1024;
{Vyplni celou obrazovku barvou 0. Optimalizovano pro maximalni rychlost
(je zhruba o 48% rychlejsi nez _Fill2). Funguje jak v normalni, tak
ve strankovane grafice, ale POUZE V ROZLISENI 1024x768!}


(***************** kreslici procedury s orezavanim: *************************)

{Zobrazi se vzdy jenom ta cast obrazku, ktera je uvnitr orezavaciho okna
(_minclipx, _minclipy, _maxclipx, _maxclipy).
Parametry a pouziti stejne jako u variant bez orezavani.}

procedure __PutPixel(x,y:integer;barva:byte);
procedure __XorPixel(x,y:integer;barva:byte);
function  __GetPixel(x,y:integer):byte;{kdyz po nem chceme pixel za okrajem, vrati pixel z nejblizsiho okraje}
procedure __Line(x1,y1,x2,y2:integer;barva:byte);
procedure __XorLine(x1,y1,x2,y2:integer;barva:byte);
procedure __MaskedLine(x1,y1,x2,y2:integer;barva:byte;maska:word);
procedure __XorMaskedLine(x1,y1,x2,y2:integer;barva:byte;maska:word);
procedure __Ellipse(stredX,stredY:integer;rx,ry:word;barva:byte);
procedure __XorEllipse(stredX,stredY:integer;rx,ry:word;barva:byte);
procedure __FilledEllipse(stredX,stredY:integer;rx,ry:word;barva:byte);
procedure __Rectangle(x1,y1,x2,y2:word;barva:byte);
procedure __XorRectangle(x1,y1,x2,y2:word;barva:byte);
procedure __Bar(x1,y1,x2,y2:integer;vbarva:byte);
procedure __XorBar(x1,y1,x2,y2:integer; barva:byte);
procedure __MaskedBar(x1,y1,x2,y2:integer;barva:word;var vzorek:_pole8bytu);
procedure __Box(x1,y1,x2,y2:integer;lhbarva,pdbarva,vbarva:byte);
procedure __MaskedBox(x1,y1,x2,y2:word;lhbarva,pdbarva:byte;vbarva:word;var vzorek:_pole8bytu);
procedure __HLine(x1,x2,y:integer;barva:byte);
procedure __XorHLine(x1,x2,y:integer;barva:byte);
procedure __VLine(x,y1,y2:integer;barva:byte);
procedure __XorVLine(x,y1,y2:integer;barva:byte);
procedure __Triangle(x1,y1,x2,y2,x3,y3:integer;barva:byte);
procedure __XorTriangle(x1,y1,x2,y2,x3,y3:integer;barva:byte);
procedure __FilledTriangle(x1,y1,x2,y2,x3,y3:integer;barva:byte);
procedure __FilledPolygon(var SeznamVrcholu; PocetVrcholu,barva:byte);
procedure __Fill(barva:word);

procedure __ThickLine(x1,y1,x2,y2,tloustka:integer; barva:byte);
{cara o dane tloustce}
procedure __XorThickLine(x1,y1,x2,y2,tloustka:integer; barva:byte);
{cara o dane tloustce s xorovanou barvou}

procedure __FloodFill1(ffx,ffy:integer; barva:byte);
{Funguje jako plechovka v Paintbrushi: barva se rozlije z bodu ffx,ffy
do vsech stran a vyplni celou jednobarevnou oblast uzavrenou bud jakoukoli
jinou barvou nebo okrajem orezavaciho okna.}
procedure __FloodFill2(ffx,ffy:integer; Barva,Hranice:byte);
{Funguje jako Floodfill z jednotky Graph: barva se rozlije od bodu ffx,ffy
do vsech stran a zarazi se bud o barvu Hranice nebo Barva nebo o okraj okna.
Pres vsechny ostatni barvy se volne preleva.}


(******************* procedury pro praci s obrazky: *************************)

{Krome _Getimage se vsechny orezavaji podle orezavaciho okna (i kdyz maji v
nazvu jenom jedno podtrzitko).}

procedure _GetImage(x1,y1,x2,y2:word; Kam:pointer);
{Nacte vyrez obrazovky - podobne jako Getimage z BGI. Nacitana oblast nesmi
zasahovat mimo obrazovku (pokud ano, nactou se kraviny), orezavaci okno se
ignoruje. Ukazatel Kam musi ukazovat na predem pripravenou alokovanou pamet
(tam se nacteny obrazek ulozi). Potrebne mnozstvi pameti se spocita jako
sirka*vyska obrazku (1 pixel = 1B, informace o rozmerech se neukladaji),
obrazova data jsou v pameti usporadana po radcich zleva doprava a odshora
dolu. X1,y1 je levy horni roh, x2,y2 pravy dolni.}
procedure _PutImage(x1,y1:integer; Sirka,Vyska:word; Obrazek:pointer);
{Zobrazi obrazek. X1,y1 jsou souradnice leveho horniho rohu, Sirka a Vyska
jsou normalne v pixelech. Pokud je nezadate spravne, obrazek se vykresli
zpotvorene. Parametr Obrazek je ukazatel na prislusna graficka data (format
stejny jako u procedury _Getimage).
Procedura je optimalizovana pro co nejvetsi rychlost (64/32b).}
procedure _PutTImage(x1,y1:integer; sirka,vyska:word; obrazek:pointer);
{Podobny jako _Putimage, ale pixely s barvou 0 se nevykresli (pruhlednost).
Rychlost nic moc (kresli se po jednotlivych bytech).}
procedure _PutRTImage(x1,y1:integer; sirka,vyska:word; obrazek:pointer);
{Podobny jako _PutTImage, ale kresli obrazek zrcadlove prevraceny
(leva <-> prava strana).}

function _GetSprite(x1,y1,x2,y2:integer; Kam:pointer; MaxVelikost:word; PruhlednaBarva:byte):boolean;
{Nacte z obrazovky pruhledny obrazek specialnim zpusobem - rovnou vynechava
pruhledne oblasti, takze se pak da mnohem rychleji zobrazit.
 x1,y1 - levy horni roh
 x2,y2 - pravy dolni roh
 kam - ukazatel na predem alokovane misto, do ktereho se nacteny obrazek ulozi
 MaxVelikost - sem zadejte, jak velke to alokovane misto je, resp. kolik mista
               v nem jste ochotni funkci poskytnout - velikost obrazku totiz
               neni nijak jednoduse predem spocitatelna.
 PruhlednaBarva - ktera barva na obrazovce se ma behem nacitani brat jako
                  pruhledna
Pokud se obrazek podari nacist cely, funkce vrati true. Pokud ne (tedy pokud
by jeho velikost presahla zadanou hodnotu MaxVelikost), bude nactena jenom
cast (zobrazit pujde) a vrati se false. Vysledna velikost nacteneho obrazku
v bytech je ulozena na zacatku Kam^ ve formatu word (tento word se do
velikosti pocita). Tento udaj lze pouzit pro prekopirovani obrazku do nove
promenne s presnou velikosti, ulozeni do souboru atd..}
procedure _PutSprite(x,y:integer; obrazek:pointer);
{Zobrazi pruhledny obrazek ziskany vyse uvedenou funkci.
Protoze je obrazek ulozen jako seznam souvislych radku a ne jako obdelnikova
bitmapa, vykresluje se tim nejrychlejsim, co mame na sklade (64/32b).}
procedure _FillSprite(x,y:integer; obrazek:pointer; barva:byte);
{Zobrazi jednobarevny flek ve tvaru daneho pruhledneho obrazku.}

(********************* zobrazovani rastrovych textu: ************************)

type {pomocne typy:}
     _FontArray=array[0..0]of byte;
     {Pomocna datova struktura pro ukladani rastrovych fontu. Delka pole je
     dynamicka podle vysky znaku. Sam o sobe je tento typ nepouzitelny -
     - potrebujeme znat vysku pisma, jinak se v nem nic nenajde.
     Technicke detaily: kazde pismeno je tvoreno nekolika byty, kazdy
     predstavuje jeden radek (kde je jednicka, tam se pixel vykresli, kde je
     nula, tam ne). Sirka znaku je pevna - 8 pixelu (tj. 8 bitu v 1 bytu),
     vyska libovolna. Znakova sada zabere v pameti 256 krat vyska pisma bytu
     (pro pismo 8x8 pixelu to tedy dela presne 2 KB).}
     _UkNaFont=^_fontarray;

     {uzivatelsky typ:}
     _Font = record
             fVyska:byte;{vyska pisma v radcich (bytech)}
             fStdX,fStdY,fStdRoztec:byte;{doporucene parametry ulozene v souboru s fontem}
             fData:_uknafont;
             end;

procedure _NactiFont(var FN:_font; var Soubor:file);
{Nacte ze souboru font.
FN - promenna typu _Font. Kdyz je po skonceni procedury FN.fdata=nil, znamena
     to, ze se nekde stala chyba a nacteni se nepovedlo.
Soubor - beztypovy soubor otevreny pro cteni s velikosti bloku 1 byte
         (tj. reset(soubor,1);), kurzor v nem musi byt na zacatku fontu.
         Procedura soubor nezavre (to vsechno proto, aby sel font zabudovat
         do nejakeho vetsiho datoveho souboru).
Proceduru nelze pouzivat na jiz nactene fonty (zustaly by ztracene v pameti)!!
Format souboru s fontem je popsan na konci teto jednotky.}
procedure _NactiFont2(var FN:_font; JmenoSouboru:string);
{Totez, ale zadava se jmeno souboru, ktery si procedura otevre a pak zase
zavre. Jednodussi na pouziti, ale lze pouzit jen pro soubory obsahujici
pouze samotny font. Opet - nepouzivat na jiz nactene fonty!}
function _UlozFont(var FN:_font;soubor:string):boolean;
{Ulozi font do souboru (jmeno piste i s koncovkou); vraci true, pokud se to
povede. Pro pouziti treba v editorech.}
procedure _ZrusFont(var FN:_font);
{Vymaze font z pameti. Ukazatel FN.fdata nastavi na nil.}
procedure _NastavFont(var FN:_font; NastavDoporucene:boolean);
{Nastavi font pro psani procedurou _Print (viz dale). Promennou F je potreba
zachovat, protoze se na ni pouze napichnou prislusne ukazatele, ale font se
nikam fyzicky nekopiruje.
 NastavDoporucene - true => Nastavi se doporucene parametry textu (velikost a
                            roztec), ktere byly s fontem ulozeny v souboru.
                    false => Nastaveni textu se nezmeni.}
procedure _NastavText(velikostX,velikostY,roztec:byte);
{Nastavi styl textu pro proceduru _Print. Kdyz je jakykoli parametr roven 0,
zustava nastavena jeho minula hodnota (tj. nemeni se).
 velikostX, velikostY - velikost pisma, technicky vzato rozmer jednoho pixelu,
                        pro vodorovny a svisly smer.
 roztec - roztec dvou sousednich znaku (od leveho kraje jednoho po levy kraj
          druheho). Normalne je rovna sirce znaku. Kdyz menite velikost pisma,
          nezapomente zadat roztec rovnou napr. 8*velikostX, jinak bude pismo
          zdrcle dohromady (coz se nekdy hodi, proto tenhle system).
Nekdy se hodi mit primy pristup k parametrum textu, coz jsou tyto promenne:}
var __velikostX,__velikostY:byte; {Pokud z nejakeho duvodu zadate velikost
                                   nulovou, text se nevykresli}
    __roztec:word;

procedure _PushText;
{Ulozi vsechny parametry textu (rozmery, roztec i ukazatel na font)
do dynamickeho LIFO zasobniku. O ten zasobnik se starat nemusite, je soucasti
teto jednotky a pracuje plne automaticky.}
procedure _PopText;
{Znovu nastavi posledne ulozene parametry textu a odstrani je ze zasobniku.
Pouzito napr. v ruznych dialogovych oknech, ktera si nastavi vlastni styl
pisma a pak zase obnovi ten, ktery byl nastaven puvodne.}
procedure _LodText;
{Znovu nastavi posledne ulozene parametry textu, ale neodstrani je ze
zasobniku. Obcas se taky hodi.}

procedure _Print(ix,iy:integer; barva:byte; textik:string);
{Napise na obrazovku text (podobne jeko Outtextxy). Orezava podle orezavaciho
okna. Kdyby kus nejakeho pismena vycuhoval vlevo nebo vpravo, cele to pismeno
se nezobrazi; kdyby vycuhovalo nahore nebo dole, zobrazi se jen viditelna
cast. Souradnice ix,iy predstavuji vzdy levy horni roh textu.

 Nasledujici odstavec popisuje rozsirene moznosti teto procedury. Pokud se
nechcete zabyvat nicim slozitym (kdyz treba tuhle jednotku vidite poprve),
muzete ho bez obav preskocit.

 Do zobrazovaneho retezce se daji vkladat specialni ridici kody. Vzdycky
zacinaji retezcem '%%', pak nasleduje jeden hlavni znak a pak urcity pocet
cislic - parametru. Jsou delany maximalne blbuvzdorne, tj. pri jakekoli
chybe se proste zobrazi jako normalni text a nevznikne zadny problem. Vsechny
dale uvedene sekvence znaku '#' znamenaji obycejne desitkove cislo, pocet
krizku udava pocet cifer (ten je nutne presne dodrzet; pokud je cislo kratsi,
musi se na zacatku doplnit nulami, jinak ho procedura povazuje za chybny kod).
Seznam vsech kodu:
 %%b### - nastavi barvu textu od tohoto mista dal. ### je triciferne cislo
          barvy (000..255).
 %%B - obnovi puvodni barvu (jaka byla zadana parametrem procedury)
 %%z### - misto tohoto kodu zobrazi znak s ordinalnim (ASCII) cislem ###.
          Vhodne napr. pokud chcete zobrazit znaky ze zacatku ASCII tabulky,
          ktere ale v textovem souboru zpusobi chaos (existuje napr. znak
          "konec souboru" a zkuste pak z takoveho souboru precist neco, co je
          za nim...). Ve zdrojaku se to da napsat jako #neco; tenhle kod exis-
          tuje kvuli pripadum, kdy program nacita texty z externiho souboru.
 %%x### - posune pomyslny "kurzor" o dany pocet pixelu vlevo (pak musi byt
          prvni cifra cisla '-') nebo vpravo. Napr. %%x+83, %%x215, %%x-04.
 %%y### - obdobne posouva "kurzor" nahoru (-) nebo dolu (+).
 %%Y - nastavi yovou souradnici "kurzoru" zpet na hodnotu zadanou parametrem
       procedury.
 %%r### - nastavi roztec pisma (v pixelech) od tohoto mista dal.
 %%R - obnovi puvodni roztec, jaka byla nastavena pred volanim procedury
 %%h### - nastavi xovou (h jako horizontalni) velikost pisma. Zarovnava se
          doleva. Nezapomente nastavit i roztec.
 %%v### - nastavi yovou (vertikalni) velikost pisma. Zarovnava se nahoru.
 %%H,
 %%V - obnovi puvodni velikost, jaka byla nastavena pred volanim procedury.
 %%0 - obnovi puvodni hodnoty uplne vseho krome posunu ve smeru x (tj. barvu,
       souradnici y, roztec a obe velikosti).
Po skonceni procedury bude automaticky obnovena velikost a roztec textu, ktera
byla nastavena pred jejim zavolanim.
 Pokud z nejakeho duvodu potrebujete ridici sekvence vyradit z provozu, zmente
hodnotu teto promenne:}
const _RidiciKody:byte=1;
{Mozne hodnoty jsou:}
      _pouzivat=1; {kody pouzivat, ridit se podle nich}
      _vypisovat=2; {nepouzivat, zobrazit je jako prosty text}
      _preskakovat=3; {nepouzivat ani nevypisovat}

{Nekdy je potreba dynamicky nastavovat pri zobrazovani textu jeho meritko.
To se obvykle provede rucnim prepocitanim a prenastavenim velikosti a roztece.
Ciselne hodnoty zadane ridicimi kody primo v textu ale nejsou zvenku
pristupne, proto tu mame tuto promennou:}
const _MeritkoKodu:word=100;
{Urcuje meritko cisel v procentech. Plati pro vsechny kody krome %%b a %%z.}

procedure _ZmerText(retezec:string);
{Projde dany retezec znak po znaku a spocita jeho rozmery (v pixelech) s
ohledem na aktualni nastaveni parametru pisma a zpusob vyhodnocovani ridicich
kodu. Nastavi hodnotu techto verejnych globalnich promennych:}
var _SirkaTextu,_VyskaTextu:word; {celkove rozmery retezce po zobrazeni od
                                   nejzazsiho leveho okraje po pravy a od
                                   horniho po dolni}
    _DeltaX,_DeltaY:integer; {Tohle prictete k souradnicim, na kterych chcete
                              text zobrazit, a vyjde vam nejzazsi leva a
                              horni souradnice okraju textu. Pokud se text
                              nikam neposune pomoci ridicich kodu, jsou obe
                              tyto hodnoty nulove.}

function _SirkaTextu2(PocetZnaku:byte):word;
{Spocita sirku retezce o zadanem poctu znaku. Nezohlednuje ridici kody,
kazdy znak pocita jako stejne siroky.}
function _VyskaTextu2:word;
{Vraci vysku jakehokoli textu, opet bez zohlednovani ridicich kodu (vsechny
znaky fontu jsou stejne vysoke, takze nezalezi na tom, co se bude psat).}


(************************** manipulace s oknem: *****************************)

procedure _SetWindow(minx,miny,maxx,maxy:integer);
{Nastavi orezavaci okno. Maximalni (a zaroven vychozi) velikost je na celou
obrazovku. Pokud by nekde vycuhovalo, automaticky se zmensi.}
procedure _SetDefaultWindow;
{Nastavi orezavaci okno na celou obrazovku.}


(*********************** cekani na navrat paprsku: **************************)

procedure _VSync;
{Ceka na synchronizacni impuls obrazovky (tj. navrat vykreslovaciho paprsku k
hornimu okraji monitoru). Cokoli pak behem toho okamziku nakreslite, bude
zobrazeno bez blikani (vhodne napr. pro virtualni obrazovku).}
procedure _VSyncStart;
{Ceka na zacatek synchronizacniho impulsu (tj. jestli impuls pri zavolani
procedury zrovna probiha, pocka, az skonci a zacne podruhe; tim se ziska
trochu vic casu, ale taky se nekdy trochu dele ceka).}


(************************ rizeni spotreby monitoru: *************************)

procedure _NastavRezimPM(jaky:byte);
{Nastavi obrazovku do daneho rezimu. Mozne hodnoty jsou:}
const _On=0;        {zapnuto}
      _Standby=1;   {prvni usporny rezim (opetovne zapnuti je rychle)}
      _Suspend=2;   {druhy usporny rezim (o neco uspornejsi, opetovne zapnuti trva dele)}
      _Off=4;       {uplne vypnuto, sviti uz jenom kontrolka}
      _ReducedOn=8; {asi nejaky tmavsi obraz, pry to je pro ploche obrazovky}
function _ZjistiRezimPM:byte;
{Vraci kod rezimu, v jakem se zrovna monitor nachazi. Pokud se test nepovede,
vraci nulu (_On).}
function _ZjistiMozneRezimyPM:byte;
{Vraci kody vsech rezimu, do kterych se monitor da prepnout (soucet vyse
uvedenych kodu; jednotliva cisla z nej lovte po bitech). V pripade neuspechu
vraci nulu.}


(*************************** virtualni obrazovka: ***************************)

procedure _SetDisplayOrigin(x,y:word);
{Nastavi polohu leveho horniho rohu monitoru (pocatku zobrazeni) nad
videopameti (VRAM). Normalni hodnota je 0,0.}
procedure _SetAP(kterou:byte);
procedure _SetVP(kterou:byte);
{SetActivePage (nastaveni stranky, na kterou se bude kreslit) a SetVisualPage
(nastaveni stranky, ktera bude videt na obrazovce). Parametr Kterou je od 0
do X, kde X muze byt jen tak velke, aby vystacila videopamet.}
procedure _NastavStrankovani;
{Prepina mezi normalnim a strankovacim rezimem. Viditelna stranka zustava vzdy
na miste a aktivni se prepne - bud na tu druhou stranku nez je viditelna,
pokud strankovani zapiname, nebo na stejnou jako viditelna, pokud ho vypiname.
Je treba hlidat si, jestli mame strankovani zapnute nebo vypnute, aby nevznikl
zmatek. V pripade, ze presto vznikne, pomuze nasledujici procedura:}
procedure _ResetStrankovani;
{Natvrdo nastavi aktivni i viditelnou stranku na 0.
Mimochodem, po vypnuti strankovani obvykle neni jasne, ktera stranka je
zrovna nastavena. Vetsine procedur to nevadi, ale vyjimkou je _Fill, ktera
pracuje jen se strankou 0. Takze bud pouzivejte jeji o malinko pomalejsi
modifikaci _Fill2 nebo resetujte stranky.}
procedure _Swap;
{Prohodi aktivni a viditelnou stranku; pri zapnutem strankovani je nutne ji
volat pokazde, kdyz chceme nechat zobrazit to, co jsme nakreslili.
Ma zabudovane cekani na navrat paprsku (synchronizacni impuls obrazovky),
takze obraz neblika.}

{Tato promenna:}
var _strankovani:boolean;
{se automaticky nastavuje podle toho, jestli je strankovani zapnute nebo
vypnute. Prakticky to tedy znamena: pokud je _strankovani=true, pak je prave
ted aktivni stranka jinde nez viditelna. Pri false jsou obe stranky stejne a
co se kresli, to je hned videt.}

(******************************* ostatni: ***********************************)

{$ifdef debug}
procedure _ShowBanks;
{Pro testovaci ucely. Kazdou banku na obrazovce vyplni jinou barvou, aby bylo
videt, kde presne zacinaji a konci.}
{$endif}


implementation(**************************************************************)
uses errmsg,klavesy2,cfg;

type PoleWordu=array[0..1000] of word; {na horni mezi nezalezi, stejne je to jenom sablona pro ukazatel}
     UkNaPoleWordu=^polewordu;           {pomocne typy}
     T_VESAInfo = record {navratovy buffer na informace o rozhrani VESA}
                  Signature:array[0..3] of char; {'VESA' nebo 'VBE2', kdyz je vsechno v poradku}
                  Version:word;  {cislo verze VESA rozhrani; v hornim bytu je ta cislice pred teckou, v dolnim ta za teckou}
                  OEMId:pointer; {ukazatel na jmeno karty (retezec zakonceny znakem #0)}
                  Flags:longint; {ruzne atributy}
                  ModeList:uknapolewordu; {ukazatel na seznam dostupnych rezimu (pole je ukonceno hodnotou $FFFF)}
                  VideoMemory:word; {velikost VRAM [64KB bloku], od VESA verze 1.1}
                  zbytek:array[1..492] of byte;
                  end;
     P_VESAinfo = ^T_VESAInfo;

var _PuvodniRezim:byte; {sem se ulozi cislo rezimu, v jakem se obrazovka
                         nachazela pred spustenim programu (obvykle 3)}
    Granularity:word;{Granularita znamena, o kolik KB dal zacina nasledujici
                      banka. Tohle uz je prepocitana hodnota, kterou kdyz
                      vynasobime cislo banky spocitane beznym zpusobem, vyjde
                      skutecne cislo banky, ktere muzeme poslat na grafarnu.}
    _CteciSegment,_ZapisovaciSegment,{segmentove adresy oken, obvykle $A000}
    _CteciOkno,_ZapisovaciOkno:word;{cisla oken pro cteni a zapis
             (obvykle obe 0 (A), ale nektere karty pouzivaji na cteni B)}
    CurBank:word; {aktualni banka}
    __SwitchBank:pointer; {adresa procedury pro prepinani bank pod VESA}
    __LHy:word; {automaticky se pricita k yove souradnici vseho, co se kresli
                 (kvuli strankovani)}

    __Font:_uknafont; {aktualni font...}
    __Vyska:byte;     {...a jeho vyska}


procedure Chcipni(NaCo:byte);{pomocna procedura pro zobrazovani chybovych hlasek, abych je nemusel vypisovat vickrat}
var txt:string;
Begin
case NaCo of
 0:txt:='Vase graficka karta nema VESA rozhrani, ktere je pro spusteni tohoto programu potreba. /'
       +' Your graphic card doesn''t support VESA interface needed by this program.';
 1:txt:='Neni dost zakladni pameti na pomocny buffer. / Not enough memory for a temporary buffer.';
 2:txt:='Vase graficka karta nepodporuje pozadovany rezim. / Your graphic card doesn''t support the desired graphic mode.';
 3:txt:='Nepodarilo se spustit pozadovany graficky rezim. / The desired graphic mode couldn''t be started.';
 end;
chyba(txt,0);
End;{chcipni}

const _NeniVESA=0;          {hodnoty parametru pro tuto proceduru}
      _MaloPameti=1;
      _RezimNepujde=2;
      _NeselSpustit=3;

procedure _NouzovySwitchbank; far; assembler; {nouzovka pro pripad, kdy od karty nedostaneme adresu bankovaci procedury}
Asm
int $10 {nastaveni registru je stejne jako pro tu specialni proceduru}
End;{_nouzovyswitchbank}

procedure _OkoukniVesu; {zjisti par dulezitych informaci o rozhrani VESA, vola se automaticky pri startu programu}
var VESAInfo:P_VESAInfo;
    vysledek:word;
Begin
if maxavail<sizeof(T_VESAInfo) then chcipni(1);
new(vesainfo);
asm
mov AX,$4F00         {kod sluzby - "zjisti informace o VESA rozhrani"}
les DI,vesainfo      {adresa zasobniku}
int $10              {a makej...}
mov vysledek,AX      {jak jsme dopadli?}
end;
if (vysledek<>$004F)or((VESAInfo^.Signature<>'VESA')and(VESAInfo^.Signature<>'VBE2'))
  then chcipni(_nenivesa);
with vesainfo^ do begin
                  _verzevesa:=version;
                  _vgakompatibilni:=(flags and 2)=0;{predbezne (hodnota se aktualizuje pri spusteni grafiky)}
                  _8bitovapaleta:=(flags and 1)<>0;
                  end;
dispose(vesainfo);
End;{_okouknivesu}

procedure _SetMode(mode:word); {nejdelsi a nejkomplikovanejsi procedura, kterou v teto jednotce najdete :-)}
type t_ModeInfo = record {buffer na informace o rezimu}
                  {pro vsechny verze rozhrani VESA:}
                  Atributy:word;{par dulezitych bitu:
                      bit 0: 1 = hardware tento rezim zvladne
                          1: jsou pritomne rozsirene informace (pro VESA 1.2 a vyssi je vzdy 1)
                          2: podporovan vystup pres BIOS
                          3: 0 = cernobily, 1 = barevny
                          4: 0 = textovy, 1 = graficky
                         od verze 2.0:
                          5: 0 = VGA kompatibilni, 1 = ne
                          6: 0 = bankovani podporovano, 1 = ne
                          7: LFB podporovano
                          8: podporovan double scan (= radky se kresli nadvakrat;
                               nutne pro nizka rozliseni, kdy jsou pixely moc vysoke a vykreslovaci paprsek moc tenky)
                         od verze 3.0:
                          9: moznost prokladaneho rezimu (= zobrazuji se jen liche radky nebo tak nejak)
                         10: podporovan hardwarovy triplebuffering
                         11: hardware zvladne stereoskopicke zobrazeni (jsou na to potreba specialni LCD bryle)
                         12: podporovana zdvojena adresa pocatku zobrazeni
                         13..15: rezervovano}
                  AtributyOknaA:byte;{bit 0: okno existuje
                                          1: da se z nej cist
                                          2: da se do nej zapisovat
                                          3..7: rezervovano}
                  AtributyOknaB:byte;{-''-}
                  Granularita:word;{o kolik KB se posune okno, kdyz prepneme na dalsi banku (zivotne dulezita hodnota)}
                  VelikostOkna:word;{[KB]}
                  SegmentOknaA:word;{v real modu prakticky vzdy $A000}
                  SegmentOknaB:word;
                  BankovaciProcedura:pointer;{dulezita procedura na prepinani bank}
                  BytuNaRadek:word;{kolik je celych bytu na radek (v bankovanych rezimech)}
                  {pro VBE 1.2 a vyssi (pro nizsi verze pouze pokud bit 1 v atributech je 1):}
                  RozliseniX:word; {\ rozmery obrazovky v pixelech,}
                  RozliseniY:word; {/    je treba zkontrolovat     }
                  SirkaZnaku,
                  VyskaZnaku:byte;
                  PocetBitovychRovin:byte;{pro 256 barev je to 1}
                  BituNaPixel:byte;{pro 256barevne rezimy 8, tohle zkontrolujeme}
                  PocetBank:byte;
                  PametovyModel:byte;{0 = textak
                                      1 = CGA
                                      2 = HGC
                                      3 = 16barevna EGA
                                      4 = packed pixel (bezna 256barevna grafika, ve ktere tato jednotka pracuje)
                                      5 = "sequ 256" (non-chain 4) graphics
                                      6 = direct color (hicolor nebo truecolor)
                                      7 = YUV
                                      8..15 - rezervovano
                                      16..255 - specialni OEM modely}
                  VelikostBanky:byte;{[KB], obvykle 64}
                  PocetStranek:byte;{kolik stranek se vejde do VRAM (tato hodnota je o 1 mensi nez skutecnost)}
                  Rezervovano1:byte;
                  {pro pametove modely 6 (direct color) a 7 (YUV):}
                  VelikostCerveneMasky:byte;{[b]}
                  PoziceCervene:byte;{pozice LSB cervene masky}
                  VelikostZeleneMasky:byte;
                  PoziceZelene:byte;
                  VelikostModreMasky:byte;
                  PoziceModre:byte;
                  VelikostRezervovaneMasky:byte;
                  PoziceRezervovane:byte;
                  AtributyDirectcoloru:byte;
                  {pro VBE 2.0 a vyssi:}
                  FyzickaFlatAdresa:longint;
                  Rezervovano2:longint;
                  Rezervovano3:word;
                  {pro VBE 3.0 a vyssi:}
                  BytuNaRadek_LFB:word;
                  PocetStranek_BankovaneRezimy:byte;
                  PocetStranek_LFB:byte;
                  VelikostCerveneMasky_LFB:byte;
                  PoziceCervene_LFB:byte;
                  VelikostZeleneMasky_LFB:byte;
                  PoziceZelene_LFB:byte;
                  VelikostModreMasky_LFB:byte;
                  PoziceModre_LFB:byte;
                  VelikostRezervovaneMasky_LFB:byte;
                  PoziceRezervovane_LFB:byte;
                  MaxPixelClock:longint;{maximalni zobrazovaci frekvence [pixelu/s] (mel by to byt dword)}
                  Zbytek:array[1..190] of byte;{doplnek do nutnych 256 B}
                  end;
     p_ModeInfo = ^t_modeinfo;
     t_CRTCInfo = record {casovaci tabulka pro nastavovani frekvence}
                  HorizontalTotal:word;            {pro podrobnosti viz proceduru SpocitejCRTC}
                  HorizontalSyncStart:word;
                  HorizontalSyncEnd:word;
                  VerticalTotal:word;
                  VerticalSyncStart:word;
                  VerticalSyncEnd:word;
                  Flags:byte;
                  PixelClock:longint;
                  RefreshRate:word;
                  zbytek:array[0..39] of byte;
                  end;
     p_CRTCInfo = ^t_crtcinfo;
var vesainfo:p_vesainfo;
    modeinfo:p_modeinfo;
    crtcinfo:p_crtcinfo;
{----------------------------------------------------------------------------}
function _ZjistiMaxFrekvenci(rezim,f:word):word;
{Vraci bud hodnotu obnovovaci frekvence monitoru v Hz vetsi nebo rovnou
zadane frekvenci f, nebo 0, kdyz nic nenajde.}
type
tEDIDinfo = record {informace o monitoru, ktere se daji ziskat pres DDC (pokud ho ten monitor podporuje)}
            rezervovano1:array[0..7] of byte;
            KodVyrobce:word; {tripismenny kod vyrobce: bity 14..10 daji prvni
                   pismeno, bity 9..5 druhe a 4..0 treti (1 = A, 2 = B atd.).}
            TypMonitoru:word; {kod modelu monitoru}
            SerioveCislo:longint; {cislo monitoru (oficialne dword)}
            TydenVyroby:byte;
            RokVyroby:byte; {0 = 1990, 1 = 1991 atd.}
            CisloVerzeEDID:byte;
            CisloRevizeEDID:byte;
            TypVstupu:byte;{bity 0: oddelena synchronizace
                                 1: sdruzena synchronizace
                                 2: synchronizace podle zelene
                               4-3: nevyuzito
                               6-5: urovne napeti: 00 = 0.700V/0.300V
                                                   01 = 0.714V/0.286V
                                                   10 = 0.100V/0.400V
                                                   11 - rezervovano
                                 7: 0 = analogovy signal, 1 = digitalni}
            SirkaMonitoru,     {\ v centimetrech }
            VyskaMonitoru:byte;{/                }
            GammaFaktor:byte; {skutecna hodnota gammy je (GammaFaktor/100)+1}
            MoznostiDPMS:byte;{bity 0..2: nevyuzito
                                       3: typ zobrazeni: 1 = barevny, RGB
                                                         0 = barevny, specialni ne-RGB
                                       4: neyuzito
                                       5: 1 = podporovan rezim "off"
                                       6: 1 = podporovan rezim "suspend"
                                       7: 1 = podporovan rezim "standby"}
            ChromaInfo:array[1..10] of byte; {netusim, k cemu to je}
            MozneFrekvence:word;{bit 0: 720x400, 70 Hz (VGA 640x400, IBM)
             (1 = podporovano)       1: 720x400, 88 Hz (XGA2)
                                     2: 640x480, 60 Hz (VGA)
                                     3: 640x480, 67 Hz (Mac II, Apple)
                                     4: 640x480, 72 Hz (VESA)
                                     5: 640x480, 75 Hz (VESA)
                                     6: 800x600, 56 Hz (VESA)
                                     7: 800x600, 60 Hz (VESA)
                                     8: 800x600, 72 Hz (VESA)
                                     9: 800x600, 75 Hz (VESA)
                                    10: 832x624, 75 Hz (Mac II)
                                    11: 1024x768, 87 Hz prokladany (8514A)
                                    12: 1024x768, 60 Hz (VESA)
                                    13: 1024x768, 70 Hz (VESA)
                                    14: 1024x768, 75 Hz (VESA)
                                    15: 1280x1024, 75 Hz (VESA)}
            MozneFrekvence2:byte;{bit 7: 1152x870, 75 Hz (Mac II, Apple)}
            MozneFrekvence3:
              array[1..8] of record
                             rozliseni:byte;{vodorovne rozliseni = (tohle+31)*8}
                             frekvence:byte;{bity 0..5: obnovovaci frekvence [Hz] zmensena o 60
                                                  6..7: pomer stran (vyska/sirka):
                                                          01 = 0.75   (3:4)
                                                          10 = 0.8
                                                          11 = 0.5625 (9:16)}
                             end;{kdyz jsou obe hodnoty 0 nebo 1, pak dana standardni frekvence neexistuje}
            PodrobneInfo:array[1..4] of array[0..17] of byte;
              {tady muzou byt bud dalsi podrobnosti ohledne obnovovacich
              frekvenci (viz tDTDinfo) nebo ruzne textove informace
              (viz tTIinfo)}
            rezervovano2:byte;
            KontrolniSoucet:byte; {dolni byte z 16bitoveho souctu vsech predchozich bytu v celem tomto zaznamu}
            end;
pEDIDinfo = ^tedidinfo;
tDTDinfo = record {jeden mozny tvar polozek pole PodrobneInfo v typu tEDIDinfo}
           HorizFrek:byte;{[kHz]}
           VertFrek:byte;{[Hz]}
           HorizAktivniCas:byte;{[px], vodorovne rozliseni (netusim, jak se to ma do toho bytu vejit)}
           HorizNeaktivniCas:byte;{[px]}
           HorizAktivniCas2:byte;{[px]}
           VertAktivniCas:byte;{[px]}
           VertNeaktivniCas:byte;{[px]}
           VertAktivniCas2:byte;{[px]}
           HorizSyncOfset:byte;{[px]}
           HorizSyncSirka:byte;{[px]}
           VertSyncOfset:byte;{[px]}
           Ofset_sirka2:byte;{[px]}
           SirkaObrazu:byte;{[mm]}
           VyskaObrazu:byte;{[mm]}
           Rozmer2:byte;{???}
           VodorovnyOkraj:byte;{[px]}
           SvislyOkraj:byte;{[px]}
           TypZobrazeni:byte;{bity 7: 1 = prokladany (interlaced)
                                 6-5: stereoskopicky: 00 = normalni, bez sterea
                                                      01 = stereo, synchronizace podle obrazku pro prave oko
                                                      10 = stereo, synchronizace podle obrazku pro leve oko
                                                      11 neni definovano
                                 4-3: typ synchronizace: 00 = analogova sdruzena
                                                         01 = analogova sdruzena bipolarni
                                                         10 = digitalni sdruzena
                                                         11 = digitalni oddelena
                                 2: pro typ synchronizace 11: polarita vertikalni synchronizace (0 = -, 1 = +)
                                    pro vsechny ostatni typy: stridava (serrate) polarita vert. synchronizace
                                 1: pro typ synchronizace 11: polarita horizontalni synchronizace (0 = -, 1 = +)
                                    pro vsechny ostatni typy: okamzik synchronizace (0 = podle zelene, 1 = RGB)
                                 0: asi nevyuzito}
           end;
tTIinfo = record {druhy mozny tvar polozek pole PodrobneInfo v typu tEDIDinfo}
          identifikace:array[1..3] of char;{kdyz jsou vsechny tyto 3 B nulove, je to TI, jinak to je DTD}
          case CoToJe:byte of{urcuje, jake informace budou nasledovat:
                                 $FF = seriove cislo
                                 $FE = jmeno prodejce
                                 $FD = rozsah frekvenci (jedina vec, kterou nyni vyuzijeme)
                                 $FC = jmeno monitoru (modelu)}
          $FD:(rezervovano1:byte;{obvykle hodnota 0}
               MinVertFrek:byte;{minimalni vertikalni obnovovaci frekvence [Hz]}
               MaxVertFrek:byte;{maximalni -"-}
               MinHorizFrek:byte;{minimalni horizontalni obnov. frekvence [kHz]}
               MaxHorizFrek:byte;{maximalni -"-}
               rezervovano2:byte);{obvykle hodnota $FF}
          $FF,$FE,$FC:(NejakyText:array[1..14] of char);{ukonceny je bud znakem #0 nebo #10}
          end;
var EDIDinfo:pedidinfo;
    maxf,tmp:word;
    i:byte;
Begin
_zjistimaxfrekvenci:=0;{jestli skoncime predcasne, tohle tu zustane}
if f=0 then exit;
{nacteni informaci z monitoru pres DDC kanal:}
if maxavail<sizeof(tedidinfo) then begin
                                   {$ifdef debug}writeln('Neni dost pameti na nacteni informaci o monitoru.');{$endif}
                                   exit;
                                   end
                              else new(edidinfo);
fillchar(edidinfo^,sizeof(tedidinfo),0);
{$ifdef debug} {zda se, ze problem s dlouhym nacitanim je vyresen}
writeln('Nacitam informace o monitoru...');
writeln;
writeln('Retrieving monitor information...');
{$endif}
tmp:=0;
asm
mov AX,$4F15    {sluzby DDC}
xor CX,CX
mov BX,1        {podsluzba "nacti informace o monitoru"}
xor DX,DX
les DI,edidinfo {navratovy zasobnik}
int $10
mov tmp,AX        {jak to dopadlo?}
end;
{$ifdef debug}writeln('Hotovo.');{$endif}
if tmp<>$004F then begin
                   {$ifdef debug}writeln('Monitor nezvlada DDC, nelze nacist informace o podporovanych frekvencich.');{$endif}
                   dispose(edidinfo);
                   exit;
                   end;
{Udaje o monitoru jsou nacteny, jdeme najit vhodnou frekvenci.
Nejdriv ji zkusime najit v prislusne tabulce (beru v uvahu pouze plnohodnotne
VESA rezimy a frekvence nad 60 Hz):}
maxf:=0;
with edidinfo^ do
 case rezim of _640x480:if (moznefrekvence and 32)<>0 then maxf:=75
                         else if (moznefrekvence and 16)<>0 then maxf:=72;
               _800x600:if (moznefrekvence and 512)<>0 then maxf:=75
                         else if (moznefrekvence and 256)<>0 then maxf:=72;
               _1024x768:if (moznefrekvence and 16384)<>0 then maxf:=75
                          else if (moznefrekvence and 8192)<>0 then maxf:=70;
               end;
{$ifdef debug}
write('V prvni tabulce ');
if maxf=0 then writeln('nebyla zadna vhodna frekvence nalezena.')
          else writeln('byla nalezena frekvence ',maxf,' Hz.');
{$endif}
if maxf<f then {jestli jsme pod pozadovanou frekvenci, zkusime druhou tabulku}
 begin
 {$ifdef debug}writeln('Zkusime jeste druhou tabulku.');{$endif}
 with edidinfo^ do
  for i:=1 to 8 do
   if ((moznefrekvence3[i].rozliseni+31) shl 3)=_maxx+1 {sedi x-ove rozliseni}
     then begin
          {jake je y-ove rozliseni?:}
          case moznefrekvence3[i].frekvence shr 6 of 1:tmp:=round((_maxx+1)*0.75);
                                                     2:tmp:=round((_maxx+1)*0.8);
                                                     3:tmp:=round((_maxx+1)*0.5625);
                                                     end;
          if tmp=_maxy+1 then begin {rozliseni sedi}
                              tmp:=(moznefrekvence3[i].frekvence and $3F)+60;{vypocitame frekvenci}
                              if tmp>=f then begin {jestli uz to staci, tak berem a konec...}
                                             _zjistimaxfrekvenci:=tmp;
                                             {$ifdef debug}writeln('Naslo se ',tmp,' Hz.');{$endif}
                                             exit;
                                             end
                                        else if tmp>maxf then maxf:=tmp; {...jinak dal hledame maximum}
                              end;
          end;
 {$ifdef debug}
 write('Po prohledani druhe tabulky ');
 if maxf=0 then writeln('stale zadnou vhodnou frekvenci nemame.')
           else writeln('mame frekvenci ',maxf,' Hz.');
 {$endif}
 end;
{Posledni kontrola - mezni frekvence:}
for i:=1 to 4 do with ttiinfo(edidinfo^.podrobneinfo[i]) do
 if (identifikace=#0#0#0)and(cotoje=$FD)
   then begin
        if maxf<minvertfrek then maxf:=minvertfrek;
        if maxf>maxvertfrek then maxf:=maxvertfrek;
        {$ifdef debug}writeln('Max. frekvence monitoru je ',maxvertfrek,' Hz.');{$endif}
        break;
        end;
{ted uz to jenom nejak shrnout a vyhodnotit:}
if maxf<60 then maxf:=0; {to uz radsi vychozi frekvenci (tohle se snad ani nemuze stat)}
dispose(edidinfo);
_zjistimaxfrekvenci:=maxf;
End;{_zjistimaxfrekvenci}
{----------------------------------------------------------------------------}
function JeToOn(rezim:word; var buffer:t_modeinfo):boolean; {nacte informace o rezimu a vrati true, pokud je to ten hledany}
var vysledek:word;
Begin
{$ifdef debug}writeln('Kontroluji rezim c. ',rezim,'...');{$endif}
jetoon:=false;
fillchar(modeinfo^,256,0); {vynulujeme zasobnik (starsi verze VESA to za nas neudelaji)}
asm
mov AX,$4F01    {sluzba "zjisti informace o rezimu"}
mov CX,rezim    {o kterem rezimu}
les DI,buffer   {pripravime zasobnik}
int $10
mov vysledek,AX
end;
if vysledek=$4F then with buffer do
 begin
 jetoon:=((atributy and 25)=25){je to barevny graficky rezim a hardware ho zvladne}
         and ((atributy and 64)=0){funguje v nem bankovani}
         and (((atributyoknaA and 1)<>0)
            or((atributyoknaB and 1)<>0)){existuje presouvatelne okno (cili opet: funguje bankovani)}
         and (((atributy and 2)=0) or ((rozlisenix=_maxx+1)and(rozliseniy=_maxy+1)and(bitunapixel=8)));
          {bud mame VBE 1.0 nebo 1.1 a budeme doufat, ze to vyjde, nebo
          mame novejsi a pak si zkontrolujeme rozliseni a barevnou hloubku}
 _vgakompatibilni:=(atributy and 32)=0;
 if granularita=0 then granularity:=1
                  else granularity:=64 div granularita;{prepocitani granularity na pouzitelnou hodnotu}
  {(pozn.: granularitA je polozka infa a granularitY je globalni promenna)}
 if bankovaciprocedura=nil then begin
                                __switchbank:=@_nouzovyswitchbank; {kdyz to nejde jinak, pouzijeme int $10}
                                {$ifdef debug}writeln('Na bankovani se pouzije int 10h.');{$endif}
                                end
                           else __switchbank:=bankovaciprocedura;
 {urceni zapisovaciho a cteciho okna a segmentu:}
 if (atributyoknaA and 5)=5 then begin {okno A existuje a da se do nej zapisovat}
                                 _zapisovaciokno:=0;
                                 _zapisovacisegment:=segmentoknaA;
                                 end
  else if (atributyoknaB and 5)=5 then begin {okno B existuje a da se do nej zapisovat}
                                       _zapisovaciokno:=1;
                                       _zapisovacisegment:=segmentoknaB;
                                       end
   else begin {zadne z obou oken neni pouzitelne (to se snad vubec nemuze stat)}
        _zapisovacisegment:=$A000; _zapisovaciokno:=0; {vychozi hodnoty - tim se snad nic nezkazi}
        {$ifdef debug}writeln('Nebylo nalezeno okno pro zapis do VRAM, pouzije se vychozi nastaveni.');{$endif}
        end;
 if (atributyoknaA and 3)=3 then begin {okno A existuje a da se z nej cist}
                                 _cteciokno:=0;
                                 _ctecisegment:=segmentoknaA;
                                 end
  else if (atributyoknaB and 3)=3 then begin {okno B existuje a da se z nej cist}
                                       _cteciokno:=1;
                                       _ctecisegment:=segmentoknaB;
                                       end
   else begin
        _ctecisegment:=$A000; _cteciokno:=0;
        {$ifdef debug}writeln('Nebylo nalezeno okno pro cteni z VRAM, pouzije se vychozi nastaveni.');{$endif}
        end;
 {$ifdef debug}
 writeln('Zapisovaci okno: segment = ',_zapisovacisegment:5,', cislo = ',_zapisovaciokno);
 writeln('Cteci okno: segment = ',_ctecisegment:5,', cislo = ',_cteciokno);
 {$endif}
 end;
End;{jetoon}
{----------------------------------------------------------------------------}
procedure SpocitejCRTC(var buffer:t_crtcinfo; rezim:word);{vypocita casovaci tabulku pro nastaveni frekvence}
{const xadjust=0; yadjust=0; {netusim, k cemu jsou (tuhle proceduru jsem nevymyslel), ale funguje to i bez nich}
var HSWidth,VSWidth:word;
    SS,SE:word;
    doublescan:boolean;
    xres,yres:word;
    pc:record l,h:word; end;{emulace dwordu, ktera umozni 32bitovou praci v 16bitovem prekladaci}
Begin
xres:=_maxx+1; yres:=_maxy+1;
doublescan:=yres<400; {moderni monitory maji ostrejsi paprsek, ktery nedokaze vykreslit tak vysoke pixely...}
if doublescan then yres:=yres*2; {...takze je musi kreslit nadvakrat => potrebujeme dvojnasobnou obnovovaci frekvenci}
with buffer do
 begin
 {Priznam se, ze tyhle vypocty nejsou moje dilo a ne vse jsem pochopil.
 Zkusim se podelit aspon o zaklady.
   +-+-+-+-+-+>+-+-+-+-+-+-+-+-+   <- Tohle je zjednoduseny nakres monitoru.
V  +-+-+-+-+-+-+-+>+-+-+-+-+-+-+     Vy#ovana oblast je to, co vidite
S >+-+-#-#-#-#-#-#-#-#-#-#-#-+-+     (pozadovanych 800x600 apod.). Vy+ovany
E  +-+-#-#-#-#-#-#-#-#-#-#-#-+-+     zbytek je okraj, ktery se nezobrazuje.
   +-+-#-#-#-#-#-#-#-#-#-#-#-+-+     Zamerovace elektronoveho paprsku ho jenom
   +-+-#-#-#-#>#-#-#-#-#-#-#-+-+     naprazdno prejizdeji. Pomlckami jsou
V  +-+-#-#-#-#-#-#-#-#-#-#-#-+-+     vyznaceny radky. To, jestli zrovna
S >+-+-#-#-#-#-#-#-#-#-#-#-#-+-+     paprsek sviti nebo nesviti, se urcuje
S  +-+-+-+-+-+-+>+-+-+-+-+-+-+-+     signaly Horizontal sync a Vertical sync.
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+     Kdyz jsou oba na nule, paprsek sviti.
       ^                   ^          Horizontal total a Vertical total jsou
      HSE                 HSS        rozmery cele plochy, kterou zamerovaci
                                     civky obsahnou (v pixelech), vcetne
 okraju, kde je paprsek vypnuty. Horizontal sync start je okamzik (vlastne
 misto, opet v pixelech), kdy paprsek dorazi doprava na konec zobrazovane
 plochy, nahodi se signal H. sync a paprsek se vypne. Horizontal sync end je
 okamzik (souradnice), kdy paprsek na levem okraji vstupuje do zobrazovane
 oblasti, signal H. sync konci a paprsek se rozsviti. Horizontal sync width je
 doba (vzdalenost) mezi H. s. start a H. S. end, tedy kdy paprsek nesviti.
 Podobne je to s hodnotami Vertical sync start, end a width. V oblasti horniho
 a dolniho okraje se H. sync prepina naprazdno a paprsek je stejne porad
 vypnuty, protoze je zapnuty V. sync (a to je presne ta doba zvana "navrat
 paprsku" (vertical retrace), na kterou se ceka, kdyz se zobrazuji nejake
 animovane veci z virtualni obrazovky).
 Vsechny tyto rozmery se pocitaji vicemene odhadem: ve vodorovnem smeru je
 sirka okraje cca 27% viditelne plochy, ve svislem cca 7%. Zbyle pricitani
 konstant, nulovani nejnizsich bitu a podobne jde mimo moje chapani (asi by to
 chtelo nejaky podrobnejsi manual).
  Pixel clock je frekvence, s jakou paprsek prejizdi jednotlive pixely (takze
 jednotka je pixel za sekundu), radove megahertzy. Je to asi nejdulezitejsi
 udaj o frekvenci. Horizontalni obnovovaci frekvence rika, kolik radku za
 sekundu se vykresli (radove kilohertzy). Vertikalni obnovovaci frekvence
 znamena, kolik se vykresli obrazovek za sekundu (radove desitky Hz), a to je
 presne to, co chceme mit ve vysledku vetsi nez tech vychozich blikavych 60 Hz
 a kvuli cemu celou tuhle saskarnu provadime :-).}
 horizontaltotal:=round(xres*1.27) and not 7;
 HSWidth:=round((horizontaltotal-xres)/5) and not 7;
 HorizontalSyncStart:=xres+16;
 HorizontalSyncEnd:=HorizontalSyncStart+HSWidth;
 VerticalTotal:=round(yres*1.07);
 VSWidth:=round(VerticalTotal/100)+1;
 VerticalSyncStart:=yres+round((VerticalTotal-yres)/5)+1;
 VerticalSyncEnd:=VerticalSyncStart+VSWidth;
 SS:=HorizontalSyncStart{+xadjust};
 SE:=HorizontalSyncEnd{+xadjust};
{ if xadjust<0 then begin
                   if SS<xres+8 then begin
                                     SS:=xres+8;
                                     SE:=SS+HSWidth;
                                     end
                   end
              else} if horizontaltotal<SE+24 then begin
                                                 SE:=horizontaltotal-24;
                                                 SS:=SE-HSWidth;
                                                 end;
 HorizontalSyncStart:=SS;
 HorizontalSyncEnd:=SE;
 SS:=VerticalSyncStart{+yadjust};
 SE:=VerticalSyncEnd{+yadjust};
{ if yadjust<0 then begin
                   if SS<yres+3 then begin
                                     SS:=yres+3;
                                     SE:=SS+VSWidth;
                                     end
                   end
              else} if VerticalTotal<SE+4 then begin
                                              SE:=VerticalTotal-4;
                                              SS:=SE-VSWidth;
                                              end;
 VerticalSyncStart:=SS;
 VerticalSyncEnd:=SE;
 Flags:=12 or ord(doublescan); {polaritu obou synchronizacnich signalu nastavime na zapornou}
 longint(pc):=longint(_frekvence)*HorizontalTotal*VerticalTotal; {pixel clock}
 if (modeinfo^.maxpixelclock>0)and(longint(pc)>modeinfo^.maxpixelclock)
           {^^tahle podminka je tu pro pripad, ze by longint pretekl az do zaporna (mel by to byt dword)}
   then begin
        {$ifdef debug}writeln('Pozadovana frekvence (pixel clock) je prilis velka - pouzije se vychozi.');{$endif}
        _frekvence:=0;
        exit;
        end;
 asm
 mov AX,$4F0B {sluzba "najdi nejblizsi frekvenci"}
 xor BX,BX
 db $66; mov CX,pc.l {= mov ECX,dword ptr pc ($66 je prefix, ktery rika, ze se ma kopirovat 32 bitu)}
 mov DX,rezim
 int $10
 db $66; mov pc.l,CX {= mov dword ptr pc,ECX}
 mov se,AX    {promennou SE uz nebudu potrebovat, tak ji vyuziju jako pomocnou}
 end;
 if se=$4F then begin
                pixelclock:=longint(pc);
                refreshrate:=_frekvence*100; {v setinach Hz}
                end
           else begin
                _frekvence:=0;
                {$ifdef debug}writeln('Nebyla nalezena vhodna frekvence (pixel clock), pouzije se vychozi.');{$endif}
                end;
 end;
End;{spocitejCRTC}
{----------------------------------------------------------------------------}
function SpustHo(rezim:word; var crtc:t_crtcinfo):word; assembler; {spusti graficky rezim, vraci $4F pri uspechu}
Asm
mov CX,_frekvence  {na test, jestli je to nula nebo ne}
mov AX,$4F02     {sluzba "nastav rezim"}
mov BX,rezim     {cislo rezimu}
or CX,CX                     {je to nula?}
jz @VychoziFrekvence         {ano => frekvenci neresime}
 or BX,2048      {tenhle bit rika, ze se ma nastavit uzivatelska frekvence}
 les DI,crtc
@VychoziFrekvence:
xor CX,CX       {pro jistotu}
int $10
{navratova hodnota funkce = AX}
End;{spustho}
{----------------------------------------------------------------------------}
var NazevSekce:string[6]; {jmeno sekce, do ktere se ulozi nastaveni grafiky ('[VESA]')}
    NazevPolozky:string[9]; {'frekvence'       <^pro konfiguracni soubor}
    kon:konfigurace;
    i:integer;
Begin{_setmode}
case mode of _Textak:begin {ukonceni grafiky a navrat do puvodniho rezimu obrazovky}
                     asm
                     xor AH,AH
                     mov AL,_puvodnirezim {normalne by to melo byt cislo 3 (textak 80x25x16), ale jeden nikdy nevi...}
                     int $10
                     {nebo snad radsi tohle?:
                     mov AX,$4F02
                     mov BX,3
                     int $10}
                     end;
                     _maxx:=79;
                     _maxy:=24;
                     {$ifdef debug}writeln('Graficky rezim ukoncen.');{$endif}
                     exit;
                     end;
             {pripravime si rozliseni:}
             _640x350:begin
                      _MaxX:=639;
                      _MaxY:=349;
                      end;
             _640x400:begin
                      _MaxX:=639;
                      _MaxY:=399;
                      end;
             _640x480:begin
                      _MaxX:=639;
                      _MaxY:=479;
                      end;
             _800x600:begin
                      _MaxX:=799;
                      _MaxY:=599;
                      end;
             _1024x768:begin
                       _MaxX:=1023;
                       _MaxY:=767;
                       end;
             end;
{pripravime navratove zasobniky:}
if maxavail<sizeof(t_vesainfo) then chcipni(_malopameti) else new(vesainfo);
if maxavail<sizeof(t_modeinfo) then chcipni(_malopameti) else new(modeinfo);
if maxavail<sizeof(t_crtcinfo) then chcipni(_malopameti) else new(crtcinfo);
asm
mov AX,$4F00    {nacti informace o VESA}
les DI,vesainfo
int $10
cmp AX,$004F    {povedlo se?}
je @OK
 push _nenivesa {nepovedlo}
 call chcipni   {chcipni(0);}
@OK:
end;
{Nejdriv zkontrolujeme, jestli danemu rozliseni odpovida rezim se standardnim
cislem (coz je to, co bylo zadano v parametru procedury). Pokud se test
nepovede nebo nesedi parametry rezimu, musime najit nejaky jiny:}
if not JeToOn(mode,modeinfo^) then
  begin
  {$ifdef debug}writeln('Standardni cislo rezimu nesouhlasi, musime najit nejaky jiny.');{$endif}
  i:=0; {bude slouzit jako index v seznamu rezimu}
   repeat
   mode:=vesainfo^.modelist^[i]; {nacteme kod ze seznamu}
   if (mode=$FFFF){jestli jsme na konci pole...}
      or (i=32767){...nebo taaakhle daleko (coz se teoreticky snad ani nemuze stat)}
     then chcipni(_rezimnepujde);
   inc(i);
   until jetoon(mode,modeinfo^);
  {cyklus bezi tak dlouho, dokud nenajdeme 256barevny rezim se spravnym rozlisenim}
  {$ifdef debug}writeln('Rezim c. ',mode,' odpovida.');{$endif}
  end {$ifdef debug}else writeln('Standardni cislo rezimu souhlasi.'){$endif};
{Cislo rezimu (mode) urceno, ted se podivame na obnovovaci frekvenci:}
nazevsekce:='[VESA]'; nazevpolozky:='frekvence'; {pro konfiguracni soubor}
{$ifdef debug}writeln('Verze vaseho VESA BIOSu je ',hi(_verzevesa),'.',lo(_verzevesa));{$endif}
if _verzevesa<$0300
  then begin {grafarna to urcite nepodporuje => neni co resit}
       _frekvence:=0;
       {$ifdef debug}writeln('Obnovovaci frekvence jde nastavovat az od verze 3.0, u vas tedy ne.');{$endif}
       end
  else begin {OK, grafarna to umi => podivame se, co chce nastavit uzivatel}
       {nacteni drive ulozene frekvence ze souboru:}
       kon.init;
       kon.nacti(cfgsoubor,nazevsekce);
       {$ifdef debug}
       i:=-1;
       kon.prectiinteger(nazevpolozky,i); {tmp = ulozena frekvence}
       if i>=0 then begin {v souboru byla ulozena frekvence}
                   _frekvence:=i; {nastavime ji jako pozadovanou}
                   {$ifdef debug}writeln('Zkusim pouzit ulozenou frekvenci ',i,' Hz.');{$endif}
                   end {$ifdef debug}
              else writeln('V konfiguracnim souboru zadna frekvence nebyla, pouziji hodnotu ',_frekvence);{$endif};
       {$else}
       kon.prectiword(nazevpolozky,_frekvence);
       {$endif}
       kon.zrus;
       end;
if _frekvence<>0
  then begin {pokud mame zadanou frekvenci, zkontrolujeme, jestli ji monitor zvladne}
       i:=_zjistimaxfrekvenci(mode,_frekvence);
       if i=0 {cteni DDC se nepovedlo...}
         then begin {...ale je sance, ze frekvence pujde nastavit (jestli tu jsme, tak urcite mame VESA 3+)}
              writeln;
              writeln('Vas monitor bud nema rozhrani DDC nebo nebyla nalezena zadna vhodna');
              writeln('obnovovaci frekvence, kterou by zvladal.');
              writeln('Dalsi postup je na vas, stisknete prislusnou klavesu:');
              writeln;
              writeln('Enter - pouzit vychozi frekvenci adapteru (bezpecne, ale je to jen 60 Hz)');
              writeln('R - presto zkusit nastavit zadanou frekvenci ',_frekvence,' Hz');
              writeln('    POZOR, jen pokud jste si jisti, ze to vas monitor snese!!!');
              writeln('Esc - okamzity konec programu');
              writeln;
              writeln;
              writeln('Your monitor doesn''t support DDC interface or no suitable refresh');
              writeln('frequency has been found.');
              writeln('Now it''s up to you, choose and press a key:');
              writeln;
              writeln('Enter - use default frequency (always safe, but it''s only 60 Hz)');
              writeln('R - try to use the specified frequency of ',_frekvence,' Hz');
              writeln('    WARNING - only if you are sure your screen can handle it!!!');
              writeln('Esc - abort the program immediately');
              writeln;
              kresetuj;
               repeat
               i:=xreadkey;
               until i in [13,27,82,114];
              case i of 13:begin
                           {$ifdef debug}writeln('Vychozi frekvence nastavena.');{$endif}
                           _frekvence:=0;
                           end;
                        27:begin
                           {$ifdef debug}writeln('Program ukoncen.');{$endif}
                           halt;
                           end;
                        {$ifdef debug}else writeln('Dobra, jedeme dal.');{$endif}
                        end;
              end
         else _frekvence:=i; {OK, frekvence byla pres DDC nalezena (nebo nalezena nebyla a je 0)}
       {jeste jedna kontrola:}
       if modeinfo^.maxpixelclock=0
         then begin
              {$ifdef debug}writeln('ModeInfo.MaxPixelClock=0 => pouzije se vychozi frekvence.');{$endif}
              _frekvence:=0;
              end;
       end;
{spocitame casovaci tabulku:}
if _frekvence<>0 then spocitejCRTC(crtcinfo^,mode);
{$ifdef debug}
if _frekvence<>0 then
 begin
 writeln(' Rekapitulace vypoctu frekvence:');
 writeln('pozadovana frekvence = ',_frekvence,' Hz');
 writeln(' (pokud je 0, znamena to vychozi frekvenci adapteru;');
 writeln('  nasledujicich hodnot si v takovem pripade nevsimejte)');
 writeln('modeinfo.MaxPixelClock = ',modeinfo^.maxpixelclock,' Hz');
 writeln('crtcinfo.PixelClock = ',crtcinfo^.pixelclock,' Hz');
 writeln('crtcinfo.RefreshRate = ',crtcinfo^.refreshrate,' setin Hz');
 end;
writeln;
writeln('Esc = konec programu, cokoli jineho = pokracovat,');
kresetuj;
if readkey=#27 then halt;
{$endif}
if spustho(mode,crtcinfo^)<>$4F
  then if _frekvence<>0 then begin
                             _frekvence:=0;
                             {$ifdef debug}
                             writeln('Start grafiky se zadanou frekvenci se nepovedl,'+
                                     ' zkusime to jeste s vychozi.');
                             {$endif}
                             if spustho(mode,crtcinfo^)<>$4F then chcipni(_neselspustit);
                             end
                        else chcipni(_neselspustit);
_pujdestrankovani:=(longint(vesainfo^.videomemory)shl 16)div((longint(_maxx)+1)*(_maxy+1))>=2;
dispose(modeinfo); dispose(vesainfo); dispose(crtcinfo);
_setdefaultwindow;
curbank:=$FFFF; {po inicializaci by mela byt vzdy nastavena banka 0, ale co kdyby nebyla}
{ulozeni skutecne nastavene frekvence pro priste:}
kon.init;
if kon.pridejsekci(nazevsekce)
   and kon.zadejcislo(nazevpolozky,_frekvence) and kon.uloz(cfgsoubor)
     then {hm};
kon.zrus;
End;{_setmode}

procedure _SwitchBank(bank:word); assembler;  {pouze pro zapisovaci okno!!!}
Asm
mov AX,bank            {AX:=pozadovana banka}
mov curbank,AX         {ulozeni banky do globalni promenne}
mul granularity        {vynasobeni AX granularitou - ted je tam skutecne cislo banky}
mov DX,AX              {do DX s nim (__switchbank ho chce prave tam)}
mov BX,_zapisovaciokno {podkod sluzby - "nastav banku" a cislo okna, do ktereho kreslime}
mov AX,$4F05           {kod sluzby - "ovladani pristupu k obrazovce"}
call __switchbank      {do toho!}
End;{_switchbank}

procedure _SwitchRBank(bank:word); assembler;  {pro cteci okno}
Asm
mov AX,bank
mul granularity
mov DX,AX
mov BX,_cteciokno
mov AX,$4F05
call __switchbank
End;{_switchrbank}

function _getbank:word; assembler;
Asm
mov AX,curbank    {jednoduse opiseme prislusnou globalni promennou}
End;{_switchbank}      {v AX se vrati vysledek}

function _getrbank:word; assembler;
{promenna Curbank plati pouze pro zapisovaci okno, u cteciho musime banku
zjistit "poctive", volanim prislusne VESA sluzby:}
Asm
mov AX,$4F05           {kod sluzby - "ovladani pristupu k obrazovce"}
mov BX,_cteciokno      {do BL kod cteciho okna}
or  BX,$0100           {do BH kod podsluzby "zjisti banku"}
call __switchbank      {do toho!}
mov AX,DX              {v DX se nam vratilo cislo banky}
xor DX,DX              {DX bude vyssi word delence, tak musi byt 0}
div granularity        {vydelime AX granularitou; v DX zustane zbytek, ale ten nas nezajima}
End;{_switchbank}      {v AX se vrati vysledek}

(***************************************************************************
                           PutPixel a GetPixel
****************************************************************************)

procedure _PutPixel(x,y:word;barva:byte);assembler;
Asm
mov AX,__lhy
mov DX,_zapisovacisegment
add y,AX       {pro virtualni obrazovku}
mov ES,DX      {ES = segment pro videopamet}
mov AX,_MaxX
inc AX         {AX = sirka obrazovky}
mul y          {vynasob AX ypsilonem; co pretece, dej do DX}
add AX,x       {k AX pricti x}
adc DX,0       {jestli AX preteklo, zvys hodnotu DX}
               {vysledek: v AX je ofset bodu, v DX cislo banky}
mov DI,AX      {ofset ulozime do registru k tomu urcenemu}
               {ted se postarame o bankovani:}
cmp DX,CurBank   {neni nahodou potrebna banka uz nastavena?}
je @neprepinej    {je -> nebudeme se zdrzovat prepinanim}
 mov curbank,DX                      {rozepsana procedura _switchbank}
 mov AX,DX
 mul Granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank
@neprepinej:
mov AL,barva
mov ES:[DI],AL     {samotne vykresleni pixelu uz je vylozene prkotina :-)}
End;{_putpixel}

procedure _XorPixel(x,y:word;barva:byte);assembler;
Asm
mov AX,__lhy
mov DX,_zapisovacisegment {je otazka, jestli se xor bere jako cteni, nebo jako zapis - nutno vyzkouset}
add y,AX
mov ES,DX
mov AX,_MaxX
inc AX
mul y
add AX,x
adc DX,0
mov DI,AX
cmp DX,CurBank
je @neprepinej
 mov curbank,DX
 mov AX,DX
 mul Granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank
@neprepinej:
mov AL,barva
xor byte ptr ES:[DI],AL {tohle je jediny radek, ktery se lisi od _putpixelu}
End;{_xorpixel}

function _GetPixel(x,y:word):byte; assembler;
Asm
mov AX,__lhy
mov DX,_ctecisegment
add y,AX
mov ES,DX
mov AX,_MaxX
inc AX
mul y
add AX,x
adc DX,0
mov CX,_cteciokno
mov DI,AX
cmp CX,_zapisovaciokno
jne @prepni {pokud nejsou obe okna stejna, nemusi promenna Curbank platit => prepneme vzdy}
cmp DX,CurBank
je @neprepinej
 mov curbank,DX
 @prepni:
 mov AX,DX
 mul Granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_cteciokno
 call __switchbank
@neprepinej:
mov AL,ES:[DI]
End;{_getpixel}

(***************************************************************************
                     PutPixel a GetPixel s orezavanim
****************************************************************************)

procedure __PutPixel(x,y:integer;barva:byte);
Begin
if (x>=_MinClipX) and (x<=_MaxClipX) and
   (y>=_MinClipY) and (y<=_MaxClipY) then _PutPixel(x,y,barva);
End;{__PutPixel}

procedure __XorPixel(x,y:integer;barva:byte);
Begin
if (x>=_MinClipX) and (x<=_MaxClipX) and
   (y>=_MinClipY) and (y<=_MaxClipY) then _xorpixel(x,y,barva);
End;{__xorpixel}

function __GetPixel(x,y:integer):byte;
Begin
if x<_minclipx then x:=_minclipx
               else if x>_maxclipx then x:=_maxclipx;
if y<_minclipy then y:=_minclipy
               else if y>_maxclipy then y:=_maxclipy;
__getpixel:=_GetPixel(x,y);
End;{__getpixel}

(***************************************************************************
                           Kreslici procedury
****************************************************************************)

procedure _HLine(x1,x2,y:word;barva:word); assembler;
var count:word;
Asm
{$ifdef blbuvzdornost}  {jestli x1>x2, prohodime je}
mov AX,x1
cmp AX,x2
js @OK
 mov AX,x1
 mov BX,x2
 mov x2,AX
 mov x1,BX
@OK:
{$endif}
{Nasledujici usek je optimalizovan pro paralelni zpracovani instrukci na
 Pentiich (starsim procesorum, ktere to neumi, to nepomuze ani neuskodi):}
mov AX,__lhy;                            mov DX,barva
add y,AX;  {pro virtualni obrazovku}     mov DH,DL
mov AX,_zapisovacisegment;               mov barva,DX   {barva ma ted hodnotu barvy v dolnim i hornim bytu}
mov ES,AX; {ES = cilovy segment}         mov BX,x2
mov AX,_MaxX;                            sub BX,x1
inc AX;                                  inc BX
mul y;                                   mov count,BX {count = pocet pixelu (delka cary)}
add AX,x1
adc DX,0   {DX = pocatecni banka}
mov DI,AX  {DI = ofset zacatku cary}
cmp DX,CurBank
je @neprepinej
 mov curbank,DX
 mov AX,DX
 mul Granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank
 mov AX,DI
@neprepinej:        {pocatecni banka nastavena}

mov BX,count
dec BX
add AX,BX        {AX = ofset konce cary}
jnc @najednou     {kdyz se vejdeme do jedne banky, jdeme dal...}

 {...jinak vyplnime nejdriv konec prvni banky:}

 or CX,$FFFF       {= mov CX,$FFFF}
 sub CX,DI
 inc CX            {CX = pocet pixelu v prvni bance}

 mov AX,count
 sub AX,CX
 mov count,AX      {count = pocet pixelu ve druhe bance}

 mov AX,barva
 db $66; shl AX,16
 mov AX,barva      {EAX ma ted v kazdem bytu hodnotu barvy}

 mov BX,CX
 shr CX,2
 and BX,3
  db $66; rep stosw  {= rep stosd, kopiruje se po 4 bytech}
 mov CX,BX
  rep stosb          {prekopirovani zbylych max. 3 bytu}

 {v posledni iteraci DI preteklo a je v nem 0, coz presne chceme}

 inc curbank
 mov AX,curbank
 mul granularity   {__switchbank obcas necha v DX nejakou kravinu, tak musime znova nasobit a nejde jenom pricist granularitu}
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank   {a jsme o banku dal}

@najednou:

mov CX,count         {CX = pocet pixelu (ve druhe bance nebo cele cary)}

mov AX,barva
db $66; shl AX,16
mov AX,barva      {EAX = barva}

mov BX,CX
shr CX,2
and BX,3
 db $66; rep stosw
mov CX,BX
 rep stosb
End;{_hline}

procedure _VLine(x,y1,y2:word;barva:byte);assembler;
var incr:word;
Asm
{$ifdef blbuvzdornost}  {jestli y1>y2, prohodime je}
mov AX,y1
cmp AX,y2
js @OK
 mov AX,y1
 mov BX,y2
 mov y2,AX
 mov y1,BX
@OK:
{$endif}

mov BX,__lhy;           mov CX,_zapisovacisegment
add y1,BX;              mov ES,CX
add y2,BX
mov AX,_MaxX
inc AX
mov incr,AX   {incr = sirka obrazovky}
mul y1
add AX,x
adc DX,0      {DX = pocatecni banka}
mov DI,AX     {DI = pocatecni ofset}

cmp DX,CurBank
je @neprepinej
 mov AX,DX
 mov curbank,DX
 mul granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank
@neprepinej:          {pocatecni banka nastavena}

mov AL,barva
mov ES:[DI],AL        {prvni pixel je nakreslen}

mov CX,y2
sub CX,y1             {CX = pocet cyklu}
jz @konec

 @cyklus:
 add DI,incr          {DI = ofset dalsiho pixelu}

 jnc @PoradVJedneBance
  inc curbank
  mov AX,curbank
  mul granularity
  mov DX,AX
  mov AX,$4F05
  mov BX,_zapisovaciokno
  call __switchbank
  mov AL,barva        {do AL vratime barvu}
 @PoradVJedneBance:   {spravna banka je nastavena}

 mov ES:[DI],AL       {pixel je nakreslen}
 loop @cyklus

@konec:
End;{_vline}

procedure _XorVLine(x,y1,y2:word;barva:byte); assembler;
var incr:word;
Asm
{$ifdef blbuvzdornost}  {jestli y1>y2, prohodime je}
mov AX,y1
cmp AX,y2
js @OK
 mov AX,y1
 mov BX,y2
 mov y1,BX
 mov y2,AX
@OK:
{$endif}

mov AX,__lhy         {pro virtualni obrazovku}
add y1,AX
add y2,AX

mov AX,_zapisovacisegment
mov ES,AX           {ES = $A000}

mov AX,_MaxX
inc AX
mov incr,AX         {AX = incr = sirka obrazovky}

mul y1
add AX,x
adc DX,0            {DX = pocatecni banka}
mov DI,AX           {DI = pocatecni ofset}

cmp DX,CurBank
je @neprepinej
 mov AX,DX
 mov curbank,DX
 mul granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank
@neprepinej:          {pocatecni banka nastavena}

mov AL,barva
xor byte ptr ES:[DI],AL        {prvni pixel je nakreslen}

mov CX,y2
sub CX,y1             {CX = pocet cyklu}
jz @konec

 @cyklus:
 add DI,incr          {DI = ofset dalsiho pixelu}

 jnc @PoradVJedneBance
  inc curbank
  mov AX,curbank
  mul granularity
  mov DX,AX
  mov AX,$4F05
  mov BX,_zapisovaciokno
  call __switchbank
  mov AL,barva        {do AL vratime barvu}
 @PoradVJedneBance:   {spravna banka je nastavena}

 xor byte ptr ES:[DI],AL       {pixel je nakreslen}
 loop @cyklus

@konec:
End;{_xorvline}

procedure _XorHLine(x1,x2,y:word;barva:word); assembler;
var count:word;
Asm
{$ifdef blbuvzdornost}  {jestli x1>x2, prohodime je}
mov AX,x1
cmp AX,x2
js @OK
 mov AX,x1
 mov BX,x2
 mov x1,BX
 mov x2,AX
@OK:
{$endif}
mov AX,__lhy
add y,AX
mov AX,barva
mov AH,AL
mov barva,AX
mov AX,_zapisovacisegment
mov ES,AX
mov AX,x2
sub AX,x1
inc AX
mov count,AX
mov AX,_MaxX
inc AX
mul y
add AX,x1
adc DX,0
mov DI,AX
cmp DX,CurBank
je @neprepinej
 mov curbank,DX
 mov AX,DX
 mul Granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank
 mov AX,DI
@neprepinej:
mov BX,count
dec BX
add AX,BX
jnc @najednou
 or CX,$FFFF
 sub CX,DI
 inc CX
 mov AX,count
 sub AX,CX
 mov count,AX
 mov AX,barva
 db $66; shl AX,16
 mov AX,barva
 mov BX,CX
 shr CX,2
 jz @nic1  {aby se nekreslilo nic, pokud CX=0 (o to se normalne stara Rep)}
  @smycka1:
  db $66; xor ES:[DI],AX {xorovani po dwordech}
  add DI,4
  loop @smycka1
 @nic1:
 and BX,3
 mov CX,BX
 or CX,CX
 jz @nic2
  @smycka2:
  xor byte ptr ES:[DI],AL  {prexorovani zbylych max. 3 bytu}
  inc DI
  loop @smycka2
 @nic2:
 inc curbank
 mov AX,curbank
 mul granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank
@najednou:
mov CX,count
mov AX,barva
db $66; shl AX,16
mov AX,barva
mov BX,CX
shr CX,2
jz @nic3
 @smycka3:
 db $66; xor ES:[DI],AX
 add DI,4
 loop @smycka3
@nic3:
and BX,3
mov CX,BX
or CX,CX
jz @nic4
 @smycka4:
 xor byte ptr ES:[DI],AL
 inc DI
 loop @smycka4
@nic4:
End;{_xorhline}

procedure _line(x1,y1,x2,y2:word; barva:byte);
var dx,dy,krokx,kroky:integer;
    pom:word;
Begin
{Bresenhamuv algoritmus obecne cary:
K pomocne promenne pricitame hodnotu mensiho z rozdilu souradnic (dx nebo dy)
a ridici promennou pri tom menime o 1. Jakmile pomocna promenna dosahne nebo
presahne hodnotu vetsiho z rozdilu souradnic, ten vetsi rozdil od ni odecteme
a zmenime o 1 i druhou souradnici.
Na zacatku musi mit pomocna promenna hodnotu rovnou polovine toho vetsiho
rozdilu souradnic, jinak by cara byla nesymetricka.}
{Pokud vychazi cara vodorovna nebo svisla, pouzijeme z duvodu rychlosti radsi
procedury pro vodorovnou nebo svislou caru, i kdyz Bresenhamuv algoritmus by
fungoval i v techto pripadech (krok druhe souradnice by byl 0):}
if x1=x2 then begin
              if y2>y1 then _vline(x1,y1,y2,barva)
                       else _vline(x1,y2,y1,barva);
              exit;
              end;
if y1=y2 then begin
              if x2>x1 then _hline(x1,x2,y1,barva)
                       else _hline(x2,x1,y1,barva);
              exit;
              end;
{vypocet rozdilu souradnic a kroku:}
if x2>x1 then begin dx:=x2-x1; krokx:=1; end
         else begin dx:=x1-x2; krokx:=-1; end;
if y2>y1 then begin dy:=y2-y1; kroky:=1; end
         else begin dy:=y1-y2; kroky:=-1; end;
{Zadny rozdil souradnic urcite neni 0, protoze to by odchytily predchozi dve
podminky a procedura by uz touhle dobou davno skoncila. Takze se ted o takovy
pripad nemusime starat.}
_putpixel(x1,y1,barva); {prvni bod cary}
if dx>=dy then begin {cara je spis vodorovnejsi, x je ridici promenna}
               pom:=dx shr 1; {pocatecni hodnota pomocne promenne}
                repeat
                inc(x1,krokx); {zmenime x o 1}
                inc(pom,dy); {pricteme k pomocne dy (mensi rozdil)}
                if pom>=dx then begin {kdyz je vesti nez dx (ten vetsi rozdil)...}
                                dec(pom,dx); {...vetsi rozdil odecteme...}
                                inc(y1,kroky); {...a zmenime y o 1}
                                end;
                _putpixel(x1,y1,barva); {nakreslime bod}
                until x1=x2; {dokud nejsme na koncovem bodu}
               end
          else begin {cara je spis svislejsi, ridici je y}
               pom:=dy shr 1;
                repeat         {postup stejny, jen jsou prehozene souradnice}
                inc(y1,kroky);
                inc(pom,dx);
                if pom>=dy then begin
                                dec(pom,dy);
                                inc(x1,krokx);
                                end;
                _putpixel(x1,y1,barva);
                until y1=y2;
               end;
End;{_line}

procedure _XorLine(x1,y1,x2,y2:word;barva:byte);
var dx,dy,krokx,kroky:integer;
    pom:word;
Begin
if x1=x2 then begin
              if y2>y1 then _xorvline(x1,y1,y2,barva)
                       else _xorvline(x1,y2,y1,barva);
              Exit;
              end;
if y1=y2 then begin
              if x2>x1 then _xorhline(x1,x2,y1,barva)
                       else _xorhline(x2,x1,y1,barva);
              Exit;
              end;
if x2>x1 then begin dx:=x2-x1; krokx:=1; end
         else begin dx:=x1-x2; krokx:=-1; end;
if y2>y1 then begin dy:=y2-y1; kroky:=1; end
         else begin dy:=y1-y2; kroky:=-1; end;
_xorpixel(x1,y1,barva);
if dx>=dy then begin
               pom:=dx shr 1;
                repeat
                inc(x1,krokx);
                inc(pom,dy);
                if pom>=dx then begin
                                dec(pom,dx);
                                inc(y1,kroky);
                                end;
                _xorpixel(x1,y1,barva);
                until x1=x2;
               end
          else begin
               pom:=dy shr 1;
                repeat
                inc(y1,kroky);
                inc(pom,dx);
                if pom>=dy then begin
                                dec(pom,dy);
                                inc(x1,krokx);
                                end;
                _xorpixel(x1,y1,barva);
                until y1=y2;
               end;
End;{_xorline}

procedure _MaskedLine(x1,y1,x2,y2:integer; barva:byte; maska:word);
var dx,dy,krokX,krokY:integer;
    pom:word;
Begin
{Tady uz se neda pouzit rychla vodorovna cara, takze pro vsechny pripady
pouzijeme obecny Bresenhamuv algoritmus.}
dx:=abs(x2-x1); dy:=abs(y2-y1);
if x2<x1 then krokx:=-1
         else if x2>x1 then krokx:=1
                       else krokx:=0;
if y2<y1 then kroky:=-1
         else if y2>y1 then kroky:=1
                       else kroky:=0;
{prvni bod cary:}
asm
rol maska,1 {rotujeme masku o jeden bit doleva}
jnc @dira1  {kdyz nenastalo preteceni, odrotovali jsme nulu, takze se nic nekresli}
 push x1              {ulozime prvni parametr pro _putpixel - x}
 push y1              {druhy parametr - y}
 push word ptr barva  {treti parametr - barva (na zasobnik jdou ukladat jen wordy, tak se musi pretypovat)}
 call _putpixel       {zavolane _putpixel}
@dira1:
end;
if dx>=dy then begin
               pom:=dx shr 1;
                repeat
                inc(x1,krokx);
                inc(pom,dy);
                if pom>=dx then begin
                                dec(pom,dx);
                                inc(y1,kroky);
                                end;
                asm
                rol maska,1
                jnc @dira2
                 push x1
                 push y1
                 push word ptr barva
                 call _putpixel
                @dira2:
                end;
                until x1=x2;
               end
          else begin
               pom:=dy shr 1;
                repeat
                inc(y1,kroky);
                inc(pom,dx);
                if pom>=dy then begin
                                dec(pom,dy);
                                inc(x1,krokx);
                                end;
                asm
                rol maska,1
                jnc @dira3
                 push x1
                 push y1
                 push word ptr barva
                 call _putpixel
                @dira3:
                end;
                until y1=y2;
               end;
End;{_maskedline}

procedure _xorMaskedLine(x1,y1,x2,y2:integer; barva:byte; maska:word);
var dx,dy,krokX,krokY:integer;
    pom:word;
Begin
dx:=abs(x2-x1);
dy:=abs(y2-y1);
if x2<x1 then krokx:=-1
         else if x2>x1 then krokx:=1
                       else krokx:=0;
if y2<y1 then kroky:=-1
         else if y2>y1 then kroky:=1
                       else kroky:=0;
asm
rol maska,1
jnc @dira1
 push x1
 push y1
 push word ptr barva
 call _xorpixel
@dira1:
end;
if dx>=dy then begin
               pom:=dx shr 1;
                repeat
                inc(x1,krokx);
                inc(pom,dy);
                if pom>=dx then begin
                                dec(pom,dx);
                                inc(y1,kroky);
                                end;
                asm
                rol maska,1
                jnc @dira2
                 push x1
                 push y1
                 push word ptr barva
                 call _xorpixel
                @dira2:
                end;
                until x1=x2;
               end
          else begin
               pom:=dy shr 1;
                repeat
                inc(y1,kroky);
                inc(pom,dx);
                if pom>=dy then begin
                                dec(pom,dy);
                                inc(x1,krokx);
                                end;
                asm
                rol maska,1
                jnc @dira3
                 push x1
                 push y1
                 push word ptr barva
                 call _xorpixel
                @dira3:
                end;
                until y1=y2;
               end;
End;{_xormaskedline}

procedure _Bar(x1,y1,x2,y2:word;barva:word);assembler;
var sirka,incr:word;
Asm
{$ifdef blbuvzdornost}
mov AX,x1
cmp AX,x2
js @xOK
 mov AX,x1
 mov BX,x2              {jestli x1>x2, prohodime je}
 mov x1,BX
 mov x2,AX
@xOK:
mov AX,y1
cmp AX,y2
js @yOK
 mov AX,y1
 mov BX,y2              {jestli y1>y2, prohodime je}
 mov y1,BX
 mov y2,AX
@yOK:
{$endif}
mov AX,__lhy
 mov BX,_zapisovacisegment
add y1,AX
 mov ES,BX        {ES = cilovy segment}
add y2,AX         {pro virtualni obrazovku}
 mov BX,barva
inc y2         {aby se to pak lip pocitalo}
 mov BH,BL
mov AX,_maxx
 mov barva,BX     {barva ma ted hodnotu v obou bytech}
sub AX,x2
 mov BX,x2 {*}
add AX,x1
 sub BX,x1
mov incr,AX      {incr = kolik se musi pridat k ofsetu na konci radku, abychom se dostali na zacatek dalsiho}
 inc BX
mov AX,_Maxx
 mov sirka,BX         {sirka spocitana}
inc AX
mul y1
add AX,x1
adc DX,0        {DX = banka}
mov DI,AX       {DI = ofset zacatku radku}

 @zacatek:         {zacatek cyklu}

 mov BX,DI
 mov CX,DX
 add BX,sirka
 adc CX,0
 dec BX
 sbb CX,0           {CX = banka bodu na konci radku}

 cmp DX,curbank
 je @neprepinej
  push DX
  call _SwitchBank
 @neprepinej:         {pocatecni banka nastavena}

 cmp CX,curbank       {je banka na konci radku stejna jako na zacatku?}
 je @najednou         {je -> vykresli se cely radek najednou}

  or CX,$FFFF
  sub CX,DI
  inc CX            {CX = sirka prvni casti}
  mov AX,sirka
  sub AX,CX
  push AX     {zasobnik = sirka druhe casti}

  mov AX,barva
  db $66; shl AX,16
  mov AX,barva           {EAX = barva}

   mov BX,CX
   shr CX,2
   db $66; rep stosw
   and BX,3
   mov CX,BX
   rep stosb

  mov AX,curbank
  inc AX
  push AX
  call _switchbank      {druha banka nastavena}

  pop CX
  jmp @jedeme

 @najednou:
 mov CX,sirka
 @jedeme:
                       {CX = sirka zbytku radku}
 mov AX,barva
 db $66; shl AX,16
 mov AX,barva           {EAX = barva}

  mov BX,CX
  shr CX,2
  db $66; rep stosw
  and BX,3
  mov CX,BX
  rep stosb

 mov DX,curbank
 add DI,incr       {DI = ofset zacatku dalsiho radku}
 adc DX,0          {DX = banka -''-}
 inc y1
 mov AX,y1
 cmp AX,y2
 jne @zacatek
End;{_bar}

procedure _MaskedBar(x1,y1,x2,y2,barva:word; var vzorek);
var i,sirka,sirka2:word;
    m:byte;
    pom:array[0..3] of word; {qword}
    poms,pomo:word;{segment a ofset pole pom}
Begin
{$ifdef blbuvzdornost}
asm
mov AX,x1
cmp AX,x2
js @xOK
 mov AX,x1
 mov BX,x2              {jestli x1>x2, prohodime je}
 mov x1,BX
 mov x2,AX
@xOK:
mov AX,y1
cmp AX,y2
js @yOK
 mov AX,y1
 mov BX,y2              {jestli y1>y2, prohodime je}
 mov y1,BX
 mov y2,AX
@yOK:
end;
{$endif}
poms:=seg(pom); pomo:=ofs(pom);{v asm mi to nejak neslo}
sirka:=x2-x1+1;
inc(y1,__lhy); inc(y2,__lhy);
for i:=y1 to y2 do
  begin
  m:=_pole8bytu(vzorek)[i and 7];
  asm{vykresleni radku}
  mov CX,x1
  and CX,7
  rol m,CL      {upraveni masky podle souradnic - aby navazovala}

  mov AX,poms
  mov DI,pomo   {ES:DI = adresa pom}
  mov ES,AX

  mov CX,8
  mov AX,barva  {AL = barva popredi, AH = barva pozadi}
   @PripravaDat:
   rol m,1
   jc @BarvaPopredi
    mov ES:[DI],AH         {pixel v barve pozadi}
    jmp @KonecVyberuBarvy
   @BarvaPopredi:
    mov ES:[DI],AL         {pixel v barve popredi}
   @KonecVyberuBarvy:
   inc DI
   loop @PripravaDat
                          {ted je v Pom jeden radek masky, co byte, to pixel}
  mov BX,_zapisovacisegment
  mov ES,BX       {ES = cilovy segment}

  mov AX,_Maxx
  inc AX
  mul i
  add AX,x1
  adc DX,0     {DX = banka zacatku radku}
  mov DI,AX    {DI = ofset zacatku radku}

  mov BX,DI
  mov CX,DX
  add BX,sirka
  adc CX,0
  dec BX         {BX = ofset bodu na konci radku}
  sbb CX,0       {CX = banka toho bodu}

  {ted je v DI ofset zacatku radku, v DX jeho banka a v BX a CX to same pro konec radku
  (ten ofset v BX nepotrebuju a stejne ho _Switchbank prepise)}

  cmp DX,curbank  {prepnuti do banky pro zacatek radku}
  je @neprepinej
   push DX
   call _SwitchBank
  @neprepinej:

  cmp CX,curbank {je banka na konci radku stejna jako na zacatku?}
  je @najednou  {je => hop dal ***}
   {neni => nakresli se prvni cast radku v prvni bance, pak se prepne o banku dal a nakresli se zbytek:}

   or CX,$FFFF  {= mov CX,$FFFF, ale trochu rychlejsi}
   sub CX,DI
   inc CX        {CX = pocet pixelu v prvni bance}

   mov AX,sirka
   sub AX,CX
   mov sirka2,AX   {sirka2 = pocet pixelu ve druhe bance}

   {kresleni po qwordech (8 bytu najednou):}
   mov BX,CX
   shr CX,3
   jz @nic1
    @PoQwordech1:
    fild qword ptr pom           {kopiruj pole na zasobnik koprocesoru}
    fistp qword ptr ES:[DI]      {presun pole ze zasobniku na obrazovku}
    add DI,8
    loop @PoQwordech1
   @nic1:
   {zbytek po bytech:}
   mov DX,DS
   mov AX,barva
   mov CX,BX
   and CX,7
   push CX  {schovat na potom}
   mov AX,poms
   mov DS,AX
   mov SI,pomo
    rep movsb
   mov DS,DX
   {v posledni iteraci DI preteklo a je v nem 0, coz presne chceme}

   inc curbank
   push curbank
   call _switchbank     {prepnuti o banku dal (DI je 0, takze budeme kreslit na zacatek dalsi banky)}

   {odrotovani masky, aby druha cast radku navazovala na prvni:}
   pop CX
   or CL,CL
   jz @NetrebaRotovati
    rol m,CL
    mov AX,poms
    mov ES,AX
    mov BX,pomo   {ES:BX = adresa pom}
    mov AX,barva
    mov CX,8
     @PripravaDat2:
     rol m,1
     jc @BarvaPopredi2
      mov ES:[BX],AH         {pixel v barve pozadi}
      jmp @KonecVyberuBarvy2
     @BarvaPopredi2:
      mov ES:[BX],AL         {pixel v barve popredi}
     @KonecVyberuBarvy2:
     inc BX
     loop @PripravaDat2
    mov AX,$A000
    mov ES,AX
   @NetrebaRotovati:

   mov CX,sirka2  {CX = pocet pixelu ve druhe bance}
   jmp @jedeme

  @najednou:
  mov CX,sirka  {CX = pocet pixelu}

  @jedeme:

  {kresleni:}
  mov BX,CX
  shr CX,3
  jz @nic2
   @PoQwordech2:
   fild qword ptr pom
   fistp qword ptr ES:[DI]
   add DI,8
   loop @PoQwordech2
  @nic2:
  mov DX,DS
  mov AX,barva
  mov CX,BX
  and CX,7
  mov AX,poms
  mov DS,AX
  mov SI,pomo
   rep movsb
  mov DS,DX
  {radek je vykreslen}
  end;
  end;
End;{_maskedbar}

procedure _Rectangle(x1,y1,x2,y2:word;barva:byte);
Begin
_hline(x1,x2,y1,barva);
_vline(x1,y1,y2,barva);
_vline(x2,y1,y2,barva);
_hline(x1,x2,y2,barva);
End;{_rectangle}

procedure _XorRectangle(x1,y1,x2,y2:word;barva:byte);
Begin
_xorhline(x1,x2,y1,barva);
_xorvline(x1,y1,y2,barva);
_xorvline(x2,y1,y2,barva);
_xorhline(x1,x2,y2,barva);
End;{_xorrectangle}

procedure _XorBar(x1,y1,x2,y2:word; barva:byte);
var i:word;
Begin
for i:=y1 to y2 do _xorhline(x1,x2,i,barva);
End;{_xorbar}

procedure _Box(x1,y1,x2,y2:word;lhbarva,pdbarva,vbarva:word);
Begin
{$ifdef blbuvzdornost}
asm
mov AX,x1
cmp AX,x2
js @xOK
 mov AX,x1
 mov BX,x2
 mov x1,BX
 mov x2,AX
@xOK:
mov AX,y1
cmp AX,y2
js @yOK
 mov AX,y1
 mov BX,y2
 mov y1,BX
 mov y2,AX
@yOK:
end;
{$endif}
_hline(x1,x2,y1,lhbarva);
_vline(x1,y1,y2,lhbarva);
_vline(x2,y1,y2,pdbarva);
_hline(x1,x2,y2,pdbarva);
if (vbarva<>0)and(x2-x1>=2)and(y2-y1>=2) then _bar(x1+1,y1+1,x2-1,y2-1,vbarva);
End;{_box}

procedure _MaskedBox(x1,y1,x2,y2:word;lhbarva,pdbarva,vbarva:word;var vzorek:_pole8bytu);
Begin
{$ifdef blbuvzdornost}
asm
mov AX,x1
cmp AX,x2
js @xOK
 mov AX,x1
 mov BX,x2
 mov x1,BX
 mov x2,AX
@xOK:
mov AX,y1
cmp AX,y2
js @yOK
 mov AX,y1
 mov BX,y2
 mov y1,BX
 mov y2,AX
@yOK:
end;
{$endif}
_hline(x1,x2,y1,lhbarva);
_vline(x1,y1,y2,lhbarva);
_vline(x2,y1,y2,pdbarva);
_hline(x1,x2,y2,pdbarva);
if (vbarva<>0)and(x2-x1>=2)and(y2-y1>=2) then _maskedbar(x1+1,y1+1,x2-1,y2-1,vbarva,vzorek);
End;{_MaskedBox}

procedure _Fill(barva:word);assembler;
var nbanks,bank,rest:word;
Asm
mov AX,barva
mov AH,AL
mov barva,AX   {barva je rozkopirovana na cely word}
mov BX,_MaxX
inc BX
mov AX,_MaxY
inc AX
mul BX           {sirka * vyska obrazovky}
mov nbanks,DX    {pretekla cast = pocet bank}
mov rest,AX      {co nepreteklo, to je pocet pixelu v posledni bance}
mov AX,_zapisovacisegment
mov ES,AX        {ES = segment obrazovky}
xor AX,AX
mov bank,AX      {zacneme na bance 0}
 @@1:
 push bank
 call _SwitchBank    {banka nastavena}
 xor DI,DI           {DI na zacatek banky}
 mov CX,$4000        {banka ma 64 kB ($10000 B), tohle je $10000/4}
 mov AX,barva
 mov BX,AX
 db $66; shl AX,16   {shl EAX,16}
 mov AX,BX           {EAX = barva v kazdem bytu}
 db $66; rep stosw   {rep stosd (kopirovani po 4 bytech)}
 inc bank            {dalsi banka}
 mov AX,bank
 dec AX
 cmp AX,nbanks
 jne @@1       {kdyz jeste nejsme u te posledni, ktera neni na obrazovce cela, hop zpet}
push bank
call _SwitchBank
xor DI,DI
mov CX,rest     {pocet pixelu v posledni bance}
inc CX
mov AX,barva
mov BX,AX
db $66; shl AX,16     {EAX = barva}
mov AX,BX
mov BX,CX
shr CX,2
db $66; rep stosw     {rep stosd dokud to jde}
and BX,3
mov CX,BX
rep stosb             {rep stosb pro posledni max. 3 byty}
End;{_fill}

procedure _Fill2(barva:word);
Begin
_bar(0,0,_maxx,_maxy,barva);
End;{_fill2}

procedure _Ellipse(stredX,stredY,rx,ry:word;barva:byte);
var x,y:word;
    a,b,as,tas,bs,tbs:longint;
    d,dx,dy:longint;
Begin
if rx=0 then begin
             _VLine(stredx,stredy-ry,stredy+ry,barva);
             Exit;
             end;
if ry=0 then begin
             _HLine(stredx-rx,stredx+rx,stredy,barva);
             Exit;
             end;
x:=0; y:=ry; a:=rx; b:=ry; as:=a*a;
tas:=as shl 1; bs:=b*b; tbs:=bs shl 1;
d:=bs-as*b+(as shr 2); dx:=0; dy:=tas*b;
while dx<dy do begin
               _PutPixel(stredx+x,stredy+y,barva);
               _PutPixel(stredx-x,stredy+y,barva);
               _PutPixel(stredx+x,stredy-y,barva);
               _PutPixel(stredx-x,stredy-y,barva);
               if d>0 then begin y:=y-1; dy:=dy-tas; d:=d-dy; end;
               Inc(x); dx:=dx+tbs; d:=d+bs+dx;
               end;
d:=d+((3*(as-bs)div 2-(dx+dy))div 2);
while y>0 do begin
             _PutPixel(stredx+x,stredy+y,barva);
             _PutPixel(stredx-x,stredy+y,barva);
             _PutPixel(stredx+x,stredy-y,barva);
             _PutPixel(stredx-x,stredy-y,barva);
             if d<0 then begin Inc(x); dx:=dx+tbs; d:=d+dx; end;
             y:=y-1; dy:=dy-tas; d:=d+as-dy;
             end;
_PutPixel(stredx+x,stredy,barva);
_PutPixel(stredx-x,stredy,barva);
End;{_ellipse}

procedure _XorEllipse(stredX,stredY,rx,ry:word;barva:byte);
var x,y:word;
    a,b,as,tas,bs,tbs:longint;
    d,dx,dy:longint;
Begin
if rx=0 then begin
             _xorVLine(stredX,stredY-ry,stredY+ry,barva);
             Exit;
             end;
if ry=0 then begin
             _xorHLine(stredX-rx,stredX+rx,stredY,barva);
             Exit;
             end;
x:=0; y:=ry; a:=rx; b:=ry; as:=a*a;
tas:=as shl 1; bs:=b*b; tbs:=bs shl 1;
d:=bs-as*b+(as shr 2); dx:=0; dy:=tas*b;
while dx<dy do begin
               _xorPixel(stredX+x,stredY+y,barva);
               _xorPixel(stredX-x,stredY+y,barva);
               _xorPixel(stredX+x,stredY-y,barva);
               _xorPixel(stredX-x,stredY-y,barva);
               if d>0 then begin y:=y-1; dy:=dy-tas; d:=d-dy; end;
               Inc(x); dx:=dx+tbs; d:=d+bs+dx;
               end;
d:=d+((3*(as-bs)div 2-(dx+dy))div 2);
while y>0 do begin
             _xorPixel(stredX+x,stredY+y,barva);
             _xorPixel(stredX-x,stredY+y,barva);
             _xorPixel(stredX+x,stredY-y,barva);
             _xorPixel(stredX-x,stredY-y,barva);
             if d<0 then begin Inc(x); dx:=dx+tbs; d:=d+dx; end;
             y:=y-1; dy:=dy-tas; d:=d+as-dy;
             end;
_xorPixel(stredX+x,stredY,barva);
_xorPixel(stredX-x,stredY,barva);
End;{_xorellipse}

procedure _FilledEllipse(stredX,stredY,rx,ry:word;barva:byte);
var x,y:word;
    a,b,as,tas,bs,tbs:longint;
    d,dx,dy:longint;
Begin
if rx=0 then begin
             _VLine(stredX,stredY-ry,stredY+ry,barva);
             Exit;
             end;
if ry=0 then begin
             _HLine(stredX-rx,stredX+rx,stredY,barva);
             Exit;
             end;
x:=0; y:=ry; a:=rx; b:=ry; as:=a*a;
tas:=as shl 1; bs:=b*b; tbs:=bs shl 1;
d:=bs-as*b+(as shr 2); dx:=0; dy:=tas*b;
while dx<dy do begin
               _HLine(stredX-x,stredX+x,stredY+y,barva);
               _HLine(stredX-x,stredX+x,stredY-y,barva);
               if d>0 then begin y:=y-1; dy:=dy-tas; d:=d-dy; end;
               Inc(x); dx:=dx+tbs; d:=d+bs+dx;
               end;
d:=d+((3*(as-bs)div 2-(dx+dy))div 2);
while y>0 do begin
             _HLine(stredX-x,stredX+x,stredY+y,barva);
             _HLine(stredX-x,stredX+x,stredY-y,barva);
             if d<0 then begin Inc(x); dx:=dx+tbs; d:=d+dx; end;
             y:=y-1; dy:=dy-tas; d:=d+as-dy;
             end;
_HLine(stredX-x,stredX+x,stredY,barva);
End;{_filledellipse}

procedure _Triangle(x1,y1,x2,y2,x3,y3:word;barva:byte);
Begin
_Line(x1,y1,x2,y2,barva);
_Line(x2,y2,x3,y3,barva);
_Line(x3,y3,x1,y1,barva);
End;{_triangle}

procedure _xorTriangle(x1,y1,x2,y2,x3,y3:word;barva:byte);
Begin
_xorLine(x1,y1,x2,y2,barva);
_xorLine(x2,y2,x3,y3,barva);
_xorLine(x3,y3,x1,y1,barva);
End;{_xortriangle}

procedure xchange(var a,b:integer); assembler;
Asm
push DS
lds SI,a          {nacteni ukazatelu na promenne}
les DI,b
mov AX,DS:[SI]    {nacteni hodnot promennych}
mov BX,ES:[DI]
mov DS:[SI],BX    {ulozeni hodnot v obracenem poradi}
mov ES:[DI],AX
pop DS
End;{xchange}

procedure _FilledTriangle(x1,y1,x2,y2,x3,y3:integer;barva:byte);
var ymin,xmin,ymid,xmid,ymax,xmax,xmid2:longint;
    i:integer;
Begin
{srovnani vrcholu podle souradnice y:}
if y1>y2 then begin xchange(y1,y2); xchange(x1,x2); end;
if y1>y3 then begin xchange(y1,y3); xchange(x1,x3); end;
if y2>y3 then begin xchange(y2,y3); xchange(x2,x3); end;
ymin:=y1; xmin:=x1; ymid:=y2; xmid:=x2; ymax:=y3; xmax:=x3;
{kdyz jsou vsechny body stejne vysoko, je to vodorovna cara a ne trojuhelnik:}
if ymax=ymin then begin
                  {nalezeni xove souradnice nejvic vlevo a nejvic vpravo:}
                  if x1>x2 then xchange(x1,x2);
                  if x1>x3 then xchange(x1,x3);
                  if x2>x3 then xchange(x2,x3);
                  _hline(x1,x3,y1,barva);
                  exit;
                  end;
{vrcholy jsou primo pod sebou - je to svisla cara:}
if (x1=x2)and(x2=x3) then begin
                          _vline(x1,y1,y3,barva);
                          exit;
                          end;
xmid2:=(xmax-xmin)*(ymid-ymin)div(ymax-ymin)+xmin;
   {bod na care, ktera jde od nejhorejsiho vrcholu k nejdolejsimu, naproti prostrednimu vrcholu}
if xmid2<xmid then xchange(integer(xmid2),integer(xmid));
if ymin<>ymid then for i:=ymin to ymid do _HLine((xmid-xmin)*(i-ymin)div(ymid-ymin)+xmin,
                                                 (xmid2-xmin)*(i-ymin)div(ymid-ymin)+xmin,i,barva);
if ymid<>ymax then for i:=ymid to ymax do _HLine((xmax-xmid)*(i-ymid)div(ymax-ymid)+xmid,
                                                 (xmax-xmid2)*(i-ymid)div(ymax-ymid)+xmid2,i,barva);
End;{_filledtriangle}

procedure _FilledPolygon(var SeznamVrcholu; PocetVrcholu,barva:byte);
type TVertex = record
               x,y:integer;
               end;
     TVertexArray=array[1..256] of TVertex;
Begin
if pocetvrcholu=1 then _PutPixel(TVertexArray(seznamvrcholu)[1].x,TVertexArray(seznamvrcholu)[1].y,barva)
 else if pocetvrcholu=2 then _Line(TVertexArray(seznamvrcholu)[1].x,TVertexArray(seznamvrcholu)[1].y,
                                   TVertexArray(seznamvrcholu)[2].x,TVertexArray(seznamvrcholu)[2].y,barva)
  else repeat
       _FilledTriangle(TVertexArray(seznamvrcholu)[1].x,TVertexArray(seznamvrcholu)[1].y,
                       TVertexArray(seznamvrcholu)[pocetvrcholu-1].x,TVertexArray(seznamvrcholu)[pocetvrcholu-1].y,
                       TVertexArray(seznamvrcholu)[pocetvrcholu].x,TVertexArray(seznamvrcholu)[pocetvrcholu].y,
                       barva);
       Dec(pocetvrcholu);
       until pocetvrcholu=2;
End;{_filledpolygon}

(***************************************************************************
                      Kreslici procedury s orezavanim
****************************************************************************)

function ClipLine(var x1,y1,x2,y2:integer):boolean;
{Orizne souradnice cary podle okna. Vraci true, pokud z cary zbyl aspon
kousek, ktery by sel zobrazit.}
var otoceno:boolean;
Begin
otoceno:=false;
 repeat
 if (x1>=_minclipx)and(x1<=_maxclipx)and
    (x2>=_minclipx)and(x2<=_maxclipx)and
    (y1>=_minclipy)and(y1<=_maxclipy)and
    (y2>=_minclipy)and(y2<=_maxclipy) then begin {cara je urcite cela v okne => OK, muzeme kreslit}
                                           clipline:=true;
                                           break;
                                           end;
 if (x1<_minclipx)and(x2<_minclipx)or
    (x1>_maxclipx)and(x2>_maxclipx)or
    (y1<_minclipy)and(y2<_minclipy)or
    (y1>_maxclipy)and(y2>_maxclipy) then begin {cara je urcite cela mimo okno => OK, neni co kreslit}
                                         clipline:=false;
                                         break;
                                         end;
 {Existuji pripady, kdy predchozi podminka rekne, ze cara neni venku, ale
 pritom ve skutecnosti venku je. To ale nevadi - cara se trochu zkrati a v
 pristim cyklu uz bude jasne, ze je opravdu venku, a skonci se.}
 if x1<_minclipx then begin {1 vycuhuje vlevo}
                      y1:=y1+longint(y2-y1)*(_MinClipX-x1)div(x2-x1);
                      {deleni nulou se nemusime bat, protoze kdyby ted bylo
                      x2=x1, musela by byt obe x mimo okno, coz by ale
                      odchytila predchozi podminka a uz bychom tady nebyli}
                      x1:=_MinClipX;
                      end
   else if y1<_minclipy then begin {1 vycuhuje nahore}
                             x1:=x1+longint(x2-x1)*(_MinClipY-y1)div(y2-y1);
                             y1:=_MinClipY;
                             end
    else if x1>_maxclipx then begin {1 vycuhuje vpravo}
                              y1:=y1+longint(y2-y1)*(_MaxClipX-x1)div(x2-x1);
                              x1:=_MaxClipX;
                              end
     else if y1>_maxclipy then begin {1 vycuhuje dole}
                               x1:=x1+longint(x2-x1)*(_MaxClipY-y1)div(y2-y1);
                               y1:=_MaxClipY;
                               end
      else begin
           {Bod 1 nevycuhuje, takze vycuhuje jenom bod 2. Abychom nemuseli
           psat dalsi ctyri podminky pro bod 2, radsi oba body prohodime.}
           xchange(x1,x2); xchange(y1,y2);
           otoceno:=not otoceno;
           end;
 {Mohli bychom napsat ty ctyri podminky tak, ze by se v jednom cyklu provedlo
 veskere orezavani najednou? Ne. Vypada to sice, ze bychom tak usetrili par
 pruchodu cyklem, ale ve skutecnosti by to nefungovalo. Mohlo by se totiz
 stat, ze by se cara zkratila podle x a hned potom zase protahla podle y a
 vysla by nekonecna smycka. Proto je nutne, aby se po kazdem "rezu" zkontrolo-
 valo, jestli uz cara neni venku z okna.}
 until false; {konci se Breakem}
if otoceno then begin {u maskovane cary je potreba, aby se kreslila od spravneho konce, proto tohle}
                xchange(x1,x2);
                xchange(y1,y2);
                end;
End;{clipline}

procedure __Line(x1,y1,x2,y2:integer;barva:byte);
Begin
if ClipLine(x1,y1,x2,y2) then _Line(x1,y1,x2,y2,barva);
End;{__line}

procedure __xorLine(x1,y1,x2,y2:integer;barva:byte);
Begin
if ClipLine(x1,y1,x2,y2) then _xorLine(x1,y1,x2,y2,barva);
End;{__xorline}

procedure __MaskedLine(x1,y1,x2,y2:integer;barva:byte;Maska:word);
Begin
{zajisteni spravneho posunu masky:}
asm
mov CX,_minclipx
sub CX,x1
js @xNe         {kdyz x1 nevycuhuje, preskocime tohle}
 and CX,15      {posun bude o (_minclipx-x1) mod 16}
 rol maska,CL   {posuneme masku}
 jmp @konec     {a koncime, pripadne vycuhovani y1 nas nezajima}
@xNe:
mov CX,_minclipy       {to same pro y1}
sub CX,y1
js @konec
 and CX,15
 rol maska,CL
@konec:
end;
{Tohle resi jenom pripad, kdy zacatek cary vycuhuje skrz levy okraj a y1
zaroven neni nad hornim okrajem, nebo kdyz cara couha skrz horni okraj a x1
zaroven neni vlevo od leveho. Vycuhovani pravym a dolnim okrajem neni reseno
vubec, byly by to jen dalsi dve podminky.}
if ClipLine(x1,y1,x2,y2) then _MaskedLine(x1,y1,x2,y2,barva,maska);
End;{__maskedline}

procedure __xorMaskedLine(x1,y1,x2,y2:integer;barva:byte;Maska:word);
Begin
asm
mov CX,_minclipx
sub CX,x1
js @xNe
 and CX,15
 rol maska,CL
 jmp @konec
@xNe:
mov CX,_minclipy
sub CX,y1
js @konec
 and CX,15
 rol maska,CL
@konec:
end;
if ClipLine(x1,y1,x2,y2) then _xormaskedline(x1,y1,x2,y2,barva,maska);
End;{__xormaskedline}

procedure __HLine(x1,x2,y:integer;barva:byte);
Begin
if x1>x2 then asm  {kontrola poradi xovych souradnic}
              mov AX,x1
              mov BX,x2
              mov x1,BX
              mov x2,AX
              end;
if (y<_MinClipY)or(y>_MaxClipY)or(x1>_MaxClipX)or(x2<_MinClipX) then Exit;
if x1<_MinClipX then x1:=_MinClipX;
if x2>_MaxClipX then x2:=_MaxClipX;
_HLine(x1,x2,y,barva);
End;{__hline}

procedure __XorHLine(x1,x2,y:integer;barva:byte);
Begin
{$ifdef blbuvzdornost}
if x1>x2 then asm
              mov AX,x1
              mov BX,x2
              mov x1,BX
              mov x2,AX
              end;
{$endif}
if (y<_MinClipY)or(y>_MaxClipY)or(x1>_MaxClipX)or(x2<_MinClipX) then Exit;
if x1<_MinClipX then x1:=_MinClipX;
if x2>_MaxClipX then x2:=_MaxClipX;
_xorhline(x1,x2,y,barva);
End;{__xorhline}

procedure __VLine(x,y1,y2:integer;barva:byte);
Begin
{$ifdef blbuvzdornost}
if y1>y2 then asm
              mov AX,y1
              mov BX,y2
              mov y1,BX
              mov y2,AX
              end;
{$endif}
if (x<_MinClipX)or(x>_MaxClipX)or(y1>_MaxClipY)or(y2<_MinClipY) then Exit;
if y1<_MinClipY then y1:=_MinClipY;
if y2>_MaxClipY then y2:=_MaxClipY;
_VLine(x,y1,y2,barva);
End;{__vline}

procedure __XorVLine(x,y1,y2:integer;barva:byte);
Begin
{$ifdef blbuvzdornost}
if y1>y2 then asm
              mov AX,y1
              mov BX,y2
              mov y1,BX
              mov y2,AX
              end;
{$endif}
if (x<_MinClipX)or(x>_MaxClipX)or(y1>_MaxClipY)or(y2<_MinClipY) then Exit;
if y1<_MinClipY then y1:=_MinClipY;
if y2>_MaxClipY then y2:=_MaxClipY;
_xorvline(x,y1,y2,barva);
End;{__xorvline}

procedure __thickline(x1,y1,x2,y2,tloustka:integer; barva:byte);
var dx,dy,krokx,kroky,posun1,posun2:integer;
    pom:word;
Begin
posun1:=tloustka shr 1; {od (odecitat)}
posun2:=tloustka-posun1-1; {do (pricitat)}
if x1=x2 then begin {svisla}
              if y2>y1 then __bar(x1-posun1,y1,x1+posun2,y2,barva)
                       else __bar(x1-posun1,y2,x1+posun2,y1,barva);
              exit;
              end;
if y1=y2 then begin {vodorovna}
              if x2>x1 then __bar(x1,y1-posun1,x2,y2+posun2,barva)
                       else __bar(x2,y1-posun1,x1,y2+posun2,barva);
              exit;
              end;
if x2>x1 then begin dx:=x2-x1; krokx:=1; end
         else begin dx:=x1-x2; krokx:=-1; end;
if y2>y1 then begin dy:=y2-y1; kroky:=1; end
         else begin dy:=y1-y2; kroky:=-1; end;
if dx>=dy then begin {cara je spis vodorovnejsi, x je ridici promenna}
               __vline(x1,y1-posun1,y1+posun2,barva);
               pom:=dx shr 1;
                repeat
                inc(x1,krokx);
                inc(pom,dy);
                if pom>=dx then begin
                                dec(pom,dx);
                                inc(y1,kroky);
                                end;
                __vline(x1,y1-posun1,y1+posun2,barva);
                until x1=x2;
               end
          else begin {cara je spis svislejsi, ridici je y}
               __hline(x1-posun1,x1+posun2,y1,barva);
               pom:=dy shr 1;
                repeat
                inc(y1,kroky);
                inc(pom,dx);
                if pom>=dy then begin
                                dec(pom,dy);
                                inc(x1,krokx);
                                end;
                __hline(x1-posun1,x1+posun2,y1,barva);
                until y1=y2;
               end;
End;{__thickline}

procedure __xorthickline(x1,y1,x2,y2,tloustka:integer; barva:byte);
var dx,dy,krokx,kroky,posun1,posun2:integer;
    pom:word;
Begin
posun1:=tloustka shr 1;
posun2:=tloustka-posun1-1;
if x1=x2 then begin
              if y2>y1 then __xorbar(x1-posun1,y1,x1+posun2,y2,barva)
                       else __xorbar(x1-posun1,y2,x1+posun2,y1,barva);
              exit;
              end;
if y1=y2 then begin
              if x2>x1 then __xorbar(x1,y1-posun1,x2,y2+posun2,barva)
                       else __xorbar(x2,y1-posun1,x1,y2+posun2,barva);
              exit;
              end;
if x2>x1 then begin dx:=x2-x1; krokx:=1; end
         else begin dx:=x1-x2; krokx:=-1; end;
if y2>y1 then begin dy:=y2-y1; kroky:=1; end
         else begin dy:=y1-y2; kroky:=-1; end;
if dx>=dy then begin
               __xorvline(x1,y1-posun1,y1+posun2,barva);
               pom:=dx shr 1;
                repeat
                inc(x1,krokx);
                inc(pom,dy);
                if pom>=dx then begin
                                dec(pom,dx);
                                inc(y1,kroky);
                                end;
                __xorvline(x1,y1-posun1,y1+posun2,barva);
                until x1=x2;
               end
          else begin
               __xorhline(x1-posun1,x1+posun2,y1,barva);
               pom:=dy shr 1;
                repeat
                inc(y1,kroky);
                inc(pom,dx);
                if pom>=dy then begin
                                dec(pom,dy);
                                inc(x1,krokx);
                                end;
                __xorhline(x1-posun1,x1+posun2,y1,barva);
                until y1=y2;
               end;
End;{__xorthickline}

procedure __Bar(x1,y1,x2,y2:integer;vbarva:byte);
Begin
{$ifdef blbuvzdornost}
asm
mov AX,x1; cmp AX,x2
js @xOK
 mov AX,x1; mov BX,x2
 mov x1,BX; mov x2,AX
@xOK:
mov AX,y1; cmp AX,y2
js @yOK
 mov AX,y1; mov BX,y2
 mov y1,BX; mov y2,AX
@yOK:
end;
{$endif}
if (x1>_MaxClipX)or(y1>_MaxClipY)or(x2<_MinClipX)or(y2<_MinClipY) then Exit;
if x1<_MinClipX then x1:=_MinClipX;
if y1<_MinClipY then y1:=_MinClipY;
if x2>_MaxClipX then x2:=_MaxClipX;
if y2>_MaxClipY then y2:=_MaxClipY;
_Bar(x1,y1,x2,y2,vbarva);
End;{__bar}

procedure __MaskedBar(x1,y1,x2,y2:integer;barva:word;var vzorek:_pole8bytu);
Begin
{$ifdef blbuvzdornost}
asm
mov AX,x1; cmp AX,x2
js @xOK
 mov AX,x1; mov BX,x2
 mov x1,BX; mov x2,AX
@xOK:
mov AX,y1; cmp AX,y2
js @yOK
 mov AX,y1; mov BX,y2
 mov y1,BX; mov y2,AX
@yOK:
end;
{$endif}
if (x1>_MaxClipX)or(y1>_MaxClipY)or(x2<_MinClipX)or(y2<_MinClipY) then Exit;
if x1<_MinClipX then x1:=_MinClipX;
if y1<_MinClipY then y1:=_MinClipY;
if x2>_MaxClipX then x2:=_MaxClipX;
if y2>_MaxClipY then y2:=_MaxClipY;
_maskedBar(x1,y1,x2,y2,barva,vzorek);
End;{__maskedbar}

procedure __Rectangle(x1,y1,x2,y2:word;barva:byte);
Begin
__hline(x1,x2,y1,barva);
__vline(x1,y1,y2,barva);
__vline(x2,y1,y2,barva);
__hline(x1,x2,y2,barva);
End;{__rectangle}

procedure __XorRectangle(x1,y1,x2,y2:word;barva:byte);
Begin
asm
mov AX,x1; cmp AX,x2
js @xOK
 mov AX,x1; mov BX,x2
 mov x1,BX; mov x2,AX
@xOK:
mov AX,y1; cmp AX,y2
js @yOK
 mov AX,y1; mov BX,y2
 mov y1,BX; mov y2,AX
@yOK:
end;
__xorhline(x1,x2,y1,barva);
__xorvline(x1,y1,y2,barva);
__xorvline(x2,y1,y2,barva);
__xorhline(x1,x2,y2,barva);
End;{__xorrectangle}

procedure __XorBar(x1,y1,x2,y2:integer; barva:byte);
var i:integer;
Begin
for i:=y1 to y2 do __xorhline(x1,x2,i,barva);
End;{__xorbar}

procedure __Box(x1,y1,x2,y2:integer;lhbarva,pdbarva,vbarva:byte);
Begin
{$ifdef blbuvzdornost}
asm
mov AX,x1; cmp AX,x2
js @xOK
 mov AX,x1; mov BX,x2
 mov x1,BX; mov x2,AX
@xOK:
mov AX,y1; cmp AX,y2
js @yOK
 mov AX,y1; mov BX,y2
 mov y1,BX; mov y2,AX
@yOK:
end;
{$endif}
__HLine(x1,x2,y1,lhbarva);
__VLine(x1,y1,y2,lhbarva);
__VLine(x2,y1,y2,pdbarva);
__HLine(x1,x2,y2,pdbarva);
if vbarva<>0 then
  begin
  if (x1>=_MaxClipX)or(y1>=_MaxClipY)or(x2<=_MinClipX)or(y2<=_MinClipY) then Exit;
  if x1<_MinClipX-1 then x1:=_MinClipX-1;
  if y1<_MinClipY-1 then y1:=_MinClipY-1;
  if x2>_MaxClipX+1 then x2:=_MaxClipX+1;
  if y2>_MaxClipY+1 then Y2:=_MaxClipY+1;
  _Bar(x1+1,y1+1,x2-1,y2-1,vbarva);
  end;
End;{__box}

procedure __MaskedBox(x1,y1,x2,y2:word;lhbarva,pdbarva:byte;vbarva:word;var vzorek:_pole8bytu);
Begin
{$ifdef blbuvzdornost}
asm
mov AX,x1; cmp AX,x2
js @xOK
 mov AX,x1; mov BX,x2
 mov x1,BX; mov x2,AX
@xOK:
mov AX,y1; cmp AX,y2
js @yOK
 mov AX,y1; mov BX,y2
 mov y1,BX; mov y2,AX
@yOK:
end;
{$endif}
__hline(x1,x2,y1,lhbarva);
__vline(x1,y1,y2,lhbarva);
__vline(x2,y1,y2,pdbarva);
__hline(x1,x2,y2,pdbarva);
if (vbarva<>0)and(x2-x1>=2)and(y2-y1>=2) then __maskedbar(x1+1,y1+1,x2-1,y2-1,vbarva,vzorek);
End;{__MaskedBox}

procedure __Ellipse(stredX,stredY:integer;rx,ry:word;barva:byte);
var x,y:word;
    a,b,as,tas,bs,tbs:longint;
    d,dx,dy:longint;
Begin
if rx=0 then begin
             __VLine(stredX,stredY-ry,stredY+ry,barva);
             Exit;
             end;
if ry=0 then begin
             __HLine(stredX-rx,stredX+rx,stredY,barva);
             Exit;
             end;
x:=0; y:=ry; a:=rx; b:=ry; as:=a*a;
tas:=as shl 1; bs:=b*b; tbs:=bs shl 1;
d:=bs-as*b+(as shr 2); dx:=0; dy:=tas*b;
while dx<dy do begin
               __PutPixel(stredX+x,stredY+y,barva);
               __PutPixel(stredX-x,stredY+y,barva);
               __PutPixel(stredX+x,stredY-y,barva);
               __PutPixel(stredX-x,stredY-y,barva);
               if d>0 then begin y:=y-1; dy:=dy-tas; d:=d-dy; end;
               Inc(x); dx:=dx+tbs; d:=d+bs+dx;
               end;
d:=d+((3*(as-bs)div 2-(dx+dy))div 2);
while y>0 do begin
             __PutPixel(stredX+x,stredY+y,barva);
             __PutPixel(stredX-x,stredY+y,barva);
             __PutPixel(stredX+x,stredY-y,barva);
             __PutPixel(stredX-x,stredY-y,barva);
             if d<0 then begin Inc(x); dx:=dx+tbs; d:=d+dx; end;
             y:=y-1; dy:=dy-tas; d:=d+as-dy;
             end;
__PutPixel(stredX+x,stredY,barva);
__PutPixel(stredX-x,stredY,barva);
End;{__ellipse}

procedure __xorEllipse(stredX,stredY:integer;rx,ry:word;barva:byte);
var x,y:word;
    a,b,as,tas,bs,tbs:longint;
    d,dx,dy:longint;
Begin
if rx=0 then begin
             __xorVLine(stredX,stredY-ry,stredY+ry,barva);
             Exit;
             end;
if ry=0 then begin
             __xorHLine(stredX-rx,stredX+rx,stredY,barva);
             Exit;
             end;
x:=0; y:=ry; a:=rx; b:=ry; as:=a*a;
tas:=as shl 1; bs:=b*b; tbs:=bs shl 1;
d:=bs-as*b+(as shr 2); dx:=0; dy:=tas*b;
while dx<dy do begin
               __xorPixel(stredX+x,stredY+y,barva);
               __xorPixel(stredX-x,stredY+y,barva);
               __xorPixel(stredX+x,stredY-y,barva);
               __xorPixel(stredX-x,stredY-y,barva);
               if d>0 then begin y:=y-1; dy:=dy-tas; d:=d-dy; end;
               Inc(x); dx:=dx+tbs; d:=d+bs+dx;
               end;
d:=d+((3*(as-bs)div 2-(dx+dy))div 2);
while y>0 do begin
             __xorPixel(stredX+x,stredY+y,barva);
             __xorPixel(stredX-x,stredY+y,barva);
             __xorPixel(stredX+x,stredY-y,barva);
             __xorPixel(stredX-x,stredY-y,barva);
             if d<0 then begin Inc(x); dx:=dx+tbs; d:=d+dx; end;
             y:=y-1; dy:=dy-tas; d:=d+as-dy;
             end;
__xorPixel(stredX+x,stredY,barva);
__xorPixel(stredX-x,stredY,barva);
End;{__xorellipse}

procedure __FilledEllipse(stredX,stredY:integer;rx,ry:word;barva:byte);
var x,y:word;
    a,b,as,tas,bs,tbs:longint;
    d,dx,dy:longint;
Begin
 if rx=0 then begin
  __VLine(stredX,stredY-ry,stredY+ry,barva); Exit;
 end;
 if ry=0 then begin
  __HLine(stredX-rx,stredX+rx,stredY,barva); Exit;
 end;
 x:=0; y:=ry; a:=rx; b:=ry; as:=a*a;
 tas:=as shl 1; bs:=b*b; tbs:=bs shl 1;
 d:=bs-as*b+(as shr 2); dx:=0; dy:=tas*b;
 while dx<dy do begin
  __HLine(stredX-x,stredX+x,stredY+y,barva);
  __HLine(stredX-x,stredX+x,stredY-y,barva);
  if d>0 then begin y:=y-1; dy:=dy-tas; d:=d-dy; end;
  Inc(x); dx:=dx+tbs; d:=d+bs+dx;
 end;
 d:=d+((3*(as-bs)div 2-(dx+dy))div 2);
 while y>0 do begin
  __HLine(stredX-x,stredX+x,stredY+y,barva);
  __HLine(stredX-x,stredX+x,stredY-y,barva);
  if d<0 then begin Inc(x); dx:=dx+tbs; d:=d+dx; end;
  y:=y-1; dy:=dy-tas; d:=d+as-dy;
 end;
 __HLine(stredX-x,stredX+x,stredY,barva);
End;{__FilledEllipse}

procedure __Triangle(x1,y1,x2,y2,x3,y3:integer;barva:byte);
Begin
__Line(x1,y1,x2,y2,barva);
__Line(x2,y2,x3,y3,barva);
__Line(x3,y3,x1,y1,barva);
End;{__triangle}

procedure __xorTriangle(x1,y1,x2,y2,x3,y3:integer;barva:byte);
Begin
__xorLine(x1,y1,x2,y2,barva);
__xorLine(x2,y2,x3,y3,barva);
__xorLine(x3,y3,x1,y1,barva);
End;{__xortriangle}

procedure __FilledTriangle(x1,y1,x2,y2,x3,y3:integer;barva:byte);
var ymin,xmin,ymid,xmid,ymax,xmax,xmid2:longint;
    i:integer;
Begin
if y1>y2 then begin xchange(y1,y2); xchange(x1,x2); end;
if y1>y3 then begin xchange(y1,y3); xchange(x1,x3); end;
if y2>y3 then begin xchange(y2,y3); xchange(x2,x3); end;
ymin:=y1; xmin:=x1; ymid:=y2; xmid:=x2; ymax:=y3; xmax:=x3;
if ymax=ymin then begin
                  if x1>x2 then xchange(x1,x2);
                  if x1>x3 then xchange(x1,x3);
                  if x2>x3 then xchange(x2,x3);
                  __hline(x1,x3,y1,barva);
                  exit;
                  end;
if (x1=x2)and(x2=x3) then begin
                          _vline(x1,y1,y3,barva);
                          exit;
                          end;
xmid2:=(xmax-xmin)*(ymid-ymin) div (ymax-ymin)+xmin;
{if xmid2<xmid then xchange(integer(xmid2),integer(xmid)); tohle nestaci}
if ymin<>ymid then for i:=ymin to ymid do __HLine((xmid-xmin)*(i-ymin) div (ymid-ymin)+xmin,
                                                  (xmid2-xmin)*(i-ymin) div (ymid-ymin)+xmin,i,barva);
if ymid<>ymax then for i:=ymid to ymax do __HLine((xmax-xmid)*(i-ymid) div (ymax-ymid)+xmid,
                                                  (xmax-xmid2)*(i-ymid) div (ymax-ymid)+xmid2,i,barva);
End;{__filledtriangle}

procedure __FilledPolygon(var SeznamVrcholu; PocetVrcholu,barva:byte);
type TVertex=record
             x,y:integer;
             end;
     TVertexArray=array[1..256] of TVertex;
Begin
if pocetvrcholu=1 then __PutPixel(TVertexArray(seznamvrcholu)[1].x,TVertexArray(seznamvrcholu)[1].y,barva)
else if pocetvrcholu=2 then __Line(TVertexArray(seznamvrcholu)[1].x,TVertexArray(seznamvrcholu)[1].y,
                                    TVertexArray(seznamvrcholu)[2].x,TVertexArray(seznamvrcholu)[2].y,barva)
else
 repeat
 __FilledTriangle(TVertexArray(seznamvrcholu)[1].x,TVertexArray(seznamvrcholu)[1].y,
                  TVertexArray(seznamvrcholu)[pocetvrcholu-1].x,TVertexArray(seznamvrcholu)[pocetvrcholu-1].y,
                  TVertexArray(seznamvrcholu)[pocetvrcholu].x,TVertexArray(seznamvrcholu)[pocetvrcholu].y,barva);
 Dec(pocetvrcholu);
 until pocetvrcholu=2;
End;{__filledpolygon}

procedure __Fill(barva:word);
Begin
__bar(_minclipx,_minclipy,_maxclipx,_maxclipy,barva);
End;{__fill}

{pro Floodfilly:}

const MaxZ=8;{maximalni pocet zasobniku}
type polepixelu=array[0..0] of record x,y:word; end;
     uknapolepixelu=^polepixelu;
     tzasobniky=array[1..maxz] of record
                                  data:uknapolepixelu;
                                  velikost:word;{velikost zasobniku [B]}
                                  max:word;{maximalni pouzitelny index}
                                  vrchol:word;{index volne pozice na vrcholu zasobniku}
                                  end;
     uzasobniky=^tzasobniky;
var poslednizasobnik:byte;{cislo prave pouzivaneho zasobniku}
    zasobniky:uzasobniky;

function NovyZasobnik:boolean;{vytvori novy zasobnik a vraci true, jestli se to povedlo}
Begin
novyzasobnik:=false;
if poslednizasobnik<maxz then
 with zasobniky^[poslednizasobnik+1] do
   begin
   velikost:=65520;
   if velikost>maxavail then velikost:=maxavail;
   if velikost<16 then exit;{uz neni pamet}
   max:=(velikost shr 2)-1;{deleno velikosti jednoho prvku pole plus jeden prvek rezerva kvuli indexovani pole od nuly}
   vrchol:=0;
   getmem(data,velikost);
   inc(poslednizasobnik);
   novyzasobnik:=true;
   end;
End;{novyzasobnik}

procedure _Push(_x,_y:integer);
Begin
if ((poslednizasobnik=0)or(zasobniky^[poslednizasobnik].vrchol>zasobniky^[poslednizasobnik].max))
  and (not novyzasobnik) then exit;
with zasobniky^[poslednizasobnik] do begin
                                     data^[vrchol].x:=_x;
                                     data^[vrchol].y:=_y;
                                     inc(vrchol);
                                     end;
End;{_push}

procedure ZrusZasobnik;
Begin
if poslednizasobnik<>0 then
 begin
 with zasobniky^[poslednizasobnik] do freemem(data,velikost);
 dec(poslednizasobnik);
 end;
End;{zruszasobnik}

procedure _Pop(var _x,_y:integer);
Begin
if poslednizasobnik=0 then exit;
if zasobniky^[poslednizasobnik].vrchol=0 then zruszasobnik;
if poslednizasobnik=0 then exit;
with zasobniky^[poslednizasobnik] do begin
                                     dec(vrchol);
                                     _x:=data^[vrchol].x;
                                     _y:=data^[vrchol].y;
                                     end;
End;{_pop}

procedure __FloodFill1(ffx,ffy:integer; barva:byte);
var i,x,y,leva,prava:integer;
    pix:byte;{pro ulozeni barvy pocatecniho pixelu, pres kterou se nova barva rozlije}
Begin
if (ffx>_maxclipx)or(ffy>_maxclipy)or(ffx<_minclipx)or(ffy<_minclipy) then exit;{jsme mimo obrazovku}
pix:=_getpixel(ffx,ffy);
if pix=barva then exit;{neni co barvit}
new(zasobniky);
poslednizasobnik:=0;
_push(ffx,ffy); {ulozime pocatecni bod na zasobnik}
 repeat
 _pop(x,y);     {precteme souradnice ze zasobniku}
 if _getpixel(x,y)=pix then {jo, tady to potrebuje vybarvit}
   begin
   if (y>_minclipy)and(_getpixel(x,y-1)=pix) then _push(x,y-1);{ulozime bod nad nim...}
   if (y<_maxclipy)and(_getpixel(x,y+1)=pix) then _push(x,y+1);{...a bod pod nim}
   leva:=x; prava:=x; {tohle je nutne}
   i:=x;
   while (i<_maxclipx)and(_getpixel(i,y)=pix) do {podivame se od toho bodu doprava}
     begin
     prava:=i; {posuneme pravou souradnici}
     inc(i);   {o pixel doprava}
     if (y<_maxclipy)and(_getpixel(i-1,y+1)<>pix)and(_getpixel(i,y+1)=pix) then _push(i,y+1);
      {kdyz se o radek niz objevi prechod hranice -> volno, musime ten bod taky ulozit}
     if (y>_minclipy)and(_getpixel(i-1,y-1)<>pix)and(_getpixel(i,y-1)=pix) then _push(i,y-1);
      {to same i o radek vys}
     end;
   i:=x;
   while (i>_minclipx)and(_getpixel(i,y)=pix) do {podivame se obdobnym zpusobem nalevo}
     begin
     leva:=i;
     dec(i);
     if (y<_maxclipy)and(_getpixel(i+1,y+1)<>pix)and(_getpixel(i,y+1)=pix) then _push(i,y+1);
     if (y>_minclipy)and(_getpixel(i+1,y-1)<>pix)and(_getpixel(i,y-1)=pix) then _push(i,y-1);
     end;
   _hline(leva,prava,y,barva); {vybarvime radek}
   end;
 until poslednizasobnik=0; {dokud jsme ze zasobniku nevytahli posledni bod}
dispose(zasobniky);
End;{__floodfill1}

procedure __FloodFill2(ffx,ffy:integer; barva,hranice:byte);
var i,x,y,leva,prava:integer;
    okraj:set of byte;
Begin
if (ffx>_maxclipx)or(ffy>_maxclipy)or(ffx<_minclipx)or(ffy<_minclipy) then exit;{jsme mimo obrazovku}
okraj:=[barva,hranice]; {jedine dve barvy, o ktere se barva zarazi}
{dal je to prakticky stejne jako u prvni verze, jenom misto "=pix" je
"not in okraj" a misto "<>pix" je "in okraj"}
if _getpixel(ffx,ffy) in okraj then exit;{neni co barvit}
new(zasobniky);
poslednizasobnik:=0;
_push(ffx,ffy);
 repeat
 _pop(x,y);
 if not(_getpixel(x,y) in okraj) then
   begin
   if (y>_minclipy)and not(_getpixel(x,y-1) in okraj) then _push(x,y-1);
   if (y<_maxclipy)and not(_getpixel(x,y+1) in okraj) then _push(x,y+1);
   leva:=x; prava:=x;
   i:=x;
   while (i<_maxclipx)and not(_getpixel(i,y) in okraj) do
     begin
     prava:=i;
     inc(i);
     if (y<_maxclipy)and(_getpixel(i-1,y+1) in okraj)and not(_getpixel(i,y+1) in okraj) then _push(i,y+1);
     if (y>_minclipy)and(_getpixel(i-1,y-1) in okraj)and not(_getpixel(i,y-1) in okraj) then _push(i,y-1);
     end;
   i:=x;
   while (i>_minclipx)and not(_getpixel(i,y) in okraj) do
     begin
     leva:=i;
     dec(i);
     if (y<_maxclipy)and(_getpixel(i+1,y+1) in okraj)and not(_getpixel(i,y+1) in okraj) then _push(i,y+1);
     if (y>_minclipy)and(_getpixel(i+1,y-1) in okraj)and not(_getpixel(i,y-1) in okraj) then _push(i,y-1);
     end;
   _hline(leva,prava,y,barva);
   end;
 until poslednizasobnik=0;
dispose(zasobniky);
End;{__floodfill2}


(****************************************************************************
                                pro texty:
*****************************************************************************)

procedure _NastavFont(var fn:_font; NastavDoporucene:boolean);
Begin
__font:=fn.fdata;
__vyska:=fn.fvyska;
if NastavDoporucene then with fn do _nastavtext(fstdx,fstdy,fstdroztec);
End;{_nastavfont}

procedure _NastavText(velikostx,velikosty,roztec:byte);
Begin
if velikostx<>0 then __velikostx:=velikostx;
if velikosty<>0 then __velikosty:=velikosty;
if roztec<>0 then __roztec:=roztec;
End;{_nastavtext}

{pro _Pushtext a _Poptext:}
type _uknatxtsettings=^_txtsettings;
     _txtsettings=record
                  vyska:byte;
                  font:_uknafont;
                  velikostx,
                  velikosty,
                  roztec:byte;
                  dalsi:_uknatxtsettings;
                  end;
const _prvnits:_uknatxtsettings=nil;

procedure _pushtext;
var n:_uknatxtsettings;
Begin
if maxavail<16 then exit;
new(n);
with n^ do begin
           vyska:=__vyska;
           font:=__font;
           velikostx:=__velikostx;
           velikosty:=__velikosty;
           roztec:=__roztec;
           dalsi:=_prvnits;
           end;
_prvnits:=n;
End;{_pushtext}

procedure _poptext;
var v:_uknatxtsettings;
Begin
if _prvnits=nil then exit;
with _prvnits^ do begin
                  __vyska:=vyska;
                  __font:=font;
                  __velikostx:=velikostx;
                  __velikosty:=velikosty;
                  __roztec:=roztec;
                  end;
v:=_prvnits;
_prvnits:=_prvnits^.dalsi;
dispose(v);
End;{_poptext}

procedure _lodtext;
Begin
if _prvnits<>nil then
 with _prvnits^ do begin
                   __vyska:=vyska;
                   __font:=font;
                   __velikostx:=velikostx;
                   __velikosty:=velikosty;
                   __roztec:=roztec;
                   end;
End;{_lodtext}

procedure _NactiFont(var FN:_font; var Soubor:file);
var velikost:word;
    b:byte;
Begin
fn.fdata:=nil; {jestli se neco pokazi, tohle tady zustane}
blockread(soubor,fn.fvyska,1);
velikost:=256*fn.fvyska; {je 256 znaku a kazdy ma tolik bytu, jak je vysoky}
if (ioresult<>0)or(velikost>maxavail) then exit;
getmem(fn.fdata,velikost);
blockread(soubor,fn.fstdroztec,1);
blockread(soubor,b,1);
fn.fstdx:=b and 15;
fn.fstdy:=b shr 4;
blockread(soubor,fn.fdata^,velikost);
if ioresult<>0 then begin
                    freemem(fn.fdata,velikost);{kdyz se font nenacetl, tak nema cenu zbytecne zabirat pamet}
                    fn.fdata:=nil;
                    end;
End;{_nactifont}

procedure _NactiFont2(var FN:_font; JmenoSouboru:string);
var f:file;
Begin
assign(f,jmenosouboru);
reset(f,1);
_nactifont(fn,f);
close(f);
if ioresult<>0 then ;{reset Ioresultu pro pripad chyby pri Close (i to se muze stat)}
End;{_nactifont2}

function _UlozFont(var FN:_font;soubor:string):boolean;
var f:file;
    b:byte;
Begin
_ulozfont:=false;
assign(f,soubor);
rewrite(f,1);
if ioresult=0 then begin
                   blockwrite(f,fn.fvyska,1);
                   blockwrite(f,fn.fstdroztec,1);
                   b:=(fn.fstdy shl 4) or fn.fstdx;
                   blockwrite(f,b,1);
                   blockwrite(f,fn.fdata^,256*fn.fvyska);
                   close(f);
                   _ulozfont:=(ioresult=0);
                   end
              else _ulozfont:=false;
End;{_ulozfont}

procedure _ZrusFont(var fn:_font);
Begin
if fn.fdata<>nil then begin
                      freemem(fn.fdata,fn.fvyska*256);
                      fn.fdata:=nil; fn.fvyska:=0;{aby bylo jasne, ze uz tu nic neni}
                      end;
End;{_zrusfont}

const MaleKody:set of char=['b','z','x','y','r','h','v']; {6znakove}
      VelkeKody:set of char=['B','Y','R','H','V','0']; {3znakove}

procedure _print(ix,iy:integer;barva:byte;textik:string);
var PoziceVRetezci:word;{index pro pohyb mezi znaky retezce (word proto, aby nepretekl, kdyz bude retezec 255 znaku dlouhy)}
    CisloRadku,{index pro pohyb mezi radky pismena}
    IndexY,{index pro kresleni jednotlivych kopii jednoho radku pismena (pro _velikostY>1)}
    radek:byte;{data - jeden radek pismena}
    y:integer;{pro vypocet a ulozeni skutecne yove souradnice radku na obrazovce}
    i:integer;{ridici promenna do asm cyklu + pro ulozeni cisla z ridiciho kodu}
    kod:char;{hlavni pismeno ridiciho kodu}
    znak:word;{pomocna, pro zadavani znaku pres ordinalni cisla (%%z...)}
    JakToDopadlo:integer;{pro vyhodnoceni cisla z ridiciho kodu (Val)}
    pvx,pvy,pr,pbarva:byte; piy:integer; {pro ulozeni puvodnich hodnot}
Begin
if (textik='')or(__font=nil)or(ix+__velikostx shl 3>=_maxclipx)or(iy>_maxclipy) then exit;
if _ridicikody=_pouzivat then begin {ulozeni pocatecnich hodnot}
                              pvx:=__velikostx;
                              pvy:=__velikosty;
                              pr:=__roztec;
                              pbarva:=barva;
                              piy:=iy;
                              end;
PoziceVRetezci:=1;
 repeat {cyklus pro kazdy znak retezce}
 {osetreni ridicich kodu:}
 znak:=$FFFF;
 if (_ridicikody<>_vypisovat)and {jestli se ridici kody nemaji brat jako normalni text...}
    (textik[pozicevretezci]='%')and {...a nasli jsme znak '%'...}
    (pozicevretezci+2<=byte(textik[0]))and {...a jsou za nim jeste aspon 2 dalsi...}
    (textik[pozicevretezci+1]='%') {...a druhy je taky '%', tak jsme nejspis narazili na ridici kod a jdeme ho vyhodnotit.}
   then begin {zpracovani ridiciho kodu}
        kod:=textik[pozicevretezci+2];
        if kod in malekody {male pismeno -> sestipismenny kod}
          then begin
               if pozicevretezci+5<=byte(textik[0]) then {jestli retezec nekonci pred koncem kodu}
                 begin
                 val(copy(textik,pozicevretezci+3,3),i,jaktodopadlo);
                 if jaktodopadlo=0 then
                   begin
                   if _ridicikody=_pouzivat then
                     case kod of 'b':barva:=i;
                                 'x':inc(ix,i*_meritkokodu div 100);
                                 'y':inc(iy,i*_meritkokodu div 100);
                                 'r':__roztec:=i*_meritkokodu div 100;
                                 'h':__velikostx:=i*_meritkokodu div 100;
                                 'v':__velikosty:=i*_meritkokodu div 100;
                                 'z':znak:=i;
                                 end;
                   inc(pozicevretezci,5);
                   if kod<>'z' then begin
                                    inc(pozicevretezci);
                                    continue; {skok na Until}
                                    end;
                   end;
                 end;
               end
          else if kod in velkekody
                 then begin {velke pismeno nebo nepismeno -> tripismenny kod}
                      if _ridicikody=_pouzivat
                        then case kod of 'B':barva:=pbarva;
                                         'Y':iy:=piy;
                                         'R':__roztec:=pr;
                                         'H':__velikostx:=pvx;
                                         'V':__velikosty:=pvy;
                                         '0':begin
                                             barva:=pbarva;
                                             iy:=piy;
                                             __roztec:=pr;
                                             __velikostx:=pvx;
                                             __velikosty:=pvy;
                                             end;
                                         end;
                      inc(pozicevretezci,3);
                      continue;
                      end;
        end;{konec zpracovani kodu}
 if (ix>=_minclipx)and(ix+__velikostx shl 3-1<=_maxclipx)and  {znak je v xovem smeru cely na obrazovce...}
    (__velikostx<>0)and(__velikosty<>0) then {...a ma nenulovou velikost - muzeme pokracovat}
 {vykresleni znaku:}
 for CisloRadku:=0 to __vyska-1 do {pro kazdy radek znaku}
  begin
  if znak=$FFFF then radek:=__font^[__vyska*byte(textik[PoziceVRetezci])+cisloradku]{nalezeni prislusneho bytu ve fontu}
                else radek:=__font^[__vyska*znak+cisloradku];
  for indexY:=0 to __velikostY-1 do {pro kazdou kopii radku pismena zobrazenou na obrazovce}
   begin
   y:=iy+cisloradku*__velikostY+indexY; {skutecna poloha zacatku radku}
   if (y>=_minclipy)and(y<=_maxclipy)then {kdyz je radek na obrazovce}
    begin
    i:=8;       {sirka pismena (konst.)}
    {vykresleni radku:}
    if __velikostx<=3 then
    asm {kresli se pixel po pixelu}
    mov AX,__lhy
    add y,AX      {pro virtualni obrazovku}
    mov AX,_zapisovacisegment
    mov ES,AX      {ES = segment pro videopamet}

    xor CH,CH     {bude potreba jen CL}
    mov BX,_zapisovaciokno  {pro __switchbank}

    mov AX,_MaxX
    inc AX
    mul y
    add AX,ix
    adc DX,0       {DX = banka}
    mov DI,AX      {DI = ofset (oboje pro prvni pixel radku)}

    cmp DX,curbank
    je @neprepinej1
     mov curbank,DX                          {rozepsany _Switchbank}
     mov AX,DX
     mul granularity
     mov DX,AX
     mov AX,$4F05
     call __switchbank
    @neprepinej1:          {banka nastavena}

     @ProKazdyPixelRadku:     {cyklus for i:=8 downto 1}
     mov CL,__velikostX   {CX = pocet zobrazenych pixelu na jeden pixel bitmapy znaku}
     rol radek,1        {je ve zdrojovem znaku v prislusnem bitu 1?}
     jc @PixelBude
      {jinak vynechani pixelu:}
      add DI,CX        {posun o sirku pixelu dal}
      jnc @neprepinej2 {kdyz DI nepretece, banka se neprepina}
       inc curbank
       mov AX,curbank
       mul granularity
       mov DX,AX
       mov AX,$4F05
       call __switchbank
      @neprepinej2:          {banka nastavena}
      jmp @hotovo
     @PixelBude:
      {nakresleni pixelu:}
      mov AL,barva
       @ProKazdyPixelPixelu:   {cyklus for CX:=__velikostX downto 1}
       mov ES:[DI],AL       {vykresleni pixelu}
       inc DI               {o pixel na obrazovce dal}
       jnz @neprepinej3     {kdyz DI pretece (dalsi banka), bude ZF = 1, CF se nenastavi}
        inc curbank
        mov AX,curbank
        mul granularity
        mov DX,AX
        mov AX,$4F05
        call __switchbank
        mov AL,barva
       @neprepinej3:          {banka nastavena, jeji cislo je stale v DX}
       loop @ProKazdyPixelPixelu
     @hotovo:
     dec i
     jnz @ProKazdyPixelRadku
    end
    else
    asm {kresli se pomoci 32bitove _Hline, protoze je to tak rychlejsi}
    @proKazdyPixelRadku:
    rol radek,1
    jnc @dira
     mov AX,8
     sub AX,i
     mul __velikostx
     add AX,ix
     push AX   {x1}
     add AL,__velikostx
     adc AH,0
     dec AX
     push AX   {x2}
     push y    {y}
     push word ptr barva {barva}
     call _hline      {kresleni}
    @dira:
    dec i
    jnz @ProKazdyPixelRadku
    end;
    end;
   end;
  end;
 inc(ix,__roztec);
 inc(pozicevretezci);
 until (pozicevretezci>byte(textik[0]))or(ix>=_maxclipx-__velikostx shl 3);
if _ridicikody=_pouzivat then begin {obnoveni ulozenych hodnot}
                              __velikostx:=pvx;
                              __velikosty:=pvy;
                              __roztec:=pr;
                              end;
End;{_print}

function _SirkaTextu2(PocetZnaku:byte):word;
Begin
{moznost c. 1: kdyz je roztec vetsi nez sirka znaku, pocitat sirku bez
prazdneho mista za poslednim znakem:}
if pocetznaku=0 then _sirkatextu2:=0
                else if __roztec>8 then _sirkatextu2:=(pocetznaku-1)*__roztec+__velikostx shl 3
                                   else _sirkatextu2:=pocetznaku*__roztec;{pro uzke pismo}
{moznost c. 2: aby to vychazelo stejne jako pri pouziti _zmertext:}
{if pocetznaku=0 then _sirkatextu2:=0
                else _sirkatextu2:=(pocetznaku-1)*__roztec+__velikostx shl 3;}
{moznost c. 3: vykaslat se na slozitosti a pocitat sirku jenom z roztece:}
{_sirkatextu2:=pocetznaku*__roztec;}
End;{_sirkatextu2}

function _VyskaTextu2:word;
Begin
_vyskatextu2:=__velikosty*__vyska;{= velikost pixelu * vyska pisma v pixelech}
End;{_vyskatextu2}

procedure _ZmerText(retezec:string);
var Pozice:byte; {aktualni pozice v retezci}
    maxX,maxY,x,y,druha:integer; {ruzne souradnice, ktere budou pri vypoctu potreba}
    {pomyslne souradnice minX a minY se rovnaji promennym _Deltax a _Deltay}
    kod:char; {hlavni znak v ridicim kodu}
    JakToDopadlo,cislo:integer; {pro vyhodnocovani cisel z ridicich kodu}
    vx,vy:byte; r:word; {velikosti a roztec pisma - jen virtualni, na skutecne globalni hodnoty nesahame}
Begin
if retezec='' then begin {neni co merit}
                   _SirkaTextu:=0;
                   _VyskaTextu:=__vyska*__velikosty;
                   _DeltaX:=0;
                   _DeltaY:=0;
                   exit;
                   end;
if _ridicikody=_vypisovat then begin {ridici kody retezec neovlivni => neni treba ho prochazet}
                               _deltax:=0; _deltay:=0; {doleva ani nahoru urcite precuhovat nebude}
                               _sirkatextu:=_sirkatextu2(byte(retezec[0]));
                               _vyskatextu:=_vyskatextu2;
                               exit;
                               end;
pozice:=1;
_deltax:=0; maxx:=0;
_deltay:=0; maxy:=0;
x:=0;    y:=0;
vx:=__velikostx; vy:=__velikosty; r:=__roztec;
 repeat {prochazime retezec znak po znaku}
 {osetreni ridicich kodu - obdobne jako v procedure _Print:}
 if (retezec[pozice]='%')and(pozice+2<=byte(retezec[0]))and(retezec[pozice+1]='%')
   then begin
        kod:=retezec[pozice+2];
        if kod in malekody {6 znaku}
          then begin
               if pozice+5<=byte(retezec[0]) then
                 begin
                 val(copy(retezec,pozice+3,3),cislo,jaktodopadlo);
                 if jaktodopadlo=0 then
                   begin
                   if _ridicikody=_pouzivat then
                     case kod of 'x':inc(x,cislo*_meritkokodu div 100);
                                 'y':inc(y,cislo*_meritkokodu div 100);
                                 'r':r:=cislo*_meritkokodu div 100;
                                 'h':vx:=cislo*_meritkokodu div 100;
                                 'v':vy:=cislo*_meritkokodu div 100;
                                 {'b' nas nezajima, nema vliv na rozmery}
                                 end;
                   inc(pozice,5);
                   if kod<>'z' then begin
                                    inc(pozice);
                                    continue;
                                    end;
                   end;
                 end;
               end
          else if kod in velkekody
                 then begin {3 znaky}
                      if _ridicikody=_pouzivat
                        then case kod of 'Y':y:=0;
                                         'R':r:=__roztec;
                                         'H':vx:=__velikostx;
                                         'V':vy:=__velikosty;
                                         '0':begin
                                             y:=0;
                                             r:=__roztec;
                                             vx:=__velikostx;
                                             vy:=__velikosty;
                                             end;
                                         end;
                      inc(pozice,3);
                      continue;
                      end;
        end;{konec zpracovani kodu}
 {misto vykresleni znaku vypocet jeho rozmeru:}
 if x<_deltax then _deltax:=x; {levy okraj znaku}
 druha:=x+(vx shl 3)-1; {pravy okraj}
 if druha>maxx then maxx:=druha;
 if y<_deltay then _deltay:=y; {horni okraj}
 druha:=y+vy*__vyska-1; {spodni okraj}
 if druha>maxy then maxy:=druha;
 {presun na dalsi znak:}
 inc(x,r);
 inc(pozice);
 until pozice>byte(retezec[0]);
_sirkatextu:=maxx-_deltax+1;
_vyskatextu:=maxy-_deltay+1;
End;{_zmertext}

(***************************************************************************
                       Procedury pro praci s obrazky
****************************************************************************)

procedure _PutTImage(x1,y1:integer;sirka,vyska:word; obrazek:pointer);
var i,SourcSegment,SourcOfset:word;
    xshift,yshift,dssave,width2,incr:word;
Begin
if (x1>_maxclipx)or(y1>_maxclipy) then Exit;
xshift:=0; yshift:=0;
if x1<_minclipx then begin{vycuhuje levy okraj?}
                     if x1+sirka<=_minclipx then Exit;
                     xshift:=_minclipx-x1;
                     dec(sirka,_minclipx-x1);
                     x1:=_minclipx;
                     end;
if y1<_minclipy then begin{vycuhuje horni okraj?}
                     if y1+vyska<=_minclipy then Exit;
                     yshift:=_minclipy-y1;
                     dec(vyska,_minclipy-y1);
                     y1:=_minclipy;
                     end;
sourcsegment:=seg(obrazek^);
SourcOfset:=ofs(obrazek^)+yshift*(sirka+xshift)+xshift;
if (x1+sirka-1)>_MaxclipX then begin{vycuhuje pravy okraj?}
                               inc(xshift,x1+sirka-1-_MaxclipX);
                               sirka:=_MaxclipX-x1+1;
                               end;
if (y1+vyska-1)>_MaxclipY then vyska:=_MaxclipY-y1+1;{vycuhuje dolni okraj?}
incr:=_maxx-sirka+1;
i:=y1+__lhy;
inc(vyska,i);{Vyska uz neni vyska, ale yova souradnice posledniho radku +1}
{nahrazuje to cyklus for i:=y1 to y1+vyska-1 do...}
asm
mov AX,DS
mov dssave,AX   {ulozeni DS (myslim, ze to s pomocnou promennou bude trochu rychlejsi nez s push+pop)}

mov AX,_zapisovacisegment
mov ES,AX       {ES = cilovy segment}

mov AX,sourcofset
mov SI,AX       {SI = zdrojovy ofset (zacatek prvniho radku)}

mov AX,_Maxx
inc AX
mul i         {AX = ofset zacatku radku na obrazovce, DX = banka na tom zacatku}

add AX,x1    {AX = ofset bodu, kde bude zacinat radek obrazku}
adc DX,0     {DX = banka toho bodu}
mov DI,AX    {DI = cilovy ofset}

{ted je v DI ofset a v DX banka}

@zacatek: {zacatek cyklu, ktery probehne pro kazdy radek}

mov BX,DI
mov CX,DX
add BX,sirka
adc CX,0
dec BX         {BX = ofset bodu na konci radku, CX = banka toho bodu}

{ted je v DI ofset zacatku radku, v DX jeho banka a v BX a CX to same pro konec radku}

cmp DX,curbank  {prepnuti do banky pro zacatek radku}
je @neprepinej
 mov AX,DX
 mov curbank,AX
 mul granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank
@neprepinej:

cmp CX,curbank {je banka na konci radku stejna jako na zacatku?}
je @najednou  {je => hop dal ***}
 {neni => nakresli se prvni cast radku v prvni bance, pak se prepne o banku dal a nakresli se zbytek:}

 or CX,$FFFF  {= mov CX,$FFFF, ale trochu rychlejsi}
 sub CX,DI
 inc CX        {CX = pocet pixelu v prvni bance}

 mov AX,sirka
 sub AX,CX
 mov width2,AX   {width2 = pocet pixelu ve druhe bance}

 mov AX,sourcsegment
 mov DS,AX     {DS = zdrojovy segment}

  @PrvniPulkaRadku:
  lodsb            {zdroj -> AL}
  or AL,AL     {je AL 0 (pruhledna)?}
  jz @nic1
   mov ES:[DI],AL      {AL -> obrazovka}
  @nic1:
  inc DI        {v cili o pixel dal (i kdyz se nic nekreslilo)}
  loop @PrvniPulkaRadku
 {v posledni iteraci DI preteklo a je v nem 0, coz presne chceme}

 mov AX,dssave
 mov DS,AX  {obnoveni DS}

 mov AX,curbank
 inc AX                 {o banku dal}
 mov curbank,AX
 mul granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank

 mov CX,width2  {CX = pocet pixelu ve druhe bance}
 jmp @jedeme

@najednou:     {***}
mov CX,sirka  {CX = pocet pixelu}

@jedeme:

or CX,CX
jz @nic      {aby se cyklus neprovedl vubec, pokud je CX=0}

mov AX,sourcsegment
mov DS,AX     {DS = opet zdrojovy segment}

 @ZbytekRadku:
 lodsb            {zdroj -> AL}
 or AL,AL
 jz @nic2
  mov ES:[DI],AL      {AL -> obrazovka}
 @nic2:
 inc DI
 loop @ZbytekRadku

mov AX,dssave
mov DS,AX      {obnoveni DS}

@nic:

{radek je vykreslen}

add SI,xshift  {ve zdroji o radek dal}

mov DX,curbank
add DI,incr      {na obrazovce o radek dal}
adc DX,0

{ted je v DI ofset a v DX banka, presne tak, jak to je na zacatku cyklu potreba}

inc i
mov AX,i
cmp AX,vyska    {uz jsme nakreslili posledni radek?}
jne @zacatek  {ne => jdeme na dalsi}
end;
End;{_puttimage}

procedure _PutRTImage(x1,y1:integer;sirka,vyska:word; obrazek:pointer);
{trochu slozitejsi Puttimage - ze zdroje se musi cist obracene}
var i,SourcSegment,SourcOfset,xshift,yshift,dssave,width2,incr:word;
Begin
if (x1>_maxclipx)or(y1>_maxclipy) then Exit;
xshift:=0; yshift:=0;
if x1<_minclipx then begin{vycuhuje levy okraj?}
                     if x1+sirka<=_minclipx then Exit;
                     xshift:=_minclipx-x1;
                     dec(sirka,_minclipx-x1);
                     x1:=_minclipx;
                     end;
if y1<_minclipy then begin{vycuhuje horni okraj?}
                     if y1+vyska<=_minclipy then Exit;
                     yshift:=_minclipy-y1;
                     dec(vyska,_minclipy-y1);
                     y1:=_minclipy;
                     end;
sourcsegment:=seg(obrazek^);
SourcOfset:=ofs(obrazek^)+yshift*(sirka+xshift)-xshift;
if (x1+sirka-1)>_MaxclipX then begin{vycuhuje pravy okraj?}
                               inc(xshift,x1+sirka-1-_MaxclipX);
                               sirka:=_MaxclipX-x1+1;
                               end;
if (y1+vyska-1)>_MaxclipY then vyska:=_MaxclipY-y1+1;{vycuhuje dolni okraj?}
incr:=_maxx-sirka+1;
i:=y1+__lhy;
inc(vyska,i);{Vyska uz neni vyska, ale yova souradnice posledniho radku +1}
{nahrazuje to cyklus for i:=y1 to y1+vyska-1 do...}
asm
mov AX,DS
mov dssave,AX   {ulozeni DS}

mov AX,_zapisovacisegment
mov ES,AX       {ES = cilovy segment}

mov AX,sourcofset
add AX,sirka
mov SI,AX       {SI = zdrojovy ofset (bod za koncem prvniho radku)}

mov AX,_Maxx
inc AX
mul i         {AX = ofset zacatku radku obrazovky, DX = banka na tom zacatku}

add AX,x1    {AX = ofset bodu, kde bude zacinat radek obrazku}
adc DX,0     {DX = banka toho bodu}
mov DI,AX    {DI = cilovy ofset}

{ted je v DI ofset a v DX banka}

@zacatek: {zacatek cyklu, ktery probehne pro kazdy radek}

mov BX,DI
mov CX,DX
add BX,sirka
adc CX,0
dec BX         {BX = ofset bodu na konci radku, CX = banka toho bodu}

{ted je v DI ofset zacatku radku, v DX jeho banka a v BX a CX to same pro konec radku}

cmp DX,curbank  {prepnuti do banky pro zacatek radku}
je @neprepinej
 mov AX,DX
 mov CurBank,AX
 mul Granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank
@neprepinej:

cmp CX,curbank {je banka na konci radku stejna jako na zacatku?}
je @najednou  {je => hop dal ***}
 {neni => nakresli se prvni cast radku v prvni bance, pak se prepne o banku dal a nakresli se zbytek:}

 or CX,$FFFF  {mov CX,$FFFF}
 sub CX,DI
 inc CX        {CX = pocet pixelu v prvni bance}

 mov AX,sirka
 sub AX,CX
 mov width2,AX   {width2 = pocet pixelu ve druhe bance}

 mov AX,sourcsegment
 mov DS,AX     {DS = zdrojovy segment}

  @PrvniPulkaRadku:
  dec SI     {slo by to i pres std a cld, ale takhle mi to pripada jednodussi}
  mov AL,DS:[SI]     {zdroj -> AL}
  or AL,AL     {je AL 0 (pruhledna)?}
  jz @nic1
   mov ES:[DI],AL      {AL -> obrazovka}
  @nic1:
  inc DI        {v cili o pixel dal (i kdyz se nic nekreslilo)}
  loop @PrvniPulkaRadku
 {v posledni iteraci DI preteklo a je v nem 0, coz presne chceme}

 mov AX,dssave
 mov DS,AX  {obnoveni DS}

 mov AX,curbank
 inc AX                {prepnuti o banku dal (DI je 0, takze budeme kreslit na zacatek dalsi banky)}
 mov CurBank,AX
 mul Granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank

 mov CX,width2  {CX = pocet pixelu ve druhe bance}
 jmp @jedeme

@najednou:
mov CX,sirka  {CX = pocet pixelu}

@jedeme:

or CX,CX
jz @nic

mov AX,sourcsegment
mov DS,AX     {DS = opet zdrojovy segment}

 @ZbytekRadku:
 dec SI
 mov AL,DS:[SI]   {zdroj -> AL}
 or AL,AL
 jz @nic2
  mov ES:[DI],AL      {AL -> obrazovka}
 @nic2:
 inc DI
 loop @ZbytekRadku

{SI je ted na zacatku radku ve zdroji}

mov AX,dssave
mov DS,AX      {obnoveni DS}

@nic:
{radek je vykreslen}

add SI,xshift      {ve zdroji o radek dal}
add SI,sirka
add SI,sirka       {(ze zacatku jednoho radku za konec dalsiho radku)}

mov DX,curbank
add DI,incr         {na obrazovce o radek dal}
adc DX,0
{ted je v DI ofset a v DX banka, presne tak, jak to je na zacatku cyklu potreba}

inc i
mov AX,i
cmp AX,vyska    {uz jsme nakreslili posledni radek?}
jne @zacatek  {ne => jdeme na dalsi}
end;
End;{_putrtimage}

procedure _PutImage(x1,y1:integer;sirka,vyska:word;obrazek:pointer);
{Podobna Puttimage, lisi se jen kopirovacim cyklem: misto pixel po pixelu s
testovanim jeho hodnoty se kopiruje po qwordech, dwordech a bytech, aby to
bylo rychlejsi.}
var xshift,yshift,sourcsegment,sourcofset,incr,i,DSsave,width2:word;
Begin
if (x1>_maxclipx)or(y1>_maxclipy) then Exit;
xshift:=0; yshift:=0;
if x1<_minclipx then begin
                     if x1+sirka<=_minclipx then Exit;
                     xshift:=_minclipx-x1;
                     dec(sirka,_minclipx-x1);
                     x1:=_minclipx;
                     end;
if y1<_minclipy then begin
                     if y1+vyska<=_minclipy then Exit;
                     yshift:=_minclipy-y1;
                     dec(vyska,_minclipy-y1);
                     y1:=_minclipy;
                     end;
sourcsegment:=seg(obrazek^);
SourcOfset:=ofs(obrazek^)+yshift*(sirka+xshift)+xshift;
if (x1+sirka-1)>_MaxclipX then begin
                               inc(xshift,x1+sirka-1-_MaxclipX);
                               sirka:=_MaxclipX-x1+1;
                               end;
if (y1+vyska-1)>_MaxclipY then vyska:=_MaxclipY-y1+1;
incr:=_maxx-sirka+1;
i:=y1+__lhy;
inc(vyska,i);
asm
mov AX,DS
mov dssave,AX
mov AX,_zapisovacisegment
mov ES,AX
mov AX,sourcofset
mov SI,AX
mov AX,_maxx
inc AX
mul i
add AX,x1
adc DX,0
mov DI,AX
 @zacatek:
 mov BX,DI
 mov CX,DX
 add BX,sirka
 adc CX,0
 dec BX
 sbb CX,0
 cmp DX,curbank
 je @neprepinej
  mov AX,DX
  mov CurBank,AX
  mul Granularity
  mov DX,AX
  mov AX,$4F05
  mov BX,_zapisovaciokno
  call __switchbank
 @neprepinej:
 cmp CX,curbank
 je @najednou
  or CX,$FFFF
  sub CX,DI
  inc CX
  mov AX,sirka
  sub AX,CX
  mov width2,AX
  mov AX,sourcsegment
  mov DS,AX
   {presun po qwordech:}
   mov BX,CX
   shr CX,4
   jz @MeneNez16_1
    @smycka1:
    fild qword ptr DS:[SI]        {1. qword na zasobnik FPU}
    fild qword ptr DS:[SI+8]      {2.         -''-         }
    fistp qword ptr ES:[DI+8]     {2. qword ze zasobniku}
    fistp qword ptr ES:[DI]       {1.        -''-       }
    add SI,16
    add DI,16
    loop @smycka1
   @MeneNez16_1:
   {presun po dwordech:}
   mov CX,BX
   and CX,15
   mov BX,CX
   shr CX,2
    db $66; rep movsw
   {presun po bytech:}
   mov CX,BX
   and CX,3
    rep movsb
  mov AX,dssave
  mov DS,AX
  mov AX,curbank
  inc AX
  mov CurBank,AX
  mul Granularity
  mov DX,AX
  mov AX,$4F05
  mov BX,_zapisovaciokno
  call __switchbank
  mov CX,width2
  jmp @jedeme
 @najednou:
 mov CX,sirka
 @jedeme:
 mov AX,sourcsegment
 mov DS,AX
   mov BX,CX
   shr CX,4
   jz @MeneNez16_2
    @smycka2:
    fild qword ptr DS:[SI]
    fild qword ptr DS:[SI+8]
    fistp qword ptr ES:[DI+8]
    fistp qword ptr ES:[DI]
    add SI,16
    add DI,16
    loop @smycka2
   @MeneNez16_2:
   mov CX,BX
   and CX,15
   mov BX,CX
   shr CX,2
    db $66; rep movsw
   mov CX,BX
   and CX,3
    rep movsb
 mov AX,dssave
 mov DS,AX
 add SI,xshift
 mov DX,curbank
 add DI,incr
 adc DX,0
 inc i
 mov AX,i
 cmp AX,vyska
 jne @zacatek
end;
End;{_putimage}

procedure _GetImage(x1,y1,x2,y2:word;kam:pointer); assembler;
{Podobna Putimage, ale s prohozenym zdrojem a cilem. Jeste zjednodusena tim,
ze se nestara o vycuhovani obrazku z obrazovky a ze je jenom 32bitova.
Ponekud ji komplikuje cachrovani se ctecim oknem.}
var i,dssave,width,width2,incr,rbank:word;
Asm
{zjisteni aktualni banky:}
mov CX,_cteciokno
cmp CX,_zapisovaciokno
je @StejnaOkna
 call _getrbank
 mov rbank,AX
 jmp @CteciBankaZjistena
@StejnaOkna:
 mov BX,curbank
 mov rbank,BX
@CteciBankaZjistena: {rbank = aktualni banka ve ctecim okne}
mov AX,__lhy
add y1,AX
add y2,AX
mov AX,y1
mov i,AX
inc y2
les DI,kam
mov AX,x2
sub AX,x1
inc AX
mov width,AX
mov AX,_maxx
sub AX,width
inc AX
mov incr,AX
mov AX,DS
mov dssave,AX
mov AX,_Maxx
inc AX
mul i
add AX,x1
adc DX,0
mov SI,AX
@zacatek:
mov BX,SI
mov CX,DX
add BX,width
adc CX,0
dec BX
sbb CX,0
cmp DX,rbank
je @neprepinej
 push DX
 mov rbank,DX
 call _SwitchRBank
@neprepinej:
cmp CX,rbank
je @najednou
 or CX,$FFFF
 sub CX,SI
 inc CX
 mov AX,width
 sub AX,CX
 mov width2,AX
 mov AX,_ctecisegment
 mov DS,AX
  mov BX,CX
  shr CX,2
  db $66; rep movsw
  and BX,3
  mov CX,BX
  rep movsb
 mov AX,dssave
 mov DS,AX
 mov AX,rbank
 inc AX
 mov rbank,AX
 push AX
 call _switchRbank
 mov CX,width2
 jmp @jedeme
@najednou:
 mov CX,width
 @jedeme:
 mov AX,_ctecisegment
 mov DS,AX
  mov BX,CX
  shr CX,2
  db $66; rep movsw
  and BX,3
  mov CX,BX
  rep movsb
 mov AX,dssave
 mov DS,AX
mov DX,rbank
add SI,incr
adc DX,0
inc i
mov AX,i
cmp AX,y2
jne @zacatek
{synchronizace banky v zapisovacim okne, pokud je okno jenom jedno:}
mov CX,_cteciokno
cmp CX,_zapisovaciokno
jne @NestejnaOkna
 mov BX,rbank
 mov curbank,BX
@NestejnaOkna:
End;{_getimage}

(***************************************************************************
                                   Ruzne
****************************************************************************)

procedure _VSync; assembler;
Asm
mov DX,$3DA
 @repeat:
 in AL,DX
 test AL,8
 jz @repeat
End;{_vsync}

procedure _VSyncStart; assembler;
Asm
mov DX,$3DA
 @repeat1:
 in AL,DX
 test AL,8
 jnz @repeat1
 @repeat2:
 in AL,DX
 test AL,8
 jz @repeat2
End;{_vsyncstart}

procedure _SetWindow(minx,miny,maxx,maxy:integer);
Begin
if minx<0 then _minclipx:=0
          else _minclipx:=minx;
if miny<0 then _minclipy:=0
          else _minclipy:=miny;
if maxx>_maxx then _maxclipx:=_maxx
              else _maxclipx:=maxx;
if maxy>_maxy then _maxclipy:=_maxy
              else _maxclipy:=maxy;
End;{_setwindow}

procedure _SetDefaultWindow;
Begin
_MinClipX:=0;
_MinClipY:=0;
_MaxClipX:=_MaxX;
_MaxClipY:=_MaxY;
End;{_setdefaultwindow}

{$ifdef debug}
procedure _ShowBanks; assembler; {jen modifikovana _Fill}
var nbanks,bank,rest:word;
Asm
mov bx,_MaxX
inc bx
mov ax,_MaxY
inc ax
mul bx
mov nbanks,dx
mov rest,ax
mov ax,_zapisovacisegment
mov es,ax
xor ax,ax
mov bank,ax
@@1:
 push bank
 call _SwitchBank
 xor di,di
 mov cx,$4000
 mov al,byte ptr bank
 mov ah,al
 mov bx,ax
 db $66; shl ax,16
 mov ax,bx
 db $66; rep stosw
 inc bank
 mov ax,bank
 dec ax
 cmp ax,nbanks
 jne @@1
push bank
call _SwitchBank
xor di,di
mov cx,rest
inc cx
mov al,byte ptr bank
mov ah,al
mov bx,ax
db $66; shl ax,16
mov ax,bx
mov bx,cx
shr cx,2
db $66; rep stosw
and bx,3
mov cx,bx
rep stosb
End;{_showbanks}
{$endif}

(****************************************************************************
                        Ovladani virtualni obrazovky
*****************************************************************************)

procedure _SetDisplayOrigin(x,y:word); assembler;
Asm
mov AX,$4F07
xor BX,BX
mov CX,x
mov DX,y
int $10
End;{_setdisplayorigin}

procedure _SetAP(kterou:byte);
Begin
__lhy:=(_maxy+1)*kterou;
End;{_setap}

procedure _SetVP(kterou:byte);
Begin
_setdisplayorigin(0,(_maxy+1)*kterou);
End;{_setvp}

procedure _NastavStrankovani; assembler;
Asm
mov AX,_maxy
inc AX
xor __lhy,AX         {visual page zustava, active se prepne}
not _strankovani
End;{_nastavstrankovani}

procedure _ResetStrankovani;
Begin
__lhy:=0;
_setdisplayorigin(0,0);
_strankovani:=false;
End;{resetstrankovani}

procedure _swap; assembler;
Asm
xor BX,BX
xor CX,CX     {pro hybani obrazovkou}
mov DX,$03DA
 @cekani1:               {cekani na navrat paprsku}
 in AL,DX
 test AL,8
 jz @cekani1
mov AX,__lhy
or AX,AX
jz @ActiveNa1
 {visual na 1:}
 mov AX,$4F07
 mov DX,__lhy             {obrazovka dolu}
 int $10
 {active na 0:}
 xor AX,AX
 mov __lhy,AX             {__lhy nahoru}
 jmp @prepnuto          {hotovo}
@ActiveNa1:
 {visual na 0:}
 mov AX,$4F07
 xor DX,DX                {obrazovka nahoru}
 int $10
 {active na 1:}
 mov AX,_maxy
 inc AX
 mov __lhy,AX              {__lhy dolu}
@prepnuto:

{mov DX,$03DA              nebo misto toho vsyncstartu radsi tohle?       xxx
@cekani3:
in AL,DX
test AL,8
jnz @cekani3

{call _vsyncstart      {zaverecne cekani na paprsek (nutne, aby neproblikavalo
                       to, co se kresli bezprostredne po volani _swapu)}
End;{_swap}

procedure _vycerni1024; assembler;
Asm
{pomocne pole 4 nulovych wordu:}
jmp @ZaData
 @pole: dw 0,0,0,0
@ZaData:
{nastaveni cilove adresy:}
mov AX,_zapisovacisegment
xor DI,DI
mov ES,AX
{nalezeni cisla banky o 1 nizsiho nez ta, na ktere budeme zacinat:}
mov AX,__lhy
or AX,AX
jz @nulta
 mov AX,12 {druha stranka zacina 12. bankou}
@nulta:
dec AX
{vnejsi cyklus (AX = cislo banky, CX = kolik bank zbyva):}
mov CX,12
 @ProKazdouBanku:
 {banka:}
 inc AX
 push AX
 call _switchbank
 mov AX,curbank
 {vybarveni:}
 mov BX,CX {zaloha CX}
 mov CX,4096
  @smycka:
  fild qword ptr @pole     {nacteni pole na zasobnik FPU}
  fild qword ptr @pole
  fistp qword ptr ES:[DI]  {presun dat ze zasobniku na obrazovku (skoda, ze to nejde jenom zkopirovat bez mazani)}
  fistp qword ptr ES:[DI+8]
  add DI,16
  loop @smycka
 mov CX,BX {obnoveni CX}
 loop @ProKazdouBanku
End;{_vycerni1024}


(****************************************************************************
                              Rizeni spotreby
*****************************************************************************)

function _ZjistiMozneRezimyPM:byte; assembler;
Asm
xor BX,BX
mov AX,$4F10
xor DI,DI      {\ ES a DI musi byt oboje 0 (rezervovano)}
mov ES,BX      {/                                       }
int $10
cmp AX,$4F
je @OK
 xor BX,BX {pri neuspechu vratime nulu, tj. "nepodporovano nic"}
@OK:
mov AL,BH
End;{_zjistimoznerezimypm}

function _ZjistiRezimPM:byte; assembler;
Asm
mov AX,$4F10
mov BX,2
int $10
cmp AX,$4F
je @OK
 xor BX,BX
@OK:
mov AL,BH
End;{_zjistirezimpm}

procedure _NastavRezimPM(jaky:byte); assembler;
Asm
mov AX,$4F10
mov BL,1
mov BH,jaky
int $10
End;{_nastavrezimpm}


(****************************************************************************
                          Rychle pruhledne obrazky
*****************************************************************************)

function _GetSprite(x1,y1,x2,y2:integer; Kam:pointer; MaxVelikost:word; PruhlednaBarva:byte):boolean;
label nevyjde;
var buffer:^_pole8bytu;{pro nacitani radku (jakekoli pole bytu indexovane od 0)}
    zacatek,konec,{pro pohyb v nactenem radku}
    index:word;{pro pohyb ve vystupnich datech}
    y,i:integer;{pomocne promenne}
Begin
_getsprite:=false;
fillchar(kam^,2,0); {pri neuspechu tam ta nula zustane}
if (x2-x1+1>maxavail) or (maxvelikost<=2) then exit;{malo pameti na buffer nebo nedostatek pridelene pameti}
getmem(buffer,x2-x1+1); {budeme cist cele radky a pak se v nich hrabat (rychlejsi nez getpixel)}
index:=2; {na zacatku si nechavame 2 B na ulozeni velikosti}
y:=y1;
 repeat {cyklus pro radky}
 _getimage(x1,y,x2,y,buffer);
 zacatek:=0;
  repeat {zpracovani jednoho radku}
  while (zacatek<=x2-x1)and(buffer^[zacatek]=pruhlednabarva) do inc(zacatek);
  if zacatek<=x2-x1 then begin {OK, jeste jsme na radku}
                         konec:=zacatek;
                         while (konec<x2-x1)and(buffer^[konec+1]<>pruhlednabarva) do inc(konec);
                         if index+konec-zacatek+7>maxvelikost then goto nevyjde; {nestaci pridelena pamet}
                         {x:}
                         i:=x1+zacatek;
                         move(i,_pole8bytu(kam^)[index],2);
                         inc(index,2);
                         {y:}
                         move(y,_pole8bytu(kam^)[index],2);
                         inc(index,2);
                         {delka:}
                         i:=konec-zacatek+1;
                         move(i,_pole8bytu(kam^)[index],2);
                         inc(index,2);
                         {data:}
                         move(buffer^[zacatek],_pole8bytu(kam^)[index],i);
                         inc(index,i);
                         {hotovo, na radku se posuneme za konec useku:}
                         zacatek:=konec+1;
                         end;
  until zacatek>x2-x1;
 inc(y);
 until y>y2;
_getsprite:=true; {jestli jsme jeste tady, podarilo se nacist vsechno}
nevyjde: {sem skocime, kdyz v prubehu procedury dojde pamet pro vystupni data}
move(index,kam^,2); {na zacatek vystupu ulozime spocitanou delku}
freemem(buffer,x2-x1+1);
End;{_getsprite}

procedure _PutSprite(x,y:integer; obrazek:pointer);
type uw=^word; ui=^integer;
var index:word;
Begin
index:=2;
while index<uw(obrazek)^ do begin
                            _putimage(x+ui(@(_pole8bytu(obrazek^)[index]))^,
                                      y+ui(@(_pole8bytu(obrazek^)[index+2]))^,
                                      uw(@(_pole8bytu(obrazek^)[index+4]))^,
                                      1,
                                      @(_pole8bytu(obrazek^)[index+6]));
                            inc(index,6+uw(@(_pole8bytu(obrazek^)[index+4]))^);
                            end;
End;{_putsprite}

procedure _FillSprite(x,y:integer; obrazek:pointer; barva:byte);
type uw=^word; ui=^integer;
var index:word;
Begin
index:=2;
while index<uw(obrazek)^ do begin
                            __hline(x+ui(@(_pole8bytu(obrazek^)[index]))^,
                                    x+ui(@(_pole8bytu(obrazek^)[index]))^+uw(@(_pole8bytu(obrazek^)[index+4]))^-1,
                                    y+ui(@(_pole8bytu(obrazek^)[index+2]))^,
                                    barva);
                            inc(index,6+uw(@(_pole8bytu(obrazek^)[index+4]))^);
                            end;
End;{_fillsprite}


BEGIN
{$ifdef debug}writeln('******** jednotka VESA startuje ********');{$endif}
_okouknivesu;{jestli VESA nefunguje, vyhodi chybovou hlasku a ukonci program}
asm {jaky rezim zrovna bezi? (mel by to byt textak, cili cislo 3, ale jeden nikdy nevi)}
mov AH,15
int $10
mov _puvodnirezim,AL
end;
_maxx:=79; _maxy:=24;
__font:=nil; __vyska:=0; __velikostX:=1; __velikostY:=1; __roztec:=8;
__lhy:=0; _strankovani:=false;
_deltax:=0; _deltay:=0; _sirkatextu:=0; _vyskatextu:=0;
END.

{Strucny prehled, co ktera verze VESA VBE prinesla:
---------------------------------------------------
1.0: funkce $4F00..$4F05, rezimy $100..$107.

1.1: funkce $4F06..$4F07, rezimy $107..$10C, informace o velikosti VRAM
     u funkce $4F00, pocet stranek a vetsi buffer u funkce $4F01.

1.2: funkce $4F08, vetsi buffer u funkce $4F00, rezimy $10D..$11B, info o
     direct coloru u funkce $4F01, nastavitelna bitova hloubka barev.

2.0: LFB, PM, funkce $4F09, cekani na paprsek u funkce $4F07.

3.0: PM entry point, funkce $4F0B, nastavovani obnovovaci frekvence,
     funkce $4F01 vraci vic informaci, funkce $4F02 umi nastavit frekvenci a
     nemusi mazat obrazovku, funkce $4F07 podporuje triplebuffering a
     stereoskopicke zobrazeni (s mrkacimi LCD brylemi).}



{Format souboru *.FNT:
-----------------------

 vyska pisma (byte) - pocet radku (bytu) na jeden znak
 doporucena roztec (byte)
 doporucena velikost (byte) - dolni 4 bity urcuji velikostX, horni velikostY
 data (array[0..255,1..vyska] of byte)

Kazdy byte pole dat je jeden radek pismena. Razeny jsou odshora dolu, od
nulteho do 255. znaku. Nejvyssi bit techto bytu znamena pixel, ktery je
na radku nejvic vlevo.}



{Struktura spritu (na disku i v pameti):
---------------------------------------------

 celkova velikost v B (word) (pocitano vcetne tohohle wordu)
 seznam useku

struktura jednoho useku:

 xova souradnice leveho konce useku relativne od referencniho bodu (integer)
 yova souradnice useku relativne od referencniho bodu (integer)
 delka useku (word)
 obrazova data useku - rada pixelu zleva doprava, bez jakekoli komprese (array[1..delka] of byte)
}