(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: XMS.PAS                                                        *)
(*  Obsah: zakladni procedury a funkce pro praci s rozsirenou pameti (XMS),*)
(*         objekty pro ukladani textu a grafiky                            *)
(*  Posledni uprava: 24.1.2012                                             *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*  Pro kompilaci: DOS.TPU, chybove hlasky jsou ulozeny nezavisle          *)
(*                 v jednotce ERRMSG.TPU                                   *)
(*  Pro spusteni: fungujici ovladac XMS (viz dale);                        *)
(*                bez nej bude pamet automaticky emulovana na disku        *)
(*  Upozorneni: Tyto zdrojove kody pouzivate na vlastni nebezpeci.         *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)

{Co vsechno je potreba udelat, abychom se ke XMS dostali?
- Windows 95, 98 a asi i dalsi: pokud se bavime o zkompilovanem programu nebo
  spousteni pres Ctrl+F9 z prostredi TPX.EXE, tak nic. Pro spousteni
  z TURBO.EXE plati totez, co v nasledujicim bode.
- DOS: musime mit zavedeny ovladac XMS. To se dela v souboru CONFIG.SYS
  temito dvema prikazy:
                        DEVICE=C:\DOS\HIMEM.SYS
                        DEVICE=C:\DOS\EMM386.EXE NOEMS
  (misto C:\DOS si zadejte svoji cestu k uvedenym souborum)
  Na konec prvniho radku doporucuji jeste pripsat parametr /TESTMEM:OFF. Tim
  se vyradi zdlouhavy test pameti a urychli se bootovani. Dalsim parametrem
  /NUMHANDLES=cislo muzeme explicitne urcit pocet dostupnych handlu (tj. kolik
  bloku pujde alokovat soucasne). Rozsah je 1..128, standardne 32.
  Himem je nutnou podminkou pro zpristupneni XMS.
  Az druhy radek ale zpusobi, ze se ke XMS dostaneme. Parametr NOEMS je velmi
  dulezity - bez nej by Emm386 veskerou rozsirenou pamet alokoval a vyuzil
  pro emulaci EMS, coz nechceme (je mozne i ciselne urcit, kolik KB pouzit na
  EMS a kolik nechat na XMS, ale to uz je celkem zbytecne).

Pod DOSem bude pristupna fyzicka pamet az do 64 MB (pripadne mene, pokud mate
mensi). Pod Windows bude tech 64 MB pristupnych vzdy, i kdyz RAMky ve
skutecnosti tolik nemate (tam je pamet virtualni).

Ve Windows je pri spousteni z IDE maximalni velikost alokovatelneho bloku
omezena na cca 2 MB, v DOSu nebo pri spousteni zkompilovaneho exace zadne
takove omezeni neni.

TPX.EXE funguje docela zvlastne. Pod Windows z nej muzete spoustet programy
vyuzivajici XMS bez problemu (s max. 2 MB na 1 blok), i kdyz v Configu nejsou
vyse uvedene prikazy na zavedeni ovladace. Ale naopak z DOSu pres nej XMS
nefunguje, i kdyz tam ty prikazy jsou.
TURBO.EXE se chova vzdy presne podle nastaveni v Config.sys.}

unit XMS;
{$I-,B-} {dulezite!}

{...$define debug} {pokud je tento symbol definovan, vypise se pri startu
                    programu uvodni hlaska a informace o tom, jestli XMS
                    funguje nebo ne.}
interface

(*************************** diagnostika: ***********************************)

var XMSresult:byte;
{V teto promenne se uchovava informace o uspesnosti posledni operace s XMS
pameti. 0 = OK, jinak chyba. Doporucuji zkontrolovat na zacatku programu -
- jestli neni 0, XMS nefunguje tak, jak by mela, a proto bude kompletne
emulovana pomoci docasnych souboru na disku (coz muze byt samozrejme o dost
pomalejsi a je vhodne na to uzivatele upozornit).
Popis jednotlivych hodnot teto promenne je uveden v jednotce ERRMSG.}

function XMSmemavail:word;
{Vraci velikost volne XMS pameti v KB.}
function XMSmaxavail:word;
{Vraci velikost nejvetsiho volneho (alokovatelneho) bloku XMS v KB.}

