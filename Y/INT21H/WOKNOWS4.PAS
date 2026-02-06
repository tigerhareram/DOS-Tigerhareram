(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: WOKNOWS4.PAS                                                   *)
(*  Obsah: soubor objektu, funkci a procedur pro tvorbu                    *)
(*         grafickeho uzivatelskeho rozhrani v programech                  *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*  Posledni uprava: 22.3.2012                                             *)
(*  Pro kompilaci: DISK, MYS3, GRAFIKA3, VESA, KLAVESY2, RETEZCE, ERRMSG,  *)
(*                 XMS, CFG, (DOS), WOKBARVY.INC, WOKTEXTY.INC             *)
(*  Pro spusteni: (MSDFLT.FNT, STDSIPKA.KUR, W4TXT??.DAT)                  *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit Woknows4;
{$I-,B-,R-,X-,E-,F-,S-,Q-} {prvni tri jsou dulezite, ostatni ne}
{$D-,L-} {usetri trochu pameti prekladace; pro ucely ladeni zruste}
interface
uses disk,mys3,grafika3,vesa,retezce,dos,xms;

{Vse, co zde najdete, volejte v grafickem rezimu.}

(******************** inicializace a par informaci: *************************)

procedure InitWoknows(_font,_kurzor,_texty:boolean);
{Inicializacni procedura, popsana bude o par radku dal. Pokud se vam to nechce
cist, nastavte vsechny tri parametry na true, tim se nic nezkazi.}
procedure ZrusWoknows;
{Postara se o zaverecny uklid - vymaze z pameti font, kurzor (pri tom ukonci
pripadnou automatickou obsluhu mysi, viz Zrusmys z jednotky MYS3) a texty.
(Jednotka XMS by se sice postarala o automaticke uvolneni rozsirene pameti i
v pripade, ze na tuhle proceduru zapomenete, ale bezpecnejsi a jistejsi je ji
na konci programu explicitne pouzit.)}

{Veskere texty v teto jednotce (krome nekolika mezer, otazniku, tecek apod.)
jsou ulozeny v externim textovem souboru:}
 const woktexty:string[12]='W4TXTCZ.DAT';
{Nacitaji se do objektu WT procedurou Initwoknows (obvykle). Pokud texty
nejsou nactene, daji se pouzivat pouze objekty krome Ciselne osy, Konzole a
Menu a procedury Infokno a Zjistujsouradnice. Vsechno ostatni texty pouziva a
kdyby nebyly nactene, nebylo by co zobrazovat.
V souboru W4TXTCZ.DAT jsou ceske hacky a carky kodovany ve znakove sade
Latin 2. Vychozi font (MSDFLT.FNT) je kodovan stejne a zarucuje, ze se nebudou
zobrazovat paznaky. Pokud ve svem programu nastavite jiny font, jednotka si
vzdy pred zobrazenim "svych" textu prepne na "svuj" font a pak zase zpet.
Texty, ktere se jednotce predavaji z programu (hlasky v informacnich oknech
apod.) se vypisuji bud tim fontem, jaky je v programu aktualne nastaven (takze
si je muzete psat treba v Kamenikach) nebo take standardnim fontem, prepina se
pomoci jedne globalni promenne, viz dale. Nadpisy dialogovych oken jsou vzdy
psany aktualne nastavenym fontem a v pripade, ze zadate nadpis='', jsou
doplneny preddefinovanym textem z vyse uvedeneho souboru. Tady pak muze
dochazet k problemum, pokud pouzivate jine kodovani. V takovem pripade bud
vsechny nadpisy dusledne zadavejte rucne nebo si diakritiku v souboru s texty
prepiste do sve znakove sady.

Indexy textu jsou ulozeny zde:}
{$I WOKTEXTY.INC}

{Procedura Initwoknows krome textu nacita i vychozi font MSDFLT.FNT a mysi
kurzor STDSIPKA.KUR. Pokud potrebujete pouzit jine soubory nez tyto, nastavte
prislusne parametry na false a do globalnich promennych Wokfont a Wokkurzor
si rucne nactete neco jineho (proceduru Initwoknows vubec neni nutne pouzivat,
mam ji tu jen pro zkraceni zapisu v jednodussich programech).

Jednotka VESA umoznuje pouzivat v zobrazovanych textech ridici kody pro
nastaveni barvy, polohy a velikosti pisma. Jednotka Woknows tyto kody plne
respektuje jen v nadpisech objektu (texty na tlacitkach, nadpisy v modre liste
okna a tak). Vsude jinde (texty uvnitr dialogu, popisky polozek u prepinacu
atd.) sice ridici kody funguji take, ale mohou zpusobit problemy, protoze se
rozmery techto textu pocitaji pouze zjednodusenou formou z delky retezce, bez
vyhodnocovani kodu. Takze tam se zmenami velikosti a polohy velmi opatrne.}


(******************************** objekty: **********************************)
{orientacni seznam:

 Tlacitko    - textove tlacitko (button)
 Tlacitko2   - graficke tlacitko
 Zatrzitko   - zatrhavaci policko (checkbox)
 Prepinac    - vyber z nekolika moznosti (radio buttons)
 Roleta      - podobny vyber, ale jinak vypada (combobox/select)
 Posuvnik    - svisly posuvnik (scrollbar)
 CiselnaOsa  - vodorovny posuvnik urceny pro zadavani cisel
 Hotspot     - klikaci obdelnikova oblast (neviditelne tlacitko)
 TextovePole - jednoradkove pole pro zadavani textu (edit/text)
 Menu        - mnohoradkove menu s volitelnym poctem polozek i textu
 Okno        - okno s nadpisem, ktere po zavreni obnovi obsah obrazovky
               v miste, na kterem se otevrelo (form/window)
 Konzole     - viceradkove pole pro zobrazovani textovych hlasek a zadavani
               cisel nebo textu (neco jako prikazovy radek AutoCADu)

 Vsechny funguji skoro stejne:
 Inicializace: Init(...) a spol. (vyjimky existuji, ale na ty budete vcas
upozorneni). Priradi se pocatecni hodnoty a cele zarizeni se vykresli
(o pripadne vypnuti kurzoru se postara, nakonec ho necha zapnuty). Ovladaci
prvek se vzdy musi vejit na obrazovku, na vycuhovani neni staveny - pozor!
Souradnice x,y znamenaji obvykle neco kolem leveho horniho rohu objektu.
 Opetovne zobrazeni: metoda Zobraz, pouzitelna kdykoli. O kurzor mysi se
postara a nechava ho pak zapnuty. U vetsiny objektu se prave tato metoda stara
o vypocty rozmeru podle aktualniho nastaveni fontu, takze pokud font zmenite a
pak znovu pouzijete zobrazeni, velikost objektu se prepocita. Take je mozne
nastavit v objektu rucne polozku Hodnota (ale pozor na povoleny rozsah!)
a pak zavolat zobrazeni, ktere vymaze puvodni zobrazenou hodnotu a vykresli
objekt s novou.
 Prace: v nejakem cyklu volejte metodu Kontrola (ve vetsine pripadu je lepsi
napred pockat na klik mysi nebo stisk klavesy), ktera otestuje mys, nastavi
Hodnotu a pripadne zobrazi prislusnou animaci.
 Cteni stavu: rucne, primo z polozky Hodnota. Pokud potrebujete zjistit,
jestli se Hodnota od minule kontroly zmenila, zeptejte se metody Zmeneno.
 Zruseni: metodou Zrus. Obsahuji ji jen ty prvky, ktere si pri inicializaci
dynamicky alokovaly nejakou pamet.


Barvy vsech objektu (konstanty) jsou v tomto souboru:}
{$I wokbarvy.inc}

type
NadpStr=string[60]; {trochu kratsi retezec pro nadpisy oken
               (cely string by byl vetsinou zbytecne plytvani pameti,
               ale v pripade potreby se tenhle typ da prodlouzit)}

wzakladobj = object
             _zmeneno:boolean; {tuto polozku bude v potomcich nastavovat metoda Kontrola}
             function zmeneno:boolean;{vraci aktualni hodnotu atributu _zmeneno a pote ho nastavi na false}
             end;
{zakladni objekt, ze ktereho budou dedit ostatni}

Tlacitko = object
           x,y:integer; {levy horni roh tlacitka}
           sirka,vyska, {rozmery (jsou o 1 mensi, aby se s nimi lip pocitalo), jsou urceny rozmery textu}
           pridavek:word; {vyska tlacitka je urcena vyskou textu plus Pridavek nad nim a pod nim}
           napis:string[60]; {napis na tlacitku}
           popis:string; {zobrazi se v okenku po kliknuti pravym mysitkem}
           hodnota:byte; {cim na nej bylo kliknuto: 0 = nic, 1/2/4 = leve/prave/prostredni mysitko. Uchovava se do nejblizsiho
                          zavolani metody Kontrola (ktera ji nastavi podle aktualni situace).}
           procedure init(ix,iy:integer;inapis,ipopis:string;ipridavek:byte);
           procedure zobraz; {vypocita rozmery tlacitka a zobrazi ho}
           procedure kontrola; {kontroluje mys a pri kliknuti na tlacitko zobrazi animaci,
                                nastavi Hodnotu a pripadne zavola Obsluhu}
           end;
{Klasicke tlacitko s textem. Funkci Kontrola je nejlepsi volat v cyklu po
Cekej, vyhodnoceni stavu pres Hodnotu. Velikost tlacitka je urcena rozmery
napisu v okamziku zobrazeni. Osetreny jsou i ty nejsilenejsi kombinace
ridicich kodu, da se pomoci nich udelat treba i viceradkovy text na jednom
tlacitku. Pokud je Popis='', klik pravym mysitkem se normalne vyhodnoti a do
Hodnoty se ulozi 2. Jestli obsahuje nejaky text, tak se po pravokliknuti tento
text zobrazi v okenku nad tlacitkem a klik bude ignorovan (Hodnota bude 0).}

Tlacitko2 = object
            x,y:word; {souradnice leveho horniho rohu}
            sirka,vyska:word; {rozmery tlacitka v pixelech}
            hodnota:byte;
            popis:string;
            obrazky:array[0..1] of pointer; {prvni je pro klid, druhy pro stisk}
            procedure init(ix,iy:integer; isirka,ivyska:word; ipopis:string; klid,stisk:pointer);
             {iSirka a iVyska jsou rozmery obrazku (musi byt pro oba stejne),
              Klid je ukazatel na obrazek tlacitka v klidu, Stisk na obrazek
              stisknuteho tlacitka}
            procedure zobraz;
            procedure kontrola;
            end;
{Graficke tlacitko.
Nejdrive je potreba si nejakym zpusobem pripravit obrazky tlacitka a ty pak
predat metode Init. Dal se chova stejne jako textove tlacitko.}

Zatrzitko = object(wzakladobj)
            x,y:integer; {levy horni roh ctverecku}
            sirka,vyska:word; {rozmery aktivni (kliknutelne) oblasti - ctverecek i s textem vedle nej}
            textik:string[60]; {text vedle zatrzitka}
            popis:string;
            hodnota:boolean; {true = zatrzeno}
            procedure init(ix,iy:integer; itextik,ipopis:string; ihodnota:boolean);
            procedure zobraz;
            procedure kontrola;
            end;
{Bily zatrhavaci ctverecek s jednim radkem textu vedle. Kliknout se da bud do
bileho ctverecku nebo na ten text, rozmery oblasti pro kliknuti jsou urceny
rozmery textu v okamziku zobrazeni (podle aktualniho nastaveni pisma, opet
jsou podporovany veskere ridici kody). Na prave mysitko reaguje bud zobrazenim
popisu, nebo, pokud je popis prazdny, vubec.}

Prepinac = object(wzakladobj)
           x,y:integer;{levy horni roh prvniho kolecka (nadpis je nad touto souradnici!)}
           nadpis:string[50];{radek zobrazeny nad polozkami prepinace}
           popis:string;{vyvola ho prave mysitko}
           Hodnota:byte;{0 = nevybrano nic, 1..PocetRadku = cislo prislusneho radku}
           sirka:word;{sirka aktivni oblasti podle nejsirsiho radku [pix.]}
           VyskaRadku:word;{vyska jednoho radku}
           texty:uknaradek;{ukazatel na seznam textu polozek}
           procedure init(ix,iy:integer; inadpis,itexty,ipopis:string; ihodnota:byte);
           procedure zobraz;
           procedure kontrola;
           procedure zrus;
           end;
{Nekolik radku, u kazdeho je bile kolecko. Kliknutim vyberete vzdy jednu
moznost. Cislo vybrane polozky urcite z promenne Hodnota. Polozky jsou
cislovany od 1; pokud je hodnota=0, neni vybrano nic. Parametry pro Init:
itexty je retezec se seznamem polozek (jsou oddeleny znakem '|'), ihodnota je
pocatecni Hodnota (muze byt i 0, pak neni vybrano nic). Ostatni je snad jasne.}

Roleta = object(wzakladobj)
         x,y:integer;{levy horni roh}
         sirka1,sirka2,vyska:word;{sirka leveho pole, sirka komplet vcetne rozbalovaciho tlacitka, vyska pole}
         popis:string;{zobrazi se po kliku pravym mysitkem}
         polozky,{ukazatel na seznam polozek}
         vybrana:uknaradek;{ukazuje na vybranou polozku (stejne jako Hodnota)}
         hodnota:word;{cislo aktualne vybrane polozky, cislovano od 1,
                       0 = nevybrano nic (to jde zadat pri inicializaci).}
         MaxHodnota:word;{celkovy pocet polozek}
         MaxDelka:byte;{pocet znaku nejdelsi polozky}
         procedure nuluj;
          {vynuluje ukazatel na polozky - pred prvnim pouzitim NUTNE!!!}
         procedure PridejPolozky(zdroj:string);
          {Pridava polozky do seznamu. Plati pravidla jako u procedury
          Nactitexty z jednotky Retezce. Pouzivat pred Init.}
         procedure init(ix,iy:integer; ihodnota:word; ipopis:string);
          {ihodnota muze byt i 0, pak neni vybrano nic}
         procedure zobraz;
         procedure kontrola;
         procedure zrus;
         end;
{Policko s nejakou textovou hodnotou a s rozbalovacim tlacitkem vpravo. Po
kliknuti levym mysitkem se ukaze roleta s nabidkou moznosti, ze kterych si
jednu vybereme.
Inicializace je ponekud netradicni - nejdriv je treba vynulovat, potom zadavat
polozky a az nakonec volat init. Zadavani polozek je tak mozne zautomatizovat
(pres nejaky cyklus apod.) a muze jich byt i vic, nez kolik by se veslo do
jednoho stringu. Ovladani: mysi vyberete polozku z nabidky, potvrdite
kliknutim nebo enterem, zrusite kliknutim mimo roletu nebo escapem.}

Posuvnik = object(wzakladobj)
           x,y:integer;{levy horni roh horniho tlacitka}
           PocetPoloh:word;{pocet moznych poloh}
           hodnota:word;{aktualne nastavena poloha, pocitano od 0 do Pocetpoloh-1}
           VyskaPolohy:word;{vyska jedne polohy na stredni casti posuvniku}
           sirka:word;{sirka posuvniku, urcuje ji sirka textu pri zobrazeni}
           nahoruT,doluT:tlacitko;
           procedure init(ix,iy:integer; iVyska,iPocetPoloh,iHodnota:word);
              {ivyska je vyska samotne stredni casti posuvniku (bez tlacitek), [px]}
           procedure zobraz;
           procedure kontrola;
           end;{posuvnik}
{Svisly posuvnik.
Pozor, ze vyska, kterou zadate pri inicializaci, je spis orientacni. Posuvnik
si ji prizpusobi tak, aby co nejlepe odpovidala poctu poloh, takze nakonec
muze vyjit nizsi nez jste zadali. Vyssi muze vyjit pouze v pripade, ze zadany
pocet poloh je vetsi nez zadana vyska - pak budou jednotlive polohy vysoke
1 pixel (coz je absolutni minimum), ale ani tak se do zadaneho prostoru
nevejdou.}

CiselnaOsa = object(wzakladobj)
             x,y:integer;{levy horni roh leveho tlacitka}
             x2:integer;{levy okraj stredni casti osy}
             min,max,hodnota:longint;{rozsah hodnot a aktualni hodnota}
             sirka:word;{skutecna sirka osy v pixelech}
             ubert,pridejt:tlacitko;
             psatcisla:boolean;{jestli se ma pod osou vypisovat minimalni, maximalni a aktualni hodnota}
             pozadi:byte;{jakou barvou pozadi se bude mazat aktualni hodnota pri prepisovani}
             nadpis:string[50];{bude zobrazen nad osou}
             textmin,textmax:string[30];{budou zobrazeny nad osou (pod nadpisem)}
             procedure init(ix,iy:integer; isirka:word; imin,imax,ihodnota:longint; inadpis,itextmin,itextmax:string;
                            icisla:boolean; ipozadi:byte);
             procedure zobraz;
             procedure kontrola;
             end;{ciselnaosa}
{Vodorovny posuvnik pro zadavani cisel. Kliknutim do oblasti posuvniku levym
mysitkem presunete "jezdec" na souradnici kurzoru, prave mysitko vyvola
napovedu k tlacitkum: ze kliknutim levym mysitkem zmenite hodnotu o 1, pravym
o 10, Shift+levym o 100, Shift+pravym o 1000.}

hotspot = object(wzakladobj)
          a,b,c,d:integer; {[a,b] je levy horni roh, [c,d] pravy dolni}
          popis:string; {funguje stejne jako popis u tlacitek}
          hodnota:byte; {kterym mysitkem sem bylo od posledni kontroly kliknuto}
          xKliku,yKliku:word; {do ktereho mista bylo kliknuto (pocitano relativne od leveho horniho rohu)}
          resetovat:boolean; {jestli se ma po kliku cekat na uvolneni tlacitek}
          procedure init(ia,ib,ic,id:integer; ires:boolean; ipopis:string);
          procedure zobraz(barva:byte); {obtahne oblast danou barvou (nestara se o kurzor), na funkci nema vliv}
          procedure kontrola;
          end;
{Neviditelna obdelnikovita klikaci oblast. Pamatuje si, cim a kam presne jsme
do ni naposledy klikli.}


UkNaTP = ^textovepole; {pomocny}
TextovePole = object(wzakladobj)
              x,y:integer;{levy horni roh}
              sirka,vyska:word;{rozmery - pro usnadneni kontroly kliku mysi}
              MaxZnaku:byte;{max. delka retezce, urcuje sirku pole}
              pozice:integer;{poloha kurzoru v textu, 0 = pred prvnim znakem, -1 = vybran cely text}
              Hodnota:string[100];{text (omezeni delky je jenom kvuli tomu, ze vic se stejne na obrazovku nevejde)}
              default:string[100];{puvodni text, obnovi se pri stisku Esc}
              ProSoubor:boolean;{true => zakazou se znaky, ktere nejdou pouzit v nazvu souboru}
              stav:byte;{aktualni stav pole}
              predchozi,dalsi:uknatp;
              procedure init(ix,iy:integer;imaxzn:byte;itext:string;iakt,iprosoubor:boolean);
                               {iakt - jestli ma byt pole po inicializaci hned aktivni}
              procedure zobraz;
              procedure kontrola;
              procedure nasmeruj(var shiftTab,Tab:textovepole);
              end;
{Pole pro zadavani textu (1 radek). Kurzor se presouva pomoci mysi nebo
klavesami Home, End a sipkami. Funguji Delete a Backspace. Esc rusi zadany
text a nahradi ho puvodnim (itext pri inicializaci) a necha pole aktivni.
Enter, Tabulator nebo klik mysi mimo pole pole deaktivuji a napsany text
nechaji. Pole se opet aktivuje kliknutim mysi. Neaktivni pole neovlivnuje
klavesnici ani mys, lze ho kontrolovat spolu s jinymi ovladacimi prvky. Jako
aktivni si zabira klavesnici pro sebe (pokud neni kontrolovano jako uplne
posledni). POZOR: na konci cyklu, ve kterem textove pole testujete, je nutne
pockat na uvolneni tlacitek na mysi (napr. procedura Resetuj z Mys3). To
proto, ze pole sama na nej necekaji, aby ta, co jsou kontrolovana drive,
"nekradla" mys a klavesnici tem, co jsou kontrolovana pozdeji.
Ukazatele Predchozi a Dalsi umoznuji prechazeni mezi jednotlivymi textovymi
poli na obrazovce klavesou Tab (dalsi) nebo kombinaci Shift+Tab (predchozi).
Nastavit je muzete bud rucne nebo metodou Nasmeruj. Po inicializaci maji oba
hodnotu nil, cili tabulator textove pole pouze deaktivuje a nikam vas
neprepne.
Pro urceni, jakym zpusobem bylo ukonceno psani do pole, slouzi polozka Stav,
ktera muze nabyvat techto hodnot:}
const _Neaktivni=0; {chova se inertne, nic nedela, kurzor neni videt}
      _Aktivni=1;   {kurzor je videt, lze psat}
      _Enterem=2;   {byl stisknut Enter, pole je ted neaktivni}
      _Escapem=3;   {byl stisknut Escape, pole je aktivni, cely text je oznacen}
      _Odkliknutim=4; {bylo kliknuto mimo pole nebo byl stisknut tabulator, pole je neaktivni}


type UkNaPolozkuMenu = ^PolozkaMenu;
     PolozkaMenu = record
                   texty:UkNaRadek;{ukazatel na seznam radku textu}
                   lhy,pdy:integer;{souradnice okraju}
                   dalsi,predchozi:uknapolozkumenu;{pro obousmerny spojovy seznam}
                   end;
     Menu = object
            PrvniRadek:UkNaRadek;
            PrvniPolozka:UkNaPolozkuMenu;
            hodnota:byte;
            procedure init;
            procedure PridejText(textik:string);
            procedure PridejPolozku(textik:string);
            procedure kontrola;
            procedure zrus;
            end;
{Dialog s uvodnim textem a nekolika moznostmi na vyber. Ovlada se trochu jinak
nez je u ostatnich objektu zvykem:
 init - vynuluje interni ukazatele. Pred prvnim pouzitim je nutne ji pouzit,
        ale nikdy jindy!!! (hlavne ne, pokud uz jsou zadane nejake texty)
 PridejText - prida dalsi text do uvodu. Lze pouzit i vickrat po sobe, text se
              bude pripojovat (vzdy na novem radku). Radky se deli bud
              automaticky, pokud vychazeji delsi nez:} const SirkaMenu=40;     {
              nebo rucne znakem '|'. Uvodni text neni povinny.
 PridejPolozku - prida jednu polozku do menu. Prvnim zavolanim vlozite prvni,
                 druhym druhou atd.. Pro radkovani uvnitr jedne polozky plati
                 totez co o uvodnim textu. Neni nutne zadavat zadne polozky,
                 v takovem pripade se automaticky vytvori polozka " OK ".
 Kontrola - vykresli menu, necha uzivatele vybrat nejakou moznost a do Hodnoty
            ulozi jeji cislo (prvni = 1, druha 2 atd.). Ovlada se mysi (vyber
            levym tlacitkem, ostatni nic) nebo klavesnici (sipky a Tab vyber,
            Enter nebo mezernik potvrzeni).
            POZOR: protoze menu byva obvykle velke jak krava, neuklada se
            pozadi okna a po pouziti zustane menu nakreslene na obrazovce!!!
            Vycuhovani z obrazovky je narozdil od ostatnich objektu osetreno
            (tj. nedojde k pretekani z praveho okraje na levy a podobne,
            proste se to orizne).
            Metodu Kontrola je mozne volat vickrat po sobe, ulozene texty
            nijak neovlivnuje. Take se da zavolat Kontrola, pak pridat par
            radku textu nebo polozek a zavolat Kontrolu znova.
 Zrus - zrusi vsechny texty v menu (uvod, polozky atd.) a pripravi ho pro
        nove pouziti.
Vzhledem k tomu, ze Menu je vlastne dialog a ne objekt, ktery by lezel na
obrazovce a cekal na akci uzivatele, ztraci metoda Zmeneno smysl, a proto zde
neni implementovana.}

type
Okno = object
       x,y:integer;{levy horni roh}
       y2:integer;{yova souradnice efektivniho leveho horniho rohu (pokud je nejaky nadpis, tak je tohle hned pod nim)}
       sirka,vyska:word;
       PozadiOkna:pointer;
       BylKurzor:boolean;
       procedure init(ix,iy:integer; isirka,ivyska:word; nadpis:nadpstr);
       procedure zrus;
       end;
{Viz Windows :-). Init okno zobrazi (a necha vypnuty kurzor), Zrus ho zase
zrusi (vrati puvodni pozadi a vrati kurzor do stavu, v jakem byl pred Initem).
Vyska modre listy je urcena aktualnim nastavenim pisma (osetreny jsou i ruzne
prasarny s ridicimi kody v nadpise), sirka okna se automaticky zvetsi, pokud
by se do nej nadpis nevesel. Pokud zadate nadpis='', zadna modra lista se
nezobrazi.}

