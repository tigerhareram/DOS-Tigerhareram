{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X-,F+,I-}

Unit x12_kbd2;
 {Keyboard 2}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram, x03_dos, x04_vga, x05_svga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16, x11_kbd1,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;


{INTERFACE}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: KLAVESY.PAS                                                    *)
(*  Obsah: kody klaves, procedury pro cteni z klavesnice a jeji nastaveni  *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*         SWAG team  (DOSovska varianta Keypressed a Readkey)             *)
(*  Posledni uprava: 28.8.2013                                             *)
(*  Pro kompilaci: (DOS.TPU)                                               *)
(*  Pro spusteni: bud nic nebo nejaky soubor s definici rozlozeni klaves   *)
(*                (*.RK), pokud chcete pouzivat specialni obsluhu          *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)

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


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

{12-Keyb.2}     {$I ..\SOURCES\Litex\STORE\12-KEYB2\klavesy.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
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
End.