function AdresaOvladaceXMS:pointer;
{Vraci obsah interniho ukazatele na ovladaci rutinu (normalne neni potreba,
ale obcas je low-level pristup potreba).}

(********************* alokace a uvolneni XMS pameti: ***********************)

procedure GetXMS(var Handle:word; Velikost:word);
{Alokuje blok XMS pameti.
 Velikost - pozadovana velikost bloku v KB
 Handle - cislo, ktere alokovanemu bloku prideli ovladac. Pomoci tohoto cisla
          se pak s blokem pracuje - neztratit!}
procedure FreeXMS(Handle:word);
{Uvolni drive alokovany blok s cislem Handle.}

{Jednotka si pamatuje cisla vsech bloku, ktere vytvorite, a pri ukonceni
programu (vcetne neplanovanych padu) vsechny automaticky uvolni. Ale stejne
je bezpecnejsi uvolnovat pamet rucne.}

(***************************** kopirovani dat: ******************************)

procedure DoXMS(handle:word; ofset:longint; var odkud; KolikBytu:word);
{Zkopiruje blok dat ze zakladni pameti do XMS.
  handle - cislo bloku XMS, do ktereho kopirujeme (musi byt alokovany!)
  ofset - ofset v tomto bloku (pocitano od nuly)
  odkud - adresa dat ke kopirovani (promenna)
  KolikBytu - velikost kopirovanych dat v B; musi byt suda (pokud date lichou,
              bude automaticky zvysena o 1)
Pozor, ze pokud neco omylem zapisete mimo alokovany blok, koledujete si o
uplne stejne problemy jako v pripade zakladni pameti!}
procedure ZeXMS(var kam; handle:word; ofset:longint; KolikBytu:word);
{Zkopiruje blok dat ze XMS do zakladni pameti. Parametry obdobne jako minule.
Hlavne pozor na automaticke zvysovani liche velikosti, aby vam to neskoncilo
Nepovolenou Operaci pri kopirovani mimo alokovanou pamet!}

{...$define presuny_mezi_xms} {Jestli myslite, ze se vam nasledujici procedura
                             bude hodit, odstrante tri tecky v teto direktive.}
{$ifdef presuny_mezi_xms}
procedure MeziXMS(CiloveHandle:word; CilovyOfset:longint; ZdrojoveHandle:word; ZdrojovyOfset:longint; KolikBytu:word);
{Zkopiruje blok dat z jednoho mista XMS na jine.}
{$endif}


(********************** objekt pro uchovavani textu: ************************)

type
{pomocne typy:}
InfoORadku = record ofset:longint; delka:byte; end;{informace o jednom radku
    (v XMS budou radky ulozeny za sebou, tak aby bylo jasne, kde ktery zacina a jak je dlouhy)}
PoleInformaci = array[1..1] of infooradku; {dynamicke pole, kde kazda polozka odpovida informacim o jednom radku souboru}
UkNaPoleInformaci = ^poleinformaci; {a nezbytny ukazatel, bez ktereho by pole nemohlo byt dynamicke}

{uzivatelsky typ:}
XText = object
        PocetRadku:word;
        Radky:uknapoleinformaci;
        Handl:word; {cislo bloku XMS pameti, ve kterem bude soubor ulozen}
        procedure init(Soubor,Zacatek,Konec:string);
        {Nacte texty z daneho textoveho souboru (parametr Soubor je jeho
        jmeno). Pokud se neco nepovede (chyba pri cteni, neexistujici soubor,
        nedostatek pameti atd.), budou po skonceni procedury vsechny datove
        polozky (Pocetradku, Radky a Handl) nulove.
        Nacitat se zacina od radku, ktery nasleduje za radkem, na kterem je
        text Zacatek (pokud je Zacatek='', nacita se od zacatku souboru),
        a konci se na poslednim radku pred radkem, na kterem je text Konec
        (pri Konec='' se cte az do konce souboru).}
        function dej(CisloRadku:word):string;
        {Vrati jeden radek z nacteneho souboru, cisluje se od 1
        (tj. od prvniho nacteneho radku).}
        procedure zrus;
        {Vymaze nactene texty z pameti a vynuluje Pocetradku, Radky a Handl.}
        end;
{K cemu je to dobre?
a) Setri se mistem v zakladni pameti (te mame jenom 640 KB a textu je casto
   pomerne hodne), v programu staci nadefinovat pouze cisla radku (konstanty).
   Cteni ze XMS je rychlejsi nez cteni z disku.