{pomocne typy:}
konzole_radek = record {nemenit - velikost je psana natvrdo cisly!}
                _barva:byte;
                obsah:string; {pozor, dynamicka delka!}
                end;
konzole_uknaradek = ^konzole_radek; {bez ukazatele pretypovani nefunguje}
konzole_radky = array[0..0] of byte; {do takovehohle dynamickeho pole se radky ulozi}

{uzivatelsky typ:}
Konzole = object(wzakladobj)
          x,y:word;
          sirka,vyska:word;
          DelkaRadku, {pocet znaku na radek}
          PocetRadku:byte;
          radky:^konzole_radky; {misto pro ulozeni radku}
          logovat:boolean; {jestli se maji vlozene texty zaznamenavat do souboru}
          log:text; {a jestli jo, tak do tohohle}
          ZadavaSe,Zadano:byte; {jaky typ dat se prave zadava nebo uz zadal
             (odpovida parametru Cteni u metody Vloz):
             0 - nezadava se nic, konzole se chova inertne
             1 - zadava se jedno cele cislo
             2 - zadavaji se dve cela cisla oddelena carkou nebo mezerou
             3 - zadavaji se souradnice, bud ciselne jako pri 2 nebo kliknutim
                 mysi nekam na obrazovku.
             255 - zadava se text
             27 (jen pro Zadano) - zadavani bylo zruseno Escapem}
          PsaciBuffer:string; {docasne uloziste zadaneho textu, nez se stiskne
                               Enter a text se zpracuje}
          HodnotaInt1,HodnotaInt2:integer; {\finalni uloziste zadanych hodnot}
          HodnotaStr:string;               {/     (odtud se ctou)            }
          {tyhle tri hodnoty si v pripade potreby nastavte rucne:}
          x0,y0:integer; {bod na obrazovce, od ktereho se pocitaji zadavane
                          souradnice (pri zadavase=3), vychozi 0,0 (tj. levy
                          horni roh obrazovky)}
          zoom:word; {meritko obrazovky v % (napr. pri 50% je souradnicovy
                      prostor oproti obrazovce polovicni, takze klik na pixel
                      100,10 da souradnice 200,20), vychozi 100% (tj. 1 pixel
                      na obrazovce = 1 delkova jednotka souradnic)}
          procedure init(iX,iY:word; iDelkaR,iPocetR:byte; iLog:string);
          {Inicializuje konzoli, alokuje pamet pro texty a pripadne
          otevre zaznamovy soubor. iLog je jmeno tohoto souboru (nebo '', kdyz
          zaznamenavat nechceme); pokud se za nej pripise ' A' nebo ' a',
          pripoji se zaznam k existujicimu souboru, jinak se soubor prepise.
          Max. delka radku je 100 znaku; kdyz date vic, automaticky se
          snizi na 100 (to je dano delkou pomocnych bufferu - kdyz si je
          zvetsite, muzete radky prodlouzit az na maximum 255, ale pak
          se stejne nevejdou na obrazovku, takze to je celkem na houby).
          Zadavany text kazdopadne muze jit az do 255.}
          procedure Zobraz;
          {Propocita rozmery podle aktualniho nastaveni textu a konzoli
          zobrazi. O kurzor mysi se postara a pak ho necha zapnuty.}
          procedure Pis(Hlaska:string; Barva:byte);
          {Do konzole vlozi novy radek textu. Zbyle radky, ktere uz tam jsou,
          odscrolluji nahoru a horni se ztrati. Pokud se vkladany text nevejde
          na jeden radek, bude automaticky zalomen (v mezerach mezi slovy).}
          procedure Vloz(Hlaska:string; Barva,Cteni:byte; ZachovejMinule:boolean);
          {Vlozi do konzole novy text a zaroven umozni, aby uzivatel neco
          zadal. Jaky typ dat se ma zadat urcuje parametr Cteni (jeho hodnoty
          odpovidaji polozce ZadavaSe - viz vyse). S hodnotou Cteni=0 se
          tato metoda chova presne stejne jako Pis. Parametr ZachovejMinule
          urcuje, jestli se ma na konci radku zobrazit posledne zadana
          hodnota - potvrdit se potom da samotnym stiskem enteru. Zobrazena
          bude <takhle>. Pri false se zapamatovana hodnota od minula smaze,
          na radku se nezobrazi a samotny enter vrati prazdnou hodnotu
          (tj. nuly u cisel nebo '' u textu).}
          procedure Kontrola;
          {Stara se o interakci s uzivatelem. Kdyz se zrovna nic nezadava,
          nedela nic. Kdyz ano, zabira si klavesnici pro sebe a napsana data
          zobrazuje na konci posledniho radku. Kurzor se zobrazuje jako '_'.
          Enter zadanou hodnotu potvrdi, Escape zrusi (pak bude Zadano=27),
          z kurzorovych klaves funguje pouze Backspace. Alt+sipky vkladaji
          znaky sipek, ale POZOR, ze jsou ze zacatku ASCII tabulky a delaji
          paseku v textovych souborech!  Pokud je zadavana vec moc dlouha,
          radek automaticky scrolluje doleva (napsany text i obsah radku pred
          nim zustava cely ulozeny v pameti, nic se neztraci).}
          procedure _reset;
          {Zrusi jakekoli rozjete zadavani hodnot (minule hodnoty nemaze,
          jenom vynuluje polozku ZadavaSe a nastavi _zmeneno na false)
          a konzoli prekresli.}
          procedure zrus;
          {Uvolni pamet dynamicky alokovanou pri initu a pripadne zavre
          zaznamovy soubor.}
          end;
{Nekolikaradkove textove pole pro zobrazovani ruznych zprav a hlasek. Kazdy
radek muze mit jinou barvu a po pripsani noveho ty stare automaticky scrolluji
nahoru. Prilis dlouhe texty se automaticky zalamuji do vice radku.
Dale se konzole da pouzit i jako prikazovy radek - uzivatel muze zadavat cisla
nebo texty (az do 255 znaku). Navic jeste muzeme nechat vsechno, co se
v konzoli zobrazuje, automaticky zaznamenavat do textoveho souboru.
Vzhledem k poctu a ruznorodosti navratovych hodnot se vyznam zdedene funkce
Zmeneno meni na "zadavani dokonceno", tj. true po stisknuti Enteru nebo
Escapu (ten pak odlisite podle hodnoty Zadano=27) nebo po kliknuti pri
zadavani souradnic, jinak je vzdy false.}


(************************** globalni promenne: ******************************)
var WokFont:_font; {vychozi systemovy font; jde nastavit i vlastni, ale mel by byt vzdy 8 pixelu vysoky}
    WokKurzor:tkurzor; {vychozi kurzor pro mys}
    WT:xtext; {objekt pro ulozeni textovych konstant}

    WokZruseno:boolean; {tuto promennou nastavuji na true funkce Vloztextokno,
     Vlozcislookno, Vyberbarvuokno, Vybersouborokno, Vlozmaskuokno a
     Vlozvzorekokno, pokud byly ukonceny zrusenim (z navratove hodnoty se to
     nepozna, protoze se v takovem pripade vraci defaultni hodnota).}

(*********************** verejne procedury a funkce: ************************)
{Pokud jde o nejake okno a souradnice se mu nezadavaji rucne, zobrazi se vzdy
nekde pobliz stredu obrazovky, ktery si samo spocita.}

procedure InfOkno(ix,iy:integer; hlaska:string; resB:boolean);
{Male zlute informacni okenko s textem, odklikne se cimkoli. Text Hlaska
se automaticky rozklada do vice radku (slova se nedeli). Rucne muzete radek
ukoncit znakem '|'. Ix a iy je stred okna, ne levy horni roh. Pokud je resb
true, pocka se na konci procedury na uvolneni vsech tlacitek na mysi a
klavesnici (procedura Resetuj), jinak ne. Rozmery okna jsou urceny rozmery
textu, ktery se ma zobrazit. Okno svou polohu automaticky prizpusobuje tak,
aby nikde nevycnivalo z obrazovky.}

const DialogyStandardnimFontem:boolean=false;
{true - v nasledujicich dialogovych oknech se bude pouzivat standardni font
        z promenne Wokfont (obvykle MSDFLT.FNT, 8x8 pixelu), po skonceni dane
        procedury nebo funkce se obnovi puvodne nastaveny font
 false - pouzije se ten font, ktery je zrovna nastaven.}

function AnoNeOkno(texty:string):boolean;
{Okno s otazkou a tlacitky Ano a Ne. Retezec Texty obsahuje text otazky.
O automatickem i rucnim rozkladani textu do radku plati totez jako u Infokna,
jenomze tady muze byt radek o neco delsi. V modre liste okna je standardne
zobrazen nadpis 'Dotaz:'. Pokud ho chcete zmenit, zacnete retezec Texty znaky
'%%n', za ne napiste novy text nadpisu a zakoncete ho sekvenci '%%N' (pozor na
velikost pismen). Priklad: '%%nTohle bude nadpis%%NTohle uz je text okna.'.
"Ano" se da zvolit i klavesami A a Enter, "ne" klavesami N a Esc.
Funkce vraci true, pokud bylo zvoleno Ano.
Sirka okna je urcena sirkou nejdelsiho radku nebo nadpisu, vyska poctem radku.}
procedure OKOkno(texty:string);
{Okno se zpravou a tlacitkem OK. Texty i pripadne rucni zadavani nadpisu
funguji stejne jako u AnoNeOkna (vychozi nedpis je 'Zpr va:'). Odklepnout se
da mysi (tlacitko OK), Enterem, mezernikem nebo klavesou O.}
function VlozTextOkno(nadpis:nadpstr; MaxZn:byte; DefaultText:string; ProSoubor:boolean):string;
{Dialogove okno pro zadani jednoradkoveho textu.
 nadpis - bude zobrazen v horni modre liste okna. Pokud zadate '', zobrazi
          se 'Zadej text:'
 maxzn - maximalni pocet znaku textu (neprehanet - davejte max. cca 75,
         aby se okno veslo na obrazovku)
 defaulttext - text, ktery je v okne zobrazen na zacatku a funkce ho vraci v
               pripade,ze je zadavani zruseno (tlacitko Zrus nebo klavesa Esc)
 prosoubor - true => dovoli psat jenom znaky, ktere se mohou vyskytovat ve
                     jmenech souboru
             false => dovoli vsechno}
function VlozCisloOkno(nadpis:nadpstr; _od,_do,default:longint):longint;
{Dialog pro zadavani cisel.
 nadpis - viz vyse, pokud je '', vypise se 'Zadej Ÿ¡slo:'
 _od,_do - rozsah pozadovaneho cisla
 default - cislo, ktere je v okne zobrazeno na zacatku a funkce ho vraci v
           pripade, ze je zadavani zruseno
Pokud napisete nejakou kravinu (pismena misto cisel apod.), bude automaticky
smazana a cislo zustane v okne, abyste ho mohli pripadne jeste opravit.}
function Nabidka(ix,iy:integer; texty:string):byte;
{Male menu podobne mistni nabidce ve Windows. Ovlada se mysi (klik na polozku
znamena vyber, klik vedle = zrusit) nebo klavesnici (sipky, Enter, Esc).
 ix,iy - levy horni roh (vycuhovani z obrazovky je osetreno, nedojde k nemu)
 texty - seznam textu jednotlivych polozek. Radky oddelujte znakem '|', radek
         s textem '-' znamena delici caru.
Vraci cislo vybrane polozky, v pripade zruseni (Esc nebo klik vedle) nulu.
Prvni polozka ma cislo 1, druha 2 atd., delici cary se nepocitaji.
Priklad pouziti:
 case nabidka(xmys,ymys,'prvni polozka|druha polozka|-|treti polozka') of ...}
function VyberBarvuOkno(nadpis:nadpstr; default:byte):byte;
{Okno s vyberem barvy pro 256 barev, vraci cislo te vybrane. Ovlada se mysi
nebo klavesnici (sipky, Home, End, Enter/O, Esc/Z).
 nadpis - je zobrazen v horni liste okna, mel by mit max. 19 znaku (jestli
          bude delsi, okno se automaticky rozsiri, ale uz nebude vypadat tak
          hezky). Pokud zadate '', zobrazi se 'Vyber barvu:'.
 default - vychozi barva, ktera je vybrana na zacatku a kterou funkce vraci
           v pripade zruseni}
procedure ZjistujSouradnice;
{Zobrazi zamerovaci kriz, se kterym pohybujete pomoci mysi, a male okenko s
jeho aktualnimi souradnicemi. Velmi uzitecna a casto pouzivana vecicka, kdyz
potrebujete zjistit, kam co na obrazovku umistit. Pro libovolne rozliseni.
Barvy: okenko se souradnicemi podle Infokna, zamerovaci kriz je bily
(barva 15) a xoruje se s pozadim.}
function VyberSouborOkno(Nadpis:nadpstr; Cesta:dirstr; Masky:string; ProUkladani:boolean):pathstr;
{Okno pro vyber souboru, vraci vybrane jmeno vcetne cesty. Parametry:
 Nadpis - zobrazi se v horni liste okna. Kdyz je '', doplni se 'Vyber soubor:'.
 Cesta - adresar, ve kterem se ma zacit. Ukoncovaci \ neni povinne.
         '' nebo '.' znamena aktualni adresar.
 Masky - seznam jmen souboru (vcetne pripadnych koncovek), jake se maji
         v okne zobrazit. Muze jich byt vic, oddeluji se carkami bez mezer a
         v okne pak budou soubory serazeny tak, jak byly serazeny Masky.
         Pozor na duplicity, pri nevhodne zvolenych maskach k nim muze dojit
         (napr. pri '*.tx?,*.t?t' budou soubory *.txt zobrazeny dvakrat).
         Masky urcuji pouze to, jake soubory se maji vyhledat a nabidnout k
         vyberu. Rucne zadane jmeno jim odpovidat nemusi.
 ProUkladani - urcuje, k cemu bude okno pouzito:
               False - primarne pro vyber z existujicich souboru za ucelem
                       cteni.
               True - primarne pro zadavani noveho souboru za ucelem ukladani.
               Rozdil je pouze v tom, kde bude po otevreni okna kurzor: pri
               false v seznamu souboru, pri true v policku pro prime zadavani
               jmena. Jinak se okno chova naprosto stejne, jedinym ucelem je
               usetreni jednoho stisku tabulatoru.
Pri pouziti tlacitka Zrus nebo klavesy Esc funkce vraci '' (prazdny retezec).
Funkce zachova aktualni adresar, ve kterem jsme byli pred jejim zavolanim.
Krome vybirani souboru umi i vytvaret adresare a mazat soubory - viz napovedu
(pristupna pres F1 nebo prave mysitko).
Barvy: pole se seznamy souboru a adresaru a texty v nich jako Textovepole,
okraje stavoveho radku s cestou jako Okno, texty v okne jako texty u Anoneokna}
function VlozMaskuOkno(nadpis:nadpstr; default:word):word;
{Pro zadavani wordu po bitech - bitove masky pro caru z jedotky VESA.
Levym mysitkem se kresli, pravym maze. Kdyz date nadpis '', zobrazi se
'Maska Ÿ ry:'.}
procedure VlozVzorekOkno(nadpis:nadpstr; var vzorek:_pole8bytu);
{Pro zadavani 8bytoveho pole po bitech - bitove masky pro obdelnik z jednotky
VESA. Levym mysitkem se kresli, pravym maze. Kdyz date nadpis '', zobrazi se
'Vzorek vìplnØ:'}
procedure NastavMysOkno(ukladat:boolean);
{Necha uzivatele nastavit vodorovnou a svislou citlivost mysi, prohodit leve a
prave tlacitko a pripadne zapnout korekci pohybu, pokud se kurzor nepohybuje
plynule (nektere mysi ovladace to delaji). Parametr rika, jestli se ma dovolit
ukladani nastaveni do hlavniho konfiguracniho souboru (Cfgsoubor z jednotky
CFG).
Horke klavesy: Enter udela totez, co tlacitko "Nastav, ale neukladej",
Esc jako "Zrus". Sipky nahoru/dolu nastavuji svislou citlivost,
sipky doleva/doprava vodorovnou.}
procedure NastavKlOkno(Popisky:uknaradek; var Rozlozeni);
{Dialog pro prirazeni klavesovych kombinaci k danym akcim. Vystupem procedury
je pole kodu klaves, ktere uz si ve svem programu musite nejak zpracovat sami.
0 znamena nedefinovano (xreadkey nulu nikdy nevraci, takze zamena nehrozi).
 Popisky - nazvy jednotlivych akci; co radek, to jeden nazev. Maximalni delka
           jednoho je 20 znaku; pokud bude delsi, orizne se.
 Rozlozeni - pole kodu klaves: array[0..pocet_popisek-1] of word (kody od
             funkce xReadkey z jednotky Klavesy).
             Poradi kodu v poli samozrejme musi odpovidat poradi nazvu akci
             v Popiskach, jinak je procedura k nicemu.
             Kazda zmena, kterou uzivatel provede, se do tohoto pole okamzite
             uklada bez moznosti zruseni nebo vraceni.}

(***************************) implementation (*******************************)
uses klavesy2,errmsg,cfg;

function wzakladobj.zmeneno:boolean;
Begin
zmeneno:=_zmeneno;
_zmeneno:=false;
End;{wzakladobj.zmeneno}

procedure tlacitko.init(ix,iy:integer;inapis,ipopis:string;ipridavek:byte);
Begin
x:=ix; y:=iy;
napis:=inapis;
popis:=ipopis;
pridavek:=ipridavek;
hodnota:=0;
self.zobraz;
End;{tlacitko.init}

procedure tlacitko.zobraz;
Begin
_zmertext(napis);
sirka:=_sirkatextu+6;
vyska:=_vyskatextu+6+pridavek shl 1;
kvyp;
_box(x,y,x+sirka,y+vyska,tlhbarva,tpdbarva,tvbarva);
_print(x+3-_deltax,y+(vyska shr 1)-(_vyskatextu shr 1)-_deltay,ttxtbarva,napis);
kzap;
End;{tlacitko.zobraz}

procedure tlacitko.kontrola;
Begin
if mysvpoli(x,y,x+sirka,y+vyska) then
  begin
  hodnota:=stavtlacitek;{ulozeni, cim bylo kliknuto}
  if stavtlacitek<>0 then begin{animace kliknuti tlacitka}
                          kvyp;
                          _box(x,y,x+sirka,y+vyska,tpdbarva,tlhbarva,0);{stisknute - obracene stinovany ramecek}
                          kzap;
                          resetuj;{pockani na uvolneni mysi}
                          kvyp;
                          _box(x,y,x+sirka,y+vyska,tlhbarva,tpdbarva,0);{pusteno - normalni ramecek}
                          kzap;
                          end;
  if (hodnota=2)and(popis<>'') then begin{kdyz je zadany nejaky popis, zobrazi se a nebere se to jako kliknuti}
                                    infokno(xmys,ymys,popis,true);
                                    hodnota:=0;
                                    end;
  end
 else hodnota:=0;{mys je mimo tlacitko}
End;{tlacitko.kontrola}

procedure tlacitko2.init(ix,iy:integer; isirka,ivyska:word; ipopis:string; klid,stisk:pointer);
Begin
x:=ix; y:=iy;
sirka:=isirka; vyska:=ivyska;
obrazky[0]:=klid; obrazky[1]:=stisk;
popis:=ipopis;
hodnota:=0;
self.zobraz;
End;{tlacitko2.init}

procedure tlacitko2.zobraz;
Begin
kvyp;
_putimage(x,y,sirka,vyska,obrazky[0]);
kzap;
End;{tlacitko2.zobraz}

