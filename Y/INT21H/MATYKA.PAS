(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: MATYKA.PAS                                                     *)
(*  Obsah: ruzne matematicke funkce, veci pro praci s vektory, komplexnimi *)
(*         cisly, maticemi (od scitani az po inverzi) a celymi cisly o     *)
(*         obecne delce                                                    *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*         M. Milda (prevody ciselnych soustav, obecna mocnina)            *)
(*         Laaca (Arcsin, Arccos)                                          *)
(*  Posledni uprava: 19.9.2013                                             *)
(*  Pro kompilaci: nic                                                     *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit matyka;
{$R-} {vypnuti kontroly rozsahu, nutne pro dynamicka pole}
{$I-} {vypnuti kontroly operaci se soubory (kontroluji se rucne)}
{$N+} {at se o realne vypocty stara koprocesor}
interface

(**************************** obecne funkce: ********************************)

function Preved(cislo:longint; zaklad,sirka:byte):string;
{Prevod cisla z desitkove soustavy na jinou o zakladu Zaklad. Sirka je pocet
cifer; kdyby vysel vysledek kratsi, doplni se na zacatek nuly.}
function NaDes(ret:string; zaklad:byte):longint;
{prevod cisla zadaneho v retezci Ret na desitkove cislo}
function pow(a,n:real):real;
{Obecna mocnina A na n-tou. Pozor, ze pri umocnovani zaporneho cisla
necelociselnym exponentem vraci nulu (coz je sice kravina, ale porad lepsi
nez nechat program spadnout na Invalid floating point operation).}
function tg(x:real):real;
{vraci hodnotu tg(x), s pojistkou proti deleni nulou (v takovem pripade vraci
hodnotu 0)}
function cotg(x:real):real;
{vraci hodnotu cotg(x), s pojistkou proti deleni nulou}
function sgn(x:real):shortint;
{Funkce signum x (znamenko x). Obcas se hodi.
 x>0 => sgn=1
 x=0 => sgn=0
 x<0 => sgn=-1}
function VzdalBodu(x1,y1,x2,y2:longint):word;
{Vraci vzdalenost dvou bodu v rovine.}
function VzdalBoduOdPrimky(x,y,a,b,c:real):real;
{Vraci vzdalenost bodu o souradnicich x,y od primky dane rovnici a*x+b*y+c=0.}
procedure VektorovySoucin(u1,u2,u3,v1,v2,v3:real; var r1,r2,r3:real);
{vektorovy soucin r := u x v}
procedure KvadRovnice(a,b,c:real; var x1,x2:real; var CoVyslo:byte);
{Spocita kvadratickou rovnici. a,b a c jsou koeficienty (rovnice je ve tvaru
a*x*x+b*x+c=0), x1 a x2 jsou vysledne koreny. V promenne CoVyslo se vraci typ
reseni:}
const krNemaReseni=0;     {a=0, b=0, c<>0 - nesplnitelna pro jakekoli x}
      krNekonecnoReseni=1;{a=0, b=0, c=0 - splnena automaticky pro jakekoli x}
      krLinearni=2;       {a=0 - neni tam x na druhou, takze je to obycejna
                      linearni rovnice s jednim resenim (vraceno v x1 i v x2)}
      krDvaRealne=3;      {D>0 - dva ruzne realne koreny x1 a x2}
      krDvojnasobny=4;    {D=0 - jeden dvojnasobny realny koren x1 = x2}
      krKomplexni=5;      {D<0 - dva komplexne sdruzene koreny
                                 x1+x2*i a x1-x2*i (i je komplexni jednotka)}
function orez(A,min,max:integer):integer;
{Pokud je A mimo interval min..max, zvetsi se nebo zmensi tak, aby se do
nej veslo; funkce vraci vyslednou hodnotu.}
function VPoli(x,y,x1,y1,x2,y2:integer):boolean;
{true, pokud bod x,y lezi uvnitr daneho obdelniku
 x1,y1 - levy horni roh toho obdelniku
 x2,y2 - pravy dolni roh}
function ArcSin(x:real):real;
function ArcCos(x:real):real;
{inverze k sin a cos, vysledek je v radianech}
function VetsiZ(a,b:integer):integer;
function MensiZ(a,b:integer):integer;
{Vraci vetsi nebo mensi cislo z a,b. Primitivni vec, ale obcas se hodi.}
function UhelVektoru(u1,u2,v1,v2:integer):real;
{vraci uhel mezi dvema rovinnymi vektory (v radianech)}
function UhelPruvodice(x,y:integer):real;
{Vraci uhel (v radianech), ktery svira pruvodic bodu x,y s kladnou poloosou x.
Uhel je bezpecne rozlisen pro vsechny 4 kvadranty. V prvnich trech je kladny
(0..1.5*pi), ve ctvrtem zaporny (0..-pi/2). Pokud jsou x i y nulove, vraci se
uhel pi/2 (zadne deleni nulou apod. nenastane).
   ^
   |           /
  y+. . . . ./
   |       / .
   |     /   .
   |   / \   .
   | /uhel|  .
  -|---------+---->
  O          x               }
function OtocByte(cislo:byte):byte;
{zrcadlove otoci dane cislo - nejnizsi bity prohodi s nejvyssimi:
10110010b -> 01001101b}
function OtocWord(cislo:word):word;
{totez, ale pro word}
procedure RozvinPlast(md,vd,h:real; var mr,vr,alfa:real);
{Rozvine zadany komoly kuzel do roviny. Kdyz vysledek narysujete na papir,
vystrihnete, vytvarujete a slepite, vyjde presne to teleso, ktere jste zadali.
Vstupy:
 md - prumer mensi podstavy pozadovaneho kuzele; pokud date 0, nebude to
      komoly, ale obycejny kuzel
 vd - prumer vetsi podstavy; pokud bude stejne velky jako md, nebude to kuzel,
      ale valec - pak se ale zmeni vyznam vystupu, viz dale
 h - pozadovana vyska kuzele
Vystupy (rozmery vysece mezikruzi):
 mr - maly (vnitrni) polomer rozvinuteho plaste, pri md=0 bude 0 a nebude to
      vysec mezikruzi, ale kruhu
 vr - velky polomer rozvinuteho plaste
 alfa - uhel rozvinuteho plaste v radianech
Pokud jste zadali md=vd, bude mit rozvinuty plast tvar obdelniku a vystupni
hodnoty znamenaji toto:
 mr - sirka plaste (obvod podstav)
 vr - vyska plaste (rovna zadane vysce valce)
 alfa - bude 0 }
function Interpol(x1,y1,x2,y2,x:real):real;
{Linearni interpolace. Funkce vrati hodnotu y odpovidajici zadanemu x.
Vypocet probiha tak, ze se mezi dva sousedni body prolozi primka:
            |       |
   |       y|  __..-+y2
   |   __..-+~~     |
 y1+-~~     |       |
   |        |       |
  -+--------+-------+--
   x1       x       x2
Bod x muze lezet i mimo interval <x1,x2>, ale pak to bude extrapolace a ne
interpolace (fungovat to ovsem bude taky).}
function DivUp(co,cim:longint):longint;
{celociselne deleni se zaokrouhlenim nahoru}


(************************* vyhodnocovani vyrazu: ****************************)

{Jde o vypocty ciselnych hodnot vyrazu zadanych jako text, napr.
'2+3*(4-sin(2*pi))/(x^2)'. Funkce rozlisuje prioritu operatoru, umi
zavorkovat, dosazovat az tri promenne a zna par nejpouzivanejsich funkci a
konstant.}

type VyrTypHodnot=double; {Tady si nastavte, jaky realny typ se ma pri
                           vypoctech pouzivat. Na bezne hodnoty staci Real,
                           ale pokud ocekavate supervelke vysledky, dejte
                           radsi Double nebo Extended, aby vam program neumrel
                           na Floating point overflow.}

function SpocitejVyraz(vyraz:string; x,y,z:vyrtyphodnot):vyrtyphodnot;
{Vyhodnoti dany vyraz a vrati vyslednou hodnotu. Pokud se ve vyrazu vyskytuji
promenne x, y nebo z, dosadi do nich hodnoty z prislusnych parametru, jinak
tyto parametry nemaji zadny efekt.
Uspesnost se hlasi v teto globalni promenne:}
 var VyrResult:word;
{Hodnota 0 znamena uspech, cokoli jineho chybu (od deleni nulou pres
neukoncene zavorky az po nedostatek pameti). Textove popisy jednotlivych kodu
(1..19) vam da funkce EM_vyrresult z jednotky Errmsg.

 Co se muze ve vyrazech vyskytnout (A a B jsou vyrazy):
A+B = k A se pricita B
A-B = od A se odecita B
A*B = A se nasobi B
A/B = A se deli B (B nesmi byt 0)
A^B = A umocneno na Btou (nesmi byt zaroven zaporne A a necelociselne B)
A~B = Ata odmocnina z B (nesmi byt zaroven zaporne B a necelociselne 1/A)
(A) = vyraz uvnitr zavorek bude vyhodnocen samostatne a jeho vysledna
        hodnota dosazena do nadrazeneho vyrazu
(...(...)...) = zavorky se daji vnorovat, maximalni uroven vnoreni je omezena
                pouze tim, kolik zavorek se vam podari nacpat do stringu :-)
abs(A) = absolutni hodnota z A
sin(A) = sinus A                         \
cos(A) = kosinus A                        \ A je v radianech
tg(A) = tangens A                         /
cotg(A) = kotangens A (tj. 1/tg(A))      /
arcsin(A)  \ abs(A) musi byt <=1   \ inverze k vyse uvedenym funkcim,
arccos(A)  /                       / vysledek je v radianech
arctg(A)                          /
ln(A) = prirozeny logaritmus A (o zakladu e), A musi byt kladne
log(A) = desitkovy logaritmus A (o zakladu 10), A musi byt kladne
pi = Ludolfovo cislo 3.14159265...
e = Eulerovo cislo 2.71828183... (zaklad prirozenych logaritmu)
x = promenna x \
y = promenna y  \ dosadi se za ne hodnoty zadane v parametrech
z = promenna z  /

Nazvy funkci, promennych a konstant piste malymi pismeny, nedelejte mezery
a na oddelovani desetinnych mist pouzivejte tecku. Nebo si piste jak chcete a
vyraz pred vyhodnocovanim prozente funkci UpravVyraz.

Priorita operatoru: nejdriv funkce, pak mocniny a odmocniny, potom nasobeni a
deleni a nakonec scitani a odcitani.

Exponencialni zapis cisel (1.24E-3 apod.) neni podporovan.}

function UpravVyraz(ktery:string):string;
(*Predzvykovaci funkce, ktera upravi vyraz ve volnejsim formatovani presne
do tvaru, jaky potrebuje funkce SpocitejVyraz. Ve vstupnim vyrazu muze
uzivatel psat mezery, pouzivat desetinnou carku (,) misto tecky (.), delit
dvojteckou (:) misto lomitkem (/), pouzivat hranate ([]) a slozene ({})
zavorky se stejnym efektem jako kulate (()) a psat klicova slova velkymi
pismeny.*)

(*************************** komplexni cisla: *******************************)

type KomplexniCislo = record
                      _R,{absolutni hodnota}
                      _fi:real;{uhel cili faze}
                      end;
{Komplexni cislo je ulozeno v goniometrickem tvaru:
cislo=R*(cos(fi)+i*sin(fi))  neboli podle Eulera:  cislo=R*exp(i*fi), a to
proto, ze je jednodussi tento tvar prevest na algebraicky (cislo=a+b*i) nez
z algebraickeho cucat goniometricky}