b) Zjednodusuje se pripadny preklad do jineho jazyka - staci prepsat textovy
   soubor (a nerozhazet pri tom pocet a poradi radku!) a nemusi se zasahovat
   do programu a znovu ho kompilovat.
Nacitane radky muzou byt i prazdne.
Komentare v souboru, ktere se nemaji nacitat, zacinejte dvema stredniky
(';;'), od nich az do konce radku se to bude ignorovat.
Pozor, radek jako takovy se precte vzdycky; pokud dvema stredniky zacina,
bude povazovan za platny prazdny radek!
Take pozor na mezery - vsechny mezery pred zacatkem komentare se nactou.
Omezeni:
- Maximalni delka jednoho radku je 255 znaku (vic se do stringu nevejde).
- Maximalni pocet radku je 13105 (delsi pole s indexy a delkami nejde
  alokovat).
- Maximalni velikost souboru, ktery nacitate, by nemela presahnout 2 MB
  (to nekdy byva maximalni alokovatelna velikost bloku XMS).
- Nactene texty jsou urceny jen pro cteni, prepsat se daji pouze v souboru.
Priklad souboru s texty a ruznych zpusobu nacitani je na konci teto jednotky.}


(*************** objekt pro uchovavani "pruhlednych" obrazku: ***************)

type
{pomocne typy (sablony pro dynamicka pole, na horni mezi indexu nezalezi):}
PoleLongintu = array[1..100] of longint;
PoleWordu = array[1..100] of word;

xSprite = object
          pocet:word; {kolik obrazku tu mame}
          adresy:^polelongintu; {seznam jejich ofsetu v bloku XMS}
          velikosti:^polewordu; {seznam jejich velikosti (aby se nemusela pokazde cist velikost ze XMS)}
          handl:word; {cislo bloku XMS, ve kterem jsou obrazky ulozeny}
          mezipamet:pointer; {pomocny buffer pro cteni ze XMS}
          VelikostMezipameti:word; {velikost tohoto bufferu}
          function init(var Soubor:file):boolean;
          {Nacte obrazky z daneho Souboru otevreneho pro cteni s velikosti
          bloku 1 (reset(soubor,1);). Po docteni soubor nezavre. Pri uspechu
          vraci true; pri neuspechu false a zrusi po sobe vsechno, co si
          stacila alokovat.}
          function init2(JmenoSouboru:string):boolean;
          {Podobna predchozi, ale zadava se ji jmeno souboru, ktery si otevre,
          nacte a zavre.}
          procedure Priprav(CisloObrazku:word);
          {Obrazek s danym Cislem si nacte ze XMS do interniho bufferu (ukazatel
          Mezipamet). Primo odtamtud se da zobrazit procedurami typu PutSprite z
          jednotek VESA a VGA. Obrazky jsou cislovany od 1.}
          function Dej(CisloObrazku:word):pointer;
          {Pripravi si obrazek s danym Cislem a vrati ukazatel na Mezipamet
          (slouzi predevsim pro pohodlnejsi zapis).}
          procedure Zrus;
          {Uvolni veskerou pamet, kterou ma objekt alokovanou, a nastavi
          atribut Pocet na 0.}
          end;
{Tady uz je snad na prvni pohled jasne, k cemu je to dobre :-) (jestli ne, tak
odpovim recnickou otazkou: kam jinam s nekolika megabajty grafiky?).
Format souboru, ze kterych se nacita, je popsan na konci teto jednotky.
Vytvorit je muzete pomoci procedur z jednotky GenXspr.}


(****************************************************************************)

implementation
uses dos; {kvuli emulaci}

type UkNaZaznam = ^zaznamobloku;
     ZaznamOBloku = record
                    HandleBloku:word;
                    dalsi:uknazaznam;
                    end;
{Pro vytvareni bezpecnostniho seznamu alokovanych bloku, aby se daly pri
neplanovanem ukonceni programu vsechny zrusit.}