procedure tlacitko2.kontrola;
Begin
if mysvpoli(x,y,x+sirka-1,y+vyska-1)
  then begin
       hodnota:=stavtlacitek;
       if hodnota<>0 then begin {animace kliknuti}
                          kvyp;
                          _putimage(x,y,sirka,vyska,obrazky[1]); {stisknuto - druhy obrazek}
                          kzap;
                          resetuj; {pockani na uvolneni mysi}
                          kvyp;
                          _putimage(x,y,sirka,vyska,obrazky[0]); {pusteno - prvni obrazek}
                          kzap;
                          end;
       if (hodnota=2)and(popis<>'') then begin {pripadne zobrazeni popisu pri pravokliku}
                                         infokno(xmys,ymys,popis,true);
                                         hodnota:=0;
                                         end;
       end
  else hodnota:=0; {mys je mimo tlacitko}
End;{tlacitko2.kontrola}

procedure zatrzitko.init(ix,iy:integer;itextik,ipopis:string;ihodnota:boolean);
Begin
x:=ix; y:=iy;
textik:=itextik; popis:=ipopis;
hodnota:=ihodnota;
_zmeneno:=false;
self.zobraz;
End;{zatrzitko.init}

procedure KresliZatrzitko(_x,_y:word;jo:boolean);
Begin
if jo then begin
           _putpixel(_x+2,_y+4,zzbarva);
           _bar(_x+2,_y+5,_x+3,_y+6,zzbarva);
           _line(_x+3,_y+7,_x+8,_y+2,zzbarva);
           _line(_x+4,_y+7,_x+8,_y+3,zzbarva);
           _line(_x+4,_y+8,_x+8,_y+4,zzbarva);
           end
      else _bar(_x+1,_y+1,_x+9,_y+9,zvbarva);
End;{kreslizatrzitko}

procedure zatrzitko.zobraz;
Begin
_zmertext(textik);
sirka:=_sirkatextu+14;
vyska:=_vyskatextu; if vyska<10 then vyska:=10;
kvyp;
_box(x,y,x+10,y+10,zlhbarva,zpdbarva,zvbarva);
kreslizatrzitko(x,y,hodnota);
_print(x+14-_deltax,y+1-_deltay,ztxtbarva,textik);
kzap;
End;{zatrzitko.zobraz}

procedure zatrzitko.kontrola;
Begin
if mysvpoli(x,y,x+sirka,y+vyska) then
 if lmys then begin
              hodnota:=not hodnota;
              _zmeneno:=true;
              kvyp;
              kreslizatrzitko(x,y,hodnota);
              kzap;
              resetuj;
              end
         else if pmys and(popis<>'') then infokno(xmys,ymys,popis,true);
End;{zatrzitko.kontrola}

procedure prepinac.init(ix,iy:integer; inadpis,itexty,ipopis:string; ihodnota:byte);
var pocr:word;
Begin
x:=ix; y:=iy;
nadpis:=inadpis;
popis:=ipopis;
{$ifdef blbuvzdornost}
while itexty[1]='|' do delete(itexty,1,1);{orezani kravin ze zacatku}
while itexty[length(itexty)]='|' do dec(itexty[0]);{orezani kravin z konce}
 repeat{nalezeni a odstraneni prazdnych radku}
 i:=pos('||',itexty);
 if i<>0 then delete(itexty,i,1);
 until i=0;
{$endif}
{rozlozeni textu do radku:}
texty:=nil;
nactitexty(texty,itexty,250); {delka radku je tedy prakticky neomezena a je na vas, aby se pak vesly na obrazovku}
{pocatecni hodnota:}
pocr:=pocetradkuvseznamu(texty);
if ihodnota>pocr then hodnota:=pocr
                 else hodnota:=ihodnota;
_zmeneno:=false;
{zobrazeni:}
zobraz;
End;{prepinac.init}

procedure puntik(x,y:integer;barva:byte);{nakresli puntik do kolecka prepinace}
Begin
_hline(x+3,x+4,y+2,barva);
_bar(x+2,y+3,x+5,y+4,barva);
_hline(x+3,x+4,y+5,barva);
End;{puntik}

procedure prepinac.zobraz;
{}procedure kolecko(y:integer);{nakresli stinovane bile kolecko, x = x celeho prepinace}
{}Begin
{}_hline(x+2,x+5,y,plhbarva);{horni okraj}
{}_bar(x+1,y+1,x+6,y+6,pvbarva);{vnitrek}
{}_putpixel(x+1,y+1,plhbarva); _putpixel(x+6,y+1,plhbarva);{dva body u horniho kraje}
{}_vline(x,y+2,y+5,plhbarva); _vline(x+7,y+2,y+5,ppdbarva);{bocni strany}
{}_putpixel(x+1,y+6,ppdbarva); _putpixel(x+6,y+6,ppdbarva);{body u dolniho kraje}
{}_hline(x+2,x+5,y+7,ppdbarva);{spodni okraj}
{}End;{kolecko}
var i:word;
    vybrany:uknaradek;
Begin{prepinac.zobraz}
kvyp;
{vypocet rozmeru podle nastaveni textu:}
sirka:=_sirkatextu2(nejdelsiradek(texty))+12;{cili sirka nejdelsiho radku plus pridavek na klikaci kolecko}
vyskaradku:=_vyskatextu2+2;
{zobrazeni nadpisu:}
_zmertext(nadpis);
_print(x,y-_deltay-_vyskatextu-4,ptxtbarva,nadpis);
{vykresleni jednotlivych polozek:}
vybrany:=texty; i:=0;
while vybrany<>nil do begin
                      kolecko(y+i*vyskaradku);
                      _print(x+13,y+i*vyskaradku+1,ptxtbarva,vybrany^.obsah);
                      vybrany:=vybrany^.dalsi; inc(i);
                      end;
{oznaceni vybrane polozky:}
if hodnota<>0 then puntik(x,y+(hodnota-1)*vyskaradku,ppbarva);
kzap;
End;{prepinac.zobraz}

procedure prepinac.kontrola;
var NovaHodnota:integer;
    PocetRadku:word;
Begin
pocetradku:=pocetradkuvseznamu(texty);
if mysvpoli(x,y,x+sirka,y+pocetradku*vyskaradku) then{mys je nad aktivni oblasti prepinace}
 if lmys then begin{kliknuto levym tlacitkem - akce}
              {vypocet cisla radku z polohy mysi:}
              novahodnota:=((ymys-y)div vyskaradku)+1;
              {orezani teto hodnoty do rozumnych mezi (to kdyby treba nekdo kliknul a pak ujel mysi mimo oblast):}
              if novahodnota<1 then novahodnota:=1;
              if novahodnota>pocetradku then novahodnota:=pocetradku;
              if novahodnota<>hodnota
                then begin{kliklo se na jinou polozku nez byla oznacena minule}
                     _zmeneno:=true;
                     kvyp;
                     if hodnota<>0 then puntik(x,y+(hodnota-1)*vyskaradku,pvbarva);{vymazani puv. puntiku}
                     hodnota:=novahodnota;
                     puntik(x,y+(hodnota-1)*vyskaradku,ppbarva);{nakresleni noveho}
                     kzap;
                     end;
              resetuj;{cekani na pusteni mysi}
              end
         else if pmys then if popis<>'' then infokno(xmys,ymys,popis,true){kliknuto pravym tlacitkem - info}
                                        else resetuj;
End;{prepinac.kontrola}

procedure prepinac.zrus;
Begin
if texty<>nil{tahle kontrola sice neni stoprocentne ucinna, ale aspon zabrani ruseni prepinace vickrat po sobe}
  then zrustexty(texty);
End;{prepinac.zrus}


{Cela Roleta by teoreticky sla vyrobit z Textoveho pole, Tlacitka a Nabidky,
ale Nabidka je pro tyto ucely malo pruzna (bez posuvniku, zadavani jen z
jednoho retezce apod.), takze to musim rozepsat.}

procedure roleta.nuluj;
Begin
polozky:=nil;{procedura Nactitexty tohle nutne potrebuje, aby vedela, ze je seznam jeste prazdny}
vybrana:=nil;
hodnota:=0;
_zmeneno:=false;
End;{roleta.nuluj}

procedure roleta.PridejPolozky(zdroj:string);
Begin
nactitexty(polozky,zdroj,200);{odradkovavani polozek si (predpokladam) bude
 kazdy delat rucne, takze na sirce radku nezalezi}
End;{roleta.PridejPolozky}

procedure roleta.init(ix,iy:integer; ihodnota:word; ipopis:string);
var w:word;
Begin
x:=ix; y:=iy;
popis:=ipopis;
maxdelka:=nejdelsiradek(polozky);
if maxdelka<1 then maxdelka:=1;{pojistka proti nulove sirce}
maxhodnota:=pocetradkuvseznamu(polozky);
{nalezeni vybrane polozky:}
if (polozky=nil)or(ihodnota=0)
  then begin
       hodnota:=0;
       vybrana:=nil;
       end
  else begin
       hodnota:=1; vybrana:=polozky;
       while (vybrana<>nil)and(vybrana^.dalsi<>nil)and(hodnota<ihodnota) do
         begin
         vybrana:=vybrana^.dalsi;
         inc(hodnota);
         end;
       end;
zobraz;
End;{roleta.init}

procedure roleta.zobraz;
Begin
sirka1:=_sirkatextu2(maxdelka)+8;{sirka bileho pole s aktualnim vyberem}
sirka2:=sirka1+_sirkatextu2(1)+7;{sirka celeho objektu vcetne rozbalovaciho tlacitka}
vyska:=_vyskatextu2+6;
kvyp;
{textove pole:}
_box(x,y,x+sirka1,y+vyska,slhbarva,spdbarva,svbarva);
{obsah pole:}
if polozky=nil then begin{kdyz nejsou zadne moznosti, radsi okenko preskrtneme, aby to nevypadalo, ze nefunguje}
                    _line(x+1,y+1,x+sirka1-1,y+vyska-1,sskrtbarva);
                    _line(x+1,y+vyska-1,x+sirka1-1,y+1,sskrtbarva);
                    end
               else if vybrana<>nil then _print(x+4,y+3,stxtbarva,vybrana^.obsah);
{"tlacitko":}
_box(x+sirka1+1,y,x+sirka2,y+vyska,tlhbarva,tpdbarva,tvbarva);
_print(x+sirka1+4,y+3,ttxtbarva,'');
kzap;
End;{roleta.zobraz}

procedure roleta.kontrola;
var RadkuVRolete:byte;{max. pocet radku zobrazenych v rolete najednou}
    pozice:integer;{na jake strance zrovna jsme, cislovano od 0, odpovida po.hodnota}
    VyskaRolety:word;{[pix]}
    yRolety:integer;{yova souradnice leveho horniho rohu rozbalene rolety}
    i,j,k:word;{pocitadla}
    po:posuvnik;{posuvnik v rolete}
    PozRol:sprite;{pozadi rolety}
    koncit,{ukoncovaci podminka cyklu}
    pozadiB:boolean;{jestli se povedlo nacist pozadi rolety}
    p:uknaradek;{pomocny}
    aktivni:uknaradek;{ukazuje na radek, ktery je prave aktivni (je nad nim mys)}
    ap:integer;{index aktualne aktivni polozky v rolete pocitany od 0 od zacatku aktualni pozice; zaporny=nic}
{}procedure KresliRadek(index:byte; _aktivni:boolean; zdroj:uknaradek);{vykresli radek v rolete}
{}var bt,bp:byte;
{}    s:word;
{}Begin
{}if _aktivni then begin bt:=sratxtbarva; bp:=sravbarva; end
{}            else begin bt:=srntxtbarva; bp:=srvbarva; end;
{}if po.pocetpoloh=1 then s:=sirka2
{}                   else s:=sirka1;
{}_bar(x+1,yrolety+1+(_vyskatextu2+2)*index,x+s-1,yrolety+(_vyskatextu2+2)*(index+1),bp);
{}if zdroj<>nil then _print(x+2,yrolety+2+(_vyskatextu2+2)*index,bt,zdroj^.obsah);
{}End;{kresliradek}
Begin
if mysvpoli(x,y,x+sirka2,y+vyska) then
  if lmys and (polozky<>nil)
    then begin
         {vykresleni stisknuteho tlacitka:}
         kvyp;
         _box(x+sirka1+1,y,x+sirka2,y+vyska,tpdbarva,tlhbarva,0);
         {vypocet vysky rolety:}
         if maxhodnota<=10 then radkuvrolete:=maxhodnota
                           else begin
                                radkuvrolete:=10;
                                {vypocet optimalniho poctu radku v rolete:}
                                while maxhodnota div (radkuvrolete-1)=maxhodnota div radkuvrolete do dec(radkuvrolete);
         {tj. snizujeme pocet, dokud se nezvetsuje pocet stranek, cimz zmensime prazdne misto na konci posledni stranky rolety}
                                end;
         vyskarolety:=(_vyskatextu2+2)*radkuvrolete+2;
         if y+vyska+vyskarolety<_maxy then yrolety:=y+vyska+1 {roleta se rozbali normalne smerem dolu}
                                      else yrolety:=y-vyskarolety; {dole neni misto, rozbalime ji nahoru}
         pozadib:=pozrol.init(sirka2+1,vyskarolety);
         {zobrazeni rozbalene rolety:}
         pozrol.nacti(x,yrolety);
         _box(x,yrolety,x+sirka2,yrolety-1+vyskarolety,srlhbarva,srpdbarva,srvbarva);
         pozice:=(integer(hodnota)-1) div radkuvrolete;
         if pozice<0 then pozice:=0;
         po.pocetpoloh:=maxhodnota div radkuvrolete+ord(maxhodnota mod radkuvrolete>0);
         if po.pocetpoloh>1 then po.init(x+sirka1+1,yrolety,vyskarolety-2-2*vyska,po.pocetpoloh,pozice)
                            else po.hodnota:=pozice;
         p:=polozky;
         for i:=1 to pozice do
          for j:=1 to radkuvrolete do p:=p^.dalsi;
         kvyp;{posuvnik ho pri inicializaci zapnul}
         for i:=0 to radkuvrolete-1 do begin
                                       kresliradek(i,false,p);
                                       if p<>nil then p:=p^.dalsi;
                                       end;
         aktivni:=nil; ap:=-1;
         koncit:=false;
         kzap;
         resetuj;
         {interakce s uzivatelem:}
          repeat
          cekejnacokoli;
          if po.pocetpoloh>1 then po.kontrola;
          if stavtlacitek<>0 then begin
                                  if not mysvpoli(x,yrolety,x+sirka2,yrolety+vyskarolety-2) then aktivni:=nil;
                                  koncit:=true;
                                  end
           else if pozice<>po.hodnota then begin
                                           pozice:=po.hodnota;
                                           p:=polozky;
                                           for i:=1 to pozice do
                                            for j:=1 to radkuvrolete do p:=p^.dalsi;
                                           kvyp;
                                           for i:=0 to radkuvrolete-1 do
                                             begin
                                             kresliradek(i,false,p);
                                             if p<>nil then p:=p^.dalsi;
                                             end;
                                           kzap;
                                           aktivni:=nil;
                                           ap:=-1;
                                           end
            else if keypressed then case readkey of #13:koncit:=true;
                                                    #27:begin
                                                        aktivni:=nil;
                                                        koncit:=true;
                                                        end;
                                                    else kresetuj;
                                                    end
             else if mysvpoli(x,yrolety,x+sirka2,yrolety+vyskarolety-2)
                    then begin {mys se pohnula a je v oblasti rolety}
                         i:=(ymys-yrolety-1)div(_vyskatextu2+2);
                         kvyp;
                         {deaktivace aktivniho:}
                         if (ap>=0)and(i<>ap) then begin
                                                   kresliradek(ap,false,aktivni);
                                                   ap:=-1;
                                                   end;
                         {aktivace noveho:}
                         if ap<0 then begin
                                      ap:=i;
                                      j:=i+pozice*radkuvrolete;{skutecne cislo polozky}
                                      aktivni:=polozky;
                                      for k:=1 to j do if aktivni<>nil then aktivni:=aktivni^.dalsi;
                                      kresliradek(ap,true,aktivni);
                                      end;
                         kzap;
                         end
                    else begin {mys se pohnula a je mimo roletu}
                         if (aktivni<>nil)and(ap>=0) then begin{deaktivace aktivniho}
                                                          kvyp;
                                                          kresliradek(ap,false,aktivni);
                                                          kzap;
                                                          ap:=-1;
                                                          aktivni:=nil;
                                                          end;
                         end;
          until koncit;
         {smazani rolety:}
         kvyp;
         if pozadib then begin
                         pozrol.zobraz(x,yrolety);
                         pozrol.zrus;
                         end
                    else _bar(x,yrolety,x+sirka2,yrolety-1+vyskarolety,opozadinamazani);
         kzap;
         {vypocet hodnoty:}
         if aktivni<>nil then begin
                              vybrana:=polozky;
                              i:=1;
                              while vybrana<>aktivni do begin
                                                        inc(i);
                                                        vybrana:=vybrana^.dalsi;
                                                        end;
                              end
                         else i:=hodnota;
         self.zobraz;{potrebuje jenom ukazatel Vybrana, ne Hodnotu}
         resetuj;
         if i<>hodnota then begin
                            hodnota:=i;
                            _zmeneno:=true;
                            end;
         end
    else if pmys and (popis<>'') then infokno(xmys,ymys,popis,true);
End;{roleta.kontrola}

procedure roleta.zrus;
Begin
zrustexty(polozky);{ukazatel Polozky bude mit po tomhle hodnotu nil}
hodnota:=0;
vybrana:=nil;
End;{roleta.zrus}

procedure ciselnaosa.init(ix,iy:integer;isirka:word;imin,imax,ihodnota:longint;inadpis,itextmin,itextmax:string;
                          icisla:boolean;ipozadi:byte);
Begin
x:=ix; y:=iy;
sirka:=isirka;
min:=imin; max:=imax;
if max<=min then max:=min+1;{blbuvzdornost musi byt ;-)}
hodnota:=ihodnota;
_zmeneno:=false;
if hodnota<min then hodnota:=min    {-''-}
               else if hodnota>max then hodnota:=max;
nadpis:=inadpis; textmin:=itextmin; textmax:=itextmax;
psatcisla:=icisla;
pozadi:=ipozadi;
zobraz;
End;{ciselnaosa.init}

procedure ciselnaosa.zobraz;
var pomstr:string[11];
    pixhodnota:word;