procedure ZadejKCAB(var KC:KomplexniCislo; a,b:real);
{slouzi pro zadani komplexniho cisla v algebraickem tvaru}
procedure ZadejKCRFi(var KC:KomplexniCislo; R,fi:real);
{pro zadani komp. cisla v goniometrickem tvaru}
function KCRe(KC:KomplexniCislo):real;
{vraci realnou cast daneho kompl. cisla}
function KCIm(KC:KomplexniCislo):real;
{vraci imaginarni cast daneho kompl. cisla}
procedure SectiKC(co,sCim:KomplexniCislo; var vysledek:KomplexniCislo);
{secte dve kompl. cisla}
procedure OdectiKC(OdCeho,Co:KomplexniCislo; var vysledek:KomplexniCislo);
{odecte komp. cisla}
procedure NasobKC(Co,Cim:KomplexniCislo; var vysledek:KomplexniCislo);
{vynasobi dve komp. cisla}
procedure VydelKC(Co,Cim:KomplexniCislo; var vysledek:KomplexniCislo);
{vydeli dve k. cisla}
procedure KCxRC(var Co:KomplexniCislo; cim:real);
{vynasobi komplexni cislo realnym}


(***************** remake Matlabu :-) (maticove operace): *******************)

type TypPrvkuMatice=real; {je mozne zmenit na libovolny realny typ dle potreby}
     PolePrvkuMatice=array[0..10] of TypPrvkuMatice; {pomocny typ - sablona pro ukazatel.
      Na velikosti nezalezi, pole bude dynamicke. Prvky v tomto jednorozmernem
      poli jsou usporadany za sebou, radek po radku, a spolu s udaji o sirce
      a vysce to cele funguje jako dynamicka dvojrozmerna matice.}
     UkNaPPM=^PolePrvkuMatice;

     Matice = record {uzivatelsky typ}
              _vyska,_sirka:word; {rozmery matice}
              _data:uknappm;      {ukazatel na vlastni matici - pole cisel}
              end;

var MatResult:byte;{nastavuje se automaticky po kazde maticove operaci:}
const matOK=0;              {0 - zadna chyba, vse je v poradku               }
      matMaloPameti=1;      {1 - nedostatek pameti pro vytvoreni matice
                                 nebo je matice vetsi nez 64 KB              }
      matNesediRozmery=2;   {2 - nesouhlasi rozmery matic nebo vkladame prvek
                                 na misto mimo matici                        }
      matChybaVZadani=3;    {3 - chyba v ciselnem retezci pri zadavani matice}
      matZdrojNeexistuje=4; {4 - matice, se kterou se snazime neco provest,
                                 neexistuje                                  }
      matKonecZadani=5;     {5 - pri nacitani matice ze zadaneho retezce byl
                                 dosazen konec retezce, ale jeste nebyly
                                 nacteny vsechny prvky matice}
      matSingularni=6;      {6 - matice je singularni, a proto s ni nejde ta
                                 operace, kterou s ni prave provadime        }
      matIOchyba=7;         {7 - chyba pri operaci se souborem}

 { Vsechny matice pojmenovane Vysledek vytvari prislusna procedura
 automaticky, neni proto treba se o jejich hodnotu pred zavolanim te procedury
 starat. V pripade chyby je obvykle Vysledek neexistujici matice,
 tj. _data=nil.
  Pozor! Nedavejte zdrojovou matici stejnou jako cilovou, protoze dynamicka
 data nefunguji jako lokalni promenna volana hodnotou, ale mohla by byt jeste
 pred dokoncenim procedury prepsana a vysel by chybny vysledek!
  Pokud neni neco jasne z teoretickeho hlediska, podivejte se na implementaci
 procedur; definice a vysvetleni maticovych operaci jsou v komentarich na
 konci procedur.
  Veskere indexy v parametrech procedur jsou pocitany od 1 (tj. levy horni roh
 matice ma index 1,1, pravy dolni pak _vyska,_sirka). Prvni index znamena
 cislo radku, druhy cislo sloupce.
  Vsechny procedury krome Initm nastavuji MatResult.}

procedure InitM(var M:matice);
{Vynuluje _sirku, _vysku a ukazatel _data. Je nutne s ni osetrit vsechny
maticove promenne pred prvnim pouzitim, hlavne ty lokalne definovane.
Nepouzivat na jiz alokovane matice!}
function VytvorM(var M:matice; vyska,sirka:word):boolean;
{Vytvori matici danych rozmeru (getmem), hodnoty prvku necha nedefinovane.
Pokud jiz ta matice existuje, zkontroluji se jeji rozmery a pokud jsou stejne
jako pozadovane, nic se uz nedela. Pokud jsou jine, matice se zrusi a vytvori
se nova o spravnych rozmerech. Maximalni velikost matice je obvyklych 64 KB.
Pokud se zada vyska nebo sirka 0, s matici se nic delat nebude (hodi se v
nekterych dalsich procedurach).}
procedure ZrusM(var M:matice);
{pokud matice existuje, vymaze ji, nastavi sirku a vysku na 0 a _data na nil}
procedure ZadejPrvekM(var M:matice; i,j:word; hodnota:TypPrvkuMatice);
{Umoznuje primo zadat prvek na i-tem radku a j-tem sloupci matice M.
Matice M musi byt jiz vytvorena.}
procedure ZadejM(var M:matice; Data:string);
{Umoznuje zadat celou matici. Jednotliva cisla v retezci Data oddelujte
mezerami (je jedno kolika), carka i tecka se berou jako desetinna carka.
Jednotlive radky oddelujte strednikem. Matice M bude podle zadaneho retezce
vytvorena.
Priklad: data='3 -87,7 98.77  7E-2;1 0 -5 5,5'
  vyjde M = 3  -87.7  98.77  0.07
            1   0     -5     5.5
Hexadecimalni zapis ($...) nefunguje.}
procedure ZadejRadekM(var M:matice; i:word; data:string);
{Umozni zadat i-ty radek matice. M musi existovat a mit spravne rozmery.
Tak trochu low-level, pouziti hlavne kdyby byla matice tak velka, ze by se
jeji zapis nevesel do stringu a nestacila by procedura ZadejM.}
procedure VyplnM(var M:matice; vyska,sirka:word; hodnota:TypPrvkuMatice);
{Vyplni celou matici danou hodnotou. Pokud matice neexistuje, bude vytvorena.
Pokud jiz existuje a chcete jeji rozmery zachovat, je dobre zadat sirku a
vysku 0 (viz proceduru VytvorM).}
procedure JednotkovaM(var M:matice; vyska,sirka:word);
{Z matice M udela jednotkovou matici, tj. na hlavni diagonale bude mit
jednicky a vsude jinde nuly. O zadavani rozmeru plati totez jako u VyplnM.
Pozn. pro ty, kteri to jeste ve skole nebrali: hlavni diagonala jsou ty prvky,
ktere maji stejne cislo radku a sloupce. Zacina v levem hornim rohu matice a
pokracuje doprava dolu.}
procedure TranspM(M:matice; var Vysledek:matice);
{Do matice Vysledek ulozi transponovanou matici M, tj. matici zrcadlove
otocenou kolem hlavni diagonaly.}
procedure SectiM(M1,M2:matice; var vysledek:matice);
{secte matice M1 a M2 (musi byt stejne velke)}
procedure OdectiM(M1,M2:matice; var vysledek:matice);
{od M1 odecte M2 (musi byt stejne velke)}
procedure MinusM(var M:matice);
{otoci znamenko u kazdeho prvku matice M}
procedure NasobCislemM(var M:matice; Cislo:typprvkumatice);
{kazdy prvek matice M vynasobi danym Cislem}
procedure NasobM(M1,M2:matice; var vysledek:matice);
{maticove vynasobi M1*M2 (sirka M1 se musi rovnat vysce M2)}
function PrvekM(var M:matice; i,j:word):typprvkumatice;
{vrati hodnotu prvku matice v i-tem radku a j-tem sloupci}
procedure RadekM(M:matice; i:word; var vysledek:matice);
{ve Vysledku vrati i-ty radek matice M}
procedure SloupecM(M:matice; j:word; var vysledek:matice);
{ve Vysledku vrati j-ty sloupec matice M}
procedure SubM(M:matice; odi,odj,doi,doj:word; var vysledek:matice);
{ve Vysledku vrati submatici z matice M s levym hornim rohem na pozici odi,odj
a s pravym dolnim rohem na pozici doi,doj}
procedure SpojM(M1,M2:matice; pod_sebe:boolean; var vysledek:matice);
{Ve Vysledku vraci spojene matice M1 a M2:
 pod_sebe - true: M1 a pod ni pripojena M2 (obe musi byt stejne siroke)
            false: M1 a zprava k ni pripojena M2 (obe musi byt stejne vysoke)}
const mPodSebe=true;
      mVedleSebe=false;    {pro prehlednejsi zapis}
procedure ProhodRadkyM(var M:matice; Ktery,sKterym:word);
{v matici M prohodi radky s danymi indexy}
procedure KopirujM(Odkud:matice; var Kam:matice);
{kopiruje matici Odkud do matice Kam (Kam se automaticky vytvori)}
procedure TrojuhM(M:matice; var vysledek:matice; var determinant:typprvkumatice);
{Ve Vysledku vrati matici M upravenou na trojuhelnikovou, a to specialne tak,
ze na hlavni diagonale jsou same jednicky (a pod ni nuly). Determinant vypadne
jako vedlejsi produkt, delejte si s nim co chcete. Procedura funguje i pro
obdelnikovou matici, ale determinant je potom nesmyslny.}
function DetM(M:matice):typprvkumatice;
{vraci determinant matice M (M musi byt ctvercova)}
procedure InvM(M:matice; var vysledek:matice);
{Ve Vysledku vrati matici inverzni k matici M (inverzni matice k M je takova
matice, kterou kdyz vynasobite M, vyjde vam jednotkova matice). M musi byt
ctvercova.}
procedure VypisM(M:matice; jmeno:string);
{Vypise matici M s prvky zaokrouhlenymi na 2 desetinna mista, zadne osetreni
prilis dlouhych radku apod., jen pro textovy rezim (writeln). Jmeno se zobrazi
pri vypisu. Priklad:
 napiseme:  vypism(A,'matice A');
 na obrazovce se objevi (napr.):  matice A =
                                      5.00   -4.00
                                      0.00   12.05  }
procedure NactiM(var M:matice; soubor:string);
{Nacte matici z textoveho souboru. Format souboru:
 vyska
 sirka
 jednotlive prvky matice razene po radcich: prvni je 1,1, druhy je 1,2 atd.
Nezalezi na poctu mezer nebo odradkovani mezi cisly (cte se procedurou Read).
Komentare a podobne neciselne udaje se smi psat az na konci souboru za matici.}
procedure UlozM(M:matice; soubor:string);
{ulozi matici do textoveho souboru}


(********************* Cela cisla s obecnou delkou: *************************)