var OvladacXMS:pointer; {procedura, ktera se stara o praci s pameti}
    moznehandle:word; {pro emulaci (cislovani docasnych souboru)}
    PuvodniExitproc:pointer;
    PrvniBlok:uknazaznam;
    {Presouvani dat se na nejnizsi urovni provadi vyplnenim deskriptoru
    (zaznamu, ve kterem jsou ulozeny informace o tom, co se kam ma kopirovat)
    a zavolanim ovladace XMS. Deskriptor vypada takhle:}
    deskriptor:record
               velikost:longint;{pocet bytu, ktere se maji kopirovat,
                                 max. 64 KB (i kdyz je to longint).
                                 Musi to byt sude cislo.}
               HandleZdroje:word;{cislo zdrojoveho bloku}
               OfsetVeZdroji:longint;{linearni adresa pocitana od zacatku zdrojoveho bloku (od 0)}
               HandleCile:word;   {\ totez pro cilovy blok}
               OfsetVCili:longint;{/                      }
               end;
    {Kdyz chceme presouvat do/ze zakladni pameti, nastavime prislusne handle
    na 0 a do ofsetu vlozime ukazatel na data pretypovany na longint.}
    XMSCesta:pathstr; {aby emulace nezkolabovala, kdyz se program prepne do jineho adresare}

procedure EmulatorXMS; far; {nahradni obsluzna procedura, ktera emuluje rozsirenou pamet v souborech na disku}
var sluzba,chyba:byte;
    _AX,_DX:word;
    l:longint;
    p:pointer;
    f:file;
{}procedure PripravSoubor(cislo:word); {sestavi z daneho cisla jmeno souboru a priradi ho k promenne f}
{}var soubor:string[12];
{}Begin
{}str(cislo,soubor);
{}soubor:=soubor+'.$$$';
{}assign(f,xmscesta+soubor);
{}End;{pripravsoubor}
Begin
asm {vstupni parametry se predavaji pres registry}
mov sluzba,AH
mov _DX,DX
end;
chyba:=0;
case sluzba of 8:begin {xmsmemavail nebo xmsmaxavail}
                 l:=longint(diskfree(0)) shr 10; {velikost disku v KB}
                 if l>$FFFF then l:=$FFFF;
                 if l=-1 then begin {jedina mozna chyba pri Diskfree}
                              _AX:=0;
                              chyba:=$C1; {I/O chyba (nestandardni kod)}
                              end
                         else _AX:=l;
                 _DX:=_AX;
                 end;
               9:{getxms}
                 if moznehandle=$FFFF then chyba:=$A1 {dosly volne handly}
                  else begin
                       inc(moznehandle);
                       pripravsoubor(moznehandle);
                       rewrite(f); close(f);
                       if ioresult<>0 then chyba:=$C1;
                       _DX:=moznehandle;
                       end;
               $0A:begin {freexms}
                   pripravsoubor(_DX);
                   erase(f);
                   if ioresult<>0 then chyba:=$C1;
                   end;
               $0B:begin {xmspresun}
                   with deskriptor do
                     begin
                     if odd(velikost) then chyba:=$A7 {at je emulace dokonala :-)}
                      else if handlezdroje=0 then begin {z pameti do souboru}
                                                  pripravsoubor(handlecile);
                                                  filemode:=2; {cteni i zapis}
                                                  reset(f,1);
                                                  seek(f,ofsetvcili);
                                                  blockwrite(f,pointer(ofsetvezdroji)^,velikost);
                                                  close(f);
                                                  if ioresult<>0 then chyba:=$C1;
                                                  end
                       else if handlecile=0 then begin {ze souboru do pameti}
                                                 pripravsoubor(handlezdroje);
                                                 reset(f,1);
                                                 seek(f,ofsetvezdroji);
                                                 blockread(f,pointer(ofsetvcili)^,velikost);
                                                 close(f);
                                                 if ioresult<>0 then chyba:=$C1;
                                                 end
{$ifdef presuny_mezi_xms}else {ze souboru do souboru}
                             if maxavail<velikost then chyba:=$C1
                              else begin
                                   getmem(p,velikost);
                                   pripravsoubor(handlezdroje);
                                   reset(f,1);
                                   seek(f,ofsetvezdroji);
                                   blockread(f,p^,velikost);
                                   close(f);
                                   pripravsoubor(handlecile);
                                   filemode:=2;
                                   reset(f);
                                   seek(f,ofsetvcili);
                                   blockwrite(f,p^,velikost);
                                   close(f);
                                   if ioresult<>0 then chyba:=$C1;
                                   freemem(p,velikost);
                                   end{$endif};
                     end;{with globdesk}
                   end;
               else chyba:=$80; {nezname (nepodporovane) cislo sluzby}
               end;{case}
