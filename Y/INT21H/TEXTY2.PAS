(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: TEXTY2.PAS                                                     *)
(*  Obsah: procedury pro textovy vystup primym zapisem do videopameti      *)
(*         a par procedur a funkci nahrazujicich funkce jednotky CRT       *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*         Laaca (http://laaca.borec.cz) - prace se znakovou sadou         *)
(*  Posledni uprava: 24.5.2014                                             *)
(*  Pro kompilaci: nic                                                     *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit Texty2;
interface

{--------------------------- uvodni definice: -------------------------------}
{(pro zacatek je muzete preskocit, vyuziji se az k pokrocilejsim figlum)}

{reprezentace textove obrazovky v pameti:}
type TextovaObrazovka = array[1..25,1..80] of record {prvni index je radek, druhy sloupec}
                                              znak:char;
                                              atribut:byte;
                                              end;
{polozka Atribut urcuje barvu znaku. Dolni 4 bity (atribut and 15) davaji
barvu znaku, horni 4 bity (atribut shr 4) barvu pozadi. Nejvyssi bit barvy
pozadi (atribut shr 7) urcuje, jestli ma pismo blikat (1) nebo ne (0), takze
na skutecnou barvu pozadi zbyvaji jen 3 bity ((atribut shr 4) and 7). To je
duvod, proc muze mit pozadi barvy obvykle jen 0..7 (pres sluzby nejakeho
preruseni se da nastavit, ze se zbavime moznosti blikani a vyuzijeme pro
pozadi vsech 16 barev, ale to uz je jina kapitola).}

var SkutecnaTxtObr:textovaobrazovka absolute $B800:0; {fyzicka obrazovka (VRAM)}
    CilovaTxtObr:^textovaobrazovka; {Pres tenhle ukazatel jednotka pristupuje
        k obrazovce, po startu programu miri na promennou Skutecnatxtobr.
        Muzete si ho presmerovat i jinam a ziskat tak virtualni obrazovku.
        Kopirovani na skutecny monitor je trivialni:
        Skutecnatxtobr:=MojeVirtualniObrazovka}


{--------------------- zakladni procedury a funkce: -------------------------}
{Vsechny parametry x a y maji vyznam souradnic, x je od 1 do 80, y od 1 do 25.
Vsechny parametry Barva maji vyznam kompletniho atributu (viz definici vyse).}

procedure NastavTextak80x25;
{Prepne obrazovku do 16barevneho textoveho rezimu s rozlisenim 80x25 znaku,
na ktery je tato jednotka stavena. Navic obrazovku vymaze a presune kurzor
do leveho horniho rohu.}
procedure TKurzorVyp;
{vypne kurzor}
procedure TKurzorZap;
{zapne kurzor}
procedure GoToXY(x,y:byte);
{Presune kurzor na dane souradnice. Mimo obrazovku se nedostanete, kurzor se
zarazi o okraj.}
function WhereX:byte;
function WhereY:byte;
{vraceji souradnice kurzoru}
(*procedure SetTextAttr(barva:byte);
{znaku na pozici kurzoru nastavi dany atribut}*)
procedure Cls(barva:byte);
{Vyplni obrazovku mezerami s atributem Barva (doporucuji hodnotu 7),
s kurzorem nehybe.}
procedure ObarviRadek(y:integer; barva:byte);
{Vsem znakum na ytem radku nastavi dany atribut.}
procedure WriteZnak(x,y:integer; barva:byte; co:char);
{Zobrazi znak Co v barve Barva na pozici x,y. Pokud souradnice vychazeji mimo
obrazovku, nekresli se nic.}
procedure WriteXY(x,y:integer; barva:byte; co:string);
{napise retezec Co barvou Barva na pozici x,y. Vykresli se jenom ta cast,
ktera nezasahuje mimo obrazovku}
procedure VymazRadek(y:integer; barva:byte);
{radek na dane y-ove souradnici naplni mezerami s danym atributem}
procedure VymazOblast(ody,doy:integer; barva:byte);
{vymaze radky v danem rozmezi yovych souradnic}
procedure VymazSloupec(x:integer; barva:byte);
{totez pro sloupec}

{------------------------ prace se znakovou sadou: --------------------------}

type charset=array[0..255,0..15] of byte;

procedure LoadCharsetFromDisk(var c:charset; JmenoSouboru:string);
{Nacte znakovou sadu z daneho souboru do promenne c. Soubor si otevre, precte
a nakonec zase zavre. Uspesnost testujte Ioresultem.}
procedure SaveCharsetToDisk(c:charset; JmenoSouboru:string);
{Ulozi znakovou sadu z promenne c do souboru. Vysledek opet kontrolujte
Ioresultem.}
procedure LoadCharsetFromVGA(var c:charset);
{Nacte znakovou sadu z obrazovky a ulozi do promenne c.}
procedure ApplyCharset(c:charset);
{Znakovou sadu z promenne c posle na obrazovku.}

implementation

procedure NastavTextak80x25; assembler;
Asm
mov AX,3 {AH=0 je kod sluzby "nastav rezim podle AL", 3 je nas pozadovany textak}
int $10
End;{nastavtextak80x25}

procedure cls(barva:byte); assembler;
Asm
mov AL,32           {mezera}
les DI,cilovatxtobr {cilova adresa}
mov AH,barva        {zadany atribut}
mov CX,80*25        {pocet znaku na obrazovce}
rep stosw  {soupni to tam (vyplnujeme to po wordech - znak i s atributem)}
End;{cls}

procedure ObarviRadek(y:integer; barva:byte);
var x:byte;
Begin
if (y>=1)and(y<=25) then for x:=1 to 80 do cilovatxtobr^[y,x].atribut:=barva;
End;{obarviradek}

procedure writeznak(x,y:integer; barva:byte; co:char);
Begin
if (y>=1)and(y<=25)and(x>=1)and(x<=80)
  then with cilovatxtobr^[y,x] do begin
                                  znak:=co;
                                  atribut:=barva;
                                  end;
End;{writeznak}

procedure writexy(x,y:integer; barva:byte; co:string);
var pozice:byte;
Begin
if (y>=1)and(y<=25)and(x<=80)and(x+length(co)>1) {jestli neni mimo obrazovku}
  then begin
       if x<1 then begin {oriznuti zleva}
                   pozice:=2-x;
                   x:=1;
                   end
              else pozice:=1;
       while (x<=80)and(pozice<=length(co)) {do konce retezce nebo obrazovky}
         do begin
            with cilovatxtobr^[y,x] do begin
                                       znak:=co[pozice];
                                       atribut:=barva;
                                       end;
            inc(x); inc(pozice);
            end;
       end;
End;{writexy}

procedure vymazradek(y:integer; barva:byte); assembler;
Asm
mov BX,y
dec BX     {ted potrebujeme pocitat od nuly}
cmp BX,0   {nad obrazovkou?}
jl @konec  {jo}
cmp BX,24  {pod obrazovkou?}
jg @konec  {jo}
 les DI,cilovatxtobr
 mov AX,160 {sirka radku v bytech...}
 mov CX,80   {totez ve wordech}
 mul BX     {...*y=pozice zacatku radku od zacatku obrazovky}
 add DI,AX  {kompletni adresa zacatku radku}
 mov AH,barva {atribut jde do vyssiho bytu, cili na druhou pozici (little endian)}
 mov AL,32    {na prvni pozici jde znak (mezera)}
 rep stosw
@konec:
End;{vymazradek}

procedure VymazOblast(ody,doy:integer; barva:byte);
var y:byte;
Begin
if (ody>25)or(doy<1) then exit;
if ody<1 then ody:=1;
if doy>25 then doy:=25;
for y:=ody to doy do vymazradek(y,barva);
End;{vymazoblast}

procedure vymazsloupec(x:integer; barva:byte);
var i:byte;
Begin
if(x>=1)and(x<=80)
  then for i:=1 to 25 do with cilovatxtobr^[i,x] do begin
                                                    znak:=' ';
                                                    atribut:=barva;
                                                    end;
End;{vymazsloupec}

procedure tkurzorzap; assembler;
Asm
mov AH,1      {sluzba "nastav velikost kurzoru"}
mov CX,$0607  {klasicke podtrzitko}
int $10
End;{tkurzorzap}

procedure tkurzorvyp; assembler;
Asm
mov AH,1
mov CX,$2000  {s touhle hodnotou se kurzor nevykresluje}
int $10
End;{tkurzorvyp}

procedure gotoxy(x,y:byte); assembler;
Asm
mov DH,y
dec DH  {my pocitame od 1, system od 0}
cmp DH,24
jle @yOK
 mov DH,24
@yOK:
mov DL,x
dec DL
cmp DL,79
jle @xOK
 mov DL,79
@xOK:
mov AH,2
mov BH,0
int $10
End;{gotoxy}

function wherex:byte; assembler;
Asm
mov AH,3
xor BH,BH  {cislo stranky, v nasem pripade 0}
int $10    {mimochodem: v CX jsme dostali velikost kurzoru, ale ta nas nezajima}
xor AH,AH
mov AL,DL
inc AL
End;{wherex}

function wherey:byte; assembler;
Asm
mov AH,3
xor BH,BH
int $10
xor AH,AH
mov AL,DH
inc AL
End;{wherey}

(*procedure SetTextAttr(barva:byte);
Uz ani nevim, k cemu tohle melo byt. V pripade potreby si to odkomentujte.
Begin
cilovatxtobr^[wherey-1,wherex-1].atribut:=barva;
End;{settextattr}*)

{----------------------------------------------------------------------------}

procedure LoadCharsetFromDisk(var c:charset; JmenoSouboru:string);
var f:file;
Begin
assign(f,jmenosouboru);
reset(f,1);
blockread(f,c,sizeof(charset));
close(f);
End;{loadcharsetfromdisk}

procedure SaveCharsetToDisk(c:charset; JmenoSouboru:string);
var f:file;
Begin
assign(f,jmenosouboru);
rewrite(f,1);
blockwrite(f,c,sizeof(charset));
close(f);
End;{savecharsettodisk}

procedure LoadCharsetFromVGA(var c:charset);
var b,w:word;
Begin
for b:=0 to 255 do begin
                   w:=b shl 5;
                   inline($FA);
                   portw[$3C4]:=$0402;
                   portw[$3C4]:=$0704;
                   portw[$3CE]:=$0204;
                   portw[$3CE]:=$0005;
                   portw[$3CE]:=$0006;
                   move(ptr($A000,w)^,c[b,0],16);
                   portw[$3C4]:=$0302;
                   portw[$3C4]:=$0304;
                   portw[$3CE]:=$0004;
                   portw[$3CE]:=$1005;
                   portw[$3CE]:=$0E06;
                   inline($FB);
                   end;
End;{loadcharsetfromvga}

procedure ApplyCharset(c:charset);
var b,w:word;
Begin
for b:=0 to 255 do begin
                   w:=b shl 5;
                   inline($FA);
                   portw[$3C4]:=$0402;
                   portw[$3C4]:=$0704;
                   portw[$3CE]:=$0204;
                   portw[$3CE]:=$0005;
                   portw[$3CE]:=$0006;
                   move(c[b,0],ptr($A000,w)^,16);
                   portw[$3C4]:=$0302;
                   portw[$3C4]:=$0304;
                   portw[$3CE]:=$0004;
                   portw[$3CE]:=$1005;
                   portw[$3CE]:=$0E06;
                   inline($FB);
                   end;
End;{applycharset}

BEGIN
CilovaTxtObr:=@skutecnatxtobr; {vychozi situace: pracujeme s fyzickou obrazovkou}
END.