type UkNaPW=^polewordu;
     PoleWordu=array[0..0] of word;

     Obrcislo = object {uzivatelsky typ}
                Delka:word; {Delka hodnoty cisla ve wordech. Cislo s nulovou
                 Delkou se bere jako nula.}
                Hodnota:uknapw; {Ukazatel na hodnotu cisla. Format dat je
                 stejny jako u normalniho longintu: little endian (nizsi byty
                 napred) a zapornost vyjadrena dvojkovym doplnkem.}
                procedure init;
                 {Vynuluje Delku a Hodnotu. Volejte pouze jednou pred prvnim
                 pouzitim obrcisla, potom uz ne!
                 Cerstve inicializovane cislo ma hodnotu 0.}
                procedure Prealokuj(KolikWordu:word);
                 {Alokuje nebo prealokuje cislo na danou delku (vetsi nebo
                 mensi, to je jedno, ale pozor, ze pri zkracovani muze dojit
                 ke ztrate nejvyssich bitu). Lze pouzit kdykoli, hodnota cisla
                 se tim nezmeni.
                 Pokud nevystaci pamet, nastane klasicky Heap Overflow.}
                procedure Smrskni;
                 {Urizne nejvyssi nevyznamne wordy (uvodni nuly u kladnych
                 cisel nebo jednicky u zapornych, samozrejme krome te jedne
                 jednicky nebo nuly, podle ktere se znamenko pozna).
                 Vzdy zustane alokovany aspon jeden word, i kdyby cislo bylo
                 nulove (s vyjimkou nealokovane nuly tesne po inicializaci
                 nebo zruseni, ta zustane nedotcena).}
                procedure VlozLongint(ktery:longint);
                 {Priradi do tohoto obrcisla danou longintovou hodnotu.}
                procedure PrictiLongint(ktery:longint);
                 {Tohle cislo zvetsi o danou longintovou hodnotu.}
                procedure Neguj;
                 {Otoci znamenko tohohle cisla.}
                procedure Vloz(var co:obrcislo);
                 {Zkopiruje do tohohle obrcisla jine.}
                procedure Pricti(var co:obrcislo);
                procedure Odecti(var co:obrcislo);
                procedure Vynasob(var cim:obrcislo);
                function  Vydel(var Cim,Zbytek:obrcislo):boolean;
                 {Celociselne deleni. Delenec je tohle cislo, Cim je delitel.
                 Po skonceni funkce bude v tomhle cisle podil a v promenne
                 Zbytek bude (necekane) zbytek. Pri pokusu o deleni nulou
                 funkce vrati false a nic neprovede, jinak vzdy vraci true.}
                procedure Odmocni;
                 {Nahradi cislo jeho druhou odmocninou. Vysledek je
                 celociselny, pripadna desetinna mista se useknou.}
                procedure PosunDoleva(oKolik:longint);
                 {Posune cislo o dany pocet bitu doleva, lze pouzit i k
                 nasobeni mocninami dvojky. Odpovida instrukcim SHL a SAL.}
                procedure PosunDoprava(oKolik:longint);
                 {Posune cislo o dany pocet bitu doprava, lze pouzit i k
                 deleni mocninami dvojky. Odpovida instrukci SAR.}
                function JeNula:boolean;
                 {Vraci true, jestli je cislo nulove.}
                function JeZaporne:boolean;
                 {Vraci true, kdyz je cislo zaporne. Pro kladne nebo nulu
                 vraci false.}
                function Porovnej(var sCim:obrcislo):shortint;
                 {Nizkourovnova porovnavaci funkce. Mozne vysledky:
                    0 - obe cisla stejna
                   +1 - tohle cislo je vetsi nez sCim
                   -1 - tohle cislo je mensi nez sCim
                 Pro pohodlnejsi zapis je tu nasledujicich pet funkci:}
                function RovnaSe(var cemu:obrcislo):boolean;
                function VetsiNez(var co:obrcislo):boolean;
                function MensiNez(var co:obrcislo):boolean;
                function VetsiNeboRovno(var NezCo:obrcislo):boolean;
                function MensiNeboRovno(var NezCo:obrcislo):boolean;
                function NaHex(ProLidi:boolean):string;
                 {Vraci cislo v hexadecimalnim tvaru. Parametr:
                  true - zaporna cisla budou zobrazena jako minus a
                         absolutni hodnota, uriznou se uvodni nevyznamne
                         cislice. Napr. "71Fh" nebo "-2h".
                  false - zaporna cisla budou zobrazena v "pocitacovem"
                          formatu (dvojkovy doplnek) a uvodni nuly (nebo
                          jednicky) se orezavat nebudou.
                          Napr. "071Fh" nebo "FFFEh".
                 Pozor, ze cislo muze mit vic cifer nez se vejde do stringu;
                 v takovem pripade nebudou videt nejvyssi cifry.}
                function NaDec:string;
                 {Vraci cislo v desitkovem tvaru (jako Str). Opet pozor na
                 mozne prekroceni delky stringu.
                 Funkce pouziva deleni, takze muze byt dost pomala. Jestli
                 spechate, pouzijte radeji rychlou NaHex.}
                procedure zrus; {Uvolni alokovanou pamet a nastavi oba
                 atributy na nulu. Funguje i jako vynulovani cisla.}
                end;
{Maximalni delka cisla je 524224 bitu (tj. 32764 wordu neboli 65528 bytu, vic
se v real modu neda alokovat).
 Alokace a zmena delky ciselnych dat probiha plne automaticky, rucne je
potreba provest pouze uvodni inicializaci a zaverecne zruseni.
 Obrcisla predavana metodam jako parametry musi byt vzdy inicializovana,
i kdyz se jedna o vystupy (jako treba zbytek po deleni). Vstupni parametry
mohou projit smrsknutim (nekdy se primo pouzivaji k vypoctum), ale jejich
numericka hodnota se nezmeni.}


implementation

(******************************* matice: ************************************)

procedure InitM(var M:matice);
Begin
with M do begin _sirka:=0; _vyska:=0; _data:=nil; end;
End;{initm}

procedure ZrusM(var M:matice);
Begin
with M do if _data=nil then matresult:=matzdrojneexistuje {uz je zrusena nebo jeste nebyla vytvorena -> neni co resit}
                       else begin {existuje, zrusime ji}
                            freemem(_data,_vyska*_sirka*sizeof(TypPrvkuMatice));
                            _sirka:=0; _vyska:=0; _data:=nil;
                            matresult:=0;
                            end;
End;{zrusm}

function VytvorM(var M:matice; vyska,sirka:word):boolean;
var velikost:longint;
Begin
if (vyska=0)or(sirka=0)
  then if M._data=nil then begin{bylo zadano "nemenit rozmery" a matice neexistovala, takze neexistuje i nadale}
                           matresult:=matzdrojneexistuje;
                           vytvorm:=false;
                           end
                      else begin{bylo zadano "nemenit rozmery" a matice existuje, takze neni co resit}
                           matresult:=0;
                           vytvorm:=true;
                           end
  else with M do begin {byly zadany nejake rozmery}
                 if _data<>nil then if (_sirka=sirka)and(_vyska=vyska) then begin{matice uz existuje a je spravne velka}
                                                                            matresult:=0;
                                                                            vytvorm:=true;
                                                                            exit;
                                                                            end
                                                                       else {matice existuje, ale neni spravne velka:}
                                                                           freemem(_data,_vyska*_sirka*sizeof(TypPrvkuMatice));
                 velikost:=vyska*sirka*sizeof(TypPrvkuMatice);{kolik pameti nova matice zabere}
                 if (velikost>maxavail)or(velikost>$FFF0{jestli mam tu max. velikost spatne, tak ji prosim opravte})
                   then begin{je moc velka}
                        _vyska:=0; _sirka:=0; _data:=nil;
                        vytvorm:=false;
                        matresult:=matmalopameti;
                        end
                   else begin{dobry, vytvorime ji}
                        getmem(_data,velikost);
                        _vyska:=vyska; _sirka:=sirka;
                        vytvorm:=true;
                        matresult:=0;
                        end;
                 end;{else, with}
End;{vytvorm}

procedure ZadejPrvekM(var M:matice; i,j:word; hodnota:TypPrvkuMatice);
Begin
with M do if _data=nil then matresult:=matzdrojneexistuje{neni do ceho vkladat}
 else if (j>_sirka)or(i>_vyska)or(i<1)or(j<1) then matresult:=matnesedirozmery{indexy vychazeji mimo matici}
  else begin{OK}
       _data^[(i-1)*_sirka+(j-1)]:=hodnota;{Jak se dostat k prvku 2D matice
       ulozene v 1D poli: cislo radku (i) pocitane od nuly vynasobime sirkou
       matice, dostaneme index prvniho prvku na i-tem radku. Pak jeste
       pricteme cislo sloupce (j, opet pocitane od nuly) a je to.}
       matresult:=0;
       end;
End;{zadejprvekm}

procedure VyplnM(var M:matice; vyska,sirka:word; hodnota:TypPrvkuMatice);
var i:word;
Begin
if vytvorm(M,vyska,sirka) then
 with M do for i:=0 to _vyska*_sirka-1 do _data^[i]:=hodnota;
 {staci jednoduchy cyklus, protoze _data^ je jednorozmerne pole}
End;{vyplnm}

procedure JednotkovaM(var M:matice; vyska,sirka:word);
var i,j:word;
Begin
if vytvorm(M,vyska,sirka) then
 with M do for i:=0 to _vyska-1 do
            for j:=0 to _sirka-1 do if i=j then _data^[i*_sirka+j]:=1
                                           else _data^[i*_sirka+j]:=0;
{jednotkova matice vypada napr. takhle: 1 0 0 0
                                        0 1 0 0
                                        0 0 1 0
                                        0 0 0 1
Jakakoli matice maticove vynasobena jednotkovou matici se nezmeni.}
End;{jednotkovam}

procedure TranspM(M:matice; var vysledek:matice);
var i,j:word;
Begin
if vytvorm(vysledek,M._sirka,M._vyska) then
 for i:=0 to M._vyska-1 do
  for j:=0 to M._sirka-1 do vysledek._data^[j*vysledek._sirka+i]:=M._data^[i*M._sirka+j];
   {transpozice = prohozeni radku a sloupcu (prvek z i,j jde na j,i)}
End;{transpm}

procedure SectiM(M1,M2:matice;var vysledek:matice);
var i:word;
Begin
if (M1._sirka<>M2._sirka)or(M1._vyska<>M2._vyska)
 then begin{matice nejsou stejne velke, takze je nelze scitat}
      zrusm(vysledek);
      matresult:=matnesedirozmery;
      end
 else if vytvorm(vysledek,M1._vyska,M1._sirka) then
        for i:=0 to M1._sirka*M1._vyska-1 do vysledek._data^[i]:=M1._data^[i]+M2._data^[i];
 {soucet matic = matice s prislusnymi prvky sectenymi:
  vysledek[1,1]=M1[1,1]+M2[1,1]; vysledek[1,2]=M1[1,2]+M2[1,2] atd.}
End;{sectim}

procedure OdectiM(M1,M2:matice;var vysledek:matice);
var i:word;
Begin
{odcitani je prakticky to same, jenom je tam - misto +}
if (M1._sirka<>M2._sirka)or(M1._vyska<>M2._vyska)
 then begin
      zrusm(vysledek);
      matresult:=matnesedirozmery;
      end
 else if vytvorm(vysledek,M1._vyska,M1._sirka) then
        for i:=0 to M1._sirka*M1._vyska-1 do vysledek._data^[i]:=M1._data^[i]-M2._data^[i];
End;{odectim}

procedure NasobCislemM(var M:matice; Cislo:typprvkumatice);
var i:word;
Begin
if M._data=nil then matresult:=matzdrojneexistuje
               else begin
                    with M do for i:=0 to _vyska*_sirka-1 do _data^[i]:=_data^[i]*cislo;
                    matresult:=matOK;
                    end;
 {nasobit matici cislem znamena nasobit tim cislem kazdy jeji prvek}
End;{nasobcislemm}

procedure MinusM(var M:matice);
var i:word;
Begin
if M._data=nil then matresult:=matzdrojneexistuje
               else begin
                    with M do for i:=0 to _vyska*_sirka-1 do _data^[i]:=-_data^[i];
                    matresult:=matOK;
                    end;
 {v podstate nasobeni cislem -1}
End;{minusm}

procedure NasobM(M1,M2:matice; var vysledek:matice);
var i,j,k:word;
    pom:typprvkumatice;
Begin
if M1._sirka<>M2._vyska then begin
                             zrusm(vysledek);
                             matresult:=matnesedirozmery;
                             exit;
                             end;
if vytvorm(vysledek,M1._vyska,M2._sirka) then
  for i:=0 to vysledek._vyska-1 do
   for j:=0 to vysledek._sirka-1 do
     begin
     pom:=0;
     for k:=0 to M1._sirka-1 do pom:=pom+M1._data^[i*M1._sirka+k]*M2._data^[k*M2._sirka+j];
     with vysledek do _data^[i*_sirka+j]:=pom;
     end;
 {vysledek maticoveho soucinu je matice stejne vysoka jako ta prvni, stejne
 siroka jako druha a kde kazdy prvek na pozici i,j je skalarnim soucinem
 iteho radku prvni matice a jteho sloupce druhe matice.
 Skalarni soucin vektoru vypada napr. takhle: (x,y,z)*(X,Y,Z)=x*X+y*Y+z*Z.
 Maticovy soucin neni obecne komutativni.}
End;{nasobm}