asm {vystupni hodnoty se vraceji opet pres registry}
mov AX,_AX
mov DX,_DX
mov BL,chyba
end;
End;{emulatorxms}

procedure initXMS; {detekuje XMS a najde adresu ovladaci procedury}
var vysledek:byte;
    s,o:word;
{}procedure EmulujTo;
{}Begin
{}getdir(0,xmscesta);
{}if xmscesta[length(xmscesta)]<>'\' then xmscesta:=xmscesta+'\';
{}ovladacXMS:=@EmulatorXMS;
{}End;{emulujto}
Begin
xmsresult:=$C0; {neoficialni kod "XMS nedostupna" (jestli pamet nebude fungovat, tohle tu zustane)}
moznehandle:=0; {pro cislovani docasnych souboru pri pripadne emulaci}
asm
mov AX,$4300
int $2F          {zjisteni, jestli ovladac XMS existuje a funguje}
mov vysledek,AL
end;
if vysledek=$80
  then begin
       asm
       mov AX,$4310
       int $2F           {zjisteni adresy ovladaci procedury}
       mov s,ES
       mov o,BX
       end;
       ovladacXMS:=ptr(s,o);
       if (xmsmaxavail=0)or(xmsmemavail=0) then emulujto {XMS je zaplnena nebo nefunguje}
                                           else xmsresult:=0 {vse OK}
       end
  else emulujto; {ovladac XMS vubec neni zaveden}
End;{initxms}

function AdresaOvladaceXMS:pointer;
Begin
adresaovladacexms:=ovladacxms;
End;{adresaovladacexms}

function XMSmemavail:word; assembler;
Asm
mov AH,8 {kod sluzby}
xor BL,BL {to kvuli vraceni pripadneho chyboveho kodu - jestli vse probehne v poradku, ta nula tu zustane}
call ovladacXMS
mov XMSresult,BL {jestli bylo vse OK, je ted BL=0, jinak v nem je kod chyby}
mov AX,DX {co je v AX, to funkce vrati; ted potrebujeme vratit hodnotu z DX}
End;{xmsmemavail}

function XMSmaxavail:word; assembler;
Asm
mov AH,8
xor BL,BL        {BL:=0}
call ovladacXMS
mov XMSresult,BL
{vracime AX}
End;{XMSmaxavail}

procedure GetXMS(var handle:word; velikost:word);
var novy:uknazaznam;
Begin
asm
mov AH,9
mov DX,velikost
xor BL,BL
call ovladacXMS
les DI,handle
mov ES:[DI],DX    {handle:=DX}
mov xmsresult,BL
end;
if xmsresult=0 then begin {pokud se blok povedlo vytvorit, zapamatujeme si jeho cislo}
                    new(novy);
                    novy^.handlebloku:=handle;
                    novy^.dalsi:=prvniblok;
                    prvniblok:=novy;
                    end;
End;{getxms}

procedure FreeXMS(handle:word);
var p,predchozi:uknazaznam;
Begin
asm
mov AH,$0A
mov DX,handle
xor BL,BL
call ovladacXMS
mov xmsresult,BL
end;
if xmsresult=0 then begin {pokud se ho podarilo smazat, smazeme i odkaz v bezpecnostnim seznamu}
                    p:=prvniblok; predchozi:=nil;
                    while (p<>nil)and(p^.handlebloku<>handle) do begin
                                                                 predchozi:=p;
                                                                 p:=p^.dalsi;
                                                                 end;
                    if p<>nil then begin
                                   if predchozi=nil then prvniblok:=p^.dalsi
                                                    else predchozi^.dalsi:=p^.dalsi;
                                   dispose(p);
                                   end;
                    end;
