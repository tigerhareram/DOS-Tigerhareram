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