function PrvekM(var M:matice; i,j:word):typprvkumatice;
Begin
with M do if _data=nil then matresult:=matzdrojneexistuje
 else if (i<1)or(j<1)or(i>_vyska)or(j>_sirka) then matresult:=matnesedirozmery
  else prvekm:=_data^[(i-1)*_sirka+j-1];
End;{prvekm}

procedure RadekM(M:matice;i:word; var vysledek:matice);
Begin
if M._data=nil then begin
                    matresult:=matzdrojneexistuje;
                    zrusm(vysledek);
                    end
               else if vytvorm(vysledek,1,M._sirka) then move(M._data^[(i-1)*M._sirka],{odkud}
                                                              vysledek._data^[0],{kam}
                                                              vysledek._sirka*sizeof(typprvkumatice));{kolik bytu}
                                                         {move je rychlejsi nez presouvat prvek po prvku}
End;{radekm}

procedure SloupecM(M:matice;j:word; var vysledek:matice);
var i:word;
Begin
if M._data=nil then begin
                    matresult:=matzdrojneexistuje;
                    zrusm(vysledek);
                    end
               else if not vytvorm(vysledek,M._vyska,1)
                      then begin
                           dec(j);
                           for i:=0 to M._vyska-1 do vysledek._data^[i]:=M._data^[i*M._sirka+j];
                           {tady uz move nejde}
                           end;
End;{sloupecm}

procedure SubM(M:matice;odi,odj,doi,doj:word; var vysledek:matice);
var sirka,vyska,i,j:word;
Begin
if M._data=nil
 then begin
      matresult:=matzdrojneexistuje;
      zrusm(vysledek);
      end
 else begin
      vyska:=doi-odi+1; sirka:=doj-odj+1;
      if vytvorm(vysledek,vyska,sirka) then
        begin
        dec(odi); dec(odj);
        for i:=0 to vyska-1 do
         for j:=0 to sirka-1 do vysledek._data^[i*vysledek._sirka+j]:=M._data^[(odi+i)*M._sirka+odj+j];
        end;
      end;
End;{subm}

procedure SpojM(M1,M2:matice; Pod_Sebe:boolean; var vysledek:matice);
var i,pocet:word;
Begin
if (M1._data=nil)and(M2._data=nil) then begin{neni co spojovat}
                                        matresult:=matzdrojneexistuje;
                                        zrusm(vysledek);
                                        exit;
                                        end;
if M1._data=nil then begin   {matice, ke ktere pripojime neexistujici matici, se nezmeni}
                     kopirujm(M2,vysledek);
                     exit;
                     end;
if M2._data=nil then begin
                     kopirujm(M1,vysledek);
                     exit;
                     end;
if pod_sebe then
 begin
 if M1._sirka<>M2._sirka then matresult:=matnesedirozmery;
 if (matresult<>0) or not vytvorm(vysledek,M1._vyska+M2._vyska,M1._sirka) then zrusm(vysledek)
  else begin
       with M1 do pocet:=_sirka*_vyska;
       {prekopirovani cele prvni matice:}
       move(M1._data^[0],vysledek._data^[0],pocet*sizeof(typprvkumatice));
       {prekopirovani druhe matice pod prvni:}
       move(M2._data^[0],vysledek._data^[pocet],M2._sirka*M2._vyska*sizeof(typprvkumatice));
       end;
 end
else{vedle sebe:}
 if M1._vyska<>M2._vyska then matresult:=matnesedirozmery;
 if (matresult<>0) or not vytvorm(vysledek,M1._vyska,M1._sirka+M2._sirka) then zrusm(vysledek)
  else for i:=0 to M1._vyska-1 do
   begin {pro kazdy radek vysledku:}
   {radek z M1:}
   move(M1._data^[i*M1._sirka],vysledek._data^[i*vysledek._sirka],M1._sirka*sizeof(typprvkumatice));
   {za nej radek z M2:}
   move(M2._data^[i*M2._sirka],vysledek._data^[i*vysledek._sirka+M1._sirka],M2._sirka*sizeof(typprvkumatice));
   end;
End;{spojm}

const cifry=['0'..'9','-','.',',','e','E'];{znaky, ze kterych se skladaji cisla}

procedure ZadejRadekM(var M:matice; i:word; data:string);
var j:byte;
    cislo:typprvkumatice;
    pozice:byte;
    slovo:string;
    kod:integer;
Begin
if data='' then matresult:=matkoneczadani{nic nebylo zadano}
 else if(i>M._vyska)or(i<1) then matresult:=matnesedirozmery{nesmyslny index radku}
  else if M._data=nil then matresult:=matzdrojneexistuje{matice neexistuje, neni kam ukladat}
   else begin
        dec(i);{kvuli pocitani od nuly}
        pozice:=1;{zacatek od prvniho znaku retezce}
        matresult:=0;{jestli vsechno dobre dopadne, ta nula tu zustane}
        with M do for j:=0 to _sirka-1 do {pro kazdy prvek radku}
         begin
         slovo:='';
         while not(data[pozice] in cifry) do inc(pozice);{preskoceni mezer pred cislem}
         if pozice>byte(data[0]) then begin{jsme za koncem retezce, coz je spatne}
                                      matresult:=matkoneczadani;
                                      exit;
                                      end;
         while (pozice<=byte(data[0]))and(data[pozice] in cifry) do
           begin {nacteni cisla}
           slovo:=slovo+data[pozice];
           inc(pozice);
           end;
         val(slovo,cislo,kod); {prevod retezce Slovo na cislo}
         if kod=0 then _data^[i*_sirka+j]:=cislo {OK}
                  else matresult:=matchybavzadani; {prevod se nezdaril}
         end;{with}
        end;{else}
End;{zadejradekm}

procedure ZadejM(var M:matice; data:string);
var i:word;
    radku,sloupcu:word;
    cislo:typprvkumatice;
    pozice:byte;
    slovo:string;
    kod:integer;
Begin
while not (data[1] in cifry) do delete(data,1,1);{oriznuti pripadnych mezer ze zacatku}
while not (data[byte(data[0])] in cifry) do dec(byte(data[0]));{oriznuti pripadnych mezer z konce}
if data='' then begin
                matresult:=matkoneczadani;
                zrusm(M);
                exit;
                end;
pozice:=1;
{spocitani radku (pocet radku = pocet stredniku + 1):}
radku:=1;
for i:=1 to byte(data[0]) do if data[i]=';' then inc(radku);
{spocitani sloupcu ( = pocet cisel v libovolnem radku, treba prvnim):}
i:=1; sloupcu:=0;
 repeat
 while data[i] in cifry do inc(i); {dojdeme za cislo}
 inc(sloupcu); {cislo znamena sloupec}
 while (data[i]<>';')and not(data[i] in cifry) do inc(i); {dojdeme bud na dalsi cislo nebo na strednik - konec radku}
 until data[i]=';'; {a to cele dokud nejsme na konci radku}
{vytvoreni matice:}
if not vytvorm(M,radku,sloupcu) then matresult:=matmalopameti
 else {nacteni dat do matice (diky usporadani matice po radcich staci jeden cyklus):}
      for i:=0 to radku*sloupcu-1 do begin
                                     slovo:='';
                                     while not (data[pozice] in cifry) do inc(pozice);{na zacatek cisla}
                                     if pozice>byte(data[0]) then begin{jsme za koncem retezce, coz je chyba}
                                                                  matresult:=matkoneczadani;
                                                                  exit;
                                                                  end;
                                     while (pozice<=byte(data[0]))and(data[pozice] in cifry) do
                                       begin{nacteni cisla}
                                       slovo:=slovo+data[pozice];
                                       inc(pozice);
                                       end;
                                     kod:=pos(',',slovo);{nalezeni pripadne desetinne carky...}
                                     if kod<>0 then slovo[kod]:='.';{...a jeji prepsani na tecku}
                                     val(slovo,cislo,kod);{prevod slova na cislo}
                                     if kod=0 then M._data^[i]:=cislo{OK}
                                              else begin{chyba}
                                                   matresult:=matchybavzadani;
                                                   exit;
                                                   end;
                                     end;{for i}
End;{zadejm}

procedure ProhodRadkyM(var M:matice; Ktery,sKterym:word);
var bafr:uknappm;
    velikost:word;
Begin
with M do
 begin
 dec(ktery); dec(skterym); {pro pocitani od nuly}
 if (ktery>_vyska-1)or(skterym>_vyska-1) then matresult:=matnesedirozmery {indexy jsou mimo matici}
  else if ktery=skterym then matresult:=0 {jeden radek sam se sebou neni potreba prohazovat -> OK, hotovo}
   else if _data=nil then matresult:=matzdrojneexistuje
    else begin
         velikost:=_sirka*sizeof(typprvkumatice); {velikost radku v bytech}
         if velikost>maxavail then matresult:=matmalopameti {je pamet?}
          else begin {a konecne vlastni presun:}
               getmem(bafr,velikost);
               move(_data^[ktery*_sirka],bafr^,velikost);
               move(_data^[skterym*_sirka],_data^[ktery*_sirka],velikost);
               move(bafr^,_data^[skterym*_sirka],velikost);
               freemem(bafr,velikost);
               matresult:=0;
               end;
         end;
 end;
End;{prohodradkym}

procedure KopirujM(odkud:matice; var kam:matice);
Begin
if odkud._data=nil
 then begin
      zrusm(kam);
      matresult:=matzdrojneexistuje; {v tomto pripade je to vlastne OK}
      end
 else if vytvorm(kam,odkud._vyska,odkud._sirka)then begin
                                                    move(odkud._data^,kam._data^,kam._vyska*kam._sirka*sizeof(typprvkumatice));
                                                    matresult:=0;
                                                    end
                                               else matresult:=matmalopameti;
End;{kopirujm}

procedure TrojuhM(M:matice; var vysledek:matice; var determinant:typprvkumatice);
var i,j,k:word;{indexy}
    pom:typprvkumatice;{pomocne cislo}
Begin
if M._data=nil then begin
                    zrusm(vysledek);
                    matresult:=matzdrojneexistuje;
                    end
 else begin
      kopirujm(M,vysledek);
      determinant:=1;{budeme ho pak ruzne nasobit}
      with vysledek do
       begin
       for i:=0 to mensiz(_sirka,_vyska)-1 do
        begin
        {test, kde v tom sloupci neni nula:}
        k:=i;{zacne se od diagonaly a postupuje se dolu}
        while (vysledek._data^[k*vysledek._sirka+i]=0)and(k<vysledek._vyska) do inc(k);
        {jestli jsou nuly vsude, matice je singularni a koncime:}
        if k>=_vyska then begin
                          zrusm(vysledek);
                          matresult:=matsingularni;
                          determinant:=0;
                          exit;
                          end;
        {na diagonale potrebujeme nenulove cislo:}
        if k<>i then begin
                     prohodradkym(vysledek,k+1,i+1);
                     determinant:=-determinant;{prohozenim radku se zmeni znamenko determinantu}
                     end;
        {vydelit i-ty radek prvkem na diagonale, aby na diagonale byla 1:}
        pom:=_data^[i*_sirka+i];{nacteni prvku}
        for j:=0 to _sirka-1 do _data^[i*_sirka+j]:=_data^[i*_sirka+j]/pom;{vydeleni vsech prvku radku tim na diagonale}
        determinant:=determinant*pom;
         {vydelenim radku konstantou se vydelil i determinant, takze ho musim zase vynasobit, aby zustal spravne}
        {nulovani sloupce pod prvkem na diagonale:}
        for k:=i+1 to _vyska-1 do{pro kazdy radek pod diagonalou}
         begin
         pom:=_data^[k*_sirka+i];{prvni prvek toho radku}
         for j:=i to _sirka-1 do{pro prvky toho radku (pred i-tym jsou bud nuly nebo oblast mimo matici)}
          _data^[k*_sirka+j]:=_data^[k*_sirka+j]-pom*_data^[i*_sirka+j];{odecteme pom-nasobek i-teho radku}
          {determinant se nemeni}
         end;{for k}
        end;{for i}
       end;{with}
      end;{else}
{Pro vypocet determinantu byla pouzita tato pravidla:
 - pokud prohodime dva radky matice, zmeni se znamenko determinantu matice
 - pokud nejaky radek vynasobime nejakym cislem, vynasobi se jim i hodnota
   determinantu
 - pokud k jednomu radku pricteme linearni kombinaci ostatnich (tj. treba
   nejaky nasobek jineho radku), hodnota determinantu se nezmeni
 - determinant trojuhelnikove matice se rovna soucinu prvku na hlavni
   diagonale}