End;{freexms}

procedure XMSpresun; assembler; {low-level kopirovaci procedura}
Asm
mov AH,$0B
xor BL,BL
lea SI,deskriptor
call ovladacXMS
mov xmsresult,BL
End;{xmspresun}

procedure DoXMS(handle:word; ofset:longint; var odkud; KolikBytu:word);
Begin
if odd(kolikbytu) then inc(kolikbytu); {delka musi byt suda}
with deskriptor do begin
                   velikost:=kolikbytu;
                   handlezdroje:=0; {0 znamena zakladni pamet}
                   ofsetvezdroji:=longint(@odkud); {bezny ukazatel}
                   handlecile:=handle;
                   ofsetvcili:=ofset;
                   end;
xmspresun;
End;{doxms}

procedure ZeXMS(var kam; handle:word; ofset:longint; KolikBytu:word);
Begin
if odd(kolikbytu) then inc(kolikbytu);
with deskriptor do begin
                   velikost:=kolikbytu;
                   handlezdroje:=handle;
                   ofsetvezdroji:=ofset;
                   handlecile:=0;
                   ofsetvcili:=longint(@kam);
                   end;
xmspresun;
End;{zexms}

{$ifdef presuny_mezi_xms}
procedure MeziXMS(CiloveHandle:word; CilovyOfset:longint; ZdrojoveHandle:word; ZdrojovyOfset:longint; KolikBytu:word);
Begin
if odd(kolikbytu) then inc(kolikbytu);
with deskriptor do begin
                   velikost:=kolikbytu;
                   handlezdroje:=zdrojovehandle;
                   ofsetvezdroji:=zdrojovyofset;
                   handlecile:=cilovehandle;
                   ofsetvcili:=cilovyofset;
                   end;
xmspresun;
End;{mezixms}
{$endif}


{----------------------------------------------------------------------------}

procedure xtext.init(soubor,zacatek,konec:string);
var t:text;
    index:word;
    velikost:longint;
    radek:string;
{}procedure OrezKomentare;
{}var p:byte;
{}Begin
{}p:=pos(';;',radek);
{}if p<>0 then radek[0]:=chr(p-1);
{}End;{orezkomentare}
Begin
radky:=nil; handl:=0; pocetradku:=0;
assign(t,soubor);
{vypocet poctu a velikosti:}
reset(t);
if (ioresult<>0) or eof(t) then exit; {konec, pokud soubor neexistuje nebo je prazdny}
velikost:=0;
if zacatek<>'' then repeat {nejdriv se musime prohrabat k uvodnimu radku (Seek v textovych souborech nefunguje)}
                    readln(t,radek);
                    if (ioresult<>0) or eof(t) then begin close(t); exit; end;
                    orezkomentare;
                    until radek=zacatek;
 repeat
 readln(t,radek);
 orezkomentare;
 if (konec<>'')and(radek=konec) then break; {zakoncovaci radek uz ukladat nebudeme}
 if ioresult<>0 then begin close(t); exit; end;
 inc(pocetradku);
 inc(velikost,byte(radek[0])+1);
 until eof(t); {jestli driv prijde zakoncovaci radek, skoncilo se breakem}
{vypocet potrebne pameti:}
if maxavail<pocetradku*longint(sizeof(infooradku)) then exit; {kdyz nestaci zakladni pamet, konec}
velikost:=velikost shr 10+ord(velikost and 1023<>0); {prepocet velikosti na KB, zaokrouhleno nahoru}
if (xmsmaxavail<velikost)or(xmsresult<>0) then exit; {kdyz nestaci rozsirena pamet nebo dojde k chybe, konec}
{alokace:}
getxms(handl,velikost);
if xmsresult<>0 then exit;
getmem(radky,pocetradku*sizeof(infooradku));
{zpatky na zacatek souboru:}
close(t); reset(t); if ioresult<>0 then exit;
{nacteni textu ze souboru:}
if zacatek<>'' then repeat {opet nejdriv najdeme uvodni radek}
                    readln(t,radek);
                    if ioresult<>0 then begin {ted uz se temer urcite zadna chyba neobjevi, ale jistota je jistota}
                                        freexms(handl); if xmsresult=0 then handl:=0;
                                        freemem(radky,pocetradku*sizeof(infooradku)); radky:=nil;
                                        close(t);
                                        exit;
                                        end;
                    orezkomentare;
                    until radek=zacatek;
