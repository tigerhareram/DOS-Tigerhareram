(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: VGAMYS.PAS                                                     *)
(*  Obsah: procedury a funkce pro ovladani mysi ve VGA grafice             *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*  Posledni uprava: 2.6.2011                                              *)
(*  Pro kompilaci: VGA, ERRMSG, DOS, CFG, RETEZCE, KLAVESY2                *)
(*  Pro spusteni: nejaky soubor s kurzorem (obvykle *.KUR)                 *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit VGAMys;
{$I-,B-,G+} {nutne}
{$X-,R-,S-,F-,Q-} {jen prkotiny pro drobne urychleni}
interface

{struktura pro ukladani kurzoru:}
type tKurzor = record
               sk,vk:byte;{sirka a vyska kurzoru (v pixelech)}
               hsx,hsy:shortint;{souradnice aktivniho bodu kurzoru od leveho horniho rohu bitmapy
                                 (pocitano od nuly, obrazek kurzoru se kresli na [xmys-hsx,ymys-hsy])}
               kData:pointer;{ukazatel na bitmapu (obycejny obrazek pro vgaputtimage)}
               end;


(************************** verejne promenne: *******************************)

var Xmys,Ymys:integer;
    PocetTlacitek,
    StavTlacitek:word;
    Lmys,Pmys,Smys:boolean;
    kurzorB:boolean;
    korekceB:boolean;
    ObracenaTlacitka:boolean;

(*********************** verejne procedury a funkce: ************************)

{********************** inicializace, zruseni apod.: ************************}

procedure InitMys;
{Tuhle proceduru urcite zavolejte pote, co spustite graficky rezim.
Inicializuje mys (pripadne zjisti, ze nefunguje), zjisti pocet tlacitek,
nastavi rozsah pohybu mysi na celou obrazovku, umisti kurzor do stredu
obrazovky, nastavi citlivost mysi na primerene vychozi a zjisti aktualni stav
tlacitek. Nezapina kurzor - nejdriv je potreba pouzit proceduru NastavKurzor
(viz dale). Take rusi jakoukoli pripadnou automatickou obsluhu mysi.}
procedure ZrusMys;
{Vypne automatickou obsluhu mysi (pokud je zapnuta), vypne kurzor a uvolni
pamet, do ktere se uklada jeho pozadi. Pro opetovne rozchozeni mysi staci
pouzit Nastavkurzor a pripadne Zapniobsluhumysi.}

procedure KorekceMysi(JoNeboNe:boolean);
{Bezpecne zapne nebo vypne korekci pohybu kurzoru (vysvetlivky - viz vyse),
rozsah pohybu mysi nastavi na celou obrazovku a presune kurzor doprostred.}
function UlozNastaveniMysi:boolean;
{Ulozi nastavene parametry mysi (citlivost, korekci a prohozeni tlacitek) do
hlavniho konfiguracniho souboru (Cfgsoubor z jednotky Cfg). Vraci true, pokud
se to povede.}
procedure NactiNastaveniMysi;
{Z Cfgsouboru nacte parametry ulozene predchozi funkci. Pokud se to povede,
aplikuje je. Pokud ne, nic nemeni.}

{************************** manipulace s kurzory: ***************************}

procedure NactiKurzor(var kam:tkurzor; var f:file);
{Nacte kurzor ze souboru do promenne.
 kam - cilova promenna. Potrebna pamet je procedurou alokovana (ale jestli tam
       uz nejaky kurzor nacten byl, nebude dealokovan, takze nacitejte pouze
       do prazdnych promennych!).
       Kdyz je po skonceni procedury kam.kdata=nil, znamena to, ze nastala I/O
       chyba pri otvirani souboru (obvykle to znamena, ze soubor neexistuje).
 f - beztypovy soubor, ktery musi byt otevren pro cteni s velikosti bloku 1 B
     (reset(f,1);) a kurzor v nem musi byt prave na zacatku dat kurzoru.
Urceno pro nacitani z vetsich souboru, ve kterych neni jen jeden kurzor.
Popis formatu souboru s kurzorem je na konci teto jednotky.}
procedure NactiKurzor2(var kam:tkurzor; soubor:string);
{To same, ale zada se jenom jmeno souboru (obvykle s koncovkou KUR), procedura
si ho otevre, nacte kurzor a zase ho zavre. Pro nacitani ze samostatnych
souboru, ktere obsahuji jen ten jeden kurzor.}
procedure ZrusKurzor(var Ktery:tkurzor);
{uvolni pamet, kterou ma pro sebe alokovanou kurzor Ktery. Po skonceni
procedury je ktery.kData=nil}
procedure NastavKurzor(var Jaky:tkurzor);
{Prepne na dany kurzor. Je potreba to provest pred prvnim zapnutim kurzoru.
Pamet pro obrazek kurzoru se nealokuje, jen se nasmeruje prislusny interni
ukazatel na obrazek v promenne Jaky; tuto promennou proto nemazte, dokud
kurzor pouzivate.}

{************ univerzalni procedury a funkce pouzitelne kdykoli *************}

procedure StavMysi;
{Precte stav mysi a aktualizuje promenne xmys, ymys, stavtlacitek, lmys, pmys
a smys; o zobrazovani kurzoru se vubec nestara.}
procedure kZap;
{Zapne kurzor. Je treba, aby byl nejaky kurzor nastaven (viz Nastavkurzor).
Pokud nebude, nezapne se.}
procedure kVyp;
{Vypne kurzor.}
function Kliknuto:boolean;
{zkraceny zapis stavtlacitek<>0 (netestuje mys)}
procedure PresunMys(noveX,noveY:word);
{Presune mys na dane souradnice. Pokud je kurzor zapnuty, postara se o nej.}
procedure MezeMysi(x1,y1,x2,y2:word);
{Vymezi obdelnikovy prostor, mimo ktery mys nemuze. Pokud se kurzor nachazel
mimo tu oblast, presune ho dovnitr na nejblizsi hranici. O spravne zobrazeni
kurzoru se postara.}
function MysVPoli(x1,y1,x2,y2:integer):boolean;
{Zjisti,jestli je mys v danem obdelnikovem poli na obrazovce. [x1,x2] je levy
horni roh pole, [x2,y2] pravy dolni (bez kontroly => neprohodit!).
Netestuje mys, jen porovna hodnoty xmys a ymys se zadanymi souradnicemi.}
procedure CitlivostMysi(vodorovne,svisle:word);
{Cim vetsi cisla, tim mensi citlivost. Nejvetsi je pri 1, optimum je cca 9
pro oba smery.  Pro techniky: cisla rikaji, o kolik dvousetin palce se musi
pohnout mysi, aby se kurzor pohnul o 8 pixelu.}
procedure ZjistiCitlivostMysi(var vodorovna,svisla:word);
{Vrati aktualni hodnoty citlivosti.}

{****************** procedury pro rucni obsluhu kurzoru: ********************}

{Tyto procedury jsou univerzalni, funguji i pri automaticke obsluze mysi.}
procedure Kurzor;
{Vlastni obsluha kurzoru. Precte stav mysi a pokud se kurzor od minuleho
volani teto procedury pohnul a je zapnuty, presune ho do nove polohy.}
procedure Cekej;
{Ceka na stisk libovolneho tlacitka nebo klavesy a mezitim se stara
o zobrazovani pohybu kurzoru.}
procedure CekejNaCokoli;
{Ceka na stisk libovolneho tlacitka nebo klavesy nebo na pohnuti mysi a
mezitim se stara o kurzor.}
procedure Resetuj;
{Pocka na uvolneni vsech cudliku na klavesnici i na mysi a stara se o kurzor.}

{*************** procedury pro automatickou obsluhu kurzoru: ****************}

procedure ZapniObsluhuMysi;
{Nastavi proceduru pro automatickou obsluhu zobrazovani kurzoru a cteni stavu
tlacitek, takze to vsechno pobezi na pozadi a nemusite se o to starat.}
procedure ZrusObsluhuMysi;
{Zrusi automatickou obsluhu mysi. Pred koncem programu je nutne tuto proceduru
(nebo ZrusMys, ve ktere je zabudovana) pouzit!!!}
procedure Cekej2;
procedure CekejNaCokoli2;
procedure Resetuj2;
{Funguji stejne jako ty pro rucni obsluhu, ale JEN pri automaticke obsluze.
Pokud je zkusite zavolat bez automaticke obsluhy, program se s nejvetsi
pravdepodobnosti zasekne v nekonecne smycce.}

(****************************************************************************)

implementation
uses errmsg,vga,dos,cfg,retezce,klavesy2;

var _pk:pointer;{ukazatel na pozadi kurzoru}
    _kx,_ky:integer;{souradnice kurzoru}
    _sk,_vk:word;{sirka a vyska kurzoru}
    _hsx,_hsy:integer;{souradnice aktivniho bodu}
    _lhx,_lhy:integer;{pomocne souradnice leveho horniho rohu pozadi kurzoru}
    _kurP:pointer;{ukazatel na obrazek kurzoru}
    _PreruseniNastaveno:boolean;{jestli je aktivovana automaticka obsluha}
    vcitlivost,scitlivost:word;{hodnoty citlivosti mysi [1/200 palce na 8 pixelu]}

{procedura, ktera bude automaticky volana pri kazdem pohnuti mysi
nebo pohybu nektereho tlacitka:}
procedure _ObsluhaMysi; far;
var PuvodniCil:pointer;
Begin
asm
push DS
push seg @data
pop DS
mov DI,AX
mov AL,korekceB
or AL,AL
jz @BezKorekce
 shr CX,3
 shr DX,3
@BezKorekce:
mov AX,DI
mov xmys,CX
mov ymys,DX
test AX,$7E
jz @TlacitkaSeNezmenila
 mov AL,obracenatlacitka
 or AL,AL
 jz @normalni
  mov AX,BX
  or AH,AL
  and BX,4
  and AX,$0201
  shl AL,1
  shr AH,1
  or BL,AL
  or BL,AH
 @normalni:
 mov stavtlacitek,BX
 mov AX,BX
 or AH,AL
 and BL,1
 mov lmys,BL
 shr AX,1
 and AL,1
 mov pmys,AL
 shr AH,1
 mov smys,AH
@TlacitkaSeNezmenila:
end;
if kurzorb and ((xmys<>_kx)or(ymys<>_ky)) then
 begin
 puvodnicil:=vgacilovaoblast;
 vgasetnormaloutput;
 vgaputimage(_lhx,_lhy,_sk,_vk,_pk);
 _kx:=xmys; _ky:=ymys;
 _lhx:=_kx-_hsx; _lhy:=_ky-_hsy;
 if _lhx<0 then _lhx:=0;
 if _lhy<0 then _lhy:=0;
 if _lhx+_sk>320 then _lhx:=320-_sk;
 if _lhy+_vk>200 then _lhy:=200-_vk;
 vgagetimage(_lhx,_lhy,_lhx+_sk-1,_lhy+_vk-1,_pk);
 vgaputtimage(_kx-_hsx,_ky-_hsy,_sk,_vk,_kurp);
 vgasetvirtualoutput(puvodnicil);
 end;
asm pop DS end;
End;{_obsluhamysi}

procedure ZapniObsluhuMysi;
var AdresaObsluhy:pointer;
Begin
if not _preruseninastaveno then
 begin
 adresaobsluhy:=@_obsluhamysi;
 asm
 mov AX,12
 mov CX,$007F
 les DX,adresaobsluhy
 mov BX,DX
 int $33
 end;
 _preruseninastaveno:=true;
 end;
End;{zapniobsluhumysi}

procedure ZrusObsluhuMysi;
var AdresaObsluhy:pointer;
Begin
if _preruseninastaveno then
 begin
 adresaobsluhy:=@_obsluhamysi;
 asm
 mov AX,12
 xor CX,CX
 les DX,adresaobsluhy
 mov BX,DX
 int $33
 end;
 _preruseninastaveno:=false;
 end;
End;{zrusobsluhumysi}

procedure InitMys;
var ukazatel:pointer;
{}function init:word; assembler;
{}Asm
{}xor AX,AX
{}int $33
{}mov pocettlacitek,BX
{}End;
Begin
getintvec($33,ukazatel);
if (ukazatel=nil)
  or (byte(ukazatel^)=$CF)
  or (init<>$FFFF)
 then chyba('Vase mys bud nefunguje, neexistuje nebo k ni nemate ovladac.',2)
 else begin
      if (pocettlacitek<>0)and(pocettlacitek<>3) then pocettlacitek:=2;
      if korekceb then citlivostmysi(2,2)
                  else citlivostmysi(9,9);
      mezemysi(0,0,319,199);
      presunmys(160,100);
      StavMysi;
      end;
End;{initmys}

procedure ZjistiCitlivostMysi(var vodorovna,svisla:word);
Begin
vodorovna:=vcitlivost;
svisla:=scitlivost;
End;{zjisticitlivostmysi}

procedure NactiKurzor(var kam:tkurzor; var f:file);
Begin
with kam do
  begin
  blockread(f,sk,1);
  blockread(f,vk,1);
  blockread(f,hsx,1);
  blockread(f,hsy,1);
  if (ioresult=0)and(sk*vk<=maxavail) then begin
                                           getmem(kdata,sk*vk);
                                           blockread(f,kdata^,sk*vk);
                                           if ioresult<>0 then begin
                                                               freemem(kdata,sk*vk);
                                                               kdata:=nil;
                                                               end;
                                           end
                                      else kdata:=nil;
  end;
End;{nactikurzor}

procedure NactiKurzor2(var kam:tkurzor; soubor:string);
var f:file;
Begin
assign(f,soubor);
reset(f,1);
if ioresult=0 then begin
                   nactikurzor(kam,f);
                   close(f);
                   if ioresult=0 then ;
                   end
              else kam.kdata:=nil;
End;{nactikurzor2}

procedure ZrusKurzor(var ktery:tkurzor);
Begin
with ktery do begin
              freemem(kdata,sk*vk);
              kdata:=nil;
              end;
End;{zruskurzor}

procedure NastavKurzor(var jaky:tkurzor);
var bylkurzor:boolean;
Begin
if jaky.kdata=nil then exit;
bylkurzor:=kurzorb; kvyp;
if _pk<>nil then begin
                 freemem(_pk,_sk*_vk);
                 _pk:=nil;
                 end;
with jaky do
  begin
  _sk:=sk; _vk:=vk;
  _hsx:=hsx; _hsy:=hsy;
  if maxavail<((_sk*_vk)or 15) then bylkurzor:=false
                               else begin
                                    getmem(_pk,_sk*_vk);
                                    _kurp:=kdata;
                                    end;
  end;
if bylkurzor then kzap;
End;{nastavkurzor}

procedure ZrusMys;
Begin
if _preruseninastaveno then zrusobsluhumysi;
kvyp;
if _pk<>nil then begin
                 freemem(_pk,_sk*_vk);
                 _pk:=nil;
                 end;
_kurp:=nil;
End;{zrusmys}

procedure KorekceMysi(JoNeboNe:boolean);
Begin
if korekceb<>jonebone then begin
                           korekceb:=jonebone;
                           mezemysi(0,0,319,199);
                           presunmys(160,100);
                           end;
End;{korekcemysi}

procedure StavMysi; assembler;
Asm
mov AX,3
int 33h
mov AL,korekceB
or AL,AL
jz @BezKorekce
 shr CX,3
 shr DX,3
@BezKorekce:
mov xmys,CX
mov ymys,DX
 mov AL,obracenatlacitka
 or AL,AL
 jz @normalni
  mov AX,BX
  or AH,AL
  and BX,4
  and AX,$0201
  shl AL,1
  shr AH,1
  or BL,AL
  or BL,AH
 @normalni:
mov stavtlacitek,BX
mov AX,BX
or AH,AL
and BL,1
mov lmys,BL
shr AX,1
and AL,1
mov pmys,AL
shr AH,1
mov smys,AH
End;{stavmysi}

procedure kurzor;
var puvodnicil:pointer;
Begin
if not _preruseninastaveno then
 begin
 stavmysi;
 if kurzorb and ((xmys<>_kx)or(ymys<>_ky)) then
  begin
  puvodnicil:=vgacilovaoblast;
  vgasetnormaloutput;
  vgaputimage(_lhx,_lhy,_sk,_vk,_pk);
  _kx:=xmys; _ky:=ymys;
  _lhx:=_kx-_hsx; _lhy:=_ky-_hsy;
  if _lhx<0 then _lhx:=0;
  if _lhy<0 then _lhy:=0;
  if _lhx+_sk>320 then _lhx:=320-_sk;
  if _lhy+_vk>200 then _lhy:=200-_vk;
  vgagetimage(_lhx,_lhy,_lhx+_sk-1,_lhy+_vk-1,_pk);
  vgaputtimage(_kx-_hsx,_ky-_hsy,_sk,_vk,_kurp);
  vgasetvirtualoutput(puvodnicil);
  end;
 end;
End;{kurzor}

procedure kZap;
var puvodnicil:pointer;
Begin
if (_kurp<>nil) and not kurzorb then
 begin
 if not _preruseninastaveno then stavmysi;
 _kx:=xmys; _ky:=ymys;
 _lhx:=_kx-_hsx; _lhy:=_ky-_hsy;
 if _lhx<0 then _lhx:=0;
 if _lhy<0 then _lhy:=0;
 if _lhx+_sk>320 then _lhx:=320-_sk;
 if _lhy+_vk>200 then _lhy:=200-_vk;
 puvodnicil:=vgacilovaoblast;
 vgasetnormaloutput;
 vgagetimage(_lhx,_lhy,_lhx+_sk-1,_lhy+_vk-1,_pk);
 vgaputtimage(_kx-_hsx,_ky-_hsy,_sk,_vk,_kurp);
 vgasetvirtualoutput(puvodnicil);
 kurzorb:=true;
 end;
End;{kzap}

procedure kVyp;
var puvodnicil:pointer;
Begin
if kurzorb then
 begin
 kurzorb:=false;
 puvodnicil:=vgacilovaoblast;
 vgasetnormaloutput;
 vgaputimage(_lhx,_lhy,_sk,_vk,_pk);
 vgasetvirtualoutput(puvodnicil);
 end;
End;{kvyp}

function kliknuto:boolean; assembler;
Asm
mov AX,stavtlacitek
End;{kliknuto}

procedure Mezemysi(x1,y1,x2,y2:word); assembler;
Asm
mov AL,kurzorb
push AX
or AL,AL
jz @JdemeNaTo
 call kvyp
@JdemeNaTo:
mov CX,x1
mov DX,x2
mov AL,korekceB
or AL,AL
jz @BezKorekce1
 shl CX,3
 shl DX,3
@BezKorekce1:
mov AX,7
int $33
mov CX,y2
mov DX,y1
mov AL,korekceB
or AL,AL
jz @BezKorekce2
 shl CX,3
 shl DX,3
@BezKorekce2:
mov AX,8
int $33
pop AX
or AL,AL
jz @konec
 call kzap
@konec:
End;{mezemysi}

procedure presunmys(novex,novey:word); assembler;
Asm
mov AL,kurzorb
push AX
or AL,AL
jz @jdemenato
 call kvyp
@jdemenato:
mov CX,novex
mov DX,novey
mov xmys,CX
mov ymys,DX
mov AL,korekceB
or AL,AL
jz @BezKorekce1
 shl CX,3
 shl DX,3
@BezKorekce1:
mov AX,4
int $33
pop AX
or AL,AL
jz @konec
 call kzap
@konec:
End;{presunmys}

procedure cekejnacokoli; assembler;
var mnlx,mnly:word;
Asm
call kurzor
mov AX,xmys
mov mnlx,AX
mov AX,ymys
mov mnly,AX
 @cekani:
 call kurzor
 mov AX,xmys
 cmp AX,mnlx
 jne @konec
 mov AX,ymys
 cmp AX,mnly
 jne @konec
 mov AX,stavtlacitek
 or AX,AX
 jnz @konec
 call keypressed
 or AL,AL
 jz @cekani
@konec:
End;{cekejnacokoli}

procedure cekej; assembler;
Asm
 @cekani:
 call kurzor
 mov AX,stavtlacitek
 or AX,AX
 jnz @konec
 call keypressed
 or AL,AL
 jz @cekani
@konec:
End;{cekej}

procedure resetuj; assembler;
Asm
 @cekani:
 call kurzor
 mov AX,stavtlacitek
 or AX,AX
 jnz @cekani
call kresetuj
End;{resetuj}

function mysvpoli(x1,y1,x2,y2:integer):boolean;
Begin
mysvpoli:=(xmys>=x1)and(xmys<=x2)and(ymys>=y1)and(ymys<=y2);
End;{mysvpoli}

procedure citlivostmysi(vodorovne,svisle:word); assembler;
Asm
mov AX,15
mov CX,vodorovne
mov vcitlivost,CX
mov DX,svisle
mov scitlivost,DX
int $33
End;{citlivostmysi}

procedure cekejnacokoli2; assembler;
var mnlx,mnly:word;
Asm
mov AX,xmys
mov mnlx,AX
mov AX,ymys
mov mnly,AX
 @cekani:
 mov AX,xmys
 cmp AX,mnlx
 jne @konec
 mov AX,ymys
 cmp AX,mnly
 jne @konec
 mov AX,stavtlacitek
 or AX,AX
 jnz @konec
 call keypressed
 or AL,AL
 jz @cekani
@konec:
End;{cekejnacokoli2}

procedure cekej2; assembler;
Asm
 @cekani:
 mov AX,stavtlacitek
 or AX,AX
 jnz @konec
 call keypressed
 or AL,AL
 jz @cekani
@konec:
End;{cekej2}

procedure resetuj2; assembler;
Asm
 @cekani:
 mov AX,stavtlacitek
 or AX,AX
 jnz @cekani
call kresetuj
End;{resetuj2}

{nazvy promennych pro ukladani nastaveni:}
const NazevSekce:string[5]='[mys]';
      NazevCX:string[11]='x-citlivost';
      NazevCY:string[11]='y-citlivost';
      NazevKor:string[15]='korekce pohybu';
      NazevObrT:string[15]='zamena tlacitek';

function UlozNastaveniMysi:boolean;
var k:konfigurace;
Begin
k.init;
uloznastavenimysi:=k.pridejsekci(nazevsekce) and
                   k.zadejcislo(nazevcx,vcitlivost) and
                   k.zadejcislo(nazevcy,scitlivost) and
                   k.zadejboolean(nazevkor,korekceb) and
                   k.zadejboolean(nazevobrt,obracenatlacitka)
                   and k.uloz(cfgsoubor);
k.zrus;
End;{uloznastavenimysi}

procedure NactiNastaveniMysi;
var k:konfigurace;
    x,y:integer;
    r:string[1];
    b:boolean;
Begin
k.init;
k.nacti(cfgsoubor,nazevsekce);
x:=-100; y:=-100;
k.prectiinteger(nazevcx,x);
k.prectiinteger(nazevcy,y);
if (x<>-100)and(y<>-100) then citlivostmysi(x,y);
b:=false;
k.prectiboolean(nazevkor,b);
korekcemysi(b);
k.prectiboolean(nazevobrt,obracenatlacitka);
k.zrus;
End;{nactinastavenimysi}

BEGIN
_kurp:=nil; _pk:=nil; kurzorB:=false;
_preruseninastaveno:=false; korekceB:=false; obracenatlacitka:=false;
vcitlivost:=8; scitlivost:=16; {takhle je ovladac standardne nastaven}
END.

{Struktura dat v souboru *.KUR:

 sirka kurzoru v pixelech (byte)
 vyska kurzoru v pixelech (byte)
 xova souradnice aktivniho bodu v pixelech (shortint)
 yova souradnice aktivniho bodu v pixelech (shortint)
 bitmapa kurzoru (array[1..vyska,1..sirka] of byte)

Bitmapa je vlastni obrazek kurzoru - seznam pixelu razeny po radcich, kde
1 byte = 1 pixel. 256 barev, hodnota 0 znamena pruhledny pixel. Primo data
pro _Puttimage (nijak nekomprimovano).
Souradnice aktivniho bodu jsou mereny od leveho horniho rohu bitmapy (kdyby
byl primo tam, mel by souradnice 0,0), + je vpravo a dole, - vlevo a nahore).

Pozor, toto neni zadny oficialni format.}