End;{trojuhm}

function DetM(M:matice):typprvkumatice;
var pomm:matice;
    det:typprvkumatice;
Begin
initm(pomm);
with M do
if _data=nil then matresult:=matzdrojneexistuje
 else if _sirka<>_vyska then matresult:=matnesedirozmery{determinant jde jen ze ctvercove matice}
  else if _sirka=1 then detm:=_data^[0]{pro matici 1x1 je determinant rovny tomu jedinemu prvku}
   else if _sirka=2 then detm:=_data^[0]*_data^[3]-_data^[1]*_data^[2]
                         {2x2: det.= soucin prvku z hlavni diagonaly minus soucin prvku z te druhe diagonaly}
    else if _sirka=3 then detm:=_data^[0]*_data^[4]*_data^[8]
                               +_data^[3]*_data^[7]*_data^[2]     {3x3: Sarussovo pravidlo,}
                               +_data^[6]*_data^[1]*_data^[5]     {trochu komplikovanejsi,}
                               -_data^[2]*_data^[4]*_data^[6]     {ale porad jeste v rozumnych mezich}
                               -_data^[5]*_data^[7]*_data^[0]
                               -_data^[8]*_data^[1]*_data^[3]
     else begin
          {pro matice vetsi nez 3x3 uz zadna zjednodusujici pravidla neplati
          a obecny rozvoj podle nektereho radku nebo sloupce by byl rekurzivni
          a pomaly, takze pojedeme pres trojuhelnikovou matici:}
          trojuhm(M,pomm,det);
          zrusm(pomm);
          detm:=det;
          end;
End;{detm}

procedure InvM(M:matice; var vysledek:matice);
var i,j,k:word;
    pom,pom2:matice;
    x:typprvkumatice;
Begin
if M._sirka<>M._vyska
 then begin {inverze jde jen ze ctvercove matice}
      matresult:=matnesedirozmery;
      zrusm(vysledek);
      end
 else begin
      initm(pom); initm(pom2);
      {postup: k dane matici pripojim zprava stejne velkou jednotkovou a to
      cele pomoci radkovych uprav upravuji tak dlouho, az z te puvodni vlevo
      mam jednotkovou. Ta vpravo (puvodne jednotkova) bude hledana inverze.
      Je na to i nejaky vzorec s determinanty a subdeterminanty, ale proc
      delat veci slozite, kdyz to jde jednoduse. A navic to takhle bude mozna
      i rychlejsi.}
      jednotkovam(pom,M._vyska,M._sirka);
      SpojM(M,pom,false,pom2);      {pom2 = M|pom}
      trojuhm(pom2,pom,x);{pom = trojuh.}
      zrusm(pom2);
      {ted jsou na hlavni diagonale jednicky a pod nimi nuly,
      zbyva vynulovat prvky nad hl. diagonalou:}
      with pom do
       for i:=0 to _vyska-2 do {pro i od nulteho do predposledniho radku (posledni neni potreba upravovat, tam je jenom ta 1)}
        for j:=i+1 to M._sirka-1 do {pro j pro kazdy prvek i-teho radku vpravo od diagonaly}
         begin
         x:=_data^[i*_sirka+j];
         for k:=j to _sirka-1 do
          _data^[i*_sirka+k]:=_data^[i*_sirka+k]-x*_data^[(j)*_sirka+k];{odecitani x-nasobku radku}
         end;
      {ted je vlevo jednotkova matice. Zbyva uz jenom tu pravou ukrojit a
      vratit jako vysledek:}
      subm(pom,1,M._sirka+1,pom._vyska,pom._sirka,vysledek);
      zrusm(pom);
      end;
End;{invm}

procedure VypisM(M:matice; jmeno:string);
var i,j:word;
Begin
write(jmeno);
if M._data=nil then writeln(' neexistuje.')
 else begin
      writeln(' =');
      for i:=1 to M._vyska do
       begin
       for j:=1 to M._sirka do write(prvekm(M,i,j):8:4);
       writeln;
       end;
      end;
writeln;
End;{vypism}

procedure NactiM(var M:matice; soubor:string);
var f:text;
    i:word;
    s,v:word;
    pom:typprvkumatice;
Begin
assign(f,soubor); reset(f);
if ioresult=0 then begin
                   read(f,v); read(f,s);
                   if (ioresult=0)and vytvorm(M,v,s)
                     then for i:=1 to s*v do begin
                                             read(f,pom);
                                             M._data^[i-1]:=pom;
                                             end;
                   if ioresult<>0 then matresult:=matiochyba;
                   close(f);
                   if ioresult<>0 then {to uz se snad nestane};
                   end
              else matresult:=matiochyba;
End;{nactim}

procedure UlozM(M:matice; soubor:string);
var f:text;
    i,j:word;
Begin
if M._data=nil then begin
                    matresult:=matzdrojneexistuje;
                    exit;
                    end;
assign(f,soubor); rewrite(f);
if ioresult=0 then with M do begin
                             writeln(f,_vyska);
                             writeln(f,_sirka);
                             for i:=0 to _vyska-1 do
                              begin
                              for j:=0 to _sirka-1 do write(f,_data^[i*_sirka+j]:9:6);
                              writeln;
                              end;
                             close(f);
                             if ioresult=0 then matresult:=0
                                           else matresult:=matiochyba;
                             end
              else matresult:=matiochyba;
End;{ulozm}


(************************ komplexni cisla: **********************************)

procedure ZadejKCAB(var KC:KomplexniCislo;a,b:real);
Begin
with KC do begin
           _R:=sqrt(a*a+b*b);{abs. hodnota je vzdalenost od pocatku -> Pythagorova veta}
           {s uhlem je to slozitejsi:}
           if a>0 then _fi:=arctan(b/a){prvni nebo ctvrty kvadrant}
                  else if a<0 then _fi:=pi+arctan(b/a){druhy nebo treti kvadrant}
                              else if b>=0 then _fi:=pi/2{a=0, b je kladne (nebo 0)}
                                           else _fi:=3*pi/2;{a=0, b je zaporne}
           end;
End;{zadejkcab}

procedure ZadejKCRFi(var KC:KomplexniCislo;R,fi:real);
Begin
with KC do begin
           _R:=R;
           _fi:=fi;
           end;
End;{zadejkcrfi}

function KCRe(KC:KomplexniCislo):real;
Begin
with KC do kcre:=_R*cos(_fi);
End;{kcinfo}

function KCIm(KC:KomplexniCislo):real;
Begin
with KC do kcim:=_R*sin(_fi);
End;{kcinfo}

procedure SectiKC(co,sCim:KomplexniCislo; var vysledek:KomplexniCislo);
Begin
{pro scitani je lepsi algebraicky tvar}
zadejKCab(vysledek,co._R*cos(co._fi)+scim._R*cos(scim._fi),
                   co._R*sin(co._fi)+scim._R*sin(scim._fi));
End;{sectikc}

procedure OdectiKC(OdCeho,Co:KomplexniCislo; var vysledek:KomplexniCislo);
Begin
zadejKCab(vysledek,odceho._R*cos(odceho._fi)-co._R*cos(co._fi),
                   odceho._R*sin(odceho._fi)-co._R*sin(co._fi));
End;{odectikc}

procedure NasobKC(Co,Cim:KomplexniCislo; var vysledek:KomplexniCislo);
Begin
{nasobit komplexni cisla znamena vynasobit jejich absolutni hodnoty a secist
jejich uhly (Moivreova veta):}
vysledek._R:=co._R*cim._R;
vysledek._fi:=co._fi+cim._fi;
End;{nasobkc}

procedure VydelKC(Co,Cim:KomplexniCislo; var vysledek:KomplexniCislo);
Begin
vysledek._R:=co._R/cim._R;
vysledek._fi:=co._fi-cim._fi;
End;{vydelkc}

procedure KCxRC(var Co:KomplexniCislo; cim:real);
Begin
with co do _R:=_R*cim;
{je to totez jako nasobit to komplexnim cislem s nulovym uhlem
(coz je realne cislo)}
End;{kcxrc}

(**************************** ostatni veci: *********************************)

function pow(a,n:real):real;
var i:longint;
    vysledek:real;
Begin
if a=0 then pow:=0 {nula na cokoli je porad nula (dejme tomu, ze i neurcity vyraz nula na nultou)}
 else if n=0 then pow:=1 {cokoli na nultou je 1}
  else if frac(n)=0 then begin {obecna mocnina, ale s celym exponentem}
                         vysledek:=1;
                         for i:=1 to abs(trunc(n)) do vysledek:=vysledek*a;
                         if n<0 then vysledek:=1/vysledek; {protoze a^(-n) = 1/(a^n)}
                         pow:=vysledek;
                         end
   else {uplne obecna mocnina s realnym exponentem}
        if a<0 then pow:=0 {radsi vysledek 0 nez Invalid floating point operation pri zapornem zakladu logaritmu}
               else pow:=exp(n*(ln(a))); {protoze ln(a^n)=n*ln(a) a exp(ln(x))=x}
End;{pow}

function tg(x:real):real;
var cosinus:real;
Begin
cosinus:=cos(x);
if cosinus=0 then tg:=0 {lepsi nula ve vysledku nez ve jmenovateli (Division by zero)}
             else tg:=sin(x)/cosinus;
End;{tg}

function cotg(x:real):real;
var sinus:real;
Begin
sinus:=sin(x);
if sinus=0 then cotg:=0
           else cotg:=cos(x)/sinus;
End;{cotg}

function sgn(x:real):shortint;
Begin
if x<0 then sgn:=-1
       else if x>0 then sgn:=1
                   else sgn:=0;
End;{sgn}

function vzdalbodu(x1,y1,x2,y2:longint):word;
Begin
vzdalbodu:=round(sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)));{Pythagorova veta}
End;{vzdalbodu}

function preved(cislo:longint;zaklad,sirka:byte):string;
var vysl:string;
    i:word;
    minus:boolean;
Begin
minus:=cislo<0; cislo:=abs(cislo);
vysl:='';
 repeat {prevod}
 i:=cislo mod zaklad;
 cislo:=cislo div zaklad;
 if i<10 then vysl:=chr(i+ord('0'))+vysl
         else vysl:=chr(i+ord('A')-10)+vysl;
 until cislo=0;
while byte(vysl[0])<sirka do vysl:='0'+vysl; {prodlouzeni na pozadovanou sirku}
if minus then preved:='-'+vysl else preved:=vysl;
End;{preved}

function naDes(ret:string;zaklad:byte):longint;
var a:word; {budouci vysledek}
    i:byte; {pomocne pocitadlo}
    minus:boolean; {na uchovani znamenka}
Begin
minus:=ret[1]='-'; if minus then delete(ret,1,1);
for i:=1 to length(ret) do ret[i]:=upcase(ret[i]);{vsechno na velka pismena}
a:=0;
for i:=1 to length(ret) do {pro kazdy znak retezce, zleva}
  begin
  a:=a*zaklad;
  if ret[i]>='A'then inc(a,byte(ret[i])-55)  {65=ord('A'), 55 protoze jeste pricitame desitku}
                else inc(a,byte(ret[i])-48); {48=ord('0')}
  end;
if minus then nades:=-a
         else nades:=a;
End;{nades}

procedure vektorovysoucin(u1,u2,u3,v1,v2,v3:real;var r1,r2,r3:real);
Begin
r1:=u2*v3-u3*v2;
r2:=u3*v1-u1*v3;
r3:=u1*v2-u2*v1;
End;{vektorovysoucin}