velikost:=0; {ted bude slouzit jako pocitadlo ofsetu}
for index:=1 to pocetradku do
 begin
 readln(t,radek);
 if ioresult<>0 then begin {stejna kontrola jako pred chvili}
                     freexms(handl); if xmsresult=0 then handl:=0;
                     freemem(radky,pocetradku*sizeof(infooradku)); radky:=nil;
                     close(t);
                     exit;
                     end;
 orezkomentare;
 with radky^[index] do begin {ulozeni informaci o radku}
                       ofset:=velikost;
                       delka:=byte(radek[0])+1; {delka v B vcetne nulteho znaku}
                       end;
 doxms(handl,velikost,radek[0],byte(radek[0])+1); {ulozeni radku do pameti}
 inc(velikost,byte(radek[0])+1); {posun na misto, kam budeme vkladat dalsi radek}
 end;
close(t); if ioresult<>0 then {uz je mi to jedno};
End;{xtext.init}

function xtext.dej(CisloRadku:word):string;
var radek,r2:string;
Begin
if (cisloradku>pocetradku)or(radky^[cisloradku].delka=0)
  then radek:=''
  else with radky^[cisloradku] do zexms(radek[0],handl,ofset,delka);
dej:=radek;
End;{xtext.dej}

procedure xtext.zrus;
Begin
if radky<>nil then begin
                   freemem(radky,pocetradku*sizeof(infooradku));
                   freexms(handl);
                   radky:=nil; pocetradku:=0; handl:=0;
                   end;
End;{xtext.zrus}


{----------------------------------------------------------------------------}

function xsprite.init(var Soubor:file):boolean;
label 0,1,2,3,4; {Nejvyhodnejsi zpusob osetrovani chyb, jaky jsem dokazal vymyslet, muhehe :-).
                  Cislo navesti odpovida poctu veci, ktere je potreba dealokovat.}
type sprajt = record {pomocna sablona pro pristup k datum pod ukazatelem}
              velikost:word;
              data:array[0..0] of byte;
              end;
     UkNaSprajt = ^sprajt;
var w,velikost,CelkovaVelikost:word;
    adresa:longint;
Begin
blockread(soubor,pocet,2);
blockread(soubor,celkovavelikost,2);
blockread(soubor,velikostmezipameti,2);
{alokace pole velikosti:}
if (ioresult=0)and(pocet shl 1<maxavail) then getmem(velikosti,pocet shl 1)
                                         else goto 0; {vynulovani poctu a konec}
{alokace pole adres:}
if pocet shl 2<maxavail then getmem(adresy,pocet shl 2)
                        else goto 1; {zruseni pole velikosti, vynulovani poctu a konec}
{alokace mezipameti:}
if velikostmezipameti<=maxavail then getmem(mezipamet,velikostmezipameti)
                                else goto 2; {zruseni adres, velikosti, pocet:=0 a konec}
{alokace bloku XMS:}
getxms(handl,celkovavelikost);
if xmsresult<>0 then goto 3; {zruseni mezipameti, adres a velikosti, vynulovani poctu a konec}
{nacteni obrazku do XMS a spocitani adres a velikosti:}
adresa:=0;
for w:=1 to pocet do begin
                     {velikost spritu:}
                     blockread(soubor,velikost,2);
                     if ioresult<>0 then goto 4; {chyba v souboru => vsechno zrusit a konec}
                     uknasprajt(mezipamet)^.velikost:=velikost;
                     {zbytek spritu:}
                     blockread(soubor,uknasprajt(mezipamet)^.data,velikost-2); {docteme zbytek spritu}
                     if ioresult<>0 then goto 4;
                     doxms(handl,adresa,mezipamet^,velikost);
                     {ulozeni velikosti a ofsetu do prislusnych poli:}
                     velikosti^[w]:=velikost;
                     adresy^[w]:=adresa;
                     inc(adresa,velikost); {dalsi bude zacinat hned za timhle}
                     end;