Begin
{tlacitka:}
ubert.init(x,y,#17,'',0);
x2:=x+ubert.sirka+5;
pridejt.init(x2+sirka+4,y,#16,'',0);
kvyp;
{nadpisy:}
_zmertext(nadpis);                   {bez popisku pro min. a max. hodnotu:}
if (textmin='')and(textmax='') then _print(x2+(sirka-1) shr 1-_sirkatextu shr 1,y-_vyskatextu-2,cotxtbarva,nadpis)
                               else begin    {s popisky:}
                                    _print(x2+(sirka-1) shr 1-_sirkatextu shr 1,y-_vyskatextu2-_vyskatextu-4,
                                           cotxtbarva,nadpis);
                                    _print(x,y-_vyskatextu2-2,cotxtbarva,textmin);
                                    _print(pridejt.x+pridejt.sirka-_sirkatextu2(length(textmax)),y-_vyskatextu2-2,
                                           cotxtbarva,textmax);
                                    end;
{min. a max. hodnota ciselne:}
if psatcisla then begin
                  str(min,pomstr);
                  _print(x,y+ubert.vyska+3,cotxtbarva,pomstr);
                  str(max,pomstr);
                  _print(pridejt.x+pridejt.sirka-_sirkatextu2(length(pomstr)),y+ubert.vyska+3,cotxtbarva,pomstr);
                  end;
_bar(x2-3,y,x2+sirka+2,y+ubert.vyska,pozadi);{smazani posuvniku}
{"drazka" posuvniku:}
_box(x2,y+ubert.vyska shr 1-1,x2+sirka-1,y+ubert.vyska shr 1+1,colhbarva,copdbarva,covbarva);
_maskedline(x2,y+ubert.vyska shr 1+4,x2+sirka-1,y+ubert.vyska shr 1+4,cotxtbarva,$4040);
_maskedline(x2,y+ubert.vyska shr 1+5,x2+sirka-1,y+ubert.vyska shr 1+5,cotxtbarva,$4040);
{nakresleni toho posuvneho tentononcu:}
pixhodnota:=((hodnota-min)*sirka)div(max-min+1);{souradnice stredu ramecku od leveho kraje osy}
_box(x2+pixhodnota-3,y,x2+pixhodnota+3,y+ubert.vyska,tlhbarva,tpdbarva,tvbarva);
{vypsani aktualni hodnoty:}
if psatcisla then begin
                  str(hodnota,pomstr);
                  napis(x2+sirka shr 1-_sirkatextu2(length(pomstr)) shr 1,y+ubert.vyska+3,cotxtbarva,pozadi,pomstr);
                  end;
kzap;
End;{ciselnaosa.zobraz}

procedure ciselnaosa.kontrola;
{}procedure prekresli;{smaze posuvny obdelnicek a znovu ho vykresli ve spravne poloze}
{}var pixhodnota:word;{xova souradnice stredu obdelnicku pocitana od x2}
{}    pomstr:string[11];
{}Begin
{}if hodnota>max then hodnota:=max                  {kontrola rozsahu hodnoty}
{}               else if hodnota<min then hodnota:=min;
{}pixhodnota:=((hodnota-min)*sirka)div(max-min+1);{vypocet polohy obdelnicku z hodnoty}
{}kvyp;
{}_bar(x2-3,y,x2+sirka+2,y+ubert.vyska,pozadi);{smazani vseho}
{}{nakresleni drazky:}
{}_box(x2,y+ubert.vyska shr 1-1,x2+sirka-1,y+ubert.vyska shr 1+1,colhbarva,copdbarva,covbarva);
{}_maskedline(x2,y+ubert.vyska shr 1+4,x2+sirka-1,y+ubert.vyska shr 1+4,cotxtbarva,$4040);
{}_maskedline(x2,y+ubert.vyska shr 1+5,x2+sirka-1,y+ubert.vyska shr 1+5,cotxtbarva,$4040);
{}{nakresleni posuvneho ramecku:}
{}_box(x2+pixhodnota-3,y,x2+pixhodnota+3,y+ubert.vyska,tlhbarva,tpdbarva,tvbarva);
{}if psatcisla then    {vypis aktualni hodnoty pod osu}
{} begin
{} str(hodnota,pomstr);
{} pomstr:='  '+pomstr+'  ';
{} napis(x2+sirka shr 1-_sirkatextu2(length(pomstr)) shr 1,y+ubert.vyska+3,cotxtbarva,pozadi,pomstr);
{} end;
{}kzap;
{}End;{prekresli}
var PuvodniHodnota:longint;
Begin
puvodnihodnota:=hodnota;
ubert.kontrola; pridejt.kontrola;
if mysvpoli(x2,y,x2+sirka-1,y+ubert.vyska)
 then if lmys then begin
                   hodnota:=(((max-min+1)*(xmys-x2)) div sirka)+min;{vypocet hodnoty z polohy mysi}
                   prekresli;
                   end
              else if pmys then infokno(xmys,ymys,wt.dej(wtcohelp),true);
if ubert.hodnota<>0 then begin
                         if ubert.hodnota=1 then if shiftpressed then dec(hodnota,100)
                                                                 else dec(hodnota,1)
                                            else if ubert.hodnota=2 then if shiftpressed then dec(hodnota,1000)
                                                                                         else dec(hodnota,10);
                         prekresli;
                         ubert.hodnota:=0;
                         end;
if pridejt.hodnota<>0 then begin
                           if pridejt.hodnota=1 then if shiftpressed then inc(hodnota,100)
                                                                     else inc(hodnota,1)
                                                else if pridejt.hodnota=2 then if shiftpressed then inc(hodnota,1000)
                                                                                               else inc(hodnota,10);
                           prekresli;
                           pridejt.hodnota:=0;
                           end;
if hodnota<>puvodnihodnota then _zmeneno:=true;
End;{ciselnaosa.kontrola}

procedure posuvnik.init(ix,iy:integer;ivyska,ipocetpoloh,ihodnota:word);
Begin
x:=ix; y:=iy;
{dany pocet poloh - musi byt aspon jeden:}
if ipocetpoloh=0 then pocetpoloh:=1
                 else pocetpoloh:=ipocetpoloh;
{pocatecni poloha - pokud je mimo zadany rozsah, musi se mu prizpusobit:}
if ihodnota<=pocetpoloh-1 then hodnota:=ihodnota
                          else hodnota:=pocetpoloh-1;
{vyska jednoho bloku (a posuvneho ramecku) - musi byt aspon 1:}
vyskapolohy:=ivyska div pocetpoloh;
if vyskapolohy=0 then vyskapolohy:=1;
_zmeneno:=false;
self.zobraz;
End;{posuvnik.init}

procedure posuvnik.zobraz;
Begin
{horni tlacitko - urci rozmery posuvniku:}
nahorut.init(x,y,'','',0);
kvyp;
with nahorut do begin
                {stredni cast posuvniku:}
                _bar(x,y+vyska+1,x+sirka,y+vyska+pocetpoloh*vyskapolohy,posbarva);
                {posuvny ramecek:}
                _box(x,y+vyska+1+self.hodnota*vyskapolohy,x+sirka,y+vyska+self.hodnota*vyskapolohy+vyskapolohy,
                     tlhbarva,tpdbarva,tvbarva);
                end;
{dolni tlacitko:}
dolut.init(x,y+nahorut.vyska+vyskapolohy*pocetpoloh+1,'','',0);
End;{posuvnik.zobraz}

procedure posuvnik.kontrola;
{}procedure vykresli;
{}Begin
{}kvyp;
{}with nahorut do begin
{}                _bar(x,y+nahorut.vyska+1,x+nahorut.sirka,y+nahorut.vyska+pocetpoloh*vyskapolohy,posbarva);
{}                _box(x,y+nahorut.vyska+1+self.hodnota*vyskapolohy,x+nahorut.sirka,
{}                     y+nahorut.vyska+self.hodnota*vyskapolohy+vyskapolohy,tlhbarva,tpdbarva,tvbarva);
{}                end;
{}kzap;
{}End;{vykresli}
var PuvodniHodnota:word;
Begin{posuvnik.kontrola}
puvodnihodnota:=hodnota;
dolut.kontrola; nahorut.kontrola;
if mysvpoli(x,y+nahorut.vyska+1,x+nahorut.sirka,y+nahorut.vyska+pocetpoloh*vyskapolohy) and (stavtlacitek<>0)
 then begin
      hodnota:=(ymys-(y+nahorut.vyska+1)) div vyskapolohy;
      vykresli;
      resetuj;
      end
  else if (dolut.hodnota<>0)and(hodnota<pocetpoloh-1)then begin
                                                          inc(hodnota);
                                                          vykresli;
                                                          end
   else if (nahorut.hodnota<>0)and(hodnota>0) then begin
                                                   dec(hodnota);
                                                   vykresli;
                                                   end;
if hodnota<>puvodnihodnota then _zmeneno:=true;
End;{posuvnik.kontrola}

procedure hotspot.init(ia,ib,ic,id:integer; ires:boolean; ipopis:string);
Begin
a:=ia; b:=ib; c:=ic; d:=id; resetovat:=ires;
hodnota:=0; _zmeneno:=false; popis:=ipopis;
End;{hotspot.init}

procedure hotspot.kontrola;
var puvodnihodnota:byte;
    puvodnix,puvodniy:word;
Begin
hodnota:=puvodnihodnota; puvodnix:=xkliku; puvodniy:=ykliku;
if mysvpoli(a,b,c,d)
  then begin
       hodnota:=stavtlacitek;
       if (hodnota=2)and(popis<>'') then begin
                                         infokno(xmys,ymys,popis,true);
                                         hodnota:=0;
                                         end;
       if hodnota<>0 then begin
                          xkliku:=xmys-a;
                          ykliku:=ymys-b;
                          if resetovat then resetuj;
                          end;
       end
  else hodnota:=0;
if (hodnota<>puvodnihodnota)or(puvodnix<>xkliku)or(puvodniy<>ykliku) then _zmeneno:=true;
End;{hotspot.kontrola}

procedure hotspot.zobraz(barva:byte);
Begin
_rectangle(a,b,c,d,barva);
End;{hotspot.zobraz}

procedure textovepole.init(ix,iy:integer;imaxzn:byte;itext:string;iakt,iprosoubor:boolean);
Begin
x:=ix; y:=iy;
maxznaku:=imaxzn;
if length(itext)>maxznaku then itext[0]:=chr(maxznaku);{oriznuti retezce, pokud je moc dlouhy}
hodnota:=itext;
default:=itext;
_zmeneno:=false;
if iakt then stav:=_aktivni
        else stav:=_neaktivni;
pozice:=-1;{pro zacatek oznacime cely text}
prosoubor:=iprosoubor;
predchozi:=nil; dalsi:=nil;
self.zobraz;
End;{textovepole.init}

procedure textovepole.zobraz;
var rk:byte;
Begin
rk:=_ridicikody; _ridicikody:=_vypisovat;
{vypocet rozmeru:}
sirka:=maxznaku*__roztec+5;
vyska:=_vyskatextu2+5;
kvyp;
{ramecek:}
_box(x,y,x+sirka,y+vyska,tplhbarva,tppdbarva,tpvbarva);
if (stav=_aktivni)and(pozice>=0) then begin
                                      _print(x+4,y+3,tptxtbarva,hodnota);{text}
                                      _vline(x+3+__roztec*pozice,y+2,y+3+_vyskatextu2,tpkbarva);{kurzor}
                                      end
 else if (stav=_escapem)or((stav=_aktivni)and(pozice=-1)) then napis(x+4,y+3,tpozntxtbarva,tpozntxtpodbarva,hodnota)
  else _print(x+4,y+3,tptxtbarva,hodnota);{text bez kurzoru}                                            {oznaceny text}
kzap;
_ridicikody:=rk;
End;{textovepole.zobraz}

procedure textovepole.kontrola;
const povoleneznaky=[#33..#255]-['/','*','?','"','<','>','|']; {znaky povolene v nazvech souboru}
var o:char;{pro cteni klavesnice}
    pomstr:string[1];{kvuli Insertu (char mu nestaci)}
    puvodnihodnota:string;
    puvodnistav:byte;
Begin
puvodnistav:=stav; puvodnihodnota:=hodnota;
if (stav=_aktivni)or(stav=_escapem) then
  begin
  if stavtlacitek<>0 then if mysvpoli(x,y,x+sirka,y+vyska) then begin{nastaveni pozice pomoci mysi}
                                                                stav:=_aktivni;
                                                                pozice:=(xmys-x-3) div __roztec;
                                                                if pozice<0 then pozice:=0
                                                                 else if pozice>length(hodnota) then pozice:=length(hodnota);
                                                                zobraz;
                                                                end
                                                           else begin{deaktivace kliknutim mimo pole}
                                                                stav:=_odkliknutim;
                                                                zobraz;
                                                                end;
  if keypressed then
    begin
    o:=readkey;
    case o of #0:begin         {kurzorove klavesy}
                 case byte(readkey) of lsipka:if pozice>0 then dec(pozice)
                                                          else pozice:=0;
                                       psipka:if pozice<length(hodnota) then inc(pozice);
                                       {alt+sipky - psani sipek (funguje jen s jednotkou Enhkbd.tpu):}
                                       altpsipka:tokeybuf(#26);
                                       althsipka:tokeybuf(#24);
                                       altdsipka:tokeybuf(#25);
                                       altlsipka:{tady to musim rozepsat, protoze znak sipky doleva ma stejny kod jako Esc}
                                                 if pozice=-1 then begin
                                                                   hodnota:=#27;
                                                                   pozice:=1;
                                                                   stav:=_aktivni;
                                                                   end
                                                              else if length(hodnota)<maxznaku
                                                                     then begin
                                                                          insert(#27,hodnota,pozice+1);
                                                                          inc(pozice);
                                                                          end;
                                       del,ctrldel:if pozice=-1 then begin
                                                                     hodnota:='';
                                                                     pozice:=0;
                                                                     end
                                                                else delete(hodnota,pozice+1,1);
                                       home:pozice:=0;
                                       endk:pozice:=length(hodnota);
                                       15:begin
                                          stav:=_odkliknutim;
                                          if predchozi<>nil then with predchozi^ do begin
                                                                                    pozice:=-1;
                                                                                    stav:=_aktivni;
                                                                                    zobraz;
                                                                                    end;
                                          end;
                                       end;
                 end;
              #8:begin{backspace}
                 if pozice>0 then begin {smazat znak vlevo od kurzoru a kurzor o znak vlevo}
                                  delete(hodnota,pozice,1);
                                  dec(pozice);
                                  end
                             else if pozice=-1 then begin {text je oznaceny - smaze se cely}
                                                    hodnota:='';
                                                    pozice:=0;
                                                    end;
                                              {else kurzor je pred textem, takze neni co mazat}
                 stav:=_aktivni;
                 end;
              #9:begin{tabulator}
                 stav:=_odkliknutim;
                 if dalsi<>nil then with dalsi^ do begin
                                                   pozice:=-1;
                                                   stav:=_aktivni;
                                                   zobraz;
                                                   end;
                 end;
              #13:stav:=_enterem;{enter}
              #27:begin{escape}
                  stav:=_escapem;
                  pozice:=-1;
                  hodnota:=default;
                  end;
              else if not prosoubor or (o in povoleneznaky) then
                begin {ostatni znaky - psani}
                if pozice=-1 then begin {text je oznaceny, znak ho nahradi}
                                  hodnota:=o;
                                  pozice:=1;
                                  stav:=_aktivni;
                                  end
                             else if length(hodnota)<maxznaku then begin {pripsani na pozici kurzoru}
                                                                   pomstr:=o;
                                                                   insert(pomstr,hodnota,pozice+1);
                                                                   inc(pozice);
                                                                   end;
                end;
              end;{case o}
    zobraz;
    end;{if keypressed}
  end
 else {stav = _neaktivni, _enterem nebo _odkliknutim}
  if (stavtlacitek<>0)and mysvpoli(x,y,x+sirka,y+vyska) then
    begin {aktivace v pripade kliknuti mysi do pole}
    pozice:=-1;
    stav:=_aktivni;
    zobraz;
    end;
if hodnota<>puvodnihodnota then _zmeneno:=true;
End;{textovepole.kontrola}

procedure textovepole.nasmeruj(var shiftTab,Tab:textovepole);
Begin
predchozi:=@shifttab;
dalsi:=@tab;
End;{textovepole.nasmeruj}

procedure okno.init(ix,iy:integer;isirka,ivyska:word;nadpis:nadpstr);
var velikost:longint;
Begin
x:=ix; y:=iy;
sirka:=isirka; vyska:=ivyska;
bylkurzor:=kurzorb;
_zmertext(nadpis);
if (nadpis<>'')and(sirka<_sirkatextu+10) then sirka:=_sirkatextu+10;{rozsireni na sirku nadpisu}
velikost:=(sirka+1)*(vyska+1);
kvyp;
if (velikost<=65528)and(velikost<=maxavail) then begin
                                                 getmem(pozadiokna,velikost);
                                                 _getimage(x,y,x+sirka,y+vyska,pozadiokna);
                                                 end
                                            else pozadiokna:=nil;
_box(x,y,x+sirka,y+vyska,olhbarva,opdbarva,ovbarva);{okno}
y2:=y;
if nadpis<>'' then begin
                   _bar(x+2,y+2,x+sirka-3,y+_vyskatextu+4,oobdbarva);{prouzek pro nadpis}
                   _print(x+6-_deltax,y+4-_deltay,obarvanadpisu,nadpis);{nadpis}
                   inc(y2,_vyskatextu+4);{souradnice spodku nadpisu}
                   end;
End;{okno.init}

procedure okno.zrus;
Begin
kvyp;
if pozadiokna=nil then begin
                       _bar(x,y,x+sirka,y+vyska,opozadinamazani);
                       _pushtext;
                       _nastavfont(wokfont,true);
                       _print(x,y,oembarva,wt.dej(wtomalopameti));
                       _print(x,y+9,oembarva,wt.dej(wtomalopameti+1));
                       _poptext;
                       end
                  else begin
                       inc(sirka); inc(vyska);
                       _putimage(x,y,sirka,vyska,pozadiokna);
                       freemem(pozadiokna,sirka*vyska);
                       end;
if bylkurzor then kzap;
End;{okno.zrus}

procedure menu.init;
Begin
prvniradek:=nil; prvnipolozka:=nil; {bude to potreba}
hodnota:=0;
End;{menu.init}

procedure menu.pridejtext(textik:string);
Begin
nactitexty(prvniradek,textik,sirkamenu);{viz jednotku Retezce}
End;{menu.pridejtext}

procedure menu.pridejpolozku(textik:string);
var nova,posledni:uknapolozkumenu;
Begin
if textik='' then exit;{prazdne polozky neberem}
new(nova);{vytvoreni nove polozky}
{pripojeni do seznamu:}
nova^.dalsi:=prvnipolozka;{nova bude na konci a seznam je kruhovy, takze z konce se bude ukazovat zase na zacatek}
if prvnipolozka=nil then begin{bude to uplne prvni polozka seznamu}
                         prvnipolozka:=nova;
                         nova^.predchozi:=nova; nova^.dalsi:=nova;{ukazuje sama na sebe}
                         end
                    else begin{bude se zarazovat na konec jiz nacateho seznamu}
                         posledni:=prvnipolozka^.predchozi;{je to kruh, takze ted jsme na posledni polozce}
                         posledni^.dalsi:=nova;{drive posledni, ted predposledni a bude ukazovat na novou}
                         prvnipolozka^.predchozi:=nova;{zacatek je propojeny s koncem}
                         nova^.predchozi:=posledni;{a je hotovo}
                         end;
nova^.texty:=nil;{tohle je nutne, aby fungovala procedura Nactitexty}
nactitexty(nova^.texty,textik,sirkamenu);
End;{menu.pridejpolozku}

procedure menu.zrus;
var p:uknapolozkumenu;
Begin
{zruseni uvodniho textu:}
zrustexty(prvniradek);
if prvnipolozka=nil then exit;{jestli tam nejsou zadne polozky, tak neni co rusit}
{rozpojeni kruhoveho seznamu polozek:}
prvnipolozka^.predchozi^.dalsi:=nil;
{Ted je seznam linearni (konci Nilem). Ruseni jednotlivych polozek:}
 repeat{jestli jsme jeste tady, tak v seznamu urcite neco je, takze muzeme pouzit repeat}
 p:=prvnipolozka^.dalsi;
 zrustexty(prvnipolozka^.texty);
 dispose(prvnipolozka);
 prvnipolozka:=p;
 until prvnipolozka=nil;
End;{menu.zrus}

procedure menu.kontrola;
var x,y,y2:integer;{levy horni roh a pomocna yova souradnice}
    sirka,vyska,sirka2:word;{rozmery okna a pomocny rozmer}
    unp,vybrana:uknapolozkumenu;{pomocny ukazatel a ukazatel na aktivni polozku}
    unr:uknaradek;{pomocny ukazatel pro zobrazovani textu}
    nejdelsi:byte;{pro uchovani delky nejdelsiho radku}
    hotovo,bylkurzor:boolean;{ukoncovaci podminka hlavniho cyklu a promenna pro ulozeni stavu kurzoru}
{}procedure KresliTlacitko(ktere:uknapolozkumenu;vybrane,stisknute:boolean);
{}{Vykresli tlacitko. Pozor, nestara se o kurzor.}
{}var lh,pd,v,t:byte;{pomocne barvy}
{}    y3:integer;{pomocna souradnice}
{}Begin
{}if stisknute then begin                 {prirazeni spravnych barev}
{}                  lh:=mislhbarva;
{}                  pd:=mispdbarva;
{}                  v:=misvbarva;
{}                  t:=mistxtbarva;
{}                  end
{}             else if vybrane then begin
{}                                  lh:=mialhbarva;
{}                                  pd:=miapdbarva;
{}                                  v:=miavbarva;
{}                                  t:=miatxtbarva;
{}                                  end
{}                             else begin
{}                                  lh:=minlhbarva;
{}                                  pd:=minpdbarva;
{}                                  v:=minvbarva;
{}                                  t:=mintxtbarva;
{}                                  end;
{}with ktere^ do begin    {vykresleni}
{}               __box(x+3,lhy,x+sirka-3,pdy,lh,pd,v);
{}               y3:=lhy+2;
{}               unr:=texty;
{}                repeat{prazdne polozky nejsou, tak muzeme repeatovat}
{}                _print(x+7+ord(stisknute),y3+1+ord(stisknute),t,unr^.obsah);
{}                unr:=unr^.dalsi;
{}                inc(y3,_vyskatextu2+2);
{}                until unr=nil;
{}               end;
{}End;{kreslitlacitko}
Begin{menu.kontrola}
bylkurzor:=kurzorb;
if prvnipolozka=nil then pridejpolozku(wt.dej(wtmenuOK));{at tam je aspon neco}
{predbezne hodnoty:}
sirka:=_sirkatextu2(nejdelsiradek(prvniradek))+8;
vyska:=4+pocetradkuvseznamu(prvniradek)*(_vyskatextu2+2);
{konecny vypocet sirky a vysky:}
unp:=prvnipolozka;
 repeat
 inc(vyska,pocetradkuvseznamu(unp^.texty)*(_vyskatextu2+2)+8);{pricteme vysku kazde polozky}
 sirka2:=_sirkatextu2(nejdelsiradek(unp^.texty))+14;{zjistime jeji sirku...}
 if sirka2>sirka then sirka:=sirka2;{...a jestli je vetsi nez prve namerena, aktualizujeme ji}
 unp:=unp^.dalsi;
 until unp=prvnipolozka;{dokud nejsme zpatky na prvni polozce kruhoveho seznamu}
{Vysku a sirku mame. Ted poloha okna:}
x:=(_maxx shr 1)-(sirka shr 1);      {nekam na prostredek obrazovky}
y:=(_maxy shr 1)-(vyska shr 1);
{vykresleni okna:}
kvyp;
__box(x,y,x+sirka,y+vyska,mlhbarva,mpdbarva,mvbarva);
{uvodni text:}
unr:=prvniradek;
y2:=y+4;
while unr<>nil do begin
                  _print(x+4,y2,mtxtbarva,unr^.obsah);
                  inc(y2,_vyskatextu2+2);
                  unr:=unr^.dalsi;
                  end;
{polozky menu:}
unp:=prvnipolozka; vybrana:=prvnipolozka;
 repeat
 with unp^ do begin{inicializace souradnic}
              lhy:=y2;
              pdy:=y2+pocetradkuvseznamu(unp^.texty)*(_vyskatextu2+2)+4;
              y2:=pdy+4;
              end;
 kreslitlacitko(unp,unp=vybrana,false);{vykresleni tlacitka}
 unp:=unp^.dalsi;
 until unp=prvnipolozka;
{hlavni cyklus:}
kzap;
hotovo:=false;
resetuj;
 repeat
 kurzor; {cekani na klik nestaci, protoze se tlacitka aktivuji pri pouhem najeti kurzoru bez klikani}
 {mys:}
 unp:=prvnipolozka;
  repeat {musime projit cely seznam a kazde tlacitko zkontrolovat}
  with unp^ do if mysvpoli(x+3,lhy,x+sirka-3,pdy)and((vybrana<>unp)or(stavtlacitek=1)) then
     begin{pokud je mys nad nejakym tlacitkem a klikneme nebo pokud tam je a to tlacitko jeste neni aktivni}
     kvyp;
     kreslitlacitko(vybrana,false,false);{deaktivace puvodne aktivniho tlacitka}
     vybrana:=unp;{vyber noveho tlacitka}
     kreslitlacitko(vybrana,true,stavtlacitek=1);{kresleni tlacitka pod kurzorem}
     kzap;
     if stavtlacitek=1 then hotovo:=true;{pokud jsme na nej klikli, koncime}
     end;
  unp:=unp^.dalsi;
  until unp=prvnipolozka;
 {klavesnice:}
 if keypressed then begin
                    sirka2:=xreadkey;{promenna sirka2 uz neni potreba, tak se zneuzije pro klavesnici}
                    kvyp;
                    case sirka2 of xlsipka,xhsipka:begin{nahoru}
                                                   kreslitlacitko(vybrana,false,false);
                                                   vybrana:=vybrana^.predchozi;
                                                   kreslitlacitko(vybrana,true,false);
                                                   end;
                                   xpsipka,xdsipka,9:begin{dolu (9 je tabulator)}
                                                     kreslitlacitko(vybrana,false,false);
                                                     vybrana:=vybrana^.dalsi;
                                                     kreslitlacitko(vybrana,true,false);
                                                     end;
                                   13,32:begin{potvrzeni (13 = enter, 32 = mezernik)}
                                         kreslitlacitko(vybrana,true,true);
                                         hotovo:=true;
                                         end;
                                   end;
                    kzap;
                    end;
 until hotovo;
{spocitani, ktera polozka byla vybrana:}
unp:=prvnipolozka;
y2:=1;{y2 se vyuzije jako pomocny citac}
while unp<>vybrana do begin
                      inc(y2);
                      unp:=unp^.dalsi;
                      end;
hodnota:=y2;{ulozeni vyberu}
if not bylkurzor then kvyp;{kurzor byl do tedka zapnuty, takze ho takhle vratime do puvodniho stavu}
End;{menu.kontrola}


procedure konzole.init(ix,iy:word; idelkar,ipocetr:byte; ilog:string);
var p:byte;
    app:boolean; {jestli append nebo rewrite}
    velikost:word;
Begin
x:=ix; y:=iy; pocetradku:=ipocetr;
delkaradku:=idelkar; if delkaradku>100 then delkaradku:=100;
psacibuffer:=''; hodnotaint1:=0; hodnotaint2:=0; hodnotastr:='';
x0:=0; y0:=0; zoom:=100;
_zmeneno:=false;
{pamet pro texty:}
velikost:=(delkaradku+2)*pocetradku; {+2 = 1 B na 0. znak stringu a 1 na barvu}
if (velikost>maxavail)or(velikost>65528) then radky:=nil {chyba}
                                         else begin {OK}
                                              getmem(radky,velikost);
                                              fillchar(radky^,velikost,0);
                                              end;
{logovaci soubor:}
if ilog='' then logovat:=false
           else begin
                p:=pos(' ',ilog);
                app:=(p<>0)and(upcase(ilog[p+1])='A');
                if app then begin {budeme pripisovat k existujicimu souboru}
                            ilog[0]:=char(p-1);{uriznuti zbytku retezce za jmenem souboru}
                            if not existujesoubor(ilog) then app:=false;
                            end;
                assign(log,ilog);
                if app then begin
                            append(log);
                            writeln(log,kolikceho(40,'-'));{oddelovaci radek}
                            end
                       else rewrite(log);
                logovat:=ioresult=0;
                end;
self.zobraz;
End;{konzole.init}

procedure konzole.zobraz;
var i:word;
Begin
sirka:=delkaradku*__roztec+5;
vyska:=pocetradku*(_vyskatextu2+2)+3;
kvyp;
_box(x,y,x+sirka,y+vyska,konlhbarva,konpdbarva,konvbarva);
if radky<>nil
  then for i:=0 to pocetradku-1 do
        _print(x+3,y+2+i*(_vyskatextu2+2),
               radky^[i*(delkaradku+2)], {barva je prvni byte radku, tak nemusime chodit pres record}
               konzole_uknaradek(addr(radky^[i*(delkaradku+2)]))^.obsah); {obsah uz je dal a je to string, tak pretypujeme}
kzap;
End;{konzole.zobraz}

procedure konzole.Vloz(Hlaska:string; Barva,Cteni:byte; ZachovejMinule:boolean);
var i:byte;
Begin
if radky=nil then exit;
{pripsani pripadne minule hodnoty a kurzoru:}
if cteni<>0
  then begin
       if zachovejminule
         then begin {pripsani minulych hodnot za hlasku}
              hlaska:=hlaska+' <';
              if cteni=255 then hlaska:=hlaska+hodnotastr
                           else begin
                                hlaska:=hlaska+nastr(hodnotaint1);
                                if (cteni=2)or(cteni=3) then hlaska:=hlaska+','+nastr(hodnotaint2);
                                end;
              hlaska:=hlaska+'>';
              end
         else if cteni=255 then hodnotastr:=''   {vynulovani minulych hodnot}
                           else begin
                                hodnotaint1:=0;
                                if (cteni=2)or(cteni=3) then hodnotaint2:=0;
                                end;
       hlaska:=hlaska+' _'; {kurzor}
       psacibuffer:='';
       end;
{pripadne rozdeleni prilis dlouhe hlasky na vic radku:}
while length(hlaska)>delkaradku do
 begin
 i:=najdikonecradku(hlaska,1,delkaradku);
 vloz(left(hlaska,i),barva,0,zachovejminule);
 delete(hlaska,1,i);
 end;
{posun vseho o radek nahoru:}
for i:=0 to pocetradku-2 do move(radky^[(i+1)*(delkaradku+2)],radky^[i*(delkaradku+2)],delkaradku+2);
{vlozeni zadane hlasky na posledni radek:}
with konzole_uknaradek(addr(radky^[(pocetradku-1)*(delkaradku+2)]))^ do
 begin
 _barva:=barva;
 obsah:=hlaska;
 end;
zobraz;
zadavase:=cteni;
{pripadny zapis hlasky do logovaciho souboru:}
if logovat then begin
                for i:=1 to length(hlaska) do if hlaska[i]<#32 then hlaska[i]:='?'; {nebezpecne znaky nahradime otaznikem}
                writeln(log,hlaska);
                if ioresult<>0 then begin {pri chybe logovani ukoncime}
                                    close(log); if ioresult<>0 then {kaslu na to};
                                    logovat:=false;
                                    end;
                end;
End;{konzole.vloz}

procedure konzole.Pis(Hlaska:string; Barva:byte);
Begin
vloz(hlaska,barva,0,true);
End;{konzole.pis}

procedure konzole.kontrola;
var radek:string[100];
    pom:string[100];
    zn:char;
    cislo,kod:integer;
    PoziceCarky:byte;
    zobrazit:boolean;
{}procedure UlozRadek;{ulozi prave rozepsany radek i s napsanou hodnotou do pole a nahlasi konec zadavani}
{}Begin
{}konzole_uknaradek(addr(radky^[(pocetradku-1)*(delkaradku+2)]))^.obsah:=left(radek+psacibuffer,delkaradku);
{}_zmeneno:=true;
{}End;{ulozradek}
Begin{kontrola}
zobrazit:=false;
if radky<>nil
  then if (zadavase=3) and lmys then begin {zadani souradnic kliknutim}
                                     hodnotaint1:=(longint(xmys-x0)*100) div zoom;
                                     hodnotaint2:=(longint(ymys-y0)*100) div zoom;
                                     radek:=konzole_uknaradek(addr(radky^[(pocetradku-1)*(delkaradku+2)]))^.obsah;
                                     dec(radek[0]); {umazeme kurzor}
                                     psacibuffer:=nastr(hodnotaint1)+','+nastr(hodnotaint2);
                                     ulozradek;
                                     zadano:=zadavase;
                                     zadavase:=0;
                                     zobrazit:=true;
                                     end
                                else if (zadavase<>0) and keypressed
  then begin {vstup z klavesnice}
       radek:=konzole_uknaradek(addr(radky^[(pocetradku-1)*(delkaradku+2)]))^.obsah; {nacteme posledni radek v poli}
       dec(radek[0]); {posledni znak je kurzor, pryc s nim}
       zn:=readkey;
       case zn of #8:if psacibuffer<>'' then dec(psacibuffer[0]); {backspace}
                  #27:begin {escape}
                      psacibuffer:=wt.dej(wtkonzruseno); ulozradek;
                      zadano:=27;
                      zadavase:=0;
                      if logovat then writeln(log,wt.dej(wtkonzruseno));
                      end;
                  #13:if psacibuffer=''   {enter}
                        then begin {nechat minule hodnoty}
                             zadano:=zadavase;
                             zadavase:=0;
                             ulozradek;
                             end
                        else case zadavase of
                              255:begin {text}
                                  hodnotastr:=psacibuffer;
                                  zadano:=zadavase;
                                  zadavase:=0;
                                  ulozradek;
                                  end;
                              1:begin {jedno cislo}
                                val(psacibuffer,cislo,kod);
                                if kod=0 then begin
                                              hodnotaint1:=cislo;
                                              zadano:=zadavase;
                                              zadavase:=0;
                                              ulozradek;
                                              end
                                         else infokno(x+sirka shr 1,y+vyska shr 1,wt.dej(wtkonchybnezadanecislo),true);
                                end;
                              2,3:begin {dve cisla}
                                  pozicecarky:=pos(',',psacibuffer); {oddelena carkou?}
                                  if pozicecarky=0 then pozicecarky:=pos(' ',psacibuffer); {nebo aspon mezerou?}
                                  if pozicecarky=0
                                    then infokno(x+sirka shr 1,y+vyska shr 1,wt.dej(wtkonchybidruhecislo),true)
                                    else begin {OK, carku jsme nasli}
                                         val(left(psacibuffer,pozicecarky-1),cislo,kod);
                                         if kod=0 then begin
                                                       hodnotaint1:=cislo;
                                                       val(copy(psacibuffer,pozicecarky+1,100),cislo,kod);
                                                       if kod=0 then begin {obe cisla jsou OK}
                                                                     hodnotaint2:=cislo;
                                                                     zadano:=zadavase;
                                                                     zadavase:=0;
                                                                     ulozradek;
                                                                     end
                                                                else infokno(x+sirka shr 1,y+vyska shr 1,
                                                                             wt.dej(wtkonchybnedruhecislo),true);
                                                       end
                                                  else infokno(x+sirka shr 1,y+vyska shr 1,wt.dej(wtkonchybneprvnicislo),true);
                                         end;
                                  end;
                              end;
                  #0:begin {sipky}
                     zn:=readkey;
                     case ord(zn) of altlsipka:psacibuffer:=psacibuffer+#27;
                                     altpsipka:psacibuffer:=psacibuffer+#26;
                                     althsipka:psacibuffer:=psacibuffer+#24;
                                     altdsipka:psacibuffer:=psacibuffer+#25;
                                     end;
                     end;
                  #32..#255:psacibuffer:=psacibuffer+zn; {bezny napsatelny znak}
                  end;
       zobrazit:=true;
       end;
if zobrazit then begin
                 {slozime posledni radek:}
                 if zadavase=0
                   then pom:=left(radek+psacibuffer,delkaradku) {zobrazit bez kurzoru}
                   else if length(psacibuffer)+1>delkaradku {zobrazit s kurzorem}
                          then pom:=right(psacibuffer,delkaradku-1)+'_'
                          else if length(radek)+length(psacibuffer)+1>delkaradku
                                 then pom:=right(radek,delkaradku-length(psacibuffer)-1)+psacibuffer+'_'
                                 else pom:=radek+psacibuffer+'_';
                 {a zobrazime ho:}
                 _bar(x+1,y+2+(pocetradku-1)*(_vyskatextu2+2),x+sirka-1,y+vyska-1,konvbarva);
                 _print(x+3,y+2+(pocetradku-1)*(_vyskatextu2+2),radky^[(pocetradku-1)*(delkaradku+2)],pom);
                 end;
End;{konzole.kontrola}

procedure konzole._reset;
Begin
if zadavase<>0 then dec(konzole_uknaradek(addr(radky^[(pocetradku-1)*(delkaradku+2)]))^.obsah[0]); {kurzor pryc}
zadavase:=0; _zmeneno:=false;
zobraz;
End;{konzole._reset}

procedure konzole.zrus;
var velikost:word;
Begin
if radky<>nil then begin
                   velikost:=(delkaradku+2)*pocetradku;
                   freemem(radky,velikost);
                   end;
if logovat then begin
                close(log);
                if ioresult<>0 then {kaslu na to};
                end;
End;{konzole.zrus}


procedure infokno(ix,iy:integer;hlaska:string;resb:boolean);
var seznam,vybrany:uknaradek;{pro manipulaci s textem}
    sirka,vyska:word;{sirka a vyska okna, slouzi k vypoctum}
    i:byte;{pomocna}
    bylkurzor:boolean;{jestli byl pred volanim infokna zapnut kurzor mysi}
    r:pointer;{pro ulozeni pozadi okenka}
    velikost:longint;{mnozstvi pameti, ktere bude potreba na ulozeni pozadi okna}
Begin
while (hlaska<>'')and(hlaska[length(hlaska)]=' ') do dec(hlaska[0]); {odrezani zbytecnych mezer z konce}
if hlaska='' then exit;
seznam:=nil;{nutne}
nactitexty(seznam,hlaska,20);{rozlozeni zadaneho textu do radku (viz jednotku Retezce)}
sirka:=_sirkatextu2(nejdelsiradek(seznam))+11;{spocitani sirky...}
vyska:=pocetradkuvseznamu(seznam)*(_vyskatextu2+3)+3;{...a vysky okna}
dec(ix,(sirka shr 1));{protoze v parametrech ix a iy zadavame stred okna, musi se upravit na levy horni roh}
dec(iy,(vyska shr 1)); {(shr 1 je totez jako div 2, ale je to o trochu rychlejsi)}
if ix<0 then ix:=0; if (ix+sirka)>_maxx then ix:=_maxx-sirka;{tohle zajisti, ze je okno cele na obrazovce}
if iy<0 then iy:=0; if (iy+vyska)>_maxy then iy:=_maxy-vyska;
velikost:=(sirka+1)*(vyska+1);{velikost potrebne pameti pro pozadi okna}
bylkurzor:=kurzorb;{jestli se ma kurzor po skonceni procedury zapnout}
kvyp;
if velikost>=maxavail then r:=nil {pamet nestaci}
                      else begin  {pamet staci}
                           getmem(r,velikost); {alokace}
                           _getimage(ix,iy,ix+sirka,iy+vyska,r); {nacteni pozadi}
                           end;
_box(ix,iy,ix+sirka,iy+vyska,iolhbarva,iopdbarva,iovbarva);{vykresleni ramecku}
vybrany:=seznam;{skocime na prvni radek}
i:=0;{podle ni se bude pocitat y-ova souradnice radku}
 repeat
 _print(ix+6,iy+3+i*(_vyskatextu2+3),iobarvatextu,vybrany^.obsah);{vypsani radku}
 vybrany:=vybrany^.dalsi;{o radek v seznamu dal}
 inc(i);
 until vybrany=nil;{byl napsan posledni radek}
if bylkurzor then kzap;
resetuj; cekej;{ceka se na odkliknuti}
kvyp;
if r=nil then _bar(ix,iy,ix+sirka,iy+vyska,opozadinamazani)
         else begin                                          {smazani okna}
              _putimage(ix,iy,sirka+1,vyska+1,r);
              freemem(r,velikost);
              end;
if bylkurzor then kzap;
zrustexty(seznam);{smazani seznamu radku z pameti}
if resb then resetuj;{kdyz resb=false, zustane po odkliknuti okna stale
kliknuto=true. Infokno tak jde pouzit treba na zadani souradnic kliknutim}
End;{infokno}

function anoneokno(texty:string):boolean;
var prvni,vybrany:uknaradek;
    i:word;{pomocna}
    anoT,neT:tlacitko;
    ok:okno;
    ch:char;{pro cteni klaves}
    stav:(sNeurcen,sAno,sNe);{pomocna, pro zaverecny cyklus}
    maxdelka:word; pocetradku:byte;
    nadpis:string[50];
Begin
if texty='' then exit;
if dialogystandardnimfontem then begin
                                 _pushtext;
                                 _nastavfont(wokfont,true);
                                 end;
{osetreni nadpisu:}
if left(texty,3)='%%n' then begin
                            i:=4;
                            while (i+2<length(texty))and(copy(texty,i,3)<>'%%N')do inc(i);
                            if i+2<length(texty) then begin
                                                      nadpis:=copy(texty,4,i-4);
                                                      delete(texty,1,i+2);
                                                      end;
                            end
                       else nadpis:=wt.dej(wtdotaz);
prvni:=nil;
nactitexty(prvni,texty,50);{rozdeleni zadaneho textu do radku}
 repeat
 _zmertext(nadpis);
 if _sirkatextu<144 then nadpis:=nadpis+' ';{co kdyby byly vsechny texty tak uzke, ze by nebylo misto na tlacitka?}
 until _sirkatextu>=144;
maxdelka:=_sirkatextu2(nejdelsiradek(prvni));{nalezeni nejdelsiho, podle ktereho se urci sirka okna...}
if _sirkatextu>maxdelka then maxdelka:=_sirkatextu;{...a nebo podle nadpisu, pokud je jeste delsi}
pocetradku:=pocetradkuvseznamu(prvni);
ok.init((_maxx shr 1)-maxdelka shr 1,{x}
        (_maxy shr 1)-((_vyskatextu2+2)*pocetradku)shr 1-_vyskatextu-26,{y}
        maxdelka+10,{sirka}
        _vyskatextu+40+(_vyskatextu2+2)*pocetradku,{vyska}
        nadpis);
with ok do begin
           {zobrazeni textu:}
           vybrany:=prvni;
           i:=y2+4;
            repeat
            _print(x+5,i+1,txtbarva,vybrany^.obsah);
            vybrany:=vybrany^.dalsi;
            inc(i,_vyskatextu2+2);
            until vybrany=nil;
           {tlacitka:}
           _pushtext; _nastavfont(wokfont,true);{kvuli tlacitkum}
           anot.init(x+sirka div 5,y+vyska-23,wt.dej(wtano),wt.dej(wtanohelp),2);
           net.init(x+sirka-sirka div 5-45,y+vyska-23,wt.dej(wtne),wt.dej(wtnehelp),2);
           end;
kzap;
ch:=' '; stav:=sneurcen;
 repeat{cekani na reakci uzivatele}
 resetuj;cekej;
 anot.kontrola; net.kontrola;
 if anot.hodnota=1 then stav:=sano;
 if net.hodnota=1 then stav:=sne;
 if keypressed then begin
                    ch:=readkey;
                    if (ch=#13)or(upcase(ch)=wt.dej(wtanoznak)) then stav:=sano
                     else if (ch=#27)or(upcase(ch)=wt.dej(wtneznak)) then stav:=sne;
                    end;
 until stav<>sneurcen;
_poptext;
anoneokno:=stav=sAno;
ok.zrus;
zrustexty(prvni);
if dialogystandardnimfontem then _poptext;
resetuj;
End;{anoneokno}

procedure okokno(texty:string);
var prvni,vybrany:uknaradek;
    i:word; ch:char;
    maxdelka:word; pocetradku:byte;
    Oukej:tlacitko;
    ok:okno;
    nadpis:string[50];
Begin
if texty='' then exit;
if dialogystandardnimfontem then begin
                                 _pushtext;
                                 _nastavfont(wokfont,true);
                                 end;
if left(texty,3)='%%n' then begin
                            i:=4;
                            while (i+2<length(texty))and(copy(texty,i,3)<>'%%N')do inc(i);
                            if i+2<length(texty) then begin
                                                      nadpis:=copy(texty,4,i-4);
                                                      delete(texty,1,i+2);
                                                      end;
                            end
                       else nadpis:=wt.dej(wtzprava);
prvni:=nil;
nactitexty(prvni,texty,50);
 repeat
 _zmertext(nadpis);
 if _sirkatextu<50 then nadpis:=nadpis+' ';{co kdyby byly vsechny texty tak uzke, ze by nebylo misto na tlacitka?}
 until _sirkatextu>=50;
maxdelka:=_sirkatextu2(nejdelsiradek(prvni));
if _sirkatextu>maxdelka then maxdelka:=_sirkatextu;
pocetradku:=pocetradkuvseznamu(prvni);
ok.init((_maxx shr 1)-(maxdelka shr 1),{x}
        (_maxy shr 1)-((_vyskatextu2+2)*pocetradku)shr 1-_vyskatextu-26,{y}
        maxdelka+10,{sirka}
        _vyskatextu+40+(_vyskatextu2+2)*pocetradku,{vyska}
        nadpis);
with ok do begin
           vybrany:=prvni;
           i:=y2+4;
            repeat
            _print(x+5,i+1,txtbarva,vybrany^.obsah);
            vybrany:=vybrany^.dalsi;
            inc(i,_vyskatextu2+2);
            until vybrany=nil;
           _pushtext; _nastavfont(wokfont,true);{kvuli tlacitku}
           oukej.init(x+(sirka shr 1)-27,y+vyska-23,wt.dej(wtok6),wt.dej(wtokhelp),2);
           end;
kzap;
 repeat
 resetuj; cekej;
 oukej.kontrola;
 if keypressed then ch:=readkey else ch:=#0;
 until (oukej.hodnota=1)or(ch=' ')or(ch=#13)or(upcase(ch)=wt.dej(wtokznak));
_poptext;
ok.zrus;
zrustexty(prvni);
if dialogystandardnimfontem then _poptext;
resetuj;
End;{okokno}

function vloztextokno(nadpis:nadpstr;maxzn:byte;defaulttext:string;prosoubor:boolean):string;
var v:okno;
    tp:textovepole;
    okt,cancelt:tlacitko;
    okb,cancelb:boolean;
    delka:byte;
    o:char;
    puvrk:byte;
Begin
wokzruseno:=false;
puvrk:=_ridicikody;
_ridicikody:=_vypisovat;
if nadpis='' then nadpis:=wt.dej(wtzadejtext);
if dialogystandardnimfontem then begin
                                 _pushtext;
                                 _nastavfont(wokfont,true);
                                 end;
while _sirkatextu2(length(nadpis))<77 do nadpis:=nadpis+' ';
delka:=length(nadpis); if maxzn>delka then delka:=maxzn;
v.init(_maxx shr 1-(_sirkatextu2(delka) shr 1+5),_maxy shr 1-30,delka*__roztec+10,_vyskatextu2 shl 1+35,nadpis);
with v do begin
          tp.init(x+2,y2+3,maxzn,defaulttext,true,prosoubor);
          _pushtext;
          _nastavfont(wokfont,true);
          okt.init(x+sirka-88,y+vyska-20,wt.dej(wtok4),wt.dej(wtvltoknookhelp),1);
          cancelt.init(x+sirka-42,y+vyska-20,wt.dej(wtzrus),wt.dej(wtvltoknozrushelp),1);
          _lodtext;
          end;
okb:=false; cancelb:=false; resetuj;
 repeat
 cekej;
 tp.kontrola;
 _nastavfont(wokfont,true);{pro spravne zobrazeni diakritiky v popisech tlacitek}
 okt.kontrola; cancelt.kontrola;
 _lodtext;
 if keypressed then o:=readkey else o:=#0;
 if (okt.hodnota=1)or(tp.stav=_enterem)or(o=#13) then okb:=true;
 if (cancelt.hodnota=1)or(tp.stav=_escapem)or(o=#27) then cancelb:=true;
 resetuj;
 until okb or cancelb;
_poptext;
if okb then vloztextokno:=tp.hodnota
       else begin
            vloztextokno:=defaulttext;
            wokzruseno:=true;
            end;
v.zrus;
if dialogystandardnimfontem then _poptext;
_ridicikody:=puvrk;
End;{vloztextokno}

function vlozcislookno(nadpis:nadpstr;_od,_do,default:longint):longint;
var ok:okno;
    okt,cancelt,pridejt,ubert:tlacitko;
    tp:textovepole;
    okb,cancelb:boolean;
    kod:integer;
    vysledek:longint;
    pomstr:string[11];
    o:char;
    puvrk:byte;
Begin
wokzruseno:=false;
puvrk:=_ridicikody;
_ridicikody:=_vypisovat;
if dialogystandardnimfontem then begin
                                 _pushtext;
                                 _nastavfont(wokfont,true);
                                 end;
if default<_od then default:=_od;
if default>_do then default:=_do;
resetuj;
okb:=false; cancelb:=false;
if nadpis='' then nadpis:=wt.dej(wtzadejcislo);
while _sirkatextu2(length(nadpis))<77 do nadpis:=nadpis+' ';
{vypocet delky cisla:}
str(_od,pomstr);
kod:=length(pomstr);
str(_do,pomstr);
if length(pomstr)>kod then kod:=length(pomstr);{bereme nejdelsi moznost}
{okno a spol.:}
_zmertext(nadpis);
ok.init(_maxx shr 1-(_sirkatextu shr 1+5),_maxy shr 1-30,kod*__roztec+10,_vyskatextu2+_vyskatextu+35,nadpis);
str(default,pomstr);
with ok do begin
           tp.init(x+2,y2+3,kod,pomstr,true,true);
           _pushtext;
           _nastavfont(wokfont,true);
           okt.init(x+sirka-88,y+vyska-20,wt.dej(wtok4),wt.dej(wtvlcoknookhelp),1);
           cancelt.init(x+sirka-42,y+vyska-20,wt.dej(wtzrus),wt.dej(wtvlcoknozrushelp),1);
           _lodtext;
           end;
 repeat
 cekej;
 tp.kontrola;
 _nastavfont(wokfont,true);
 okt.kontrola; cancelt.kontrola;
 _lodtext;
 if keypressed then o:=readkey else o:=#0;
 if (okt.hodnota=1)or(tp.stav=_enterem)or(o=#13) then okb:=true;
 if (cancelt.hodnota=1)or(tp.stav=_escapem)or(o=#27) then cancelb:=true;
 if okb then with tp do
              repeat
              val(hodnota,vysledek,kod);
              if (kod<>0)and(hodnota<>'') then
                begin
                delete(hodnota,kod,1);{hezky natvrdo}
                okb:=false;
                stav:=_aktivni;
                pozice:=length(hodnota);
                zobraz;
                end;
              until (kod=0)or(hodnota='');
 resetuj;
 until okb or cancelb;
_poptext;
if okb then begin
            if vysledek<_od then vysledek:=_od;
            if vysledek>_do then vysledek:=_do;
            vlozcislookno:=vysledek;
            end
       else begin
            vlozcislookno:=default;
            wokzruseno:=true;
            end;
ok.zrus;
if dialogystandardnimfontem then _poptext;
_ridicikody:=puvrk;
End;{vlozcislookno}

function nabidka(ix,iy:integer;texty:string):byte;
type uknaradek=^radek;
     radek=record
           textik:string[30];
           a,b,c,d:integer;{jako u Hotspotu}
           dalsi,predchozi:uknaradek;
           end;
var prvni,vybrany:uknaradek;
    ok:okno;
    max,{delka nejdelsiho radku}
    pocetradku,pocetcar:byte;
    z:char;
    s,v,{pro vypocet rozmeru ramecku}
    i:word;{pomocna}
    koncit,bylkurzor:boolean;
{}procedure ctiradek;{cte radky z retezce Texty a zapisuje je do linearniho seznamu}
{}var ret:string[30];
{}Begin
{}ret:='';
{} repeat
{} inc(i);{pozice v retezci texty}
{} ret:=ret+texty[i];{precteni jednoho znaku}
{} until (texty[i]='|')or(i>=length(texty));{konci se pri precteni | nebo dojeti na konec textu}
{}while ret[length(ret)] in ['|',' '] do dec(ret[0]);{odriznuti prebytecnych znaku}
{}while ret[1]=' 'do delete(ret,1,1);
{}vybrany^.textik:=ret;
{}if i<length(texty) then begin{vytvoreni noveho radku v pameti}
{}                        new(vybrany^.dalsi);
{}                        vybrany^.dalsi^.predchozi:=vybrany;
{}                        vybrany:=vybrany^.dalsi;
{}                        vybrany^.dalsi:=nil;
{}                        end;             {nedostatek pameti nepredpokladam}
{}End;{ctiradek}
{}procedure kresliradek(oznacit:boolean);{kresli radek, na ktery ukazuje Vybrany}
{}Begin
{}kvyp;
{}with vybrany^ do begin
{}                 if textik='-' then begin{cara}
{}                                    _hline(a,c,b+2,nhbarva);
{}                                    _hline(a,c,b+3,ndbarva);
{}                                    end
{}                               else if oznacit then begin     {text}
{}                                                    _bar(a,b,c,d,nozntxtpodbarva);
{}                                                    _print(a+3,b+3,nozntxtbarva,textik);
{}                                                    end
{}                                               else begin
{}                                                    _bar(a,b,c,d,ovbarva);
{}                                                    _print(a+3,b+3,ntxtbarva,textik);
{}                                                    end;
{}                 end;
{}kzap;
{}End;{kresliradek}
{}function spocitej:byte;{spocita, kolikata polozka je oznacena}
{}var pom:uknaradek;
{}    cislo:byte;
{}Begin
{}pom:=prvni;
{}cislo:=1;
{}while pom<>vybrany do begin
{}                      if pom^.textik<>'-'then inc(cislo);
{}                      pom:=pom^.dalsi;
{}                      end;
{}spocitej:=cislo;
{}End;{spocitej}
Begin{nabidka}
{orezani prebytecnych znaku ze zacatku a konce vstupniho retezce:}
while texty[length(texty)] in [' ','|','-'] do dec(texty[0]);
while texty[1] in [' ','-','|'] do delete(texty,1,1);
if texty='' then exit;{nema cenu zobrazovat prazdne okno}
if dialogystandardnimfontem then begin
                                 _pushtext;
                                 _nastavfont(wokfont,true);
                                 end;
resetuj;
{nacteni radku ze vstupniho retezce:}
new(prvni); prvni^.predchozi:=nil; prvni^.dalsi:=nil; prvni^.textik:='';
vybrany:=prvni; i:=0;
 repeat ctiradek until i>=length(texty);
vybrany:=prvni; i:=1; pocetradku:=0; pocetcar:=0; max:=0;
 repeat{spocitani radku a nalezeni nejdelsiho}
 with vybrany^ do begin
                  if textik='-' then begin{je to rozdelovaci cara}
                                     inc(pocetcar);
                                     inc(i,6);
                                     end
                                else begin{je to text}
                                     inc(pocetradku);
                                     inc(i,14);
                                     end;
                  if max<length(textik)then max:=length(textik);
                  end;
 vybrany:=vybrany^.dalsi;
 until vybrany=nil;
s:=_sirkatextu2(max)+6;{sirka ramecku}
v:=(_vyskatextu2+6)*pocetradku+6*pocetcar+4;{vyska ramecku}
if ix<0 then ix:=0 else if ix>_maxx-s then ix:=_maxx-s;{pojistka proti vycuhovani z obrazovky}
if iy<0 then iy:=0 else if iy>_maxy-v then iy:=_maxy-v;
vybrany:=prvni; i:=1;
 repeat{inicializace klikacich oblasti}
 with vybrany^ do begin
                  if textik='-' then begin{je to rozdelovaci cara}
                                     d:=iy+i+5;
                                     b:=iy+i;
                                     inc(i,6);
                                     end
                                else begin{je to text}
                                     d:=iy+i+_vyskatextu2+5;
                                     b:=iy+i;
                                     inc(i,_vyskatextu2+6);
                                     end;
                  a:=ix+1; c:=ix+s-1;
                  end;
 vybrany:=vybrany^.dalsi;
 until vybrany=nil;
bylkurzor:=kurzorb;
ok.init(ix,iy,s,v,'');{zobrazeni okenka}
{vypsani radku:}
vybrany:=prvni; i:=1; {na zacatku je oznacena prvni polozka}
 repeat
 kresliradek(i=1);
 vybrany:=vybrany^.dalsi; inc(i);
 until vybrany=nil;
koncit:=false; vybrany:=prvni;
 repeat{hlavni cyklus}
 cekejnacokoli;
 if keypressed then
   begin
   case readkey of #0:case readkey of #72:if vybrany<>prvni then begin{nahoru}
                                                                 kresliradek(false);
                                                                  repeat
                                                                  vybrany:=vybrany^.predchozi;
                                                                  until vybrany^.textik<>'-';
                                                                 kresliradek(true);
                                                                 end;
                                      #80:if vybrany^.dalsi<>nil then begin{dolu}
                                                                      kresliradek(false);
                                                                       repeat
                                                                       vybrany:=vybrany^.dalsi;
                                                                       until vybrany^.textik<>'-';
                                                                      kresliradek(true);
                                                                      end;
                                      end;
                   #13:begin{Enter}
                       nabidka:=spocitej;
                       koncit:=true;
                       end;
                   #27:begin{Escape}
                       nabidka:=0;
                       koncit:=true;
                       end;
                   end;
   end{if keypressed}
               else begin
                    if lmys then begin{bylo kliknuto, pocita se jen leve mysitko}
                                 if mysvpoli(ix,iy,ix+s,iy+v)then begin{mys je nad oknem}
                                                                  if vybrany^.textik<>'-'then
                                                                    begin
                                                                    nabidka:=spocitej;
                                                                    koncit:=true;
                                                                    end;
                                                                  end
                                                             else begin{kliklo se vedle}
                                                                  nabidka:=0;
                                                                  koncit:=true;
                                                                  end;
                                 end
                            else begin{jen se pohnula mys}
                                 with vybrany^ do if not mysvpoli(a,b,c,d) then kresliradek(false);
                                 vybrany:=prvni;
                                 while (vybrany<>nil)and not mysvpoli(vybrany^.a,vybrany^.b,vybrany^.c,vybrany^.d)do
                                  vybrany:=vybrany^.dalsi;
                                 if vybrany=nil then vybrany:=prvni{neukazujeme na nic}
                                                else kresliradek(true);{ukazujeme na nejaky radek}
                                 end;
                    end;
 until koncit;{konec hlavniho cyklu}
ok.zrus;{zruseni ramecku}
while prvni<>nil do begin{vycisteni pameti}
                    vybrany:=prvni;
                    prvni:=prvni^.dalsi;
                    dispose(vybrany);
                    end;
if dialogystandardnimfontem then _poptext;
if bylkurzor then kzap;
End;{nabidka}

function vyberbarvuokno(nadpis:nadpstr;default:byte):byte;
var ok:okno;
    vybrana,vybrana2:integer;
    okt,cancelt:tlacitko;
    hotovo:boolean;
    o:word;{na cteni klaves}
    i,j:word;
    lhx,lhy:word;{souradnice}
Begin
wokzruseno:=false;
lhx:=(_maxx shr 1)-80; lhy:=(_maxy shr 1)-45;
resetuj;
if nadpis='' then nadpis:=wt.dej(wtvyberbarvu);
if dialogystandardnimfontem then begin
                                 _pushtext;
                                 _nastavfont(wokfont,true);
                                 end;
vybrana:=default; vybrana2:=vybrana; hotovo:=false;
_zmertext(nadpis);
ok.init(lhx-3,lhy-_vyskatextu-7,165,188+_vyskatextu,nadpis);{okno}
_pushtext; _nastavfont(wokfont,true);
with ok do begin
           for i:=0 to 15 do for j:=0 to 15 do {barvy}
             _bar(lhx+10*j,lhy+10*i,lhx+10*j+9,lhy+10*i+9,i shl 4+j);
           okt.init(lhx,lhy+162,wt.dej(wtok10),wt.dej(wtokbarvyhelp),1);  {tlacitka}
           cancelt.init(lhx+121,lhy+162,wt.dej(wtzrus),wt.dej(wtzrusbarvuhelp),1);
           end;
 repeat
 {znacka:}
 _rectangle((vybrana and 15)*10+lhx+1,(vybrana shr 4)*10+lhy+1,(vybrana and 15)*10+lhx+9,(vybrana shr 4)*10+lhy+9,0);
 _rectangle((vybrana and 15)*10+lhx,(vybrana shr 4)*10+lhy,(vybrana and 15)*10+lhx+8,(vybrana shr 4)*10+lhy+8,14);
 napis(lhx+93,lhy+166,txtbarva,ovbarva,nastr2(vybrana,3));{vypis cisla barvy}
 kzap;
 resetuj; cekej;
 if stavtlacitek<>0 then begin
                         if mysvpoli(lhx,lhy,lhx+159,lhy+159)
                          then vybrana2:=(xmys-lhx) div 10+((ymys-lhy) div 10)shl 4;{vyber barvy mysi}
                         okt.kontrola; cancelt.kontrola;
                         if okt.hodnota=1 then hotovo:=true;
                         if cancelt.hodnota=1 then begin
                                                   vybrana2:=default;
                                                   hotovo:=true;
                                                   end;
                         end
                    else begin {vyber klavesnici}
                         i:=xreadkey;
                         if (upcase(chr(i))=wt.dej(wtokznak))or(i=13) then hotovo:=true{Enter}
                          else if (upcase(chr(i))=wt.dej(wtzrusznak))or(i=27) then begin{Escape}
                                                                                   vybrana2:=default;
                                                                                   wokzruseno:=true;
                                                                                   hotovo:=true;
                                                                                   end
                           else case i of
                                 xlsipka:if vybrana2>0 then dec(vybrana2) else vybrana2:=255;
                                 xpsipka:if vybrana2<255 then inc(vybrana2) else vybrana2:=0;
                                 xhsipka:begin
                                         dec(vybrana2,16);
                                         if vybrana2<0 then inc(vybrana2,256);
                                         end;
                                 xdsipka:begin
                                         inc(vybrana2,16);
                                         if vybrana2>255 then dec(vybrana2,256);
                                         end;
                                 xhome:dec(vybrana2,vybrana2 and 15);{konec radku}
                                 xend:inc(vybrana2,integer(15)-vybrana2 and 15);{zacatek radku}
                                 end;
                         end;
 kvyp;
 {zruseni znacky:}
 _bar((vybrana and 15)*10+lhx,(vybrana shr 4)*10+lhy,(vybrana and 15)*10+lhx+9,(vybrana shr 4)*10+lhy+9,vybrana);
 vybrana:=vybrana2;
 until hotovo;
vyberbarvuokno:=vybrana;
_poptext;
ok.zrus;
if dialogystandardnimfontem then _poptext;
End;{vyberbarvuokno}

procedure zjistujsouradnice;
const vlevo=10;
var bylkurzor:boolean;
    ok:okno;
    px:integer;{pomocna x-ova souradnice}
    mx,my:integer;
    vpravo:word;{pomocna souradnice}
{}procedure vypis;{vypise do okenka souradnice kurzoru}
{}Begin
{}with ok do _box(x,y,x+sirka,y+vyska,iolhbarva,iopdbarva,iovbarva);{smazani starych cisel}
{}_print(ok.x+3,ok.y+2,iobarvatextu,nastr2(xmys,3)+':'+nastr2(ymys,3));{vypsani novych cisel do okenka}
{}End;{vypis}
Begin{zjistujsouradnice}
_pushtext; _nastavfont(wokfont,true);
vpravo:=_maxx-89;
bylkurzor:=kurzorb;{ulozeni kurzoru}
kvyp;
resetuj;
if xmys>320 then px:=vlevo else px:=vpravo;{urceni polohy okenka}
ok.init(px,_maxy-29,60,12,'');
mx:=xmys; my:=ymys;
vypis;
 repeat
 {zamerovaci kriz:}
 _xorhline(0,_maxx,my,15);
 _xorvline(mx,0,_maxy,15);
  repeat
  kurzor;
  until (xmys<>mx)or(ymys<>my)or(stavtlacitek<>0)or keypressed;
 _xorhline(0,_maxx,my,15);
 _xorvline(mx,0,_maxy,15);
 mx:=xmys; my:=ymys;
 if (abs(xmys-(px+30))<40)and(ymys>_maxy-59) then begin{pokud se kurzorem blizime k okenku...}
                                                  ok.zrus;{...presune se na druhy konec obrazovky, aby neprekazelo:}
                                                  if px=vlevo then px:=vpravo
                                                              else px:=vlevo;
                                                  ok.init(px,_maxy-29,60,12,'');
                                                  end;
 vypis;
 until (stavtlacitek<>0)or keypressed;
ok.zrus;
if bylkurzor then kzap;
_poptext;
End;{zjistujsouradnice}

function VyberSouborOkno(Nadpis:nadpstr; Cesta:dirstr; Masky:string; ProUkladani:boolean):pathstr;
const vecinaokno=10; {kolik radku ma oblast se seznamem souboru}
      vyskaveci=11; {vyska jednoho radku v px}
type string12=string[12];
var Prvni, {ukazatel na uplny zacatek seznamu adresaru a souboru}
    PrvniVOkne, {ukazatel na adresar/soubor, ktery je v okne na prvnim radku}
    Vybrany, {ukazatel na prave vybrany (zamodreny) adresar nebo soubor}
    pomocny:uknasoubor; {pro alokace, mazani, prochazeni apod.}
    pozice:word; {pomocna a pro ukladani pozice okna nad seznamem (tj. na kolikatou polozku ukazuje Prvnivokne)}
    b:byte; {pomocna}
    MistniVyber:byte; {vysledek nabidky z praveho mysitka nebo z klavesy "mistni nabidka"}
    PuvodniCesta:dirstr; {pro ulozeni aktualni cesty pred volanim teto funkce, abychom se tam mohli vratit}
    okynko:okno; {podkladove okno}
    posouvadlo:posuvnik; {pro posouvani seznamu}
    levex,horniy,pravex,dolniy:integer; {souradnice okraju oblasti se seznamem souboru}
    novyadrt,vymazt,infot,okt,cancelt:tlacitko; {ovladaci cudliky napravo od seznamu}
    jmenotp:textovepole; {policko jmeno souboru}
    hotovo, {na ukonceni vnejsiho cyklu}
    JsmeJinde:boolean; {rika, jestli je potreba pregenerovat seznam souboru (na ukonceni vnitrniho cyklu)}
    rezim:(normalni,disky); {jestli prave vybirame soubory a adresare nebo disky}
    o:word; {pro klavesnici a obcas jako pomocna}
    PocetVeci:word; {pocet polozek v seznamu (prakticky jenom kvuli posuvniku)}
    MaxDelkaCesty:byte; {pro stavovy radek s aktualni cestou [zn]}
{}function SlozJmeno(odkud:uknasoubor):string12; {slozi z daneho prvku seznamu cele jmeno i s pripadnou koncovkou}
{}var vysledek:string12;
{}Begin
{}if odkud=nil then vysledek:=''
{}             else begin
{}                  vysledek:=odkud^.jmeno;
{}                  if odkud^.koncovka<>'' then vysledek:=vysledek+'.'+odkud^.koncovka;
{}                  end;
{}slozjmeno:=vysledek;
{}End;{slozjmeno}
{}procedure VybranyNaKonec; {nastavi ukazatel Vybrany na posledni soubor v seznamu}
{}Begin
{}if vybrany=nil then vybrany:=prvni;
{}while (vybrany<>nil)and(vybrany^.dalsi[true]<>nil) do vybrany:=vybrany^.dalsi[true];
{}End;{vybranynakonec}
{}procedure VytvorSeznamDisku; {projde dostupne disky, nacte jmenovky a ulozi je do seznamu}
{}var c:char;
{}    logmap,pocetdisket,b:byte;
{}    sr:searchrec;
{}    jm:string[12];
{}Begin
{}pocetdisket:=pocetdisketovychmechanik;
{}for c:='A' to 'Z' do
{} begin
{} logmap:=zjistilogickemapovani(c);
{} if (c>'B')and(logmap=255) then break; {zadne dalsi disky (doufam)}
{} {priprava jmenovky disku:}
{} jm:=#19; {fantomova nebo neexistujici disketa (takovy ten dvojity vykricnik)}
{} if (c='A')and(pocetdisket>=1)and((logmap=0)or(logmap=1))
{}    or (c='B')and(pocetdisket>=2)and((logmap=0)or(logmap=2)) then jm:=wt.dej(wtdisketa) {funkcni disketa}
{}  else if c>'B' then begin {harddisk, CD nebo flashka}
{}                     findfirst(c+':\*.*',volumeid,sr);
{}                     if doserror=0 then jm:=sr.name {pri zobrazovani bude potreba z nej vyhodit tecku}
{}                                   else jm:=''; {disk bez jmenovky}
{}                     end;
{} {zarazeni disku do seznamu:}
{} new(vybrany); {maxavail ani testovat nebudu, disku je jenom par}
{} with vybrany^ do begin
{}                  b:=pos('.',jm);
{}                  if b=0 then begin
{}                              jmeno:=jm; koncovka:='';
{}                              end
{}                         else begin
{}                              jmeno:=left(jm,pred(b));
{}                              koncovka:=right(jm,length(jm)-b);
{}                              end;
{}                  atributy:=volumeid;
{}                  velikost:=0;
{}                  zmeneno:=sr.time;
{}                  dalsi[false]:=nil;
{}                  dalsi[true]:=nil;
{}                  end;
{} if prvni=nil then begin
{}                   prvni:=vybrany;
{}                   prvnivokne:=vybrany;
{}                   end
{}              else begin
{}                   prvnivokne^.dalsi[true]:=vybrany;
{}                   vybrany^.dalsi[false]:=prvnivokne;
{}                   prvnivokne:=vybrany;
{}                   end;
{} {prvni = zacatek seznamu, vybrany = novy, prvnivokne = konec seznamu (drobatko zneuzite promenne)}
{} inc(pocetveci);
{} end;
{}prvnivokne:=prvni;
{}End;{vytvorseznamdisku}
{}procedure PrekresliSeznam(aktivne:boolean); {vykresli seznam, parametr urcuje barvu oznacene polozky}
{}var i,barva:byte;
{}    pd:char; {pismeno disku}
{}    jm:string[14]; {jmeno - co bude na radku zobrazeno}
{}Begin
{}if rezim=disky then begin {kterym diskem okno zacina}
{}                    pomocny:=prvni; pd:='A';
{}                    while pomocny<>prvnivokne do begin
{}                                                 pomocny:=pomocny^.dalsi[true];
{}                                                 inc(pd);
{}                                                 end;
{}                    end;
{}pomocny:=prvnivokne;
{}kvyp;
{}for i:=0 to vecinaokno-1 do begin
{}                            {podklad pod radkem:}
{}                            if (pomocny=nil)or(pomocny<>vybrany) then barva:=tpvbarva
{}                             else if aktivne then barva:=tpozntxtpodbarva
{}                              else barva:=tpneaktozntxtpodbarva;
{}                            _bar(levex+1,horniy+1+vyskaveci*i,
{}                                 pravex-1,horniy+vyskaveci*succ(i),barva);
{}                            {text na radku:}
{}                            if pomocny<>nil
{}                              then begin
{}                                   if pomocny=vybrany then barva:=tpozntxtbarva
{}                                                      else barva:=tptxtbarva;
{}                                   if rezim=disky then jm:=pd+':' {disk}
{}                                    else if pomocny^.atributy=volumeid then jm:=#8 {odkaz Disky... (ctverecek s koleckem)}
{}                                     else if pomocny^.atributy and directory=0 then jm:=' ' {soubor}
{}                                                                               else jm:=#255; {adresar (muj specialni znak)}
{}                                   jm:=jm+' '+pomocny^.jmeno;
{}                                   if (pomocny^.koncovka<>'')and(rezim<>disky) then jm:=jm+'.';
{}                                   jm:=jm+pomocny^.koncovka;
{}                                   _print(levex+3,horniy+3+vyskaveci*i,barva,jm);
{}                                   pomocny:=pomocny^.dalsi[true];
{}                                   end;
{}                            inc(pd);
{}                            end;
{}kzap;
{}End;{prekresliseznam}
{}procedure OJedenDal; {posune vyber o 1 radek dolu}
{}var vzdalenost:byte;
{}Begin
{}{nejdriv je potreba zjistit, jestli je vybrany na konci okna:}
{}pomocny:=prvnivokne; vzdalenost:=0;
{}while pomocny<>vybrany do begin
{}                          inc(vzdalenost);
{}                          pomocny:=pomocny^.dalsi[true]; {vybrany je vzdycky za prvnim, nikdy pred nim}
{}                          end;
{}if vzdalenost=vecinaokno-1 then begin {je potreba posunout okno}
{}                                prvnivokne:=prvnivokne^.dalsi[true];
{}                                inc(pozice);
{}                                end;
{}vybrany:=vybrany^.dalsi[true];
{}End;{ojedendal}
{}procedure JmenoDoPole; {zkopiruje jmeno vybraneho souboru ze seznamu do pole pro jmeno}
{}Begin
{}if (vybrany<>nil)and(vybrany^.atributy and (directory+volumeid)=0)
{}  then begin
{}       jmenotp.hodnota:=slozjmeno(vybrany);
{}       jmenotp.zobraz;
{}       end;
{}End;{jmenodopole}
{}const up=false; down=true;
{}procedure page(kam:boolean); {posune vyber o vysku okna nahoru nebo dolu}
{}var i:byte;
{}Begin
{}if (vybrany=nil)or(prvnivokne=nil) then exit;
{}{posun vyberu:}
{}for i:=1 to vecinaokno do
{} begin
{} if vybrany^.dalsi[kam]<>nil then vybrany:=vybrany^.dalsi[kam];
{} if prvnivokne^.dalsi[kam]<>nil then prvnivokne:=prvnivokne^.dalsi[kam];
{} end;
{}{vypocet pozice:}
{}if kam then begin
{}            inc(pozice,vecinaokno);
{}            if pozice>pocetveci-1 then pozice:=pocetveci-1;
{}            end
{}       else if pozice<vecinaokno then pozice:=0 else dec(pozice,vecinaokno);
{}jmenodopole;
{}End;{page}
{}procedure najdi(co:char); {nastavi vyber na soubor nebo adresar, ktery zacina danym pismenem}
{}Begin
{}if (prvni=nil)or(vybrany=nil) then exit;
{}co:=upcase(co);
{}if (vybrany^.jmeno[1]=co)and(vybrany^.dalsi[true]<>nil)
{}   and(vybrany^.dalsi[true]^.jmeno[1]=co)
{}  then ojedendal
{}  else repeat
{}       ojedendal;
{}       if vybrany=nil then begin
{}                           vybrany:=prvni; prvnivokne:=prvni; pozice:=0;
{}                           exit; {aby se to nezacyklilo donekonecna}
{}                           end;
{}       until vybrany^.jmeno[1]=co;
{}End;{najdi}
{}procedure PrejdiDoVybraneho; {prejde do vybraneho adresare nebo disku}
{}var nanic:longint;
{}    kod:byte;
{}    pd:char; {disk}
{}Begin
{}if rezim=disky
{}  then begin {prepnuti disku}
{}       if vybrany^.jmeno=#19 then exit; {zakaz prepnuti na fantomovou disketu}
{}       {nalezeni pismena vybraneho disku:}
{}       pomocny:=prvni; pd:='A';
{}       while pomocny<>vybrany do begin {pocitac uplne bez disku nehrozi, takze nehrozi ani prvni=nil}
{}                                 pomocny:=pomocny^.dalsi[true];
{}                                 inc(pd);
{}                                 end;
{}       {pismeno mame, ted kontrola, jestli mame i ten disk:}
{}       zjistivolnemisto(pd,nanic,kod);
{}       if kod=0 then begin {je to prazdna mechanika nebo neco podobneho}
{}                     okokno(wt.dej(wtvjednotce)+pd+wt.dej(wtnenivlozendisk));
{}                     exit;
{}                     end;
{}       {a konecne prepnuti na ten disk:}
{}       chdir(pd+':\');
{}       nanic:=ioresult; {reset ioresulty pro pripad potizi}
{}       rezim:=normalni;
{}       end
{}  else begin {adresar nebo odkaz na disky}
{}       if vybrany^.atributy=volumeid
{}         then rezim:=disky
{}         else begin chdir(slozjmeno(vybrany)); nanic:=ioresult; end;
{}       end;
{}jsmejinde:=true; {signal, ze bude potreba pregenerovat seznam souboru/adresaru/disku}
{}End;{prejdidovybraneho}
{}procedure oukej; {potvrdi vybrany soubor, sestavi navratovou hodnotu a nahlasi konec}
{}var CeleJmeno:pathstr;
{}Begin
{}getdir(0,celejmeno);
{}if celejmeno[length(celejmeno)]<>'\' then celejmeno:=celejmeno+'\';
{}celejmeno:=celejmeno+jmenotp.hodnota;
{}vybersouborokno:=celejmeno;
{}hotovo:=true;
{}End;{oukej}
{}procedure vyber(kolikaty:byte); {vybere nebo potvrdi dany radek okna (pocita je od 0)}
{}var poz:byte;
{}Begin
{}pomocny:=prvnivokne; poz:=0;
{}while (poz<>kolikaty)and(pomocny<>nil)and(pomocny^.dalsi[true]<>nil) do begin
{}                                                                        pomocny:=pomocny^.dalsi[true];
{}                                                                        inc(poz);
{}                                                                        end;
{}if poz=kolikaty then if pomocny=vybrany then begin if lmys then o:=xenter;{ekvivalent Enteru} end
{}                                        else begin {oznaceni radku, na ktery se kliklo}
{}                                             vybrany:=pomocny;
{}                                             prekresliseznam(true);
{}                                             jmenodopole;
{}                                             end;
{}               {else mys je za koncem seznamu, tak klik ignorujeme}
{}End;{vyber}
{}procedure ZobrazInfo; {zobrazi okno s informacemi o oznacenem souboru}
{}var dt:datetime;
{}    atr:string[55];
{}Begin
{}with vybrany^ do
{}  begin
{}  atr:='';            {slozeni popisu atributu:}
{}  if atributy and directory<>0 then atr:=wt.dej(wtadresar);
{}  if atributy and readonly<>0 then atr:=atr+wt.dej(wtjenprocteni);
{}  if atributy and hidden<>0 then atr:=atr+wt.dej(wtskryty);
{}  if atributy and sysfile<>0 then atr:=atr+wt.dej(wtsystemovy);
{}  if atributy and archive<>0 then atr:=atr+wt.dej(wtarchivovat);
{}  if atr='' then atr:=wt.dej(wtzadne)
{}            else begin
{}                 dec(atr[0]); {odmazani mezery na konci}
{}                 atr[length(atr)]:='.'; {misto carky na konec tecku}
{}                 end;
{}  unpacktime(vybrany^.zmeneno,dt);
{}  okokno('%%n'+wt.dej(wtvlastnostisouboru)+'%%N'
{}         +wt.dej(wtjmeno)+slozjmeno(vybrany)+'|'
{}         +wt.dej(wtvelikost)+nastr(velikost)+' B ('+nastr(velikost shr 10)+' KB)|'+
{}         wt.dej(wtposlednizmena)+nastr(dt.day)+'.'+nastr(dt.month)+'.'+nastr(dt.year)
{}            +', '+nastr(dt.hour)+':'+nastr3(dt.min,2)+':'+nastr3(dt.sec,2)+'|'+
{}         wt.dej(wtatributy)+atr);
{}  end;
{}End;{zobrazinfo}
{}procedure VytvorAdresar; {vytvori novy adresar a zaradi ho na konec seznamu}
{}var jm:string[12];
{}    c:dirstr; j:namestr; k:extstr;
{}    sr:searchrec;
{}Begin
{}jm:=vloztextokno(wt.dej(wtjmenoadresare),12,'',true);
{}if wokzruseno or (jm='') then exit;
{}fsplit(jm,c,j,k);
{}if c<>'' then begin okokno(wt.dej(wtchybaadr1)); exit; end;
{}mkdir(jm);
{}if ioresult<>0 then begin okokno(wt.dej(wtchybaadr2a)+jm+wt.dej(wtchybaadr2b)); exit; end;
{}findfirst(jm,anyfile-volumeid,sr); {jak to dopadlo}
{}fsplit(sr.name,c,j,k); {at mame finalni verzi}
{}new(pomocny); {pamet nekontroluju, snad vystaci}
{}vybranynakonec;
{}with pomocny^ do begin
{}                 jmeno:=j;
{}                 koncovka:=copy(k,2,3);
{}                 atributy:=sr.attr;
{}                 velikost:=sr.size; {bude vzdy 0}
{}                 zmeneno:=sr.time;
{}                 dalsi[false]:=vybrany;
{}                 dalsi[true]:=nil;
{}                 end;
{}vybrany^.dalsi[true]:=pomocny;
{}o:=xend; {simulace zmacknuti Endu, aby se spravne prekreslilo okno}
{}End;{vytvoradresar}
Begin{vybersouborokno}
wokzruseno:=false;
{vykresleni okna:}
if nadpis='' then nadpis:=wt.dej(wtvybersoubor);
_pushtext;
_zmertext(nadpis);
okynko.init(_maxx shr 1-100,_maxy shr 1-60-_vyskatextu,180,155+_vyskatextu,nadpis);
_nastavfont(wokfont,true);
maxdelkacesty:=okynko.sirka div __roztec-2; {delka cesty podle sirky okna}
with okynko do begin
               levex:=x+3;
               horniy:=y2+3;
               pravex:=levex+_sirkatextu2(14)+3+2;
               dolniy:=horniy+vyskaveci*vecinaokno+1;
               end;
_box(levex,horniy,pravex,dolniy,tplhbarva,tppdbarva,0); {obrys seznamu}
_print(levex+2,dolniy+6,txtbarva,wt.dej(wtjmeno)); {popis k policku se jmenem}
o:=pravex+19; {xova souradnice tlacitek, at se nemusi pocitat vickrat}
novyadrt.init(o,horniy,wt.dej(wtnovyadr),wt.dej(wtnovyadrhelp),1);
vymazt.init(o,horniy+30,wt.dej(wtvymaz),wt.dej(wtvymazhelp),1);
infot.init(o,horniy+50,wt.dej(wtinfo),wt.dej(wtinfohelp),1);
okt.init(o,horniy+71,wt.dej(wtok4),wt.dej(wtvsoknookhelp),3);
cancelt.init(o,horniy+95,wt.dej(wtzrus),wt.dej(wtvsoknozrushelp),1);
jmenotp.init(levex+60,dolniy+4,12,'',proukladani,true);
{priprava disku a cesty:}
if masky='' then masky:='*.*'; {prazdna maska znamena cokoli}
getdir(0,puvodnicesta); {sem se nakonec musime vratit}
if cesta='' then cesta:='.'; {aktualni adresar}
if cesta[length(cesta)]<>'\' then cesta:=cesta+'\'; {tohle je pro pripad, ze by byla zadana cesta typu 'D:' -
         - bez lomitka by se jenom prepnul disk a zustal by na nem nastaveny ten adresar, jaky tam zrovna byl}
chdir(cesta);
if ioresult<>0 then {budeme tam, kde jsme byli, coz v podstate nevadi};
rezim:=normalni; {na vyberu disku se zacinat nikdy nebude}
hotovo:=false;
 Repeat {vnejsi cyklus - v kazde iteraci se generuje novy seznam souboru a meni se aktualni cesta}
 pocetveci:=0;
 if rezim=disky
   then vytvorseznamdisku
   else begin
        {seznam podadresaru:}
        pocetveci:=seznamsouboru(prvni,'*.*',true);
        if (doserror<>-1)and((prvni=nil)or(prvni^.jmeno<>'..'))
          then begin {pridani odkazu na vyber disku}
               if maxavail<sizeof(tsoubor) then begin
                                                zrusseznamsouboru(prvni);
                                                okokno(wt.dej(wtfatalnemalopameti));
                                                okynko.zrus;
                                                exit;
                                                end;
               new(vybrany);
               with vybrany^ do begin
                                jmeno:=wt.dej(wtdisky);
                                koncovka:='';
                                atributy:=volumeid; {aby se to odlisilo od souboru a adresaru}
                                velikost:=0;
                                zmeneno:=0;
                                dalsi[false]:=nil;
                                dalsi[true]:=prvni;
                                end;
               if prvni=nil then prvni:=vybrany
                            else begin
                                 prvni^.dalsi[false]:=vybrany;
                                 prvni:=vybrany;
                                 end;
               end;
        vybrany:=prvni;
        vybranynakonec;
        {pridame seznam souboru:}
        pozice:=1;
        while pozice<=length(masky) do {cyklus pro kazdou masku}
         begin
         {najdi v retezci jednu masku:}
         b:=pozice;
          repeat {posun b za posledni znak masky}
          inc(b);
          until (b>length(masky))or(masky[b]=',');
         {najdi soubory, ktere masce odpovidaji:
         (trosku zneuziju ukazatele Vybrany a Prvnivokne a promennou o)}
         o:=seznamsouboru(prvnivokne,copy(masky,pozice,b-pozice),false);
         inc(pocetveci,o);
         {pridej nalezene soubory na konec seznamu:}
         if prvnivokne<>nil {ale jenom pokud se vubec neco naslo}
           then begin
                if vybrany=nil then prvni:=prvnivokne
                               else begin
                                    vybrany^.dalsi[true]:=prvnivokne;
                                    prvnivokne^.dalsi[false]:=vybrany;
                                    end;
                vybranynakonec;
                end;
         pozice:=succ(b); {posun pozice za carku, tedy na zacatek dalsi masky (nebo za konec retezce)}
         end;
        end;
 jsmejinde:=false; {seznam je hotovy}
 {vypiseme aktualni cestu:}
 kvyp;
 _box(levex,dolniy+21,okynko.x+okynko.sirka-3,dolniy+21+13,opdbarva,olhbarva,ovbarva);
 if rezim=disky then _print(levex+5,dolniy+21+3,txtbarva,wt.dej(wtdisky))
                else begin
                     getdir(0,cesta);
                     if length(cesta)>maxdelkacesty {jestli je cesta pro zobrazeni moc dlouha, zkratime ji}
                       then cesta:=left(cesta,3)+'...'+right(cesta,maxdelkacesty-6);
                     _print(levex+5,dolniy+21+3,txtbarva,cesta);
                     end;
 {pripravime posuvnik:}
 _bar(pravex+2,horniy+40,pravex+16,dolniy,ovbarva); {aby se nezdvojoval konec posuvniku, kdyz ho zkracujeme}
 o:=(pocetveci+vecinaokno-1) div vecinaokno; {kolik to da oken}
 posouvadlo.init(pravex+2,horniy,82,o,0);
 {vykreslime okno se seznamem:}
 prvnivokne:=prvni;
 pozice:=0;
 vybrany:=prvni;
 prekresliseznam(jmenotp.stav=_neaktivni);
 {interaktivni vnitrni cyklus:}
  repeat
  resetuj; cekej;
  if rezim=normalni then begin
                         novyadrt.kontrola; vymazt.kontrola; infot.kontrola;
                         end;
  okt.kontrola; cancelt.kontrola;
  jmenotp.kontrola; {pozor, nedavat pred okt.kontrola!}
  posouvadlo.kontrola;
  if posouvadlo.zmeneno then begin {posun seznamu podle posuvniku}
                             o:=(pozice+vecinaokno-1) div vecinaokno; {kde je ted okno}
                             if o>posouvadlo.hodnota then repeat
                                                          page(up);
                                                          until ((pozice+vecinaokno-1) div vecinaokno<=posouvadlo.hodnota)
                                                                or (vybrany=prvni)
                              else if o<posouvadlo.hodnota then repeat
                                                                page(down);
                                                                until ((pozice+vecinaokno-1) div vecinaokno
                                                                             >=posouvadlo.hodnota)
                                                                      or (vybrany^.dalsi[true]=nil);
                             prekresliseznam(jmenotp.stav<>_aktivni);
                             end;
  if keypressed then o:=xreadkey else o:=0; {odtedka je v o kod klavesy}
  if o=xmistninabidka then mistnivyber:=nabidka((levex+pravex) shr 1,(horniy+dolniy) shr 1,wt.dej(wtvsonabidka))
                      else mistnivyber:=0;
  if (stavtlacitek<>0) and mysvpoli(succ(levex),succ(horniy),pred(pravex),pred(dolniy))
    then begin
         vyber((ymys-horniy-1) div vyskaveci); {vyber nebo potvrzeni souboru mysi (musi byt tady pred vyhodnocenim Enteru!)}
         if pmys then mistnivyber:=nabidka(xmys,ymys,wt.dej(wtvsonabidka));
         end;
  if (jmenotp.stav=_enterem)
     or (jmenotp.stav=_aktivni)and((okt.hodnota=1)or(o=xenter))
    then oukej {rucne napsane jmeno vratime bez prutahu}
    else if (okt.hodnota=1)or(o=xenter)or(mistnivyber=1) {odentrovany vyber ze seznamu}
           then if vybrany^.atributy and (volumeid+directory)<>0
                  then prejdidovybraneho {adresar nebo disk}
                  else oukej; {soubor => vybrat a konec}
  if jmenotp.stav=_odkliknutim then begin {prepnuti do pole se seznamem}
                                    jmenotp.stav:=_neaktivni;
                                    prekresliseznam(true); {zmodrani kurzoru}
                                    end
   else if (jmenotp.stav=_aktivni)and(jmenotp.pozice=-1) {klik mysi do pole se jmenem}
          then prekresliseznam(false); {zesediveni kurzoru}
  if (cancelt.hodnota=1)or(o=xesc)or(jmenotp.stav=_escapem) then begin {zruseni okna}
                                                                 wokzruseno:=true;
                                                                 vybersouborokno:='';
                                                                 hotovo:=true;
                                                                 end;
  if ((vymazt.hodnota=1)or(o=xdel)or(mistnivyber=4)) {zmackli jsme cudlik pro smazani...}
     and(vybrany<>nil)and(vybrany^.atributy and (directory+volumeid)=0) {...neco je vybrano a neni to adresar ani disk...}
     and anoneokno(wt.dej(wtopravduchcetesmazatsoubor)+slozjmeno(vybrany)+'?') {...a souhlasime se smazanim...}
     and vymazsoubor(slozjmeno(vybrany)) {...a povede se to}
    then begin
         {vyhozeni ze seznamu:}
         pomocny:=vybrany^.dalsi[true]; {po smazani se kurzor posune na nasledujici...}
         if pomocny<>nil
           then pomocny^.dalsi[false]:=vybrany^.dalsi[false];
         if vybrany^.dalsi[false]<>nil
           then begin
                vybrany^.dalsi[false]^.dalsi[true]:=vybrany^.dalsi[true];
                if pomocny=nil then pomocny:=vybrany^.dalsi[false]; {...nebo kdyby to nevyslo, tak na predchozi}
                end;
         if vybrany=prvni then prvni:=vybrany^.dalsi[true]; {tohle je teoreticky nemozne, ale jistota je jistota}
         if vybrany=prvnivokne then begin
                                    prvnivokne:=vybrany^.dalsi[true];
                                    inc(pozice);
                                    end;
         dispose(vybrany);
         vybrany:=pomocny;
         dec(pocetveci); {posuvnik necham byt, tohle ho nezabije}
         jmenodopole;
         o:=1; {jakykoli nenulovy nesmysl, ktery zpusobi, ze se na konci}
         end;  {cyklu prekresli pole a aktualizuje posuvnik             }
  if ((infot.hodnota=1)or(o=xaltenter)or(mistnivyber=5)) {chceme zobrazit vlastnosti...}
     and(vybrany<>nil)and(vybrany^.atributy and volumeid=0) {...a je jak}
    then zobrazinfo;
  if ((novyadrt.hodnota=1)or(mistnivyber=3)or(o=xctrln))and(rezim=normalni) then vytvoradresar;
  if (o=xf1)or(mistnivyber=2)
    then for b:=0 to 2 do okokno(wt.dej(wtvsohelp1+b));
  case o of xtab,xshifttab:begin {prepnuti do pole se jmenem}
                           jmenotp.stav:=_aktivni;
                           jmenotp.zobraz;
                           end;
            xhsipka:if (vybrany<>nil)and(vybrany^.dalsi[false]<>nil)
                      then begin
                           if vybrany=prvnivokne then begin
                                                      prvnivokne:=prvnivokne^.dalsi[false];
                                                      dec(pozice);
                                                      end;
                           vybrany:=vybrany^.dalsi[false];
                           jmenodopole;
                           end;
            xdsipka:if (vybrany<>nil)and(vybrany^.dalsi[true]<>nil)
                      then begin
                           ojedendal;
                           jmenodopole;
                           end;
            xhome:begin
                  vybrany:=prvni;
                  prvnivokne:=prvni;
                  pozice:=0;
                  jmenodopole;
                  end;
            xend:begin
                 vybranynakonec;
                 prvnivokne:=vybrany;
                 pozice:=pocetveci-1;
                 {posun zpatky, aby byl vybrany na konci okna:}
                 for b:=vecinaokno-1 downto 1 do
                  if (prvnivokne=nil)or(prvnivokne^.dalsi[false]=nil)
                    then break
                    else begin
                         prvnivokne:=prvnivokne^.dalsi[false];
                         dec(pozice);
                         end;
                 jmenodopole;
                 end;
            xpgup:page(up);   {\ Jmenodopole je v nich zabudovana }
            xpgdn:page(down); {/                                  }
            33..255:begin
                    najdi(chr(o)); {hledani podle zmacknuteho prvniho pismena}
                    jmenodopole;
                    end;
            end;
  if o<>0 then begin
               {pokud byla stisknuta klavesa a nevyhodnotilo ji jmenotp,
               znamena to, ze musime aktualizovat seznam a posuvnik:}
               prekresliseznam(jmenotp.stav<>_aktivni);
               o:=(pozice+vecinaokno-1) div vecinaokno; {kam ma posuvnik ukazovat (o uz do konce cyklu nebude na nic potreba)}
               if (o<>posouvadlo.hodnota)and(o<posouvadlo.pocetpoloh)
                 then begin {jestli tam neukazuje, presuneme ho}
                      posouvadlo.hodnota:=o;
                      posouvadlo.zobraz;
                      end;
               end;
  until hotovo or jsmejinde;
 zrusseznamsouboru(prvni);
 Until hotovo;
okynko.zrus;
chdir(puvodnicesta); o:=ioresult;
_poptext;
End;{vybersouborokno}

function vlozmaskuokno(nadpis:nadpstr;default:word):word;
var ok:okno;
    hs:hotspot;
    okt,cancelt,infot:tlacitko;
    i:byte;
    pole:array[0..15]of boolean;
    m,o,x,y:word;
{}procedure policko(ktere:byte);
{}Begin
{}kvyp;
{}if pole[ktere] then _box(x+11*ktere,y,x+11*ktere+9,y+10,10,8,2)
{}               else _bar(x+11*ktere,y,x+11*ktere+9,y+10,0);
{}kzap;
{}End;{policko}
Begin{vlozmaskuokno}
wokzruseno:=false;
x:=(_maxx shr 1)-100; y:=(_maxy shr 1)-30;
if nadpis='' then nadpis:=wt.dej(wtmaskacary);
m:=default; o:=0;
for i:=15 downto 0 do pole[i]:=((m shr (15-i)) and 1)=1;
if dialogystandardnimfontem then begin
                                 _pushtext;
                                 _nastavfont(wokfont,true);
                                 end;
_zmertext(nadpis);
ok.init(x-3,y-7-_vyskatextu,180,39+_vyskatextu,nadpis);
_pushtext; _nastavfont(wokfont,true);{kvuli tlacitkum}
okt.init(x,y+13,wt.dej(wtok14),wt.dej(wtvmoknookhelp),1);
cancelt.init(x+120,y+13,wt.dej(wtzrus),wt.dej(wtvmoknozrushelp),1);
infot.init(x+160,y+13,'?',wt.dej(wtvysvetlivky),1);
hs.init(x,y,x+11*16-1,y+10,false,'');
for i:=0 to 15 do policko(i);
resetuj;
 repeat
 cekej;
 hs.kontrola;
 okt.kontrola;
 cancelt.kontrola;
 infot.kontrola;
 case hs.hodnota of 1:begin
                      i:=hs.xkliku div 11;
                      pole[i]:=true;
                      policko(i);
                      end;
                    2:begin
                      i:=hs.xkliku div 11;
                      pole[i]:=false;
                      policko(i);
                      end;
                    end;
 if keypressed then o:=xreadkey;
 if (cancelt.hodnota=1)or(o=27) then begin
                                     vlozmaskuokno:=default;
                                     wokzruseno:=true;
                                     o:=1;
                                     end;
 if (okt.hodnota=1)or(o=13) then begin
                                 m:=0;
                                 for i:=15 downto 0 do begin
                                                       m:=m shl 1;
                                                       m:=m or ord(pole[i]);
                                                       end;
                                 vlozmaskuokno:=m;
                                 o:=1;
                                 end;
 if (infot.hodnota=1)or(o=xF1) then begin
                                    infokno(xmys,ymys,wt.dej(wtvmoknohelp),true);
                                    o:=0;
                                    end;
 until o=1;
ok.zrus; resetuj;
_poptext;
if dialogystandardnimfontem then _poptext;
End;{vlozmaskuokno}

procedure VlozVzorekOkno(nadpis:nadpstr; var vzorek:_pole8bytu);
var ok:okno;
    hs:hotspot;
    okt,cancelt,infot:tlacitko;
    i,j:byte;
    pole:array[0..7,0..7]of boolean;
    x,y,o:word;
{}procedure policko(px,py:byte);
{}Begin
{}kvyp;
{}if pole[py,px] then _box(x+11*px,y+11*py,x+11*px+9,y+11*py+9,10,8,2)
{}               else _bar(x+11*px,y+11*py,x+11*px+9,y+11*py+9,0);
{}kzap;
{}End;{policko}
Begin{vlozvzorekokno}
wokzruseno:=false;
if dialogystandardnimfontem then begin
                                 _pushtext;
                                 _nastavfont(wokfont,true);
                                 end;
if nadpis='' then nadpis:=wt.dej(wtvzorekvyplne);
o:=0;
for i:=0 to 7 do for j:=0 to 7 do pole[i,j]:=(vzorek[i] shl j)and $80=$80;
x:=(_maxx shr 1)-70; y:=(_maxy shr 1)-40;
_zmertext(nadpis);
ok.init(x-3,y-7-_vyskatextu,135,97+_vyskatextu,nadpis);
_pushtext; _nastavfont(wokfont,true);
okt.init(x+90,y+1,wt.dej(wtok4),wt.dej(wtvvoknookhelp),15);
cancelt.init(x+90,y+49,wt.dej(wtzrus),wt.dej(wtvvoknozrushelp),3);
infot.init(x+94,y+72,' ? ',wt.dej(wtvysvetlivky),0);
hs.init(x,y,x+11*8-1,y+11*8-1,false,'');
for i:=0 to 7 do for j:=0 to 7 do policko(j,i);
resetuj;
 repeat
 cekej;
 hs.kontrola;
 okt.kontrola;
 cancelt.kontrola;
 infot.kontrola;
 case hs.hodnota of 1:begin
                      j:=hs.xkliku div 11;
                      i:=hs.ykliku div 11;
                      pole[i,j]:=true;
                      policko(j,i);
                      end;
                    2:begin
                      j:=hs.xkliku div 11;
                      i:=hs.ykliku div 11;
                      pole[i,j]:=false;
                      policko(j,i);
                      end;
                    end;
 if keypressed then o:=xreadkey;
 if (okt.hodnota=1)or(o=13) then begin
                                 fillchar(vzorek,8,0);
                                 for i:=0 to 7 do
                                  for j:=0 to 7 do vzorek[i]:=vzorek[i] or ord(pole[i,j]) shl (7-j);
                                 o:=27;
                                 end;
 if cancelt.hodnota=1 then begin o:=27; wokzruseno:=true; end;
 if (infot.hodnota=1)or(o=xF1) then begin
                                    infokno(xmys,ymys,wt.dej(wtvvoknohelp),true);
                                    o:=0;
                                    end;
 until o=27;
ok.zrus; resetuj;
_poptext;
if dialogystandardnimfontem then _poptext;
End;{vlozvzorekokno}

procedure NastavMysOkno(ukladat:boolean);
var puvodnicx,puvodnicy,pomcx,pomcy:word;
    puvodnikb,puvodniotb,pomkb,pomotb:boolean;
    ok:okno; {okno, ve kterem to vsechno je}
    xo,yo:ciselnaosa; {posuvniky pro nastaveni vodorovne a svisle citlivosti}
    kz,oz:zatrzitko; {prepinace s korekci/bez korekce a normalne/pro levaky}
    testt,okulozt,okneulozt,zrust:tlacitko;
    koncit:boolean; {podminka ukonceni hlavniho cyklu}
    o:char; {pro klavesnici}
Begin
puvodnikb:=korekceb; puvodniotb:=obracenatlacitka;
zjisticitlivostmysi(puvodnicx,puvodnicy);
koncit:=false;
_pushtext; _nastavfont(wokfont,true); {nejsou tu zadne uzivatelske hlasky, tak pujdeme natvrdo standardnim fontem}
ok.init(_maxx shr 1-90,_maxy shr 1-90,180,175+ord(ukladat) shl 4,wt.dej(wtnastavenimysi));
with ok do
  begin
  xo.init(x+5,y2+24,133,1,100,puvodnicx,wt.dej(wtvodorovnacitlivost),wt.dej(wtvelka),wt.dej(wtmala),true,ovbarva);
   {Hodnota 100 nema zadny zvlastni vyznam, stejne dobre by tam mohlo byt neco
   vetsiho nebo i mensiho. Prakticky se stejne nikdy nebude nastavovat vetsi
   cislo nez cca 20 (to uz je docela hooodne pomaly kurzor).}
  yo.init(x+5,y2+75,133,1,100,puvodnicy,wt.dej(wtsvislacitlivost),wt.dej(wtvelka),wt.dej(wtmala),true,ovbarva);
  kz.init(x+5,y2+104,wt.dej(wtkorigovatskakani),wt.dej(wtkorskhelp),puvodnikb);
  oz.init(x+5,y2+117,wt.dej(wtvymenittlacitka),wt.dej(wtymentlachelp),puvodniotb);
  testt.init(x+3,y2+130,wt.dej(wtopatrnazkouska),wt.dej(wtopzkouskahelp),0);
  zrust.init(x+139,y2+130,wt.dej(wtzrus),wt.dej(wtnmoknozrushelp),0);
  okneulozt.init(x+3,y2+146,wt.dej(wtnastavaleneukladej),wt.dej(wtnmoknonnuhelp),0);
  if ukladat then okulozt.init(x+3,y2+162,wt.dej(wtnastavauloz),wt.dej(wtnmoknonuhelp)+cfgsoubor+wt.dej(wtnmoknonuhelp+1),0);
  end;
o:=#255; {neco bezpecneho, co se s nicim nepopere}
 repeat {hlavni uzivatelsky cyklus}
 cekej;
 xo.kontrola; yo.kontrola;
 kz.kontrola; oz.kontrola;
 testt.kontrola; zrust.kontrola;
 okneulozt.kontrola;
 if ukladat then okulozt.kontrola;
 if keypressed then o:=readkey;
 if (o=#0)and keypressed
   then case ord(readkey) of hsipka:begin
                                    if yo.hodnota<yo.max then inc(yo.hodnota);
                                    yo.zobraz;
                                    end;
                             dsipka:begin
                                    if yo.hodnota>yo.min then dec(yo.hodnota);
                                    yo.zobraz;
                                    end;
                             lsipka:begin
                                    if xo.hodnota>xo.min then dec(xo.hodnota);
                                    xo.zobraz;
                                    end;
                             psipka:begin
                                    if xo.hodnota<xo.max then inc(xo.hodnota);
                                    xo.zobraz;
                                    end;
                             end;
 if (zrust.hodnota=1)or(o=#27) then begin
                                    korekcemysi(puvodnikb);
                                    obracenatlacitka:=puvodniotb;
                                    citlivostmysi(puvodnicx,puvodnicy);
                                    koncit:=true;
                                    end;
 if (okneulozt.hodnota=1)or(o=#13) then begin
                                        korekcemysi(kz.hodnota);
                                        obracenatlacitka:=oz.hodnota;
                                        citlivostmysi(xo.hodnota,yo.hodnota);
                                        koncit:=true;
                                        end;
 if ukladat and (okulozt.hodnota=1)
   then begin
        korekcemysi(kz.hodnota);
        obracenatlacitka:=oz.hodnota;
        citlivostmysi(xo.hodnota,yo.hodnota);
        if uloznastavenimysi then koncit:=true
                             else koncit:=not anoneokno(wt.dej(nmoknochybaukl));
        end;
 if testt.hodnota=1 then begin
                         {ulozeni aktualnich hodnot:}
                         zjisticitlivostmysi(pomcx,pomcy);
                         pomkb:=korekceb; pomotb:=obracenatlacitka;
                         {nastaveni hodnot z posuvniku a kz:}
                         korekcemysi(kz.hodnota); obracenatlacitka:=oz.hodnota;
                         citlivostmysi(xo.hodnota,yo.hodnota);
                         {vyzkouseni kurzoru (behem funkce Anoneokno):}
                         if not anoneokno(wt.dej(wtnmoknootazka)) then
                           begin {nelibilo se => zpet k minulym hodnotam}
                           korekcemysi(pomkb);
                           obracenatlacitka:=pomotb;
                           citlivostmysi(pomcx,pomcy);
                           end;
                         end;
 until koncit;
resetuj;
ok.zrus;
_poptext;
End;{nastavmysokno}

procedure NastavKlOkno(popisky:uknaradek; var rozlozeni);
type PoleWordu=array[0..0] of word;
var zavrit,infot:tlacitko;
    rkz:zatrzitko;
    o,w,x,vt,pozice,maxpozice:integer;
    ok:okno;
    x2:integer;
{}function JmenoKlavesy(xcislo:word):string;{vraci jmeno klavesy podle kodu od Xreadkey (max. 9 znaku)}
{}Begin
{}case xcislo of 0:jmenoklavesy:='';{nedefinovana klavesa (nulu xreadkey nevraci)}
{}               8:jmenoklavesy:=wt.dej(wtbksp);
{}               9:jmenoklavesy:=wt.dej(wttab);
{}               13:jmenoklavesy:=wt.dej(wtenter);
{}               27:jmenoklavesy:=wt.dej(wtesc);
{}               32:jmenoklavesy:=wt.dej(wtmez);
{}               33..255:jmenoklavesy:=chr(xcislo);{bezne zobrazitelne znaky z ASCII tabulky}
{}               xlsipka:jmenoklavesy:=#27;{\                                 }
{}               xpsipka:jmenoklavesy:=#26;{ \znaky sipek z pocatku ASCII tabulky}
{}               xhsipka:jmenoklavesy:=#24;{ / (#27 ted nema nic spolecneho s kodem escapu)}
{}               xdsipka:jmenoklavesy:=#25;{/                                 }
{}               xins:jmenoklavesy:=wt.dej(wtins);
{}               xdel:jmenoklavesy:=wt.dej(wtdel);
{}               xhome:jmenoklavesy:=wt.dej(wthome);
{}               xend:jmenoklavesy:=wt.dej(wtend);
{}               xpgup:jmenoklavesy:=wt.dej(wtpgup);
{}               xpgdn:jmenoklavesy:=wt.dej(wtpgdn);
{}               xf1..xf10:jmenoklavesy:='F'+nastr(xcislo-314);{F1..F10 jdou hezky za sebou, tak si trochu zkratim zapis}
{}               xf11:jmenoklavesy:='F11';
{}               xf12:jmenoklavesy:='F12';
{}               else jmenoklavesy:='#'+nastr(xcislo);{prece nemuzu vypsat uplne vsechno, ze jo...}
{}               end;
{}End;{jmenoklavesy}
{}procedure kresli(enterB:boolean);{prekresli okenko se seznamem akci}
{}var p:uknaradek;
{}    w,i:integer;
{ }procedure _radek(stav:byte);{vykresli jeden radek (stav: 0=neaktivni, 1=vybrana, 2=upravovana)}
{ }var textik:string[20];
{ }    bt,bp:byte;
{ }Begin
{ }case stav of 0:begin bt:=tptxtbarva; bp:=tpvbarva; end;
{ }             1:begin bt:=tpozntxtbarva; bp:=tpozntxtpodbarva; end;
{ }             2:begin bt:=nkatxtbarva; bp:=nkatxtpodbarva; end;
{ }             end;
{ }with ok do begin
{ }           _bar(x+3,y2+4+vt*i,x+sirka-3,y2+3+vt*(i+1),bp);
{ }           textik:=p^.obsah;
{ }           if length(textik)>20 then textik[0]:=#20;
{ }           if not dialogystandardnimfontem then _lodtext;
{ }           _print(x+5,y2+5+vt*i,bt,textik);
{ }           if stav=2 then textik:='    ?'
{ }                     else textik:=jmenoklavesy(polewordu(rozlozeni)[w]);
{ }           if not dialogystandardnimfontem then _nastavfont(wokfont,true);
{ }           _print(x2,y2+5+vt*i,bt,'- '+textik);
{ }           end;
{ }End;{_radek}
{}Begin{kresli}
{}p:=popisky; w:=0;
{}if pozice>2 then while (w<maxpozice-4)and(w<pozice-2) do begin
{}                                                         inc(w);
{}                                                         p:=p^.dalsi;
{}                                                         end;
{}{ted p^ = prvni radek zobrazeny v okne, w = jeho cislo}
{}with ok do
{} begin
{} kvyp;
{} for i:=0 to 4 do
{}   begin
{}   if w<=maxpozice then if w=pozice then if enterb then _radek(2)
{}                                                   else _radek(1)
{}                                    else _radek(0)
{}                   else break;
{}   inc(w);
{}   p:=p^.dalsi;
{}   end;
{} kzap;
{} end;
{}End;{kresli}
Begin{nastavklokno}
if popisky=nil then exit;{kdyz neexistuje seznam akci, neni co resit}
maxpozice:=pocetradkuvseznamu(popisky)-1;
pozice:=0;
_pushtext;{uzivatelsky font je ulozen}
if dialogystandardnimfontem then _nastavfont(wokfont,true);
vt:=_vyskatextu2;{vyska uzivatelskeho fontu}
x2:=_sirkatextu2(20);{sirka popisku akci}
if x2<150 then x2:=150;{pojistka proti prilisnemu smrsknuti okna pri moc uzkem fontu}
_nastavfont(wokfont,true);
if _vyskatextu2>vt then vt:=_vyskatextu2;{vyska standardniho fontu}
inc(vt,2);{vyska radku = vyska vetsiho z obou fontu + pridavek 2 pixely}
ok.init((_maxx shr 1)-(x2 shr 1)-50,_maxy shr 1-45,x2+_sirkatextu2(12)+5,5*vt+38,wt.dej(wtkonfiguraceklaves));
with ok do
  begin
  inc(x2,x+8);{prepocet na absolutni souradnici (s pridavkem)}
  _box(x+2,y2+3,x+sirka-2,y2+4+5*vt,tplhbarva,tppdbarva,tpvbarva);
  infot.init(x+3,y+vyska-19,wt.dej(wtinfo),'',1);
  rkz.init(x+55,y+vyska-16,wt.dej(wtresitkonflikty),wt.dej(wtreskonflhelp),true);
  zavrit.init(x+sirka-57,y+vyska-19,wt.dej(wtzavrit),wt.dej(wtnkoknozavrithelp),1);
  end;
{je nastaven wokfont}
 repeat {vnejsi cyklus - pro vraceni na zacatek pri konfliktu klaves}
 o:=0;
 kresli(false);
 resetuj;
  repeat {vnitrni cyklus - hlavni}
  cekej;
  zavrit.kontrola; infot.kontrola; rkz.kontrola;
  if keypressed then
    begin
    o:=xreadkey;
    case o of xhsipka:if pozice>0 then dec(pozice);
              xdsipka:if pozice<maxpozice then inc(pozice);
              xhome:pozice:=0;
              xend:pozice:=maxpozice;
              xpgup:if pozice>=5 then dec(pozice,5) else pozice:=0;
              xpgdn:if pozice<=maxpozice-5 then inc(pozice,5) else pozice:=maxpozice;
              13:begin
                 kresli(true);
                 o:=xreadkey;
                 if rkz.hodnota then {vymazani konfliktnich klaves:}
                  for w:=0 to maxpozice do if polewordu(rozlozeni)[w]=o then polewordu(rozlozeni)[w]:=0;
                 polewordu(rozlozeni)[pozice]:=o;{ulozeni nove klavesy}
                 o:=0;
                 end;
              end;
    kresli(false);
    end
   else o:=0;{not keypressed}
  if infot.hodnota<>0 then infokno(xmys,ymys,wt.dej(wtnkoknohelp),true)
  until (zavrit.hodnota=1)or(o=27);
 o:=27;
 {kontrola konfliktu klaves:}
 if maxpozice>0 then {pokud jsou aspon dve akce (jedna by nemela s cim kolidovat)}
   begin
   for w:=0 to maxpozice-1 do
    if polewordu(rozlozeni)[w]<>0 then
      for x:=w+1 to maxpozice do if polewordu(rozlozeni)[w]=polewordu(rozlozeni)[x] then begin
                                                                                         o:=10;{cokoli, jen ne 27}
                                                                                         break;
                                                                                         end;
   if (o<>27)and anoneokno('%%n'+wt.dej(wtpozor)+'%%N'+wt.dej(wtnkoknopozor)) then o:=27;
   end;
 until o=27;
ok.zrus;
_poptext;
End;{nastavklokno}

procedure InitWoknows(_font,_kurzor,_texty:boolean);
Begin
{standardni font:}
if _font then begin
              _nactifont2(wokfont,'msdflt.fnt');
              _nastavfont(wokfont,true);
              end;
{standardni kurzor mysi:}
if _kurzor then begin
                nactikurzor2(wokkurzor,'stdsipka.kur');
                nastavkurzor(wokkurzor);
                end;
{texty:}
if _texty then wt.init(woktexty,'','');
End;{initwoknows}

procedure ZrusWoknows;
Begin
if wt.pocetradku<>0 then wt.zrus;
_zrusfont(wokfont);
zrusmys;
zruskurzor(wokkurzor);
End;{zruswoknows}

BEGIN
wokfont.fdata:=nil;
wokkurzor.kdata:=nil;
wokzruseno:=false;
wt.pocetradku:=0;
END.