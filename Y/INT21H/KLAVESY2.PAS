(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: KLAVESY2.PAS                                                   *)
(*  Obsah: kody klaves, procedury pro cteni z klavesnice a jeji nastaveni  *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*         SWAG team  (DOSovska varianta Keypressed a Readkey)             *)
(*  Posledni uprava: 28.8.2013                                             *)
(*  Pro kompilaci: (DOS.TPU)                                               *)
(*  Pro spusteni: bud nic nebo nejaky soubor s definici rozlozeni klaves   *)
(*                (*.RK), pokud chcete pouzivat specialni obsluhu          *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit klavesy2;
{$B-,I-,R-}
interface

{Teoreticky uvod (jak to tady funguje a jak se to lisi od standardniho
chovani) najdete hned za Implementation. Dal jsem ho az tam, protoze je
docela dlouhy a tady by prekazel.}

(****************** univerzalni funkce pouzitelne kdykoli: ******************)

{Bud jde o proceduralni promenne, ktere budou automaticky nasmerovany na
aktualne pouzitelnou variantu, nebo o systemove sluzby ci obecne psane
rutiny fungujici nezavisle na obsluze preruseni.}

procedure Readln2(var Cil);
{Nahrada standardniho Readln, funguje se standardni i novou obsluhou.
POZOR: Cil muze byt pouze string, nic jineho! Typ neni uveden, aby se daly
pouzit retezce libovolne delky, ale v praxi doporucuji pouzivat vyhradne plnou
delku 255 znaku, aby se nedalo zadat neco delsiho nez je cilova promenna.}

var KeyPressed:function:boolean;
    ReadKey:function:char;
{pouziti a ucinky stejne jako stejnojmenne funkce z jednotky Crt}
    ToKeyBuf:procedure(S:string);
{vlozi retezec S do bufferu klavesnice, jako kdyby ho tam napsal uzivatel}
    kResetuj:procedure;
{vyprazdneni bufferu klavesnice}

{Standardni ASCIIkody nekterych rozsirenych klaves pro funkci Readkey
(#0 a pak #tohle):}
const
F1=59;     shiftF1=84;     ctrlF1=94;      altF1=104;
F2=60;     shiftF2=85;     ctrlF2=95;      altF2=105;
F3=61;     shiftF3=86;     ctrlF3=96;      altF3=106;
F4=62;     shiftF4=87;     ctrlF4=97;      altF4=107;
F5=63;     shiftF5=88;     ctrlF5=98;      altF5=108;
F6=64;     shiftF6=89;     ctrlF6=99;      altF6=109;
F7=65;     shiftF7=90;     ctrlF7=100;     altF7=110;
F8=66;     shiftF8=91;     ctrlF8=101;     altF8=111;
F9=67;     shiftF9=92;     ctrlF9=102;     altF9=112;
F10=68;    shiftF10=93;    ctrlF10=103;    altF10=113;
F11=133;   shiftF11=135;   ctrlF11=137;    altF11=139;
F12=134;   shiftF12=136;   ctrlF12=138;    altF12=140;
lsipka=75; {taky 75}       ctrllsipka=115; altlsipka=155;
psipka=77; {77}            ctrlpsipka=116; altpsipka=157;
hsipka=72; shiftHsipka=72; ctrlhsipka=141; althsipka=152;
dsipka=80; shiftDsipka=80; ctrldsipka=145; altdsipka=160;
ins=82;    {82}            ctrlins=146;    altins=162;
del=83;    {83}            ctrldel=147;    altdel=163;
home=71;   {71}            ctrlhome=119;   althome=151;
endk=79;   {79}            ctrlend=117;    altend=159;
pgup=73;   {73}            ctrlpgup=132;   altpgup=153;
pgdn=81;   {81}            ctrlpgdn=118;   altpgdn=161;

procedure kCekej;
{cekani na stisk klavesy}
procedure kRCR;
{Vyprazdni buffer, ceka na stisk klavesy a nakonec opet vyprazdni buffer.
Vhodne pro situace, kdy je potreba pockat na stisk klavesy a mit jistotu, ze
se bude vzdycky cekat a ze potom v bufferu nic nezbyde.}
function xReadKey:word;
{Vraci ordinalni cislo stisknute klavesy. U rozsirenych klaves (ty, co vraceji
nejdriv #0 a az pak nejake cislo) vraci to druhe cislo zvetsene o 256 (takze
odpada nutnost druheho cteni jako u obycejneho Readkey).
Kody klaves pro tuto funkci:}
const     {Kody pismen a cislic jsou jejich bezna ordinalni cisla (Ord).}
xF1=59+256;   xShiftF1=84+256;   xCtrlF1=94+256;   xAltF1=104+256;
xF2=60+256;   xShiftF2=85+256;   xCtrlF2=95+256;   xAltF2=105+256;
xF3=61+256;   xShiftF3=86+256;   xCtrlF3=96+256;   xAltF3=106+256;
xF4=62+256;   xShiftF4=87+256;   xCtrlF4=97+256;   xAltF4=107+256;
xF5=63+256;   xShiftF5=88+256;   xCtrlF5=98+256;   xAltF5=108+256;
xF6=64+256;   xShiftF6=89+256;   xCtrlF6=99+256;   xAltF6=109+256;
xF7=65+256;   xShiftF7=90+256;   xCtrlF7=100+256;  xAltF7=110+256;
xF8=66+256;   xShiftF8=91+256;   xCtrlF8=101+256;  xAltF8=111+256;
xF9=67+256;   xShiftF9=92+256;   xCtrlF9=102+256;  xAltF9=112+256;
xF10=68+256;  xShiftF10=93+256;  xCtrlF10=103+256; xAltF10=113+256;
xF11=133+256; xShiftF11=135+256; xCtrlF11=137+256; xAltF11=139+256;
xF12=134+256; xShiftF12=136+256; xCtrlF12=138+256; xAltF12=140+256;

xLSipka=75+256; {xShiftLSipka=xlsipka;} xCtrlLSipka=115+256;  xAltLsipka=155+256;
xPSipka=77+256; {xShiftPSipka=xpsipka;} xCtrlPSipka=116+256;  xAltPSipka=157+256;
xHSipka=72+256; {xShiftHSipka=xhsipka;} xCtrlHSipka=141+256;  xAltHSipka=152+256;
xDSipka=80+256; {xShiftDSipka=xdsipka;} xCtrlDSipka=145+256;  xAltDSipka=160+256;

xIns=82+256;  {xShiftIns=xins;}   xCtrlIns=146+256;  xAltIns=162+256;
xDel=83+256;  {xShiftDel=xdel;}   xCtrlDel=147+256;  xAltDel=163+256;
xHome=71+256; {xShiftHome=xhome;} xCtrlHome=119+256; xAltHome=151+256;
xEnd=79+256;  {xShiftEnd=xend;}   xCtrlEnd=117+256;  xAltEnd=159+256;
xPgUp=73+256; {xShiftPgUp=xpgup;} xCtrlPgUp=132+256; xAltPgUp=153+256;
xPgDn=81+256; {xShiftPgDn=xpgdn;} xCtrlPgDn=118+256; xAltPgDn=161+256;

xTab=9;     xShiftTab=15+256;    xCtrlTab=148+256; xAltTab=165+256;
xBksp=8;   {xShiftBksp=xbksp;}   xCtrlBksp=127;    xAltBksp=14+256;
xEnter=13; {xShiftEnter=xenter;} xCtrlEnter=10;    xAltEnter=28+256;
xMezernik=32; {vzdy}

xCtrlPrintscreen=16; {ostatni kombinace negeneruji zadny znak}
xEsc=27; {shift i ctrl taky 27} xAltEsc=1+256;

{tri windowsovske klavesy ve spodni rade:}
xLOkno=182+256; xShiftLOkno=194+256; xCtrlLOkno=206+256; xAltLOkno=218+256;
xPOkno=183+256; xShiftPOkno=195+256; xCtrlPOkno=207+256; xAltPOkno=219+256;
xMistniNabidka=184+256; xShiftMistniNabidka=196+256; xCtrlMistniNabidka=208+256; xAltMistniNabidka=220+256;

{nektera pismena s Controlem:}
xCtrlG=7; xCtrlC=3; xCtrlN=14;

procedure SetCapsLock(jak:boolean);
procedure SetNumLock(jak:boolean);
procedure SetScrollLock(jak:boolean);
{tyto procedury zapinaji nebo vypinaji prislusne locky (true=zap., false=vyp.)}

function KlavesniceUmi(co:byte):boolean;
{Zjisti, jestli klavesnice podporuje danou funkci. Za parametr Co muzete
dosadit nasledujici hodnoty:}
const klNastavitVychoziRychlost=0;
      klVypnoutOpakovani=1;
      klNastavitRychlost=2; {tj. jestli bude fungovat procedura Rychlostklavesnice}
      klZjistitRychlost=3;
      klZjistitTyp=4;
      klJeRozsirena=5; {toto je dobre otestovat drive nez zacneme cekat na stisk F12 apod.}
      klMa122Klaves=6;
{Funkce vyuziva int $16.
Nasledujici ctyri vyuzivaji primy zapis na porty klavesnice:}
function KlavesniceReaguje:boolean;
{Vysle na klavesnici prikaz "posli echo" a zkontroluje, jestli spravne odpovi.
Jestli ano, vrati true. False jsem jeste nezazil.}
procedure ResetKlavesnice;
{Vysle na klavesnici prikaz "resetuj se a proved interni diagnostiku".
Nouzovka pro pripad vaznejsich potizi.
Pozor, nema nic spolecneho s resetovanim bufferu!}
procedure NastavKontrolky(scroll,num,caps:boolean);
{Rozsviti (true) nebo zhasne (false) prislusne lockove LEDky.}
procedure RychlostKlavesnice(Zpozdeni,Rychlost:byte);
{Nastavi rychlost opakovani stisknute klavesy a zpozdeni po prvnim stisku.
 Zpozdeni: 0 = prodleva 250 ms
           1 =    "     500  "
           2 =    "     750  "
           3 =    "    1000  "
 Rychlost: cokoli od 0 (30 znaku za vterinu) do 31 (2 znaky za vterinu)}

(*procedure BIOSRychlostKlavesnice(Zpozdeni,Rychlost:byte);
{Totez jako vyse uvedena, ale dela to pres int $16, ne pres porty.}
Celkem zbytecna, nechavam ji tu jen tak pro zajimavost. V pripade potreby
si ji odkomentujte (tady i v implementation).*)


(************* funkce pouze pro standardni obsluhu klavesnice: **************)

{Pri zapnute vlastni obsluze je nezkousejte pouzivat - nebudou fungovat
a nektere muzou zpusobit zaseknuti nebo pad programu!}

{Tyhle tri pracuji na bazi int $21:}
function StdKeyPressed:boolean;
function StdReadKey:char;
{Funguji stejne jako ty z jednotky CRT, jenom umi cist o par klaves vic.}
procedure StdkResetuj;

procedure StdToKeyBuf(s:string);
{Tahle jede pres int $16. Pozor, ze se do standardniho bufferu vejde maximalne
15 znaku; kdyz jich bude vic, klavesnice zacne piskat.}

function LShiftPressed:boolean;     {stisknut levy shift}
function PShiftPressed:boolean;     {stisknut pravy shift}
function ShiftPressed:boolean;      {stisknut libovolny shift}
function LCtrlPressed:boolean;      {stisknut levy control}
function PCtrlPressed:boolean;      {stisknut pravy control}
function CtrlPressed:boolean;       {stisknut libovolny control}
function LAltPressed:boolean;       {stisknut levy alt}
function PAltPressed:boolean;       {stisknut pravy alt}
function AltPressed:boolean;        {stisknut libovolny alt}
function CapsLockPressed:boolean;   {stisknut capslock}
function NumLockPressed:boolean;    {stisknut numlock}
function ScrollLockPressed:boolean; {stisknut scrolllock}
function StdCapsLock:boolean;   {zapnuty capslock}
function StdNumLock:boolean;    {zapnuty numlock}
function StdScrollLock:boolean; {zapnuty scrolllock}
{Tyto funkce vraceji true, pokud je splnena prislusna podminka.
Potrebne informace ctou ze stavoveho wordu klavesnice.}

(************** zapnuti a vypnuti vlastni obsluhy klavesnice: ***************)

function NactiRozlozeni(var Soubor:file):boolean;
{Nacte rozlozeni klaves z daneho Souboru do prvni volne pozice v internim
seznamu rozlozeni. Soubor musi byt otevreny pro cteni s velikosti bloku 1 B
(reset(soubor,1);), po skonceni procedury zustane otevreny a kurzor v nem bude
za poslednim bytem nactenych dat. Pri uspechu se vraci true, pri chybe false.
Seznam ma kapacitu 10 rozlozeni, indexuje se od 1. Prvni nactene rozlozeni
prijde na 1. pozici, druhe na 2. atd..
Mezi rozlozenimi se da kdykoli prepnout klavesami Ctrl+Alt+F1..F10.
Format souboru s rozlozenim je popsan uplne na konci teto jednotky.}
function NactiRozlozeni2(JmenoSouboru:string):boolean;
{Totez, ale predate jenom jmeno souboru, ktery si procedura otevre, precte
a zase zavre.}
procedure NastavRozlozeni(index:byte);
{Prepne na dane rozlozeni klaves (ekvivalent Ctrl+Alt+F...). Pokud rozlozeni
s timhle cislem neni nactene, nedela nic.
POZOR: jestli tuhle proceduru volate rucne pri zapnute obsluze, radsi zakazte
       preruseni, aby nedoslo k problemum, kdyby se uprostred ni zmackla
       nejaka klavesa. Treba takhle:    asm cli end;
                                        nastavrozlozeni(5);
                                        asm sti end;}
function ZrusRozlozeni:boolean;
{Vyhodi z interniho seznamu posledni nactene rozlozeni klaves. Automaticky
zaridi prepnuti na jine rozlozeni, pokud by se rusilo to, ktere je prave
aktivni. Take automaticky vypne obsluhu, pokud zrusi uplne posledni rozlozeni.
Navratova hodnota: true - jedno rozlozeni bylo uspesne zruseno
                   false - seznam uz je prazdny, nebylo co rusit}

procedure InitKlav;
{Zapne novou obsluhu preruseni a postara se o presmerovani vsech univerzalnich
proceduralnich promennych na definice zacinajici na "moje". Napred je ovsem
potreba nacist aspon jedno rozlozeni klaves, jinak tahle procedura nic
neudela. Kdyz jsou nejaka rozlozeni nactena, ale zadne jeste neni vybrane,
automaticky vybere to prvni.}
procedure ZrusKlav;
{Obnovi puvodni BIOSovskou obsluhu klavesnice a presmeruje vsechny
proceduralni promenne zpatky na "std". Pokud ji nezavolate rucne, spusti se
automaticky pri ukonceni programu (Exitproc).
Neovlivnuje aktualne nastavene rozlozeni klaves, takze jestli potom znovu
zavolate Initklav, bude nastavene zase to, co predtim. Take nactena rozlozeni
nijak nemaze; jestli to potrebujete, pouzijte Zrusrozlozeni.}

function JmenoRozlozeni:string;
{Informativni funkce, vraci jmeno aktualne nastaveneho rozlozeni. Pokud neni
nastaveno zadne, vrati ''.}
function KlavesyInstalovany:boolean;
{Pro pripad, ze bychom zapomneli, jestli nova obsluha bezi nebo ne.
Sice by sem sla dat primo ta promenna, ale bylo by to moc riskantni, protoze
prepsani = katastrofa.}

(************** funkce pouze pro vlastni obsluhu klavesnice: ****************)

{Kdyz neni zapnuta vlastni obsluha klavesnice, nepouzivejte je - nefungovaly
by a mohly by zaseknout program!}

function MojeKeyPressed:boolean;
procedure MojeKResetuj;
{funguji jako obvykle, ale jsou rychlejsi, protoze nevolaji zadne preruseni}
function MojeReadKey:char;
{Funguje jako obvykle, jenom pozor na jeji vzajemnou interakci s promennou
Koncit (kterou nastavuje na true stisk Ctrl+Breaku, ale teoreticky se da
vyuzit i jinak). Jsou dve moznosti urcene touto direktivou:}
                     {...$define BreakRusiReadkey}
{definovano => Pokud Koncit=true, Mojereadkey neceka na stisk klavesy. Jestli
               je zrovna buffer prazdny, vrati znak #1.
nedefinovano => Promenna Koncit bude na zacatku funkce Mojereadkey nastavena
                na false, takze se na stisk klavesy bude v pripade potreby
                vzdycky cekat.
Kdyz se promenna Koncit nastavi na true v prubehu cekani na klavesu (tedy kdyz
stiskneme Ctrl+Break), vrati Mojereadkey znak #1.}
procedure MojeToKeyBuf(s:string);
{Maximalni delka bufferu se da nastavit konstantou DelkaASCIIBufferu, normalne
je to 32 znaku.}

function pKeyPressed:boolean;
{Vraci true, pokud je prave ted zmacknuta nejaka klavesa (bere to primo na
urovni scankodu, s bufferem nema nic spolecneho).}
function Pressed(klavesa:word):boolean;
{Rika, jestli je dana klavesa prave ted stisknuta. Opet bez ohledu na buffer,
umoznuje cteni vice soucasne stisknutych klaves a umi i rozlisit rozsirene
scankody od normalnich (tedy napr. normalni sipky od numericke klavesnice).
Parametr je word jenom kvuli snadnejsi implementaci, povoleny rozsah hodnot
je 1..2*Maxscankod. Kody klaves pro tuto funkci:}
const MaxScanKod=93; {<--Tuhle konstantu v zadnem pripade nemente!
1. rada:   2. rada:           3. rada:              4. rada:}
pEsc=1;    pVlnovka=41;{`~}   pTab=15;              pCapsLock=58;
pF1=59;    p1k=2;             pQk=16;               pAk=30;
pF2=60;    p2k=3;             pWk=17;               pSk=31;
pF3=61;    p3k=4;             pEk=18;               pDk=32;       {K na konci znamena "klavesa" }
pF4=62;    p4k=5;             pRk=19;               pFk=33;       {a slouzi k lepsimu odliseni  }
pF5=63;    p5k=6;             pTk=20;               pGk=34;       {techto konstant od pripadnych}
pF6=64;    p6k=7;             pYk=21;               pHk=35;       {jinych, podobne kratkych     }
pF7=65;    p7k=8;             pUk=22;               pJk=36;       {identifikatoru.              }
pF8=66;    p8k=9;             pIk=23;               pKk=37;
pF9=67;    p9k=10;            pOk=24;               pLk=38;
pF10=68;   p0k=11;            pPk=25;               pStrednik=39;{;:}
pF11=87;   pPomlcka=12;{-_}   pLHZavorka=26;(*[{*)  pApostrof=40;{'"}
pF12=88;   pRovnitko=13;{=+}  pPHZavorka=27;(*]}*)  pEnter=28;
           pBackspace=14;     pBackSlash=43;{\| (obvykle nekde mezi enterem a backspacem)}
{5. rada:         6. rada:}
pLevyShift=42;    pLevyCtrl=29;
pZk=44;           pLeveOkno=91+maxscankod;
pXk=45;           pLevyAlt=56;
pCk=46;           pBackslash2=86;{pripadna druha \| (obvykle nekde v okoli mezerniku)}
pVk=47;           pMezernik=57;
pBk=48;           pPravyAlt=56+maxscankod;
pNk=49;           pPraveOkno=92+maxscankod;
pMk=50;           pMistniNabidka=93+maxscankod;{tohle je nejvetsi scankod, jaky se na normalni klavesnici vyskytuje}
pCarka=51;{,<}    pPravyCtrl=29+maxscankod;
pTecka=52;{.>}             {numericka klavesnice:}
pLomitko=53;{/?}           pNumLock=69;
pPravyShift=54;            pNumLomitko=53+maxscankod;{/}
{kurzorove klavesy:}       pNumHvezdicka=55;{*}
pIns=82+maxscankod;        pNumMinus=74;{-}
pHome=71+maxscankod;       pNum7=71;
pPgUp=73+maxscankod;       pNum8=72;
pDel=83+maxscankod;        pNum9=73;      {ostatni:}
pEnd=79+maxscankod;        pNum4=75;      pScrollLock=70;
pPgDn=81+maxscankod;       pNum5=76;      pPrintScreen=55+maxscankod;
pHSipka=72+maxscankod;     pNum6=77;      pZapnutyNumlock=42+maxscankod;{imaginarni}
pLSipka=75+maxscankod;     pNum1=79;
pDSipka=80+maxscankod;     pNum2=80;
pPSipka=77+maxscankod;     pNum3=81;
                           pNum0=82;
                           pNumTecka=83;{.}
                           pNumPlus=78;{+}
                           pNumEnter=28+maxscankod;

{verejne promenne pro vlastni obsluhu:}
var Pauza:boolean;{Promenna, kterou nastavuje na true stisk Pause a na false
           stisk libovolne klavesy (zruseni pauzy stisk nesezere, bude
           normalne vyhodnocen).}
    Koncit:boolean;{Promenna, kterou nastavuje na true stisk Ctrl+Break.}
     {S promennymi Pauza a Koncit si muzete delat co chcete, jenom pozor, ze
      Pauza udrzi true jenom do prvniho stisku jakekoli klavesy.}
    CapsLock,NumLock,ScrollLock:boolean; {aktualni stav locku}
     {S locky opatrne - jenom cist! Mente jen pomoci procedur Set...lock.}
const TvrdyBreak:boolean=false; {Jestli ma Ctrl+Break uplne haltnout program
                                (true) nebo jenom nastavit promennou Koncit
                                na true (false).
       Pozor, halt z preruseni obcas dokaze trochu pocuchat system, takze
       tohle pouzivejte jenom jako posledni nouzovku.}
      PausovyZnak:char=#0; {Jaky znak se ma vlozit do bufferu po stisku Pause,
                      #0 = zadny. Promenna Pauza se nastavi v kazdem pripade.}
      AutoScreenshot:boolean=false; {jestli ma Printscreen automaticky volat
                                     proceduru na ulozeni screenshotu, ...}
      ScrshotProc:procedure=nil; {...konkretne tuhle, do ktere je napred
                                  potreba vlozit adresu skutecneho
                                  screenshotovadla}
      propadavani:boolean=false; {jestli se pri stisku nedefinovane kombinace
                                  urcite klavesy s preradovacem ma vratit kod
                                  teto klavesy bez preradovacu (true) nebo
                                  nic (false)}
      MrtvolyProVsechny:boolean=false;
       {true: mrtve znaky se vyhodnocuji pri stisku jakekoli klavesy vcetne
              rozsirenych (jako v DOSu)
       false: mrtve znaky se vyhodnocuji jenom pri jednobytovych klavesach
              (jako ve Windows)}

implementation (*************************************************************)

{Trocha teorie do zacatku, aneb jak klavesnice funguje
-------------------------------------------------------
(Pozn.: Kdyz rikam "kurzorove klavesy", myslim tim Insert, Delete, Home, End,
Page up, Page down a vsechny ctyri sipky. Kdyz rikam "preradovace", myslim
tim shifty, alty, controly a vetsinou i caps-, scroll- a numlock.)

 Pri stisku nebo pusteni (krome Pause/Breaku) jakekoli klavesy se automaticky
vola preruseni 9. Na nejnizsi urovni se s klavesnici komunikuje pres dva
porty: $60 a $64. Z portu $60 cteme scankody stisknutych nebo pustenych klaves
(nejlepsi je cist je v obsluzne procedure int 9, abychom o zadny neprisli)
a zapisujeme do nej prikazy pro klavesnici. Z portu $64 cteme stavovy kod
klavesnice. Jeho jednotlive bity maji nasledujici vyznam:
Bit 0 - vystupni ASCII buffer je plny
    1 - vstupni buffer plny (tj. s odesilanim dalsich prikazu musime pockat)
    2 - flag 0 (?)
    3 - flag 1 (?)
    4 - klavesnice je povolena (coz obvykle je, jinak by nefungovala)
    5 - neco specialniho pro PS/2 (?)
    6 - timeout
    7 - chyba parity (?)
Prakticke vyuziti ma pro nas jenom bit 1.

 Pravy Alt, pravy Ctrl, kurzorove klavesy, / a Enter na numericke klavesnici,
Printscreen, leve i prave "okno" a "mistni nabidka" jsou tzv. rozsirene
klavesy. Pri stisku vysilaji dvoubytovou sekvenci: 224 ($E0) a pak jeste jedno
cislo. Pri delsim drzeni vysilani teto sekvence opakuji (opakovani se prerusi
bud pustenim teto klavesy nebo stiskem jine) a pri pusteni vyslou 224 a pak
to puvodni cislo zvetsene o 128.

 Pause pri stisku vysle sekvenci 225,29,69,225,157,197; pri delsim drzeni ani
pri pusteni uz nic dalsiho nevysila.
 Break (Ctrl+Pause) vysle 224,70,224,198 a dal rovnez nic.
Pause/Break je jedina klavesa, ktera meni scankod podle aktualniho stavu
Controlu. Vsechny ostatni scankody jsou na preradovacich nezavisle a za
zadnych okolnosti se nemeni.

 Vsechny ostatni klavesy krome vyse jmenovanych vysilaji pri stisku
jednobytovy scankod, pri delsim drzeni ho opakuji a pri pusteni ho vyslou
zvetseny o 128.

 Numlock ma zvlastni vedlejsi ucinek. Kdyz je zapnuty, tak kurzorove klavesy,
Printscreen, "okna" a "mistni nabidka" pri stisku vyslou pred svou obvyklou
sekvenci jeste dva byty 224,42 a po pusteni po sve sekvenci jeste 224,170
(kody opakovane pri delsim drzeni zustavaji pri starem). De facto to tedy
vypada, jako kdyby se stiskla jeste jakasi imaginarni klavesa s kodem
"rozsirena 42". Ovsem pozor, spolehnout se na ni nemuzete, a to hned ze dvou
duvodu. Zaprve: ne vsechny klavesnice ji pouzivaji u vsech vyse uvedenych
klaves, a zadruhe: ne vsechny klavesnice dokazou vnimat numlock ve chvili,
kdy je obsluhujete vlastnim prerusenim.
 Zadna fyzicka klavesa tenhle scankod nema, takze neni potreba obavat se
kolizi.

 Pozn.: Scankod klavesy nema nic spolecneho s ASCII kodem, ktery cteme napr.
pomoci Readkey. A zatimco mapovani ASCII kodu muze mit kazda klavesnice jine
(ceske, anglicke atd.), scankody jsou u vsech stejne.

 Standardni BIOSovska obsluha klavesnice dela toto:

 Pri stisku nebo pusteni nektereho preradovace nastavi prislusne bity ve
stavovem wordu klavesnice na adrese 0:$0417.
 Pri stisku num-, caps- nebo scrolllocku nastavi prislusny bit ve stavovem
wordu a k tomu rozsviti nebo zhasne prislusnou kontrolku.
 Pri mackani cisel na numericke klavesnici pri stisknute klavese Alt (jedno
ktere) si natukane cislice pamatuje a pri pusteni Altu je prevede na jedno
cislo, vyanduje hodnotou 255 a vysledek coby ASCII znak hodi do bufferu
klavesnice (ten zacina na adrese 0:$041E a nekde jsou i ukazatele na jeho
zacatek a konec, ale uz si nepamatuju kde). Znak #0 se takhle napsat neda,
samotna nula se ignoruje.
 Pri stisku Pause pozastavi program do stisku libovolne klavesy.
 Pri stisku Break (Ctrl+Pause) vyvola preruseni $1B, ktere ukonci program.
 Pri stisku Printscreenu posle kopii obrazovky bud na tiskarnu (DOS) nebo do
schranky (Windows), ale pouzitelnost se lisi pocitac od pocitace.
 Vsechny ostatni klavesy krome mrtvych se modifikuji podle aktualniho stavu
preradovacu (shifty, locky apod.) a jejich kod se odesle do bufferu
klavesnice. "Rozsirene" klavesy (coz neni totez jako rozsirene klavesy na
urovni scankodu a tato "rozsirenost" se navic muze menit s aktualnim stavem
preradovacu - pozor!) daji znak #0 a po nem jeste druhy;
normalni (ne-rozsirene) klavesy jenom jeden.
 Pri stisku mrtve klavesy (napr. hacku nebo carky na ceske klavesnici) si ji
BIOS zapamatuje a pristi klavesu se ji pokusi modifikovat a vysledny znak
potom odesle do bufferu; kdyby to nevyslo (treba hacek nad Q nebo podobny
nesmysl), hodi do bufferu samotny mrtvy znak a za nim samotne pismeno.
Windowsovska obsluha mrtvych klaves se od DOSovske lisi v tom, ze po stisku
dvou mrtvych klaves po sobe se vyhodnoti a nabufferuji jako dva samotne mrtve
znaky, zatimco v DOSu se nestane nic, druha mrtva klavesa prebije prvni a dal
se ceka na nejakou nemrtvou klavesu, se kterou se zkombinuje (narozdil od
Windows, kde to musi byt jen a pouze tisknutelny znak - kurzorove klavesy
mrtvy priznak neovlivni).
 Pri stisku Ctrl+Alt+nejaka F-klavesa se prepina rozlozeni klaves (napr. u me
je pod F1 anglicke a pod F2 ceske). Ale zalezi na konkretnim ovladaci, nekde
to muzou byt jine kombinace (treba Ctrl+Shift+neco apod.) a nekde jina eFka
znamenaji jine jazyky.

 Tato jednotka se to pokousi vice ci mene kopirovat. Rozdily:
- Prakticky absolutni svoboda v definici rozlozeni klaves a nezavislost na
  systemovych ovladacich (nehrozi tedy zadne problemy s diakritikou).
- Znak #0 pomoci Altu a numericke klavesnice napsat jde.
- K dispozici je pole booleanu, ze ktereho muzete cist aktualni stav
  kterekoli klavesy (funkci Pressed).
- Buffer klavesnice je delsi a delku si muzete nastavit konstantou. Pri jeho
  zaplneni klavesnice nepiska, jenom se uz do bufferu dalsi stisknute klavesy
  nepridavaji. Je tedy mozne program ovladat pomoci funkce Pressed a jenom
  obcas, kdyz potrebujeme napsat nejaky text, buffer vyprazdnit.
- Standardni stavovy word se neaktualizuje, misto nej jsou tu promenne
  Numlock, Capslock a Scrolllock a na shifty a spol. funkce Pressed.
- Read a Readln nejdou pouzit na cteni z klavesnice - POZOR!!! Program by se
  zasekl. Misto toho pouzijte zdejsi proceduru Readln2.
- Z podobnych duvodu nepouzivejte Keypressed a Readkey z jednotky Crt!
  Nahradte je zdejsim vydanim.
- Pause program fyzicky nezastavi, ale nastavi na true globalni promennou
  Pauza, kterou je treba nekde v programu vyhodnotit a zachovat se podle ni.
- Break nastavi na true globalni promennou Koncit. Dale si muzete nastavit,
  jestli ma program natvrdo haltnout nebo ne (vychozi nastaveni je ne).
- Na Printscreen lze napojit vlastni proceduru, ktera se po kazdem jeho stisku
  automaticky zavola (za predpokladu, ze stisk neukradnou Windows, ale to se
  da zakazat ve Vlastnostech programu).
- Prepinani rozlozeni standardni dosovskou kombinaci Ctrl+Alt+F1..F10 funguje,
  ale napred je potreba si vsechna pozadovana rozlozeni nacist ze souboru.
- A par nepodstatnych drobnosti.}

uses dos; {pro getintvec a setintvec}

(*********************** nova obsluha klavesnice: ***************************)

{nejnizsi uroven - scankody a spol.:}
type PoleBooleanu=array[1..2*maxscankod+6] of boolean;
        {(+6 je kvuli repe scasd, v pripade zmeny Maxscankodu tuto hodnotu
        upravte, aby vysla celkova delka delitelna ctyrmi a minimalne o 4 B
        vetsi nez 2*Maxscankod)}
var _klavesy:^polebooleanu; {pro uchovavani prehledu o aktualne stisknutych klavesach}
    rozsirena:byte; {informace o tom, jestli posledni precteny scankod byl kod
        pro rozsirenou klavesu (pak je rovna Maxscankodu) nebo ne (potom je 0)}

{tabulky wordovych ASCII kodu:}
type AsciiTabulka=array[1..2*maxscankod] of word;
const BezNiceho=0;
      SeShiftem=1;
      SControlem=2;
      SPravymControlem=3; {rezerva pro pripadne rozliseni L/P controlu, zatim nepodporovano}
      SLevymAltem=4;
      SPravymAltem=5;
      SCapslockem=6;
      SCapslockemAShiftem=7;
var TabulkyKlaves:array[0..7] of ^asciitabulka;

{ASCII buffer (fronta, do ktere se ukladaji stisknute klavesy):}
const DelkaASCIIBufferu=32; {libovolne, max. 255 (nebo predelejte indexy na word a pak max. 64K)}
var ASCIIBuffer:array[1..delkaasciibufferu] of char;
    PocetZnakuVBufferu,SemPsat,OdtudCist:byte;

{ciselny buffer pro psani ASCII kodu pres Alt+cisla:}
const DelkaCiselnehoBufferu=5; {min. 3, max. 5; pocita se s tim, ze se to po prevedeni na cislo vejde do wordu}
      CisliceNumpadu:array[71..83] of char='789 456 1230.'; {prevodni tabulka ze scankodu na cislice       }
var CiselnyBuffer:string[delkaciselnehobufferu];            {a zaroven maska pouzivana numlockem - nesahat!}


{tabulky pro mrtve klavesy:}
type PoleZnaku=array[0..0] of char; {\ sablony pro dynamicka pole }
     PoleWordu=array[0..0] of word; {/                            }
var PocetMrtvol:byte; {pocet mrtvych znaku (tj. polozek v nasledujicich dvou tabulkach)}
    SeznamMrtvol:^poleznaku; {tady se najde mrtvy znak...}
    SeznamOfsetu:^polewordu; {...na stejnou pozici se sahne sem...}
    DelkaSKZ:word; {velikost nasledujicich dvou tabulek}
    SeznamKombinovatelnychZnaku, {...od toho ofsetu se to tady prohleda...}
    SeznamVyslednychZnaku:^poleznaku; {...a na stejnou pozici se sahne sem pro vysledek}
    mrtvola:char; {aktualni mrtvy znak (#0 = zadny)}

{ostatni:}
var instalovano:boolean; {jestli je nainstalovana nase obsluha klavesnice}
    PuvodniInt9:pointer; {pro ulozeni puvodniho preruseni klavesnice}
    PuvodniExit:pointer; {pro ulozeni Exitprocu}
    JedePause,JedeBreak:boolean; {pomocne pro vyhodnocovani klavesy Pause/Break}
    SW:word absolute 0:$0417; {standardni stavovy word klavesnice}

{seznam rozlozeni:}
type RozlozeniKlaves = record
                       JmenoRozlozeni:string[8]; {jmeno pro kontrolu a identifikaci, prakticka funkce zadna}
                       _TabulkyKlaves:array[0..7] of pointer;
                       _PocetMrtvol:byte;
                       _SeznamMrtvol,                     {tyhle polozky odpovidaji         }
                       _SeznamOfsetu:pointer;             {vyse uvedenym globalnim promennym}
                       _DelkaSKZ:word;
                       _SeznamKombinovatelnychZnaku,
                       _SeznamVyslednychZnaku:pointer;
                       end;
     UkNaRozlozeni=^rozlozeniklaves;
var SeznamRozlozeni:array[1..10] of uknarozlozeni;
    IndexRozlozeni:byte; {ktere rozlozeni je zrovna nastaveno (0 = zadne)}

function jmenorozlozeni:string;
Begin
if (indexrozlozeni>0)and(indexrozlozeni<10)
  then jmenorozlozeni:=seznamrozlozeni[indexrozlozeni]^.jmenorozlozeni
  else jmenorozlozeni:='';
End;{jmenorozlozeni}   {devetkrat slovo "rozlozeni" v jedne sestiradkove procedure... to je snad rekord :-D}

procedure ZrusASCIITabulky(var ktere); {pomocna}
type pu=array[0..7] of pointer;
var b:byte;
Begin
for b:=7 downto 0 do
 if (pu(ktere)[b]<>nil)and((b=0)or(pu(ktere)[b]<>pu(ktere)[0])) {podminka kvuli vynechani duplicit}
   then dispose(pu(ktere)[b]);
fillchar(ktere,sizeof(pu),0);
End;{zrusasciitabulky}

procedure _ZrusRozlozeni(var ktere:rozlozeniklaves); {dealokuje vsechny ukazatele v danem rozlozeni}
Begin
with ktere do
 begin
 zrusasciitabulky(_tabulkyklaves);
 if _pocetmrtvol<>0 then begin
                         freemem(_seznammrtvol,_pocetmrtvol);
                         freemem(_seznamofsetu,_pocetmrtvol shl 1);
                         freemem(_seznamkombinovatelnychznaku,_delkaskz);
                         freemem(_seznamvyslednychznaku,_delkaskz);
                         end;
 end;
fillchar(ktere,sizeof(ktere),0); {jen tak pro jistotu}
End;{_zrusrozlozeni}

function ZrusRozlozeni:boolean;
var index:byte;
Begin
index:=10;
while (index>0)and(seznamrozlozeni[index]=nil) do dec(index); {najdeme posledni alokovane rozlozeni}
if index<>0 then begin
                 if index=1 then zrusklav {rusime posledni => musime vypnout obsluhu}
                  else if index=indexrozlozeni then nastavrozlozeni(pred(index)); {rusime aktualni => musime prepnout na jine}
                 _zrusrozlozeni(seznamrozlozeni[index]^);
                 dispose(seznamrozlozeni[index]);
                 seznamrozlozeni[index]:=nil;
                 zrusrozlozeni:=true;
                 end
            else zrusrozlozeni:=false;
End;{zrusrozlozeni}

function NactiRozlozeni(var Soubor:file):boolean;
var MameTabulku:array[0..7] of boolean;
    b,index:byte;
    MaloPameti:boolean;
    kam:uknarozlozeni; {pomocny ukazatel, aby se nemuselo porad lezt do pole}
Begin
nactirozlozeni:=false;
{nalezeni volneho mista v seznamu rozlozeni:}
index:=1;
while (index<=10)and(seznamrozlozeni[index]<>nil) do inc(index);
if index=11 then exit; {uz je nacteno 10 rozlozeni, vic uz nejde}
{alokace:}
if maxavail<sizeof(rozlozeniklaves) then exit;
new(kam);
{nacteni souboru:}
malopameti:=false;
blockread(soubor,kam^.jmenorozlozeni,9);
mametabulku[0]:=true; {zakladni tabulka je tam vzdycky,...}
blockread(soubor,mametabulku[1],7); {...u ostatnich to neni jiste}
if ioresult<>0 then begin dispose(kam); exit; end;
for b:=0 to 7 do if mametabulku[b]
                   then begin
                        if maxavail<sizeof(asciitabulka) then begin
                                                              malopameti:=true;
                                                              break;
                                                              end;
                        getmem(kam^._tabulkyklaves[b],sizeof(asciitabulka));
                        blockread(soubor,kam^._tabulkyklaves[b]^,sizeof(asciitabulka));
                        end
                   else kam^._tabulkyklaves[b]:=kam^._tabulkyklaves[bezniceho];
blockread(soubor,kam^._pocetmrtvol,1);
if (ioresult<>0) or malopameti or (maxavail<3*kam^._pocetmrtvol)
  then begin zrusasciitabulky(kam^._tabulkyklaves); dispose(kam); exit; end;
if kam^._pocetmrtvol=0 then with kam^ do begin {zadne mrtve klavesy}
                                         _seznammrtvol:=nil;
                                         _seznamofsetu:=nil;
                                         _seznamkombinovatelnychznaku:=nil;
                                         _seznamvyslednychznaku:=nil;
                                         end
                       else begin
                            with kam^ do
                             begin
                             blockread(soubor,_delkaskz,2);
                             if (ioresult<>0)or(maxavail<3*_pocetmrtvol+_delkaskz shl 1)
                               then begin zrusasciitabulky(_tabulkyklaves); dispose(kam); exit; end;
                             getmem(_seznammrtvol,_pocetmrtvol);
                             getmem(_seznamofsetu,_pocetmrtvol shl 1);
                             getmem(_seznamkombinovatelnychznaku,_delkaskz);
                             getmem(_seznamvyslednychznaku,_delkaskz);
                             blockread(soubor,_seznammrtvol^,_pocetmrtvol);
                             blockread(soubor,_seznamofsetu^,_pocetmrtvol shl 1);
                             blockread(soubor,_seznamkombinovatelnychznaku^,_delkaskz);
                             blockread(soubor,_seznamvyslednychznaku^,_delkaskz);
                             end;
                            if ioresult<>0 then begin _zrusrozlozeni(kam^); dispose(kam); exit; end;
                            end;
seznamrozlozeni[index]:=kam;
nactirozlozeni:=true;
End;{nactirozlozeni}

function NactiRozlozeni2(JmenoSouboru:string):boolean;
var soubor:file;
Begin
assign(soubor,jmenosouboru);
reset(soubor,1);
if ioresult=0 then nactirozlozeni2:=NactiRozlozeni(soubor)
              else nactirozlozeni2:=false;
close(soubor);
if ioresult=0 then {hm};
End;{nactirozlozeni2}

procedure DoBufferu(co:char);{vlozi do ASCII bufferu jeden znak}
Begin
if pocetznakuvbufferu<delkaasciibufferu
  then begin
       asciibuffer[sempsat]:=co;
       if sempsat=delkaasciibufferu then sempsat:=1
                                    else inc(sempsat);
       inc(pocetznakuvbufferu);
       end;
End;{dobufferu}

procedure mojetokeybuf(s:string);
var b:byte;
Begin
for b:=1 to byte(s[0]) do begin
                          asm cli end; {<---- zakazeme preruseni, aby se nam buffer nerozhodil,        }
                          dobufferu(s[b]);   {kdyby uzivatel neco zmacknul behem volani tehle procedury}
                          asm sti end; {a zase ho povolime}
                          end;
End;{mojetokeybuf}

function mojekeypressed:boolean;
Begin
mojekeypressed:=pocetznakuvbufferu<>0;
End;{mojekeypressed}

function mojereadkey:char;
Begin
{$ifndef BreakRusiReadkey} koncit:=false; {$endif}
 repeat until (pocetznakuvbufferu<>0) or koncit;
if pocetznakuvbufferu=0
  then mojereadkey:=#1 {nahradni znak pro pripad preruseni Breakem}
  else begin {normalni precteni znaku z fronty}
       mojereadkey:=asciibuffer[odtudcist];
       asm cli end;
       if odtudcist=delkaasciibufferu then odtudcist:=1
                                      else inc(odtudcist);
       dec(pocetznakuvbufferu);
       asm sti end;
       end;
End;{mojereadkey}

procedure readln2(var cil);
var z:word;
    vysledek:string;
Begin
vysledek:='';
 repeat
 z:=xreadkey;
 case z of 8,xlsipka:if vysledek<>'' then begin {Backspace nebo leva sipka - smaz posledni znak}
                                          dec(vysledek[0]); {zkrat retezec o 1}
                                          write(#8#32#8); {posun kurzor o znak doleva, premazni to tam mezerou a zase doleva}
                                          end;
           27:begin {Esc - vymaz retezec, vypis \ a odradkuj (sice tuhle vec nesnasim, ale radsi at se to chova stejne)}
              vysledek:='';
              writeln('\');
              end;
           9,32..255:begin {tabulator nebo normalni citelne znaky - pripis to k retezci}
                     vysledek:=vysledek+chr(z);
                     write(chr(z));
                     end;
           end;
 until (z=13) {Enter}
       or koncit; {Ctrl+Break}
writeln; {zaverecne zalomeni radku}
move(vysledek,cil,length(vysledek)+1); {do beztypove promenne se neda normalne prirazovat, tak to musime takhle obejit}
End;{readln2}

procedure PrikazKlavesnice(prikaz:byte); assembler;
Asm
{cekani, az bude klavesnice schopna prikaz prijmout (coz je obvykle hned):}
xor CX,CX
 @cyklus:
 in AL,$64 {nacteme hodnotu ze stavoveho portu klavesnice}
 test AL,2 {kdyz je ten bit 1, znamena to, ze klavesnice jeste nezpracovala minule prikazy, tak musime pockat}
 jz @dobry
 loop @cyklus {pri prvnim pruchodu CX podtece na $FFFF a pak se odcita az do 0 (tim se resi cekani a timeout)}
@dobry:
{odeslani prikazu:}
mov AL,prikaz
out $60,AL {nekdy se doporucuje pouziti portu $64, ale to mi nefungovalo}
End;{prikazklavesnice}
{dvoubytove prikazy se resi dvojim volanim tehle procedury}

procedure RychlostKlavesnice(zpozdeni,rychlost:byte);
Begin
prikazklavesnice($F3); {kod prikazu "nastav rychlost"}
{A ted jaka ta rychlost ma byt:}
prikazklavesnice(((zpozdeni and 3) shl 5) or (rychlost and 31));
 {Zpozdeni a rychlost je potreba naskladat do tech spravnych bitu, ve kterych
 je klavesnice ocekava, a odeslat. Andy tu jsou jenom jako bezpecnostni
 pojistka, ktera orizne pripadne hodnoty mimo povoleny rozsah.}
End;{rychlostklavesnice}

function KlavesniceReaguje:boolean;
Begin
prikazklavesnice($EE); {prikaz "posli echo"}
klavesnicereaguje:=port[$60]=$EE; {kdyz klavesnice posle zpatky stejny kod, je to OK}
End;{klavesnicereaguje}

procedure ResetKlavesnice;
Begin
prikazklavesnice($FF); {prikaz "reset a interni diagnostika"}
End;{resetklavesnice}

procedure NastavKontrolky(scroll,num,caps:boolean);
Begin
prikazklavesnice($ED); {prikaz "nastav kontrolky klavesnice"}
prikazklavesnice(ord(scroll) or (ord(num) shl 1) or (ord(caps) shl 2)); {nastaveni prislusnych bitu}
End;{nastavkontrolky}

procedure mojekresetuj;
Begin
asm cli end;
PocetZnakuVBufferu:=0;
SemPsat:=1;
OdtudCist:=1;
asm sti end;
End;{mojekresetuj}

procedure ZmackniNumlock; {provede vsechny ukony potrebne pro prepnuti numlocku. Jen pro novou obsluhu!}
var i:byte;
    pomw:word;
Begin
numlock:=not numlock;
NastavKontrolky(scrolllock,numlock,capslock);
{Prepnuti numlocku v podstate prohodi normalni a shiftovou tabulku pro
numericke klavesy. Na rychlosti celkem nesejde (jak casto se numlock
prepina?), takze to muzeme udelat tou nejjednodussi cestou, jeden kod
po druhem:}
if tabulkyklaves[seshiftem]<>nil {pokud je s cim prohazovat}
  then for i:=71 to 83 do {rozsah scankodu od '7' do '.'}
        if cislicenumpadu[i]<>' ' {chceme jenom cisla a tecku, nic jineho}
          then begin {vymena dvou kodu}
               pomw:=tabulkyklaves[bezniceho]^[i];
               tabulkyklaves[bezniceho]^[i]:=tabulkyklaves[seshiftem]^[i];
               tabulkyklaves[seshiftem]^[i]:=pomw;
               end;
End;{zmackninumlock}

procedure NastavRozlozeni(index:byte);
var bylnumlock:boolean;
Begin
if seznamrozlozeni[index]=nil then exit;
bylnumlock:=instalovano and numlock;
if bylnumlock then zmackninumlock; {vsechna neaktivni rozlozeni musi byt ulozena bez numlocku, aby v nem nebyl gulas}
with seznamrozlozeni[index]^ do
 begin
 move(_TabulkyKlaves,tabulkyklaves,sizeof(tabulkyklaves));
 pocetmrtvol:=_PocetMrtvol;
 seznammrtvol:=_SeznamMrtvol;
 seznamofsetu:=_SeznamOfsetu;
 delkaskz:=_DelkaSKZ;
 seznamkombinovatelnychznaku:=_SeznamKombinovatelnychZnaku;
 seznamvyslednychznaku:=_SeznamVyslednychZnaku;
 end;
if bylnumlock then zmackninumlock;
indexrozlozeni:=index;
End;{nastavrozlozeni}

procedure MojeInt9; interrupt; {nova obsluha preruseni klavesnice}
var scankod,scankod2:byte;
    stisknuto:boolean;
    IndexTabulky:byte;
    WordovyKod:word;
    ofset:word;
    pomw:word; pomi:integer;
Begin
scankod:=port[$60]; {na ktere klavese se neco deje}
port[$20]:=$20; {reset radice preruseni - radsi hned, aby se pak dalo v klidu exitovat}
pauza:=false; {stisk cehokoli rusi pauzu}
if (scankod=70)and(rozsirena<>0) then begin {zacatek breaku}
                                      rozsirena:=0;
                                      jedebreak:=true;
                                      exit;
                                      end;
if scankod=224 then if jedebreak then exit {pokracovani sekvence breaku}
                                 else begin {signal rozsirene klavesy}
                                      rozsirena:=maxscankod;
                                      exit;
                                      end;
if (scankod=198) and jedebreak then begin {konec sekvence breaku}
                                    jedebreak:=false;
                                    koncit:=true;
                                    if tvrdybreak then halt {tohle obcas nedela dobrotu}
                                                  else exit;
                                    end;
if scankod=225 then begin {zacatek pause}
                    jedepause:=true;
                    exit;
                    end;
if jedepause and (scankod in [29,69,225,157]) then exit; {pokracovani sekvence pause}
if (scankod=197) and jedepause then begin {konec pause}
                                    jedepause:=false;
                                    pauza:=true;
                                    if pausovyznak<>#0 then dobufferu(pausovyznak);
                                    exit;
                                    end;
{tim je Pause/Break vyresen, ted hlavni pole s klavesami:}
stisknuto:=scankod and $80=0; {nejvyssi bit rika, jestli doslo ke stisku nebo k pusteni}
{promenna Scankod zustava v puvodni podobe}
scankod2:=scankod and $7F+rozsirena; {Scankod2 je rozsireny a bez horniho bitu}
rozsirena:=0;
if scankod2<=2*maxscankod {pojistka proti prekroceni rozsahu pole (sice takove klavesy teoreticky neexistuji, ale co kdyby)}
  then _klavesy^[scankod2]:=stisknuto;
{pole s klavesami vyrizeno, ted Alty+cisla:}
if scankod=56 then begin {stisknut nektery Alt => inicializace ciselneho bufferu}
                   ciselnybuffer:='';
                   exit;
                   end;
if scankod=56+$80 then begin {pusten nektery Alt => vyhodnoceni ciselneho bufferu}
                       if ciselnybuffer<>''
                         then begin
                              val(ciselnybuffer,pomw,pomi);
                              if pomi=0 then begin {OK, je to platne cislo}
                                             dobufferu(char(pomw and $FF));
                                             ciselnybuffer:='';
                                             end;
                              end;
                       exit;
                       end;
if not stisknuto then exit; {dal uz se starame jenom o stisky, ne o pusteni}
{Alty+cisla jsou vyrizene, ted locky:}
if scankod2=58 then begin
                    capslock:=not capslock;
                    NastavKontrolky(scrolllock,numlock,capslock);
                    exit;
                    end;
if scankod2=70 then begin
                    scrolllock:=not scrolllock;
                    NastavKontrolky(scrolllock,numlock,capslock);
                    exit;
                    end;
if scankod2=69 then begin
                    zmackninumlock;
                    exit;
                    end;
{locky jsou vyrizene, ted specialni kombinace s Altem:}
if _klavesy^[plevyalt] or _klavesy^[ppravyalt] {drzi se nejaky Alt?}
  then if _klavesy^[plevyctrl] or _klavesy^[ppravyctrl] {drzi se nejaky Control?}
         then begin {Ctrl+Alt+neco}
              if (scankod2>=pF1)and(scankod2<=pF10) {stisknuto nejake F?}
                then begin {Ctrl+Alt+Fx = prepnuti rozlozeni klaves}
                     nastavrozlozeni(scankod2-pF1+1); {F1=1, F2=2 atd.}
                     exit;
                     end;
              end
         else if scankod2 in [71,72,73,75,76,77,79,80,81,82] {stisknuto cislo na numpadu?}
                then begin {Alt+cislo => pripis ho do ciselneho bufferu}
                     if length(ciselnybuffer)<delkaciselnehobufferu
                       then ciselnybuffer:=ciselnybuffer+CisliceNumpadu[scankod2];
                     exit;
                     end;
{printscreen:}
if (scankod2=pprintscreen) and autoscreenshot and (@scrshotproc<>nil)
  then begin
       scrshotproc;
       exit;
       end;
{vyber ASCII tabulky podle stavu preradovacu:}
if _klavesy^[ppravyalt] then indextabulky:=spravymaltem
 else if _klavesy^[plevyalt] then indextabulky:=slevymaltem
  else if _klavesy^[plevyctrl] or _klavesy^[ppravyctrl] then indextabulky:=scontrolem
   else if _klavesy^[plevyshift] or _klavesy^[ppravyshift]
          then if capslock then indextabulky:=scapslockemashiftem
                           else indextabulky:=seshiftem
    else if capslock then indextabulky:=scapslockem
     else indextabulky:=bezniceho;
{nalezeni wordoveho ASCIIkodu:}
wordovykod:=tabulkyklaves[indextabulky]^[scankod2];
if (wordovykod=0) and propadavani then begin {nedefinovana => propadneme do zakladni tabulky}
                                       indextabulky:=bezniceho;
                                       wordovykod:=tabulkyklaves[indextabulky]^[scankod2];
                                       end;
if wordovykod=0 then exit; {nedefinovana klavesa nedela nic}
{prevod kodu na znak(y) a zarazeni do bufferu:}
if lo(wordovykod)=0 then begin {rozsirena}
                         if mrtvolyprovsechny and (mrtvola<>#0)
                           then begin {pripadne vlozeni aktualniho mrtveho znaku (bez kombinovani)}
                                dobufferu(mrtvola);
                                mrtvola:=#0;
                                end;
                         dobufferu(#0);
                         dobufferu(char(hi(wordovykod)));
                         end
 else if hi(wordovykod)=0 then mrtvola:=char(lo(wordovykod)) {mrtva}
  else if lo(wordovykod)=hi(wordovykod) {obycejna, kombinovatelna s mrtvymi}
         then begin
              if mrtvola=#0
                then dobufferu(char(lo(wordovykod))) {bez mrtvych znaku je to jednoduche...}
                else begin {...s nimi o trochu slozitejsi}
                     ofset:=0; {trochu ho zneuzijeme do funkce pomocneho indexu}
                     while (ofset<pocetmrtvol)and(seznammrtvol^[ofset]<>mrtvola)
                       do inc(ofset); {najdeme aktualni mrtvolu v tabulce}
                     if ofset>=pocetmrtvol then begin {tohle se teoreticky stat nemuze, ale co kdyby}
                                                dobufferu(mrtvola);
                                                mrtvola:=#0;
                                                dobufferu(char(lo(wordovykod)));
                                                exit;
                                                end;
                     ofset:=seznamofsetu^[ofset]; {ted uz je v Ofsetu to, na co je staveny}
                     while (ofset<delkaskz)and(seznamkombinovatelnychznaku^[ofset]<>#0)
                           and(seznamkombinovatelnychznaku^[ofset]<>char(lo(wordovykod)))
                       do inc(ofset); {najdeme v tabulce znak odpovidajici stisknute klavese}
                     if (ofset>=delkaskz)or(seznamkombinovatelnychznaku^[ofset]=#0)
                       then begin {nekombinovatelne => do bufferu obe}
                            dobufferu(mrtvola);
                            dobufferu(char(lo(wordovykod)));
                            end
                       else dobufferu(seznamvyslednychznaku^[ofset]); {zkombinujeme mrtvolu s klavesou a vlozime jako 1 znak}
                     mrtvola:=#0;
                     end;
              end;
  {else neplatna definice klavesy, kaslem na ni}
End;{mojeint9}

function pressed(klavesa:word):boolean; assembler;
Asm     {pressed:=_klavesy^[klavesa];}
mov BX,klavesa
les DI,_klavesy
dec BX           {protoze pole _klavesy je indexovano od 1}
mov AL,ES:[DI+BX]
End;{pressed}

procedure InitKlav;
Begin
if not instalovano then
 begin
 if indexrozlozeni=0 {jestli jeste neni nastaveno zadne rozlozeni klaves, nastavime ho automaticky}
   then if seznamrozlozeni[1]=nil then exit {kdyz zadne neni k dispozici, radsi skoncime}
                                  else nastavrozlozeni(1); {jinak nastavime hned to prvni}
 if maxavail<sizeof(polebooleanu) then exit; {neni pamet na pole klaves}
 repeat until (sw and $730F)=0; {nejdriv pockej na pusteni vsech preradovacu}
 {nastaveni nasich locku podle standardniho stavoveho wordu:}
 capslock:=stdcapslock;
 if numlock<>stdnumlock then zmackninumlock;
 scrolllock:=stdscrolllock;
 new(_klavesy); {alokace pole pro stisknute klavesy}
 fillchar(_klavesy^,sizeof(polebooleanu),false); {vsechny klavesy nastav na "pusteno"}
 rozsirena:=0; mrtvola:=#0;
 PocetZnakuVBufferu:=0; SemPsat:=1; OdtudCist:=1;
 ciselnybuffer:='';
 getintvec(9,puvodniint9); {zaloha puvodniho preruseni}
 setintvec(9,@mojeint9); {nastaveni noveho preruseni}
 instalovano:=true;
 puvodniexit:=exitproc; {zaloha puvodni ukoncovaci procedury}
 exitproc:=@zrusklav; {presmerovani ukoncovaci procedury na odinstalovani preruseni}
 KeyPressed:=mojekeypressed;
 ReadKey:=mojereadkey;
 ToKeyBuf:=mojetokeybuf;
 kResetuj:=mojekresetuj;
 end;
End;{InitKlav}

procedure ZrusKlav;
Begin
if instalovano then
 begin
 KeyPressed:=stdkeypressed;
 ReadKey:=stdreadkey;
 ToKeyBuf:=stdtokeybuf;
 kResetuj:=stdkresetuj;
 exitproc:=puvodniexit;{vraceni puvodni ukoncovaci procedury}
 setintvec(9,puvodniint9);{nastaveni puvodniho preruseni}
 dispose(_klavesy);
 instalovano:=false;
 {nastaveni standardniho stavoveho wordu podle nasich locku
  (rozepsano, aby se zbytecne nehrabalo do kontrolek):}
 if capslock then sw:=sw or 64
             else sw:=sw and not 64;
 if numlock then sw:=sw or 32
            else sw:=sw and not 32;
 if scrolllock then sw:=sw or 16
               else sw:=sw and not 16;
 end;
End;{zrusklav}

function pKeyPressed:boolean; assembler;
Asm
les DI,_klavesy    {ES:DI = adresa pole _klavesy}
db $66; xor CX,CX  {prekladac by nesezral mov ECX,48, tak musime nadvakrat}
db $66; xor AX,AX  {EAX = 0 (tj. false v kazdem bytu)}
mov CX,48          {ECX = 2*93+6 (pocet bytu v poli) div 4 (pocet bytu ve dwordu)}
db $66; repe scasw {repe scasd - porovnavej prvky pole s EAX tak dlouho, dokud jsou stejne a nejsi na konci pole}
or AX,CX      {= mov AX,CX (AX bylo 0)}
{Kdyz je stisknuta nejaka klavesa, cyklus repe scasd se zastavi driv nez
dojde na konec pole, a tudiz v CX zbyde nenulove cislo (=true), jinak projede
cele pole a v CX bude 0 (=false). Posledni ctyri byty pole jsou vyplnove a
vzdy nulove, takze vysledek neovlivni.}
End;{pkeypressed}

function KlavesyInstalovany:boolean;
Begin
klavesyinstalovany:=instalovano;
End;{KlavesyInstalovany}


(************************** standardni funkce: ******************************)

Function stdKeypressed:Boolean; assembler;
Asm
mov AX,$0B00
int $21
{funkce vraci hodnotu z AL; kdyz je nenulova, je to true}
End;{stdkeypressed}

function stdReadKey:char; assembler;
Asm
mov AX,$0700
int $21
{funkce vraci hodnotu z AL - znak}
End;{stdreadkey}

procedure stdkResetuj; assembler;
Asm
mov AX,$0C06
mov DL,$FF
int $21
End;{stdkresetuj}

function lshiftpressed:boolean;
Begin lshiftpressed:=(sw and 2)<>0 End;

function pshiftpressed:boolean;
Begin pshiftpressed:=(sw and 1)<>0 End;

function shiftpressed:boolean; assembler;
{Stejny princip jako vyse uvedene funkce, jenom jina forma zapisu. Asm funkce
byvaji obvykle o neco rychlejsi (a shift se testuje pomerne casto).}
Asm
xor AX,AX
mov SI,$0417     {SI = $0417}
mov ES,AX        {ES = 0}
mov AX,[ES:SI]   {AX = sw}
and AX,3         {kdyz vyjde nenulove cislo (stisknut libovolny Shift), je to true}
End;{shiftpressed}

function lctrlpressed:boolean;
Begin lctrlpressed:=(sw and (256 or 4))=260 End;

function pctrlpressed:boolean;
Begin pctrlpressed:=(sw and (256 or 4))=4 End;

function ctrlpressed:boolean; assembler;
Asm {Begin ctrlpressed:=(sw and 4)<>0 End;}
xor AX,AX
mov SI,$0417
mov ES,AX
mov AX,[ES:SI]
and AX,4
End;{ctrlpressed}

function laltpressed:boolean;
Begin laltpressed:=(sw and (512 or 8))=520 End;

function paltpressed:boolean;
Begin paltpressed:=(sw and (8 or 512))=8 End;

function altpressed:boolean;
Begin altpressed:=(sw and 8)=8 End;

function capslockpressed:boolean;
Begin capslockpressed:=(sw and 16384)=16384 End;

function numlockpressed:boolean;
Begin numlockpressed:=(sw and 8192)=8192 End;

function scrolllockpressed:boolean;
Begin scrolllockpressed:=(sw and 4096)=4096 End;

function stdcapslock:boolean;
Begin stdcapslock:=(sw and 64)<>0 End;

function stdnumlock:boolean;
Begin stdnumlock:=(sw and 32)<>0 End;

function stdscrolllock:boolean;
Begin stdscrolllock:=(sw and 16)<>0 End;

procedure stdtokeybuf(s:string); assembler;
Asm
les DI,s        {ES:DI = adresa retezce}
mov BL,[ES:DI]  {BL = delka retezce (nulty znak)}
mov AH,5        {cislo sluzby}
 @cyklus:       {cyklus pro kazdy znak retezce (while)}
 or BL,BL       {je tam jeste neco?}
 jz @hotovo     {neni => konec; jinak:}
  inc DI         {o znak v retezci dal}
  mov CL,[ES:DI] {nacteme znak do CL}
  int $16        {zavolame preruseni klavesnice}
  dec BL
 jmp @cyklus
@hotovo:
End;{stdtokeybuf}


(************************** univerzalni funkce: *****************************)

procedure setcapslock(jak:boolean);
Begin
if instalovano then begin
                    capslock:=jak;
                    nastavkontrolky(scrolllock,numlock,capslock);
                    end
               else begin
                    if jak then sw:=sw or 64     {nastaveni prislusneho bitu ve stavovem wordu}
                           else sw:=sw and not 64;
                    nastavkontrolky(stdscrolllock,stdnumlock,jak); {nekdy prebliknou samy, nekdy ne, tak se radsi pojistime}
                    end;
End;{setcapslock}

procedure setnumlock(jak:boolean);
Begin
if instalovano then begin
                    if jak<>numlock then zmackninumlock;
                    end
               else begin
                    if jak then sw:=sw or 32
                           else sw:=sw and not 32;
                    nastavkontrolky(stdscrolllock,jak,stdcapslock);
                    end;
End;{setnumlock}

procedure setscrolllock(jak:boolean);
Begin
if instalovano then begin
                    scrolllock:=jak;
                    nastavkontrolky(scrolllock,numlock,capslock);
                    end
               else begin
                    if jak then sw:=sw or 16
                           else sw:=sw and not 16;
                    nastavkontrolky(jak,stdnumlock,stdcapslock);
                    end;
End;{setscrolllock}

(*
procedure BIOSRychlostKlavesnice(zpozdeni,rychlost:byte); assembler;
Asm
mov AX,$0305
mov BH,zpozdeni
mov BL,rychlost
int $16
End;{biosrychlostklavesnice}
*)

procedure kcekej;
Begin
repeat until keypressed;
End;{kcekej}

function xreadkey:word;
var zn:char;
Begin
zn:=readkey;
if zn=#0 then xreadkey:=ord(readkey)+256
         else xreadkey:=ord(zn);
End;{xreadkey}

function KlavesniceUmi(co:byte):boolean; assembler;
Asm
mov AH,9
int $16
mov CL,co    {kolikaty bit kontrolujeme}
shr AX,CL    {posuneme kontrolovany bit na nejnizsi pozici...}
and AX,1     {...a vsechny ostatni vynulujeme}
End;{klavesniceumi}

procedure krcr;
Begin
kresetuj; kcekej; kresetuj;
End;{krcr}

BEGIN
pauza:=false; koncit:=false;
instalovano:=false;
fillchar(tabulkyklaves,sizeof(tabulkyklaves),0);
fillchar(SeznamRozlozeni,sizeof(SeznamRozlozeni),0);
indexrozlozeni:=0;
{na zacatku standardni obsluha:}
KeyPressed:=stdkeypressed;
ReadKey:=stdreadkey;
ToKeyBuf:=stdtokeybuf;
kResetuj:=stdkresetuj;
END.

(*Prubeh obsluzneho preruseni:
(relativne prehledna, ale zastarala pracovni verze - berte s rezervou)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nacti scankod z portu

je pauza: nastav "pauzu" na false
70 a rozsirena: zacatek Breaku - vynuluj "rozsirenou", nastav "jede Break"
           a konec
224: jede Break: konec
     jinak: nastav "rozsirenou" a konec
198 a jede Break: zrus "jede Break", udelej, co se ma udelat (kod Breaku
           do bufferu nebo nejak ukonci program) a konec
225: zacatek Pause - nastav "jede Pause" a konec
29, 69, 225 nebo 157 a jede Pause: konec
197 a jede Pause: zrus "jede Pause", udelej, co se ma udelat (kod Pause do
           bufferu nebo nastav nejakou promennou "pauza" na true) a konec

(tim je Pause/Break vyresen, ted pole s klavesami:)

podle horniho bitu nastav "stisknuto"
vynuluj horni bit
pricti "rozsirenou"
vynuluj "rozsirenou"
aktualizuj "_klavesy"

stisknuto a (56 nebo r56) (stisknut nektery Alt) [tohle pujde lip
           s neupravenym scankodem (jenom test na =56)]: inicializuj ciselny
           buffer a konec
(neni stisknuto) a (56 nebo r56) (pusten nektery Alt): vyhodnot ciselny
           buffer, pripadny vysledek hod do ASCII bufferu a konec

neni stisknuto: konec

(_klavesy a Alt+cisla jsou hotove)

58 nebo 70: prepni caps/scroll lock a jeho kontrolku a konec
69: prepni numlock a jeho kontrolku a presmeruj tabulky na alternativni
           nebo zpatky
stisk 71..3, 75..7, 79..82 a je stisknuty nejaky Alt: hod do ciselneho bufferu
           prislusnou cislici a konec

stisk r55 (Printscreen) a ma to tak byt: zavolani procedury pro ulozeni
           screenshotu a konec (jinak se Printscreen bere jako normalni
           klavesa s nejakym ASCII kodem)

(nastaveni ASCII tabulek podle preradovacu:)

stisknut pravy Alt: aktualni tabulka := pravoaltove klavesy
 else    levy Alt       ...             levo  ...
  else   Ctrl           ...             ctrlove   ...
   else  Shift: zapnuty capslock: aktualni tabulka := caps+shift
                           jinak: aktualni tabulka := shift
    else capslock: aktualni tabulka := capslockove klavesy
     else aktualni tabulka := normalni klavesy

pouzij scankod jako index a vytahni z ASCII tabulky wordovy kod  <--+
kod=0 (nedefinovana klavesa): aktualni tabulka := normalni klavesy  |
                              zkus to jeste jednou -----------------+
                              kod=0: konec

(vyhodnoceni znaku podle ASCII tabulky:)

lo(kod)=0 (rozsirena): kdyz se to tak ma delat, tak nabufferuj pripadny
           mrtvy znak a vynuluj ho; pak nabufferuj #0 a pak hi(kod)
hi(kod)=0 (mrtva): mrtvy priznak:=lo(kod)
lo(kod)=hi(kod) (obycejna):
    mrtvy priznak=#0 (tj. zadny neni): nabufferuj lo(kod)
    jinak: projdi seznam mrtvych znaku a najdi index toho, ktery je aktualne
                       v priznaku (nebo jestli je seznam prazdny, tak konec)
           pres tenhle index koukni do seznamu ofsetu (array of word) a
                       precti ofset pro seznam znaku, se kterymi tahle mrtvola
                       jde zkombinovat
           od tohohle ofsetu prochazej seznam znaku, dokud nenarazis na
                       lo(kod) nebo #0
                      sahni do seznamu vyslednych znaku na stejny ofset
                       a nabufferuj ho (na pozici #0 bude pripraveny samotny
                       mrtvy znak)
           vynuluj mrtvy priznak

konec:
resetuj radic preruseni
*)


(*Format souboru s definici rozlozeni klaves (koncovka .RK):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- jmeno (string[8]): vzato ze jmena souboru se zdrojakem (bez koncovky)
- ktere tabulky jsou pritomne (array[1..7] of boolean):
  1 - se shiftem
  2 - s controlem
  3 - rezervovano pro pripadne rozliseni L/P controlu, zatim vzdy false
  4 - s levym altem
  5 - s pravym altem
  6 - s capslockem
  7 - s capslockem a shiftem
- tabulky wordovych kodu (array[1..2*maxscankod] of word) - jedna za druhou,
 ve stejnem poradi jako v predchozim seznamu; jednotlive kody v tabulkach
 muzou nabyvat nasledujicich hodnot (xy je nejake nenulove cislo):
  $0000: nedefinovana klavesa, pri stisku nedela nic
  $xyxy (oba byty stejne): bezna klavesa, generuje se znak $xy
  $xy00: rozsirena klavesa, generuje se #0 a #$xy
  $00xy: mrtva klavesa; negeneruje se nic, jenom se interni priznak nastavi
         na znak $xy a vyhodnoti se az pri stisku nasledujici klavesy
  Maxscankod je 93 (a to se asi jen tak nezmeni).
- pocet mrtvych znaku (byte): 0 = soubor uz dal nepokracuje, jinak:
- delka seznamu kombinovatelnych znaku (word)
- seznam mrtvych znaku (array[1..pocet m.z.] of char)
- seznam ofsetu pro seznam kombinovatelnych znaku (array[1..pocet m.z.] of word)
- seznam kombinovatelnych znaku (array[1..delka s.k.z.] of char)
- seznam vyslednych znaku (array[1..delka s.k.z.] of char)

O kompilaci z textoveho formatu ZRK do binarniho RK se stara program KOMPKLAV,
popis syntaxe najdete na zacatku jeho zdrojoveho kodu.
*)