init:=true; {jestli jsme jeste tady, operace se zdarila}
exit;
{sem uz se dostaneme jenom v pripade chyby:}
4: freexms(handl);
3: freemem(mezipamet,velikostmezipameti);
2: freemem(adresy,pocet shl 2);
1: freemem(velikosti,pocet shl 1);
0: pocet:=0;
   init:=false;
End;{xsprite.init}

function xsprite.init2(jmenosouboru:string):boolean;
var f:file;
Begin
assign(f,jmenosouboru);
reset(f,1);
init2:=(ioresult=0) and init(f);
close(f);
if ioresult=0 then ;
End;{xsprite.init2}

procedure xsprite.priprav(CisloObrazku:word);
Begin
zexms(mezipamet^,handl,adresy^[cisloobrazku],velikosti^[cisloobrazku]);
End;{xsprite.priprav}

function xsprite.dej(CisloObrazku:word):pointer;
Begin
priprav(cisloobrazku);
dej:=mezipamet;
End;{xsprite.priprav}

procedure xsprite.Zrus;
Begin
if pocet=0 then exit; {pojistka pro pripad, ze uz by bylo jednou zruseno}
freexms(handl);
freemem(mezipamet,velikostmezipameti);
freemem(adresy,pocet shl 2);
freemem(velikosti,pocet shl 1);
pocet:=0;
End;{xsprite.zrus}

{----------------------------------------------------------------------------}

procedure NovyExitproc; far;
{procedura, ktera pri ukonceni programu automaticky uvolni vsechny alokovane
bloxy pameti XMS (jinak by, narozdil od zakladni pameti, zustaly obsazene
az do vypnuti pocitace)}
Begin
exitproc:=puvodniexitproc;
xmsresult:=0;
while (prvniblok<>nil)and(xmsresult=0) do freexms(prvniblok^.handlebloku);
End;{novyexitproc}

BEGIN
{$ifdef debug}writeln('Jednotka XMS startuje...');{$endif}
prvniblok:=nil;
puvodniexitproc:=exitproc;
exitproc:=@novyexitproc;
initXMS;
{$ifdef debug}
if xmsresult=0 then writeln('Rozsirena pamet funguje - OK.')
               else writeln('Rozsirena pamet nefunguje, takze bude emulovana na disku.');
{$endif}
END.


{Priklad textoveho souboru, ze ktereho nacitame do objektu xtext:

bla bla...
<texty>;;komentar, ktery se ignoruje
prvni radek (*)
druhy radek (*)
treti radek (*);;komentar, ktery se taky ignoruje
</texty>
bla...

Pri zavolani init('texty.txt','<texty>','</texty>') se nactou tri radky
oznacene (*). 'prvni radek' metoda Dej vrati pod indexem 1 a tak dale. Neni
samozrejme nutne, aby uvodni a zakoncovaci radek vypadaly zrovna takhle; muze
to byt jakykoli text, hlavne aby se pak v souboru nevyskytl i jinde.

Pri zavolani init('texty.txt','','') se nacte uplne vsechno a pod indexem 1
najdeme radek 'bla bla...'.

Pri init('texty.txt','<texty>','') se zacne nacitat na radku 'prvni radek (*)'
a skonci se na konci souboru. Jednicka bude 'prvni radek (*)'.

Init('texty.txt','','</texty>') nacita od zacatku souboru (jednicka bude
'bla bla...') a skonci na radku 'treti radek (*)'.}



{Struktura souboru, ze ktereho nacita xSprite:

 pocet spritu v souboru, minimalne 1 (word)
 soucet velikosti vsech spritu [KB], zaokrouhleno nahoru na cele KB (word)
 velikost nejvetsiho spritu [B], zaokrouhleno nahoru na sude cislo (word)
 sprity, naskladane jeden za druhym

Tyto soubory se tvori jednotkou GenXspr.
Format spritu je popsan v jednotkach VESA a Images.}