procedure kvadrovnice(a,b,c:real; var x1,x2:real; var CoVyslo:byte);
var d:real;{diskriminant}
Begin
if a=0 then if b=0 then if c=0 then covyslo:=krnekonecnoreseni
                               else covyslo:=krnemareseni
                   else begin
                        covyslo:=krlinearni;
                        x1:=-c/b;
                        x2:=x1;
                        end
       else begin
            d:=b*b-4*a*c;
            if d>0 then begin
                        covyslo:=krdvarealne;
                        d:=sqrt(d);
                        x1:=(-b+d)/(2*a);
                        x2:=(-b-d)/(2*a);
                        end
                   else if d=0 then begin
                                    covyslo:=krdvojnasobny;
                                    x1:=(-b)/(2*a);
                                    x2:=x1;
                                    end
                               else begin
                                    covyslo:=krkomplexni;
                                    d:=sqrt(-d);
                                    x1:=(-b)/(2*a);
                                    x2:=d/(2*a);
                                    end;
            end;
End;{kvadrovnice}

function orez(a,min,max:integer):integer;
Begin
if a<min then a:=min;
if a>max then a:=max;
orez:=a;
End;{orez}

function vpoli(x,y,x1,y1,x2,y2:integer):boolean;
Begin
vpoli:=(x>=x1)and(x<=x2)and(y>=y1)and(y<=y2);
End;{vpoli}

function ArcSin(x:real):real;
var r:real;
Begin
r:=1-x*x;
if r>0 then arcsin:=arctan(x/sqrt(r))
       else arcsin:=0;
End;{arcsin}

function ArcCos(x:real):real;
var r:real;
Begin
r:=1-x*x;
if (r>=0)and(x<>0) then arccos:=arctan(sqrt(r)/x)
                   else arccos:=0;
End;{arccos}

function vetsiz(a,b:integer):integer; assembler;
Asm          {if a>b then vetsiz:=a else vetsiz:=b;, Asm verze prevzata z jednotky Editors/Borland}
mov AX,a
cmp AX,b
jg @aJeVetsi       {pro cislo bez znamenka by to bylo ja}
mov AX,b
@aJeVetsi:
End;{vetsiz}

function mensiz(a,b:integer):integer; assembler;
Asm          {if a<b then mensiz:=a else mensiz:=b;, Asm verze prevzata z jednotky Editors/Borland}
mov AX,a
cmp AX,b
jl @aJeMensi   {pro cislo bez znamenka jb}
mov AX,b
@aJeMensi:
End;{mensiz}

function uhelvektoru(u1,u2,v1,v2:integer):real;
var u,v:real;
Begin
u:=sqrt(u1*u1+u2*u2);
v:=sqrt(v1*v1+v2*v2);
uhelvektoru:=arccos((u1*v1+u2*v2)/(u*v));
End;{uhelvektoru}

function Uhelpruvodice(x,y:integer):real;
Begin
if x>0 then uhelpruvodice:=arctan(y/x) {1. a 4. kvadrant}
       else if x<0 then uhelpruvodice:=pi+arctan(y/x) {2. a 3. kvadrant}
                   else if y>=0 then uhelpruvodice:=pi/2 {primo nahoru}
                                else uhelpruvodice:=3*pi/2; {primo dolu}
End;{uhelpruvodice}

function otocbyte(cislo:byte):byte; assembler;
Asm    {v Asm je to kupodivu jednodussi a pohodlnejsi na napsani nez v obycejnem Pascalu :-) }
mov BL,cislo    {BL = zdroj}
xor AL,AL       {AL = cil, zatim 0}
mov CX,8        {bude to 8krat (pocet bitu v bytu)}
 @cyklus:
 shl AL,1       {AL o 1 bit doleva}
 ror BL,1       {BL rotuj o 1 bit doprava}
 adc AL,0       {pokud "pretekla" jednicka, pricti ji k AL (skonci na nejnizsim bitu)}
 loop @cyklus
{navratova hodnota funkce se rovnou preda v AL, kde uz je vysledek}
End;{otocbyte}

function OtocWord(cislo:word):word; assembler;
Asm                {totez, ale pro 16 bitu}
mov BX,cislo
xor AX,AX
mov CX,16
 @cyklus:
 shl AX,1
 ror BX,1
 adc AX,0
 loop @cyklus
{navratova hodnota funkce se preda v AX}
End;{otocword}

procedure rozvinplast(md,vd,h:real; var mr,vr,alfa:real);
var a,b,c:real;
Begin
if md>vd then begin{kdyz je zadany mensi prumer vetsi nez ten vetsi, radsi je prohodim}
              a:=md;
              md:=vd;
              vd:=a;
              end;
if md=vd then begin {je to valec}
              mr:=pi*md; {obvod podstavy = sirka plaste}
              vr:=h; {vyska plaste je rovna te zadane}
              alfa:=0; {uhel dvou rovnobezek je 0}
              end
         else begin {je to kuzel, at uz komoly nebo obycejny}
              md:=md/2; vd:=vd/2; {odtedka to jsou polomery!}
              {pomocne hodnoty:}
              a:=2*pi*vd;
              b:=2*pi*md;
              c:=sqrt(sqr(h)+sqr(vd-md));
              {vlastni vypocet:}
              alfa:=(a-b)/c;
              mr:=b/alfa;
              vr:=a/alfa;
              end;
End;{rozvinplast}

function interpol(x1,y1,x2,y2,x:real):real;
Begin
interpol:=y1+(y2-y1)*(x-x1)/(x2-x1);
End;{interpol}

function DivUp(co,cim:longint):longint;
Begin
divup:=(co+cim-1) div cim;
End;{divup}

function VzdalBoduOdPrimky(x,y,a,b,c:real):real;
Begin
vzdalboduodprimky:=abs(a*x+b*y+c)/sqrt(a*a+b*b);
End;{vzdalboduodprimky}

(************************** vyrazy: *****************************************)

const cislice=['0'..'9','.']; {z ceho se mohou skladat cisla}
      znamenka=['+','-','*','/','^','~'];
      pismena=['a'..'z']; {z ceho se mohou skladat nazvy konstant a funkci}
      _abs='A';
      _sin='S';    {Protoze pouzivame jenom jednoznakove operatory, }
      _cos='C';    {je potreba pro viceznakove funkce zvolit nejake }
      _tg='T';     {jednopismenne zkratky.                          }
      _cotg='K';
      _arcsin='B';
      _arccos='D';
      _arctg='G';
      _ln='L';
      _log='O';

function UpravVyraz(ktery:string):string;
var i,p:byte;
Begin
{vyhazeni mezer:}
p:=pos(' ',ktery);
while p<>0 do begin
              delete(ktery,p,1);
              p:=pos(' ',ktery);
              end;
{prevod alternativnich znaku na platne:}
for i:=1 to length(ktery) do
 case ktery[i] of ',':ktery[i]:='.'; {desetinna carka na tecku}
                  '[':ktery[i]:='('; {alternativni zavorky na kulate}
                  '{':ktery[i]:='(';
                  ']':ktery[i]:=')';
                  '}':ktery[i]:=')';
                  ':':ktery[i]:='/'; {alternativni delitko na lomitko}
                  'A'..'Z':inc(ktery[i],ord('a')-ord('A')); {velka pismena na mala}
                  end;
upravvyraz:=ktery;
End;{upravvyraz}

function SpocitejVyraz(vyraz:string; x,y,z:vyrtyphodnot):vyrtyphodnot;
type PoleRealu=array[1..128] of vyrtyphodnot;
     PoleCharu=array[1..127] of char;
var operandy:^polerealu; {zasobnik na hodnoty}
    PocetOperandu:byte; {pocet hodnot v tomto zasobniku}
    operatory:^polecharu; {zasobnik na znamenka}
    PocetOperatoru:byte; {pocet znamenek}
    {zasobniky by sly udelat i jednoduseji jako staticka pole, ale to by pak
    hrozilo, ze pri vicenasobne rekurzi pri vnorenych zavorkach pretece
    systemovy zasobnik}
    PocetZavorek, {pro hledani koncu zavorek}
    ZacatekPodvyrazu,KonecPodvyrazu:byte; {pozice prvniho a posledniho znaku vyrazu v zavorce}
    index:byte; {pro prochazeni vyrazu}
    OK:boolean; {pro detekci neznamych znaku}
    JednoCislo:string[20]; {pro tahani vicecifernych cisel z vyrazu}
    cislo:vyrtyphodnot; {pro prevod nalezenych cisel na binarni tvar}
    kod:integer; {pro kontrolu uspesnosti prevodu}
    slovo:string[20]; {pro tahani jmen promennych a funkci}

  procedure VlozCislo(jake:vyrtyphodnot); {vlozi danou hodnotu na zasobnik hodnot}
  Begin
  inc(pocetoperandu);
  operandy^[pocetoperandu]:=jake;
  End;{vlozcislo}

  procedure VlozZnamenko(jake:char); {vlozi dane znamenko na zasobnik operatoru}
  Begin
  inc(pocetoperatoru);
  operatory^[pocetoperatoru]:=jake;
  End;{vlozznamenko}

  procedure VlozFunkci(jakou:char); {vlozi na zasobniky vyplnovou hodnotu a operator funkce}
  Begin
  vlozcislo(0); {vypln, aby se nemusely zavadet unarni operace}
  vlozznamenko(jakou);
  End;{vlozfunkci}

  procedure uklid; {vyklizeni zabrane pameti}
  Begin
  dispose(operandy); dispose(operatory);
  End;{uklid}

  function priorita(ceho:char):byte; {rekne, jakou prioritu ma dany operator}
  Begin
  case ceho of '+','-':priorita:=10; { \ na presnych hodnotach nezalezi, }
               '*','/':priorita:=20; { / jde jenom o to, ktera je vetsi  }
               '^','~':priorita:=30; {/                                  }
               _abs,_sin,_cos,_tg,_cotg,_arcsin,_arccos,_arctg,_ln,_log:priorita:=$FF; {tahle musi byt uplne nejvetsi}
               else priorita:=0; {tohle prakticky nemuze nastat, ale radsi at je to definovane}
               end;
  End;{priorita}

  function operace(PrvniOperand,DruhyOperand:vyrtyphodnot; operator:char):vyrtyphodnot;
  {provede s danymi hodnotami danou operaci a vrati vysledek}
  Begin
  case operator of '+':operace:=prvnioperand+druhyoperand;
                   '-':operace:=prvnioperand-druhyoperand;
                   '*':operace:=prvnioperand*druhyoperand;
                   '/':if druhyoperand=0 then vyrresult:=1
                                         else operace:=prvnioperand/druhyoperand;
                   '^':if (prvnioperand<0)and(frac(druhyoperand)<>0)
                         then vyrresult:=2
                         else operace:=pow(prvnioperand,druhyoperand);
                   '~':if prvnioperand=0 then vyrresult:=3
                        else if (druhyoperand<0)and(frac(1/prvnioperand)<>0)
                               then vyrresult:=4
                         else operace:=pow(druhyoperand,1/prvnioperand);
                   _abs:operace:=abs(druhyoperand);     {prvni operand se u funkci ignoruje}
                   _sin:operace:=sin(druhyoperand);
                   _cos:operace:=cos(druhyoperand);
                   _tg:if cos(druhyoperand)=0 then vyrresult:=5
                                              else operace:=tg(druhyoperand);
                   _cotg:if sin(druhyoperand)=0 then vyrresult:=6
                                                else operace:=cotg(druhyoperand);
                   _arcsin:if abs(druhyoperand)>1 then vyrresult:=7
                                                  else operace:=arcsin(druhyoperand);
                   _arccos:if abs(druhyoperand)>1 then vyrresult:=8
                                                  else operace:=arccos(druhyoperand);
                   _arctg:operace:=arctan(druhyoperand);
                   _ln:if druhyoperand<=0 then vyrresult:=9
                                          else operace:=ln(druhyoperand);
                   _log:if druhyoperand<=0 then vyrresult:=10
                                           else operace:=ln(druhyoperand)/ln(10);
                   else operace:=0; {teoreticky nemozne}
                   end;
  End;{operace}

