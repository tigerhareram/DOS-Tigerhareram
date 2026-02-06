(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: MYS3.PAS                                                       *)
(*  Obsah: procedury a funkce pro ovladani mysi ve VESA grafice            *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*  Posledni uprava: 13.4.2011                                             *)
(*  Pro kompilaci: VESA, ERRMSG, CFG, KLAVESY2, DOS                        *)
(*  Pro spusteni: nejaky soubor s kurzorem (obvykle *.KUR)                 *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit Mys3;
{$I-,B-,G+} {nutne}
{$X-,R-,S-,F-,Q-} {jen prkotiny pro drobne urychleni}
interface

{struktura pro ukladani kurzoru:}
type tKurzor = record
               sk,vk:byte;{sirka a vyska kurzoru (v pixelech)}
               hsx,hsy:shortint;{souradnice aktivniho bodu kurzoru od leveho horniho rohu bitmapy
                                 (pocitano od nuly, obrazek kurzoru se kresli na [xmys-hsx,ymys-hsy])}
               kData:pointer;{ukazatel na bitmapu (obycejny obrazek pro _puttimage)}
               end;


(************************** verejne promenne: *******************************)

var Xmys,Ymys:integer;{souradnice kurzoru mysi na obrazovce}
    PocetTlacitek,{pocet tlacitek mysi - 2 nebo 3, detekuje ho procedura
        InitMys. Ciste informativni hodnota, delejte si s ni co chcete.}
    StavTlacitek:word;{1=leve, 2=prave, 4=stredni. Kdyz je stisknuto vic
        tlacitek najednou, sectou se (OR).}
    Lmys,Pmys,Smys:boolean;{jestli je stisknuto prislusne tlacitko (jen
        rozdelena promenna Stavtlacitek pro pohodlnejsi praci)}
    kurzorB:boolean;{Jestli je zapnuty kurzor. Nemenit rucne! Staraji se o ni
        procedury kVyp a kZap.}
    korekceB:boolean;{Nektere mysi ovladace zpusobuji, ze se kurzor nepohybuje
        plynule, ale skace po osmi pixelech. To se da korigovat a tato
        promenna rika, jestli je korekce aktivni. Teoreticky by mohla byt
        zapnuta porad, ale prakticky to s ni neni uplne to prave vorechove,
        protoze nastaveni citlivosti pak neni zrovna plynule. Proto je mozne
        pracovat v obou rezimech, s korekci i bez ni. Technicky se korekce
        provadi prostym vydelenim souradnic kurzoru osmi, proto:
         POZOR 1: Zapnutim korekce se kurzor vyrazne zpomali, vypnutim se
        naopak vyrazne zrychli a prakticky se s nim neda nikam trefit!!
         POZOR 2: Pro zapnuti a vypnuti korekce pouzivejte prislusnou
        proceduru, nemente hodnotu teto promenne rucne! (jinak by se rozhodil
        rozsah pohybu mysi, ktery musi byt s ohledem na korekci prepocitan)}
    ObracenaTlacitka:boolean;{True znamena, ze se vymeni leve tlacitko mysi
        s pravym (pro praci levou rukou). V promennych Stavtlacitek, Lmys a
        Pmys budou uz vymenene hodnoty, takze ve svem programu se nemusite o
        nic starat. Promennou Obracenatlacitka lze bez obav nastavovat rucne
        (procedura na to stejne zadna neni).}

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
uses errmsg,vesa,dos,cfg,klavesy2;

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
Begin
asm
{DS je pri zavolani teto procedury nastaven na segment ovladace mysi, ale my
potrebujeme datovy segment programu, takze:}
push DS         {ulozime DS (obnovovat ho budeme na konci procedury)}
push seg @data  {vezmeme datovy segment programu...}
pop DS          {...a vlozime ho do DS.
Jinak nez pres zasobnik to v tuto chvili nejde, protoze nemame zadny volny
registr - jsou v nich totiz ulozene udaje o mysi, ktere nam poskytl ovladac:}
mov DI,AX   {jenom si ulozim AX nekam do bezpeci, protoze bude jeste potreba}
mov AL,korekceB
or AL,AL
jz @BezKorekce
 shr CX,3   {vydeleni obou souradnic kurzoru osmi}
 shr DX,3
@BezKorekce:
mov AX,DI   {obnoveni AX}
mov xmys,CX
mov ymys,DX
test AX,$7E  {V AX je kod udalosti, ktera zpusobila vyvolani teto procedury
              (odpovida masce v CX pri nastavovani obsluhy - viz dale).
              Pokud je AX = 1 (nastal pouze pohyb mysi), preskoci se usek
              zpracovani stavu tlacitek.}
jz @TlacitkaSeNezmenila
 mov AL,obracenatlacitka
 or AL,AL
 jz @normalni
  mov AX,BX
  or AH,AL
  and BX,4     {BX = prostredni}
  and AX,$0201 {AL = leve, AH = prave}
  shl AL,1     {prohozeni tlacitek}
  shr AH,1
  or BL,AL     {nakopirovani zpet do BX}
  or BL,AH
 @normalni:
 mov stavtlacitek,BX
 mov AX,BX
 or AH,AL        {AH = AL = stav tlacitek}
 and BL,1        {stisknuto leve?}
 mov lmys,BL     {uloz do lmys}
 shr AX,1        {AH i AL o bit doprava}
 and AL,1        {stisknuto prave?}
 mov pmys,AL     {uloz do pmys}
 shr AH,1        {AH o bit doprava}
                 {stisknuto prostredni?}
 mov smys,AH     {uloz do smys}
@TlacitkaSeNezmenila:
end;
if kurzorb and ((xmys<>_kx)or(ymys<>_ky)) then {kdyz je zapnuty kurzor a bylo jim pohnuto}
 begin
 asm
 {ulozime aktualni banku pro pripad, ze by se obsluha kurzoru volala uprostred jine procedury, ktera si uz banku nastavila}
 call _getbank {zapisovaci okno}
 push AX      {vysledek typu word vratila funkce v AX, takze ho ulozime}
 call _getrbank {cteci okno}
 push AX
 {zaridime, aby se kurzor kreslil stale na viditelnou stranku:}
 mov BL,_strankovani
 push BX
 or BL,BL
 jz @NestrankujeSe
  call _nastavstrankovani
 @NestrankujeSe:
 end;
 _putimage(_lhx,_lhy,_sk,_vk,_pk);{zobrazeni pozadi - vymazani kurzoru}
 _kx:=xmys; _ky:=ymys;{ulozeni nove polohy kurzoru}
 _lhx:=_kx-_hsx; _lhy:=_ky-_hsy;    {levy horni roh pozadi kurzoru}
 if _lhx<0 then _lhx:=0;    {aby nevycuhoval levy nebo horni okraj z obrazovky (kvuli _getimage)}
 if _lhy<0 then _lhy:=0;
 if _lhx+_sk-1>_maxx then _lhx:=_maxx-_sk+1;  {aby nevycuhoval ani pravy nebo dolni okraj}
 if _lhy+_vk-1>_maxy then _lhy:=_maxy-_vk+1;
 _getimage(_lhx,_lhy,_lhx+_sk-1,_lhy+_vk-1,_pk);{nacteni pozadi kurzoru}
 _puttimage(_kx-_hsx,_ky-_hsy,_sk,_vk,_kurp);{zobrazeni kurzoru}
 asm
 {vratime puvodni stranku:}
 pop AX
 or AL,AL
 jz @NestrankujeSe2
  call _nastavstrankovani
 @NestrankujeSe2:
 {vratime puvodni banku:}
 call _switchrbank {hodnotu parametru si procedura precte ze zasobniku, kam jsme banku pred chvili ulozili}
 call _switchbank
 end;
 end;
asm pop DS end; {obnoveni ulozeneho DS zpet na segment ovladace mysi}
End;{_obsluhamysi}

procedure ZapniObsluhuMysi;
var AdresaObsluhy:pointer;
Begin
if not _preruseninastaveno then
 begin
 adresaobsluhy:=@_obsluhamysi;
 asm
 mov AX,12    {AX = 12 - sluzba "nastav proceduru pro obsluhu mysi"}
 mov CX,$007F {CX = maska, pri jakych prilezitostech se ma procedura zavolat:}
 les DX,adresaobsluhy           { 01111111   volat pri:                           }
 mov BX,DX                      { ³³³³³³³ÀÄÄ pohybu mysi
(podle nekterych pramenu to       ³³³³³³ÀÄÄÄ stisku leveho tlacitka
pry ma byt BX a ne DX, tak        ³³³³³ÀÄÄÄÄ uvolneni -"-
tam radsi dam oboje)              ³³³³ÀÄÄÄÄÄ stisku praveho tl.                   }
 int $33                        { ³³³ÀÄÄÄÄÄÄ uvolneni -"-                         }
 end;                           { ³³ÀÄÄÄÄÄÄÄ stisku prostredniho tl.              }
 _preruseninastaveno:=true;     { ³ÀÄÄÄÄÄÄÄÄ uvolneni -"-                         }
 end;                           { ÀÄÄÄÄÄÄÄÄÄ tenhle a vyssi bity uz nejsou vyuzity}
End;{zapniobsluhumysi}

procedure ZrusObsluhuMysi;
var AdresaObsluhy:pointer;
Begin
if _preruseninastaveno then
 begin
 adresaobsluhy:=@_obsluhamysi;
 asm
 mov AX,12
 xor CX,CX     {maska = 0 - nevolat proceduru vubec, cili tak se to zrusi}
 les DX,adresaobsluhy {nevim, jestli je tohle nutne, tak to radsi nastavim}
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
{}xor AX,AX  {AX = 0 - sluzba "reset a inicializace mysi"}
{}int $33
{}mov pocettlacitek,BX
{}{vrati se AX}
{}End;
Begin
getintvec($33,ukazatel); {nacteme adresu ovladace (obsluhy preruseni int $33) mysi}
if (ukazatel=nil) {obsluzna procedura neexistuje -> ovladac urcite neni nainstalovan}
  or (byte(ukazatel^)=$CF) {obsluzna procedura existuje, ale obsahuje pouze instrukci IRET ("konec preruseni") -> ovladac neni}
  or (init<>$FFFF) {nejaky ovladac nainstalovany je, ale nefunguje tak, jak by mel}
 then chyba('Bud nemate mys nebo vam nefunguje nebo k ni nemate ovladac.',2)
                  {2 = uzivatel to muze risknout a program nechat bezet}
 else begin
      if (pocettlacitek<>0)and(pocettlacitek<>3) then pocettlacitek:=2;
       {1, 2, $FFFF = 2 tlacitka,
        3 = 3 tlacitka,
        0 = neco jineho}
      if korekceb then citlivostmysi(2,2)
                  else citlivostmysi(9,9); {takhle mi vyhovuje nejvic, v pripade potreby zmente}
      mezemysi(0,0,_maxx,_maxy); {meze mysi = cela obrazovka}
      presunmys(_maxx shr 1,_maxy shr 1); {kurzor do stredu obrazovky}
      StavMysi; {inicializace zbyvajicich promennych}
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
                   if ioresult=0 then ;{reset pro pripad, ze by se pri Close vyskytl problem}
                   end
              else kam.kdata:=nil;
End;{nactikurzor2}

procedure ZrusKurzor(var ktery:tkurzor);
Begin
with ktery do begin
              freemem(kdata,sk*vk);
              kdata:=nil;{pro kontrolu}
              end;
End;{zruskurzor}

procedure NastavKurzor(var jaky:tkurzor);
var bylkurzor:boolean;
Begin
if jaky.kdata=nil then exit;{kurzor neni nacten}
bylkurzor:=kurzorb; kvyp;
if _pk<>nil then begin{zruseni pozadi predchoziho kurzoru}
                 freemem(_pk,_sk*_vk);
                 _pk:=nil;
                 end;
with jaky do
  begin
  _sk:=sk; _vk:=vk;
  _hsx:=hsx; _hsy:=hsy;
  if maxavail<((_sk*_vk)or 15) then bylkurzor:=false{zabranime zapnuti (lepsi nez se patlat s chybovymi hlaskami)}
                               else begin
                                    getmem(_pk,_sk*_vk);{nova pamet pro pozadi}
                                    _kurp:=kdata;{nastaveni ukazatele na obrazek}
                                    end;
  end;
if bylkurzor then kzap;
End;{nastavkurzor}

procedure ZrusMys;
Begin
if _preruseninastaveno then zrusobsluhumysi;
kvyp;
if _pk<>nil then begin
                 freemem(_pk,_sk*_vk); {uvolneni pameti pro pozadi kurzoru}
                 _pk:=nil;
                 end;
_kurp:=nil; {nutne, aby se kurzor nedal zapnout, kdyz nema alokovane pozadi}
End;{zrusmys}

procedure KorekceMysi(JoNeboNe:boolean);
Begin
if korekceb<>jonebone then begin
                           korekceb:=jonebone;
                           mezemysi(0,0,_maxx,_maxy);
                           presunmys(_maxx shr 1,_maxy shr 1);
                           end;
End;{korekcemysi}

procedure StavMysi; assembler;
Asm
mov AX,3     {AX = 3 - sluzba "cteni stavu mysi"}
int 33h
mov AL,korekceB
or AL,AL
jz @BezKorekce
 shr CX,3    {korekce skakani znamena vydelit souradnice kurzoru osmi}
 shr DX,3
@BezKorekce:
mov xmys,CX
mov ymys,DX
 mov AL,obracenatlacitka  {zpracovani tlacitek je stejne jako v procedure _obsluhamysi}
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
and BL,1        {true=1, false=0}
mov lmys,BL                {lmys:=(stavtlacitek and 1)=1;}
shr AX,1
and AL,1
mov pmys,AL                {pmys:=(stavtlacitek shr 1)and 1 =1;}
shr AH,1
mov smys,AH                {smys:=(stavtlacitek shr 2)=1;}
End;{stavmysi}

procedure kurzor;
Begin
if not _preruseninastaveno then
 begin
 stavmysi;
 {Dale to same jako v procedure _ObsluhaMysi, s jedinym rozdilem, ze tentokrat
 nemusime ukladat aktualni banku. Procedura se totiz vola rucne, proto
 nehrozi, ze by byla zavolana nekde, kde to necekame.}
 if kurzorb and ((xmys<>_kx)or(ymys<>_ky)) then
  begin
  asm
  mov AL,_strankovani
  push AX
  or AL,AL
  jz @NestrankujeSe
   call _nastavstrankovani
  @NestrankujeSe:
  end;
  _putimage(_lhx,_lhy,_sk,_vk,_pk);
  _kx:=xmys; _ky:=ymys;
  _lhx:=_kx-_hsx; _lhy:=_ky-_hsy;
  if _lhx<0 then _lhx:=0;
  if _lhy<0 then _lhy:=0;
  if _lhx+_sk-1>_maxx then _lhx:=_maxx-_sk+1;
  if _lhy+_vk-1>_maxy then _lhy:=_maxy-_vk+1;
  _getimage(_lhx,_lhy,_lhx+_sk-1,_lhy+_vk-1,_pk);
  _puttimage(_kx-_hsx,_ky-_hsy,_sk,_vk,_kurp);
  asm
  pop AX
  or AL,AL
  jz @NestrankujeSe
   call _nastavstrankovani
  @NestrankujeSe:
  end;
  end;
 end;
End;{kurzor}

procedure kZap;
Begin
if (_kurp<>nil) and not kurzorb then
 begin
 if not _preruseninastaveno then stavmysi;
 _kx:=xmys; _ky:=ymys;
 _lhx:=_kx-_hsx; _lhy:=_ky-_hsy;
 if _lhx<0 then _lhx:=0;
 if _lhy<0 then _lhy:=0;
 if _lhx+_sk-1>_maxx then _lhx:=_maxx-_sk+1;
 if _lhy+_vk-1>_maxy then _lhy:=_maxy-_vk+1;
 asm
 mov AL,_strankovani
 push AX
 or AL,AL
 jz @NestrankujeSe
  call _nastavstrankovani
 @NestrankujeSe:
 end;
 _getimage(_lhx,_lhy,_lhx+_sk-1,_lhy+_vk-1,_pk);
 _puttimage(_kx-_hsx,_ky-_hsy,_sk,_vk,_kurp);
 asm
 pop AX
 or AL,AL
 jz @NestrankujeSe
  call _nastavstrankovani
 @NestrankujeSe:
 end;
 kurzorb:=true;{tohle musi byt az na konci, kvuli automatice}
 end;
End;{kzap}

procedure kVyp;
Begin
if kurzorb then
 begin
 kurzorb:=false;{tohle musi byt hned na zacatku, kvuli automatice}
 asm
 mov AL,_strankovani
 push AX
 or AL,AL
 jz @NestrankujeSe
  call _nastavstrankovani
 @NestrankujeSe:
 end;
 _putimage(_lhx,_lhy,_sk,_vk,_pk);
 asm
 pop AX
 or AL,AL
 jz @NestrankujeSe
  call _nastavstrankovani
 @NestrankujeSe:
 end;
 end;
End;{kvyp}

function kliknuto:boolean; assembler;
Asm
mov AX,stavtlacitek   {kliknuto:=stavtlacitek<>0;}
{navratova hodnota funkce se vraci v AX (AL); pokud je to nenulove cislo, je to true}
End;{kliknuto}

procedure Mezemysi(x1,y1,x2,y2:word); assembler;
Asm
mov AL,kurzorb
push AX           {ulozime stav kurzoru na zasobnik}
or AL,AL          {je to nula (false)?}
jz @JdemeNaTo     {ano => neni treba kurzor vypinat, uz je vypnuty}
 call kvyp        {vypnuti kurzoru}
@JdemeNaTo:
mov CX,x1
mov DX,x2
mov AL,korekceB
or AL,AL
jz @BezKorekce1
 shl CX,3     {pripadne vynasobeni souradnic osmi pri korekci skakani kurzoru}
 shl DX,3
@BezKorekce1:
mov AX,7     {AX = 7 - sluzba "nastaveni x-oveho rozsahu mysi"}
int $33
mov CX,y2
mov DX,y1
mov AL,korekceB
or AL,AL
jz @BezKorekce2
 shl CX,3
 shl DX,3
@BezKorekce2:
mov AX,8     {AX = 8 - sluzba "nastaveni y-oveho rozsahu mysi"}
int $33
pop AX       {nacteni ulozeneho stavu kurzoru ze zasobniku}
or AL,AL     {je (byla) to 0 (false)?}
jz @konec    {byla => nemusime nic zapinat, hop na konec}
 call kzap    {zapnuti kurzoru}
@konec:
End;{mezemysi}

procedure presunmys(novex,novey:word); assembler;
Asm
mov AL,kurzorb
push AX                    {ulozeni stavu kurzoru}
or AL,AL
jz @jdemenato
 call kvyp
@jdemenato:
mov CX,novex
mov DX,novey
mov xmys,CX      {ulozeni novych souradnic}
mov ymys,DX
mov AL,korekceB
or AL,AL
jz @BezKorekce1
 shl CX,3        {korekce skakani kurzoru}
 shl DX,3
@BezKorekce1:
mov AX,4         {AX = 4 - sluzba "presun mysi"}
int $33
pop AX           {obnoveni kurzoru do puvodniho stavu}
or AL,AL
jz @konec
 call kzap
@konec:
End;{presunmys}

procedure cekejnacokoli; assembler;
var mnlx,mnly:word;
Asm
call kurzor          {kurzor;}
mov AX,xmys
mov mnlx,AX          {mnlx:=xmys}
mov AX,ymys
mov mnly,AX          {mnly:=ymys}
 @cekani:    {cyklus}
 call kurzor
 mov AX,xmys
 cmp AX,mnlx
 jne @konec       {if xmys<>mnlx then goto @konec}
 mov AX,ymys
 cmp AX,mnly
 jne @konec       {if ymys<>mnly then goto @konec}
 mov AX,stavtlacitek
 or AX,AX
 jnz @konec       {if kliknuto then goto @konec}
 call keypressed
 or AL,AL
 jz @cekani       {if not keypressed then goto @cekani}
@konec:
End;{cekejnacokoli}

procedure cekej; assembler;
Asm                {repeat kurzor until (stavtlacitek<>0) or keypressed;}
 @cekani:
 call kurzor
 mov AX,stavtlacitek
 or AX,AX
 jnz @konec {if kliknuto then goto @konec}
 call keypressed
 or AL,AL
 jz @cekani {if not keypressed then goto @cekani}
@konec:
End;{cekej}

procedure resetuj; assembler;
Asm
 @cekani:    {repeat until stavtlacitek=0}
 call kurzor
 mov AX,stavtlacitek
 or AX,AX
 jnz @cekani
call kresetuj {reset bufferu klavesnice}
End;{resetuj}

function mysvpoli(x1,y1,x2,y2:integer):boolean;
Begin
mysvpoli:=(xmys>=x1)and(xmys<=x2)and(ymys>=y1)and(ymys<=y2);
End;{mysvpoli}

procedure citlivostmysi(vodorovne,svisle:word); assembler;
Asm
mov AX,15         {AX = 15 - sluzba "nastav citlivost mysi"}
mov CX,vodorovne
mov vcitlivost,CX
mov DX,svisle
mov scitlivost,DX
int $33
End;{citlivostmysi}

procedure cekejnacokoli2; assembler;
var mnlx,mnly:word;
Asm
{kurzor se o sebe stara sam}
mov AX,xmys
mov mnlx,AX          {mnlx:=xmys}
mov AX,ymys
mov mnly,AX          {mnly:=ymys}
 @cekani:    {repeat}
 mov AX,xmys
 cmp AX,mnlx
 jne @konec       {if xmys<>mnlx then goto @konec}
 mov AX,ymys
 cmp AX,mnly
 jne @konec       {if ymys<>mnly then goto @konec}
 mov AX,stavtlacitek
 or AX,AX
 jnz @konec       {if kliknuto then goto @konec}
 call keypressed
 or AL,AL
 jz @cekani       {if not keypressed then goto @cekani}
@konec:
End;{cekejnacokoli2}

procedure cekej2; assembler;
Asm
 @cekani:
 mov AX,stavtlacitek
 or AX,AX
 jnz @konec {if kliknuto then goto @konec}
 call keypressed
 or AL,AL
 jz @cekani {if not keypressed then goto @cekani}
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