Begin{spocitejvyraz}
vyrresult:=0;
if maxavail<sizeof(polerealu)+sizeof(polecharu) then begin vyrresult:=19; exit; end;
new(operandy); new(operatory);
if vyraz='' then vyraz:='0'; {blbuvzdornost predevsim}
if vyraz[1]='-' then vyraz:='0'+vyraz {aby se nemuselo zavadet unarni minus...}
 else if vyraz[1]='+' then delete(vyraz,1,1); {...a plus}
pocetoperandu:=0; pocetoperatoru:=0; {zasobniky jsou na zacatku prazdne}
index:=1; {pojedeme od prvniho znaku vyrazu}
while index<=length(vyraz) do
  begin
  ok:=false;
  {------------------cisla:------------------}
  if vyraz[index] in cislice
    then begin
         jednocislo:=vyraz[index];
         inc(index);
         while index<=length(vyraz) do
           begin {nacteme zbyle cifry cisla}
           if vyraz[index] in cislice then jednocislo:=jednocislo+vyraz[index]
                                      else break; {uz jsme za cislem}
           inc(index);
           end;
         val(jednocislo,cislo,kod); {prevedeme na skutecnou ciselnou hodnotu}
         if kod<>0 then begin vyrresult:=12; uklid; exit; end; {prevod se nepovedl}
         vlozcislo(cislo); {ulozime hodnotu na zasobnik}
         ok:=true;
         {ted jsme na prvnim znaku za cislem}
         end;
  {------------------znamenka:------------------}
  if (index<=length(vyraz))and(vyraz[index] in znamenka)
    then begin
         while (pocetoperatoru<>0)and(priorita(vyraz[index])<=priorita(operatory^[pocetoperatoru])) do
           begin
           {prave nacteny operator ma mensi prioritu nez ten na zasobniku,
            pred jeho vlozenim je potreba vyhodnotit vsechny predchozi
            operatory na zasobniku, ktere maji vetsi prioritu:}
           if pocetoperandu<2 then begin vyrresult:=13; uklid; exit; end;
           operandy^[pocetoperandu-1]:=operace(operandy^[pocetoperandu-1],
                                               operandy^[pocetoperandu],
                                               operatory^[pocetoperatoru]);
           if vyrresult<>0 then begin uklid; exit; end;
           dec(pocetoperandu);
           dec(pocetoperatoru);
           end;
         if pocetoperatoru>=127 then begin vyrresult:=18; uklid; exit; end;
          {^tohle muze nastat jenom pri chybnem vyrazu typu '++++++++++++'}
         vlozznamenko(vyraz[index]); {ulozime novy operator na zasobnik}
         {writeln('Vlozen operator ',vyraz[index]);}
         inc(index); {ve vyrazu se posuneme za tento operator}
         ok:=true;
         end;
  {------------------promenne a funkce:------------------}
  if (index<=length(vyraz))and(vyraz[index] in pismena)
    then begin
         slovo:=vyraz[index];
         inc(index);
         while index<=length(vyraz) do
           begin {nacteme zbyla pismena}
           if vyraz[index] in pismena then slovo:=slovo+vyraz[index]
                                      else break;
           inc(index);
           end;
         if slovo='x' then vlozcislo(x)        {promenne}
          else if slovo='y' then vlozcislo(y)
           else if slovo='z' then vlozcislo(z)
            else if slovo='pi' then vlozcislo(pi)     {konstanty}
             else if slovo='e' then vlozcislo(exp(1))
              else if slovo='abs' then vlozfunkci(_abs)   {funkce}
               else if slovo='sin' then vlozfunkci(_sin)
                else if slovo='cos' then vlozfunkci(_cos)
                 else if slovo='tg' then vlozfunkci(_tg)
                  else if slovo='cotg' then vlozfunkci(_cotg)
                   else if slovo='arcsin' then vlozfunkci(_arcsin)
                    else if slovo='arccos' then vlozfunkci(_arccos)
                     else if slovo='arctg' then vlozfunkci(_arctg)
                      else if slovo='ln' then vlozfunkci(_ln)
                       else if slovo='log' then vlozfunkci(_log)
                        else begin vyrresult:=14; uklid; exit; end;
         ok:=true;
         {ted jsme na prvnim znaku za slovem; u funkci zbyva nacist argument:}
         end;
  {------------------zavorky:------------------}
  if (index<=length(vyraz))and(vyraz[index]='(')
    then begin
         {zjistime, kde tahle zavorka konci:}
         pocetzavorek:=1;
         zacatekpodvyrazu:=index+1;
          repeat
          inc(index);
          if index>length(vyraz) then begin vyrresult:=15; uklid; exit; end;
          if vyraz[index]='(' then inc(pocetzavorek) {vnorene zavorky}
           else if vyraz[index]=')' then dec(pocetzavorek);
          until pocetzavorek=0; {ke kazde '(' prislusna ')'}
         konecpodvyrazu:=index-1;
         {na vyraz v zavorce rekurzivne zavolame vyhodnoceni:}
         cislo:=spocitejvyraz(copy(vyraz,zacatekpodvyrazu,konecpodvyrazu-zacatekpodvyrazu+1),x,y,z);
         if vyrresult<>0 then begin uklid; exit; end;
         {a vysledek vlozime na zasobnik hodnot:}
         vlozcislo(cislo);
         inc(index); {posuneme se za zavorku}
         {ted jsme na prvnim znaku za zavorkou}
         ok:=true;
         end;
  if not ok {nenaslo se cislo, znamenko, klicove slovo ani zavorka}
    then begin vyrresult:=16; uklid; exit; end;
  {slo by to udelat i jinak, treba pouzit case nebo if... else if...,
   ale takhle se usetri par pruchodu cyklem}
  end;
{vyraz je vyrizeny, ted jeste vyridime to, co zustalo v zasobnicich:}
while pocetoperandu>1 do {postupujeme tak dlouho, dokud nezustane posledni hodnota}
  begin
  if pocetoperatoru=0 then begin vyrresult:=17; uklid; exit; end;
  operandy^[pocetoperandu-1]:=operace(operandy^[pocetoperandu-1],
                                      operandy^[pocetoperandu],
                                      operatory^[pocetoperatoru]);
  if vyrresult<>0 then begin uklid; exit; end;
  dec(pocetoperandu);
  dec(pocetoperatoru);
  end;
if pocetoperatoru<>0 then vyrresult:=18;
spocitejvyraz:=operandy^[1]; {posledni hodnota v zasobniku je vysledek}
uklid;
End;{spocitejvyraz}

(***************************** obrcisla: ************************************)

procedure obrcislo.init;
Begin
delka:=0;
hodnota:=nil;
End;{obrcislo.init}

procedure obrcislo.Prealokuj(KolikWordu:word);
var nova:uknapw;
    KeZkopirovani:word;
    vypln:byte;
Begin
if kolikwordu=delka then exit; {neni co menit}
if kolikwordu=0 then begin zrus; exit; end; {realokace na nulovou delku znamena zruseni}
getmem(nova,kolikwordu shl 1); {1 word = 2 byty, "shl 1" = "*2"}
if delka<kolikwordu then begin {kratsi do delsiho - vlevo rozkopirujeme nejvyssi bit}
                         if jezaporne then vypln:=$FF  {zaporne nastavime jednickami}
                                      else vypln:=0;   {kladne nulami}
                         fillchar(nova^[delka],(kolikwordu-delka) shl 1,vypln);
                         end;
if delka<>0 then begin {presunuti puvodniho cisla}
                 if delka<kolikwordu then kezkopirovani:=delka
                                     else kezkopirovani:=kolikwordu; {pripadny vrsek se urizne}
                 move(hodnota^[0],nova^[0],kezkopirovani shl 1);
                 freemem(hodnota,delka shl 1);
                 end;
delka:=kolikwordu;
hodnota:=nova;
End;{obrcislo.prealokuj}

procedure obrcislo.Smrskni;
var prazdno:word;
    w:word;
Begin
if delka=0 then exit;
if hodnota^[delka-1] and $8000=0 then prazdno:=0      {kladne}
                                 else prazdno:=$FFFF; {zaporne}
w:=delka-1;
while (w<>0)
      and (hodnota^[w]=prazdno) {pokud jsou tady same nevyznamne bity...}
      and ((hodnota^[w-1] and $8000)=(prazdno and $8000)) {...a nejvyssi bit nasledujiciho wordu je taky nevyznamny...}
 do dec(w); {...muzeme vrchni word bez obav zahodit}
prealokuj(w+1);
End;{obrcislo.smrskni}

procedure obrcislo.VlozLongint(ktery:longint);
Begin
prealokuj(2); {1 longint = 2 wordy}
move(ktery,hodnota^,4); {format dat mame stejny, takze to staci zkopirovat}
End;{obrcislo.vlozlongint}

procedure obrcislo.PrictiLongint(ktery:longint);
var pom:obrcislo;
Begin
pom.init;
pom.vlozlongint(ktery);
pricti(pom);
pom.zrus;
End;{obrcislo.prictilongint}

procedure obrcislo.Neguj;
var w:word;
Begin
if not jenula {alokovana nula by se klidne znegovat mohla (nic by to s ni neudelalo), ale s nealokovanou by byly problemy}
  then begin
       for w:=0 to delka-1 do hodnota^[w]:=not hodnota^[w]; {prvni krok: negace vsech bitu}
       prictilongint(1); {druhy krok: pricteni jednicky}
       end;
End;{obrcislo.neguj}

procedure obrcislo.Vloz(var co:obrcislo);
Begin
prealokuj(co.delka);
move(co.hodnota^,hodnota^,delka shl 1);
End;{obrcislo.vloz}

procedure obrcislo.Pricti(var co:obrcislo);
var SpolecnaDelka:word;
    prvni,druhe:pointer;
Begin
{soucet muze pretect max. o jeden bit, takze obe cisla srovname na stejnou
delku o 1 vetsi nez vetsi z tech puvodnich dvou:}
if delka>co.delka then spolecnadelka:=delka
                  else spolecnadelka:=co.delka;
inc(spolecnadelka);
prealokuj(spolecnadelka);
co.prealokuj(spolecnadelka);
{a ted to scitani:  (hura, konecne nejaky assembler :-))}
prvni:=hodnota; druhe:=co.hodnota; {primo to les a lds nejak neberou, tak musim oklikou pres extra ukazatele}
asm
push DS
les DI,prvni     {ES:DI - k tomuhle pricitam}
lds SI,druhe     {DS:SI - tohle pricitam}
mov CX,spolecnadelka
clc              {timhle se vynuluje CF}
 @cyklus:
 lodsw           {vezmi jeden word ze druheho cisla...}
 adc AX,[ES:DI]  {...pricti word z prvniho cisla a pripadny pretekly bit (CF) z minule iterace...}
 stosw           {...a uloz to do prvniho cisla}
 dec CX
 jnz @cyklus     {misto dec+jnz by sel pouzit loop, ale tohle je o par taktu rychlejsi}
pop DS
end;
smrskni;     {aby nam cisla prilis nebobtnala}
co.smrskni;
End;{obrcislo.pricti}

procedure obrcislo.Odecti(var co:obrcislo);
Begin
{A-B = A+(-B) a negovat i scitat uz umime, takze nic nemusime psat odznova:}
co.neguj;
pricti(co);
co.neguj;
End;{obrcislo.odecti}

procedure obrcislo.Vynasob(var cim:obrcislo);
var cinitel,vysledek:obrcislo;
Begin
if cim.jenula then begin zrus; exit; end; {drobna zkratka pro urychleni, ale neni nutna, funguje to i s nulou}
{Algoritmus odpovida klasickemu nasobeni na papire, jenom se nam diky binarni
soustave ponekud zjednodusuje: nic nemusime nasobit, cifry staci bud nulovat
nebo opisovat beze zmeny. Potize mohou nastat jedine kdyz je druhy operand
zaporny, to se pak mezivysledky musi krome scitani i odcitat. Pro usetreni
prace se radsi postarame o to, aby zaporny nebyl:}
cinitel.init;
cinitel.vloz(cim);
if cinitel.jezaporne then begin
                          neguj;
                          cinitel.neguj;
                          {znegovanim obou operandu se znamenko vysledku
                          nezmeni, jenom se zbavime neprijemneho minusu
                          v ciniteli}
                          end;
vysledek.init; {0}
while not cinitel.jenula do begin
                            {pri jednickovem bitu se mezivysledek pricita beze zmeny, pri nulovem se ignoruje:}
                            if cinitel.hodnota^[0] and 1<>0 then vysledek.pricti(self);
                            posundoleva(1);
                            cinitel.posundoprava(1);
                            end;
cinitel.zrus;
zrus;
delka:=vysledek.delka;         {rychlejsi nez vloz(vysledek) a vysledek.zrus,}
hodnota:=vysledek.hodnota;     {protoze se usetri fyzicke kopirovani dat     }
End;{obrcislo.vynasob}

function obrcislo.Vydel(var cim,zbytek:obrcislo):boolean;
var minus:boolean;
    x,delitel,podil:obrcislo;
    posun,i:word;
Begin
if cim.jenula then begin vydel:=false; exit; end {deleni nulou nejde}
              else vydel:=true;
zbytek.zrus; {dealokace pripadne predchozi hodnoty}
minus:=false;
if jezaporne then begin minus:=not minus; neguj; end {se zapornymi cisly by nam to nefungovalo, takze znamenko ulozime zvlast}
             else smrskni; {tim si usetrime zbytecne prochazeni uvodnich nul (v negaci je smrsknuti vestavene)}
delitel.init; {pomocny delitel}
delitel.vloz(cim);
if delitel.jezaporne then begin {i delitele potrebujeme vyhradne kladneho}
                          minus:=not minus;
                          delitel.neguj;
                          end
                     else delitel.smrskni;
if mensinez(cim) then begin {delenec<delitel: neni co resit, podil=0 a delenec=zbytek}
                      zbytek.delka:=delka;
                      zbytek.hodnota:=hodnota;
                      delka:=0;
                      hodnota:=nil;
                      {zbytek je vzdy kladny a podil je 0, takze ani v pripade
                      minusu neni potreba dodatecne negovat}
                      exit;
                      end;
{Nejjednodussi by bylo od delence odecitat delitele tak dlouho, dokud by to
slo, a po kazdem odecteni zvysit vysledek (podil) o 1. V delenci by nakonec
zustal zbytek. Drobna nevyhoda: extremni pomalost, hlavne s hodne velkymi
delenci a malymi deliteli.
 Rychlejsi je odecitat xnasobky delitele a podil zvysovat rovnou o x. Cislo
x zvolime co nejvetsi a navic kulate (tj. mocninu dvojky), takze nasobeni
pujde nahradit bitovymi posuny. Postupujeme od nejvetsich moznych nasobku
a jak se nam delenec zmensuje, posouvame x doprava.}
posun:=(delka-cim.delka) shl 4+15; {uvodni posun, kterym se delitel dostane na aspon stejnou delku jako delenec}
x.init;
x.vlozlongint(1);
x.posundoleva(posun); {pocatecni x}
delitel.posundoleva(posun); {pocatecni xnasobek delitele}
podil.init; {zatim 0, budeme sem pricitat}
for i:=posun downto 0 do {od maxima az do jednonasobku (posun o 0 = jednonasobek)}
 begin
 if vetsineborovno(delitel) then begin {delenec>xnasobek delitele: OK, muzeme odecitat}
                                 podil.pricti(x); {tolikrat tam byl}
                                 odecti(delitel); {od delence odecteme ten xnasobek}
                                 end;
 delitel.posundoprava(1); {nejvyssi bit delence je ted urcite nulovy, takze pokracujeme nizsimi nasobky}
 x.posundoprava(1);
 end;
{ted nam v tomhle cisle (self) zustal zbytek, v Podilu mame podil a ostatni
promenne nas nezajimaji}
zbytek.delka:=delka;        {presunuti zbytku}
zbytek.hodnota:=hodnota;
delka:=podil.delka;         {presunuti podilu}
hodnota:=podil.hodnota;
if minus then neguj;        {vraceni puvodniho znamenka}
delitel.zrus; x.zrus;
End;{obrcislo.vydel}

procedure obrcislo.odmocni;
var vysledek,bit,pom:obrcislo;
Begin
{Puvodne jsem odmocninu ani psat nechtel, ale na Wikipedii jsem narazil na
algoritmus, ktery po pokusnem prepsani do Pascalu hned napoprve fungoval.
Takze ho tu nechavam, ale vysvetlivky po mne nechtejte (zdroje:
http://en.wikipedia.org/Square_root_algorithm "Binary numeral system (base 2)"
a http://medialab.freaknet.org/martin/src/sqrt/).}
if jenula then exit; {odmocnina z nuly je nula, neni co pocitat}
if jezaporne then neguj; {nechce se mi resit komplexni cisla}
vysledek.init;
bit.init;
bit.prealokuj(delka);
bit.hodnota^[bit.delka-1]:=$4000; {druhy nejvyssi bit = 1}
while mensinez(bit) do bit.posundoprava(2);
pom.init;
while not bit.jenula do
 begin
 pom.vloz(vysledek);
 pom.pricti(bit);  {pom=vysledek+bit}
 if vetsineborovno(pom) then begin
                             odecti(pom);
                             vysledek.posundoprava(1);
                             vysledek.pricti(bit);
                             end
                        else vysledek.posundoprava(1);
 bit.posundoprava(2);
 end;
bit.zrus; pom.zrus; zrus;
delka:=vysledek.delka;
hodnota:=vysledek.hodnota;
End;{obrcislo.odmocni}

procedure obrcislo.PosunDoleva(oKolik:longint);
var wordu,bitu,i,PreteklyKus1,PreteklyKus2:word;
Begin
if jenula or (okolik=0) then exit;
wordu:=okolik shr 4; {div 16}
bitu:=okolik and 15; {mod 16}
prealokuj(delka+wordu+1); {aby nam to nalevo nepreteklo}
if bitu<>0 then begin
                preteklykus2:=0;
                for i:=0 to delka-1 do
                 begin
                 preteklykus1:=hodnota^[i] shr (16-bitu); {levy konec, ktery pretece}
                 hodnota^[i]:=(hodnota^[i] shl bitu) or preteklykus2; {posun a pridani pretekleho konce zprava}
                 preteklykus2:=preteklykus1; {co preteklo ted, to schovame pro pristi iteraci}
                 end;
                end;
if wordu<>0 then begin
                 for i:=delka-1 downto wordu do hodnota^[i]:=hodnota^[i-wordu];
                 fillchar(hodnota^[0],wordu shl 1,0); {vypln nulami zprava}
                 end;
smrskni;
End;{obrcislo.posundoleva}

procedure obrcislo.PosunDoprava(oKolik:longint);
var wordu,bitu,i,PreteklyKus1,PreteklyKus2,vypln:word;
Begin
if jenula or (okolik=0) then exit;
wordu:=okolik shr 4; {div 16}
bitu:=okolik and 15; {mod 16}
if hodnota^[delka-1] and $8000<>0 then vypln:=$FFFF {zaporne vyplnujeme jednickami}
                                  else vypln:=0;    {kladne nulami}
if wordu<>0 then begin
                 for i:=0 to delka-wordu-1 do hodnota^[i]:=hodnota^[i+wordu];
                 fillchar(hodnota^[delka-wordu],wordu shl 1,vypln);
                 end;
if bitu<>0 then begin
                preteklykus2:=vypln;
                for i:=delka-wordu-1 downto 0 do
                 begin
                 preteklykus1:=hodnota^[i] shl (16-bitu);
                 hodnota^[i]:=(hodnota^[i] shr bitu) or preteklykus2;
                 preteklykus2:=preteklykus1;
                 end;
                end;
smrskni;
End;{obrcislo.posundoprava}

function obrcislo.JeNula:boolean;
var i:word;
Begin
jenula:=true;
if delka<>0 then for i:=0 to delka-1 do if hodnota^[i]<>0 then begin
                                                               jenula:=false;
                                                               break;
                                                               end;
End;{obrcislo.jenula}

function obrcislo.JeZaporne:boolean;
Begin
jezaporne:=(delka<>0)and(hodnota^[delka-1] and $8000<>0); {jednickovy nejvyssi bit znamena minus}
End;{obrcislo.jezaporne}

function obrcislo.Porovnej(var sCim:obrcislo):shortint;
var pom:obrcislo;
Begin
pom.init;
pom.vloz(self);
pom.odecti(scim);
if pom.jenula then porovnej:=0
 else if pom.hodnota^[pom.delka-1] and $8000=0 then porovnej:=1
  else porovnej:=-1;
pom.zrus;
End;{obrcislo.porovnej}

function obrcislo.RovnaSe(var cemu:obrcislo):boolean;
Begin
rovnase:=porovnej(cemu)=0;
End;{obrcislo.rovnase}

function obrcislo.VetsiNez(var co:obrcislo):boolean;
Begin
vetsinez:=porovnej(co)>0;
End;{obrcislo.vetsinez}

function obrcislo.MensiNez(var co:obrcislo):boolean;
Begin
mensinez:=porovnej(co)<0;
End;{obrcislo.mensinez}

function obrcislo.VetsiNeboRovno(var nezco:obrcislo):boolean;
Begin
vetsineborovno:=porovnej(nezco)>=0;
End;{obrcislo.vetsineborovno}

function obrcislo.MensiNeboRovno(var nezco:obrcislo):boolean;
Begin
mensineborovno:=porovnej(nezco)<=0;
End;{obrcislo.mensineborovno}

function obrcislo.NaHex(prolidi:boolean):string;
var hexacifry:array[0..15] of char;
    i,j:word;
    vysledek:string;
    zaporne:boolean;
Begin
if delka=0 then vysledek:='0'
           else begin
                if prolidi then begin
                                {zjisteni absolutni hodnoty:}
                                zaporne:=hodnota^[delka-1] and $8000<>0;
                                if zaporne then neguj;
                                end;
                {prevod na hexa cislice:}
                vysledek:='';
                hexacifry:='0123456789ABCDEF';
                for i:=0 to delka-1 do
                 for j:=0 to 3 do vysledek:=hexacifry[((hodnota^[i]) shr (j shl 2)) and 15]+vysledek;
                                           {kazde 4 bity jsou jedna hexacifra}
                if prolidi then begin
                                {umazani prebytecnych nul ze zacatku:}
                                i:=1;
                                while (i<length(vysledek))and(vysledek[i]='0') do inc(i);
                                delete(vysledek,1,i-1);
                                {pridani pripadneho minusu:}
                                if zaporne then begin
                                                vysledek:='-'+vysledek;
                                                neguj; {zpatky na puvodni hodnotu}
                                                end;
                                end;
                end;
nahex:=vysledek+'h';
End;{obrcislo.nahex}

function obrcislo.NaDec:string;
var pom,cifra,deset:obrcislo;
    vysledek:string;
    minus,nanic:boolean;
Begin
if jenula then begin nadec:='0'; exit; end;
pom.init; {pomocna hodnota, kterou budeme postupne delit desitkou (puvodni cislo si znicit nechceme)}
pom.vloz(self);
minus:=pom.jezaporne;
if minus then pom.neguj;
deset.init; {konstanta 10 (zatim nemam specialni funkci na deleni konstantou)}
deset.vlozlongint(10);
cifra.init; {sem budou chodit zbytky po deleni desitkou, neboli jednotlive cislice}
vysledek:='';
while not pom.jenula do begin
                        nanic:=pom.vydel(deset,cifra); {navratova hodnota nas nezajima, protoze nulou nedelime}
                        {Cifra bude mit vzdy alokovanou Hodnotu, protoze
                        vznika odcitanim a smrskavanim, takze do ni muzeme
                        bez obav sahnout:}
                        vysledek:=chr(cifra.hodnota^[0]+ord('0'))+vysledek; {'0'..'9'}
                        end;
if minus then vysledek:='-'+vysledek;
pom.zrus; cifra.zrus; deset.zrus;
nadec:=vysledek;
End;{obrcislo.nadec}

procedure obrcislo.zrus;
Begin
if delka<>0 then freemem(hodnota,delka shl 1);
init;
End;{obrcislo.zrus}

END.