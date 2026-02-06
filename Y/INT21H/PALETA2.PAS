(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: PALETA2.PAS                                                    *)
(*  Obsah: procedury pro operace s paletou ve 256tibarevne grafice         *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*  Posledni uprava: 3.12.2011                                             *)
(*  Pro kompilaci: {$ifdef prechody} CAS.TPU {$endif}                      *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit Paleta2;
{$G+,I-}
{$D-,L-}
interface

{$define prechody} {zruste, pokud nepotrebujete plynule prechody, ktere
                    vyuzivaji jednotku Cas}
{$ifdef prechody}
{Vsechny parametry oznacene Rychlost znamenaji dobu cekani mezi dvema kroky
v ms (pro proceduru Pockej). Pocet kroku, ktere se provedou, neni vzdy stejny,
zavisi na tom, o kolik se lisi aktualni paleta od te pozadovane (maximalne
tedy 63 kroku). Optimalni hodnota rychlosti pro caste pouzivani je neco mezi
1 a 10, 50 a vic uz je opravdu hodne pomale. Kdyz zadate nulu, zadne plynule
prechody nebudou a cela akce se provede skokove v jednom kroku.
Cekani je reseno tak, aby nezaviselo na rychlosti procesoru.}
{$endif}


{$define ProcentovyJas} {nechte nebo zruste podle chuti}

{$ifdef procentovyjas}
  {Jas je v procentech, jde nastavit od 0% (uplne cerna obrazovka) az do 200%
  (uplne bila obrazovka), normalni je 100%.}
{$else}
  {Jas jde nastavit od 0 (cerna obrazovka) az do 255 (bila obrazovka),
  normalni je 128. Vypocty v tomto rozsahu jsou o neco rychlejsi nez jejich
  procentova varianta (da se pouzit shr misto div).}
{$endif}

{Nastavovani jasu ovlivnuje vzdy jen zobrazeni barev na obrazovce, na
hodnotach v palete (promenne) se neprojevuje. Jedinou vyjimkou je nacitani
palety z obrazovky - tam se vsechny barvy nactou "natvrdo", tj. vcetne
aktualniho zjasneni nebo ztmaveni.}

(************************* verejna promenna: ********************************)

const {$ifdef procentovyjas}
      _jas:byte=100; {0 = cerno, 100 = normal, 200 = bilo}
      {$else}
      _jas:byte=128; {0 = cerno, 128 = normal, 256 = bilo (samozrejme pouzivejte maximalne 255)}
      {$endif}


(************************* uzivatelsky typ: *********************************)

type RGBpal256=array[0..255,1..3]of byte; {256barevna paleta (slozky jsou: 1 = cervena, 2 = zelena, 3 = modra)}


(************************* verejne procedury: *******************************)

procedure SetRGBpal(cislo,r,g,b:byte);
{rychlejsi a univerzalnejsi obdoba Setrgbpalette, pouziti uplne stejne}
Procedure GetRGBpal(cislo:byte; var r,g,b:byte);
{nacte slozky dane barvy}
procedure ZjistiPaletu(var Pal:rgbpal256);
{Nacte celou paletu z obrazovky a ulozi ji do promenne Pal (nebere v uvahu
jas (jeho hodnotu nemeni), precte paletu presne tak, jak je zrovna nastavena,
vcetne pripadneho zesvetleni nebo ztmaveni).}
function NactiPaletu(var P:rgbpal256; soubor:string):boolean;
{nacte paletu ze souboru, vraci true, pokud se to povede}
procedure NastavCelouPaletu(var Pal:rgbpal256);
{Aplikuje paletu Pal. Rychla, ale neumi pracovat s jasem (hodnotu jasu vzdy
nastavi na vychozi (100% nebo 128)).}
procedure NastavPaletu(var P:rgbpal256; Vocad,Pocad,NovyJas:byte);
{Aplikuje na obrazovku barvy s cisly Vocad az Pocad z palety P. Jas techto
barev na obrazovce nastavi na hodnotu Novyjas a tuto hodnotu take prohlasi za
aktualne nastavenou hodnotu jasu.}
procedure NastavBarvu(var P:rgbpal256; Cislo,R,G,B:byte);
{Nastavi jednu barvu v palete i na obrazovce. Na obrazovce barvu prizpusobi
aktualne nastavenemu jasu, do palety ulozi presne ty zadane hodnoty.}
procedure RotujPaletu(var P:rgbpal256; vocad,pocad:byte; oKolik:integer);
{posune (jednorazove) dany usek barev o oKolik pozic (okolik>0 => doprava,
oKolik<0 => doleva) a ty barvy, ktere "vypadnou" jednim koncem ven, vrati
druhym koncem zpatky. Jas se nemeni. Efekt se projevi jen na obrazovce,
v palete ne.}
function NastavPresnostPalety(BitovaHloubka:byte):byte;
{Umozni nastavit pocet bitu na jednu barevnou slozku v palete. Normalne jsou
palety 6bitove (hodnoty slozek 0..63), ale na novejsich grafickych kartach
jdou pomoci VESA sluzeb prepnout do 8bitoveho rezimu (hodnoty slozek 0..255).
Pred volanim teto funkce doporucuji zkontrolovat promennou _8bitovaPaleta
(boolean) z jednotky VESA, jestli vam to vubec bude fungovat.
Funkce vraci skutecny pocet bitu, jaky se podarilo nastavit, nebo nulu pri
chybe.}

{$ifdef prechody}
procedure ZmenJas(var P:rgbpal256; Vocad,Pocad,NovyJas:byte; Rychlost:word);
{plynula zmena jasu, jen pro barvy Vocad..Pocad}
procedure ZmenBarvu(var P:rgbpal256; CisloBarvy,nR,nG,nB:byte; Rychlost:word);
{plynule prebarvi jednu barvu na jinou (v palete i na monitoru)}
procedure ZmenPaletu(Start:rgbpal256;var Cil:rgbpal256; Vocad,Pocad:byte; Rychlost:word);
{plynule prebarveni barev vocad..pocad z palety Start do Cil}
{$endif}

function NajdiNejblizsiBarvu(var Paleta:rgbpal256; R,G,B:integer):byte;
{Vrati index barvy z dane Palety, jejiz slozky jsou nejbliz zadanym. Vysledek
nikdy nebude 0, protoze se barva 0 obvykle pouziva jako "pruhledna", takze by
jeji zmena byla nezadouci. Blizkost barev se pocita jako eukleidovska
vzdalenost ve trirozmernem prostoru RGB krychle.}
type PrevodniPole=array[0..255] of byte; {pro nasledujici proceduru}
procedure PrevedPaletu(var p1:rgbpal256; od1,do1:byte; var p2:rgbpal256; od2,do2:byte; var Vysledek:prevodnipole);
{Procedura, ktera ke kazde barve v useku od1..do1 v palete p1 najde nejblizsi
barvu v useku od2..do2 v palete p2, vyslednou prevodni tabulku pak ulozi do
pole Vysledek. Tabulka se potom pouzije tak, ze vezmeme nejakou barvu z prvni
palety, pouzijeme ji jako index a cislo v tabulce na tomto indexu udava
nejpodobnejsi barvu ve druhe palete. Barvy mimo zadane useky od..do zustanou
nezmeneny (tj. prislusne hodnoty v tabulce budou rovne svym indexum).}


implementation
{$ifdef prechody}uses cas;{$endif}

const _max:byte=63; {Maximalni hodnota barevne slozky, normalne 63 pro
                    6bitovou paletu. Automaticky ji nastavuje procedura
                    Nastavpresnostpalety.}

procedure SetRGBpal(cislo,r,g,b:byte); assembler;
Asm
mov DX,$03C8        {coz znamena:}
mov AL,cislo
out DX,AL           {port[$3C8]:=cislo;}
inc DX
mov AL,r
out DX,AL           {port[$3C9]:=r;}
mov AL,g
out DX,AL           {port[$3C9]:=g;}
mov AL,b
out DX,AL           {port[$3C9]:=b;}
End;{setrgbpal}

Procedure getrgbpal(cislo:byte;var r,g,b:byte); assembler;
Asm
mov DX,$03C7
mov AL,cislo
out DX,AL               {port[$03C7]:=cislo;}
add DX,2
in AL,DX
les DI,r
mov ES:[DI],AL          {R:=port[$03C9];}
in AL,DX
les DI,g
mov ES:[DI],AL          {G:=port[$03C9];}
in AL,DX
les DI,b
mov ES:[DI],AL          {B:=port[$03C9];}
End;{getrgbpal}

procedure NastavCelouPaletu(var pal:rgbpal256); assembler; {by Asp / VR group}
Asm
mov DX,$03C8
xor AX,AX
out DX,AL     {port[$03C8]:=0}
push DS
lds SI,pal    {priprav do DS:SI adresu palety}
inc DX
mov CX,768
 rep outsb    {port[$03C9]:=postupne kazdy byte palety}
pop DS
mov _jas,100  {jas 100%}
End;{nastavceloupaletu}

procedure ZjistiPaletu(var pal:rgbpal256); assembler; {by Asp / VR group}
Asm
mov DX,$03C7
xor AX,AX
out DX,AL
les DI,pal
add DX,2
mov CX,768
 rep insb
End;{zjistipaletu}


function NactiPaletu(var P:rgbpal256; soubor:string):boolean;
var f:file of rgbpal256;
Begin
assign(f,soubor);
reset(f);
read(f,P);
close(f);
nactipaletu:=ioresult=0;
End;{nactipaletu}

procedure NastavPaletu(var p:rgbpal256; vocad,pocad,novyjas:byte);
var i:byte;
Begin
_jas:=novyjas;
{$ifdef procentovyjas}
if _jas>100 then for i:=vocad to pocad do setrgbpal(i,p[i,1]+((_max-p[i,1])*(_jas-100)) div 100,
                                                      p[i,2]+((_max-p[i,2])*(_jas-100)) div 100,
                                                      p[i,3]+((_max-p[i,3])*(_jas-100)) div 100)
            else for i:=vocad to pocad do setrgbpal(i,(p[i,1]*_jas) div 100,
                                                      (p[i,2]*_jas) div 100,
                                                      (p[i,3]*_jas) div 100);
{$else}
if _jas>128 then for i:=vocad to pocad do setrgbpal(i,p[i,1]+((_max-p[i,1])*(_jas-128)) shr 7,
                                                      p[i,2]+((_max-p[i,2])*(_jas-128)) shr 7,
                                                      p[i,3]+((_max-p[i,3])*(_jas-128)) shr 7)
            else for i:=vocad to pocad do setrgbpal(i,(p[i,1]*_jas) shr 7,
                                                      (p[i,2]*_jas) shr 7,
                                                      (p[i,3]*_jas) shr 7);
{$endif}
End;{nastavpaletu}

procedure nastavbarvu(var p:rgbpal256; cislo,r,g,b:byte);
Begin
p[cislo,1]:=r; p[cislo,2]:=g; p[cislo,3]:=b;
{$ifdef procentovyjas}
if _jas>100 then setrgbpal(cislo,r+((_max-r)*(_jas-100))div 100,g+((_max-g)*(_jas-100))div 100,b+((_max-b)*(_jas-100))div 100)
            else setrgbpal(cislo,(r*_jas) div 100,(g*_jas) div 100,(b*_jas) div 100);
{$else}
if _jas>128 then setrgbpal(cislo,r+((_max-r)*(_jas-128))shr 7,g+((_max-g)*(_jas-100))shr 7,b+((_max-b)*(_jas-100))shr 7)
            else setrgbpal(cislo,(r*_jas) shr 7,(g*_jas) shr 7,(b*_jas) shr 7);
{$endif}
End;{nastavbarvu}


{$ifdef prechody}

procedure zmenjas(var p:rgbpal256;vocad,pocad,novyjas:byte;rychlost:word);
Begin
if rychlost=0 then begin
                   _jas:=novyjas;
                   nastavpaletu(p,vocad,pocad,_jas);
                   end
              else begin
                   while _jas<>novyjas do begin
                                          startcekani;
                                          if _jas>novyjas then dec(_jas)
                                                          else inc(_jas);
                                          nastavpaletu(p,vocad,pocad,_jas);
                                          pockej(rychlost);
                                          end;
                   end;
End;{zmenjas}

procedure ZmenBarvu(var P:rgbpal256;cislobarvy,nr,ng,nb:byte;rychlost:word);
var r,g,b:byte;
Begin
if rychlost=0 then nastavbarvu(p,cislobarvy,nr,ng,nb)
              else begin
                   r:=p[cislobarvy,1];
                   g:=p[cislobarvy,2];
                   b:=p[cislobarvy,3];
                   while(r<>nr)or(g<>ng)or(b<>nb)do
                     begin
                     startcekani;
                     if r>nr then dec(r)else if r<nr then inc(r);
                     if g>ng then dec(g)else if g<ng then inc(g);
                     if b>nb then dec(b)else if b<nb then inc(b);
                     nastavbarvu(p,cislobarvy,r,g,b);
                     pockej(rychlost);
                     end;
                   end;
End;{zmenbarvu}

procedure ZmenPaletu(start:rgbpal256; var cil:rgbpal256; vocad,pocad:byte; rychlost:word);
var i,j:byte;
    padla:boolean;
{}function hotovo:boolean;
{}var it:word;
{}Begin
{}it:=0;
{} repeat
{} if(start[it,1]<>cil[it,1])or(start[it,2]<>cil[it,2])or(start[it,3]<>cil[it,3])
{}  then it:=257;
{} inc(it);
{} until it>255;
{}hotovo:=(it=256);
{}End;{hotovo}
Begin{_zmenpaletu}
padla:=false;
if rychlost=0 then nastavpaletu(cil,vocad,pocad,_jas)
              else repeat
                   startcekani;
                   if hotovo then padla:=true
                             else begin
                                  for i:=vocad to pocad do
                                   for j:=1 to 3 do if start[i,j]>cil[i,j] then dec(start[i,j])
                                                                           else if start[i,j]<cil[i,j] then inc(start[i,j]);
                                  nastavpaletu(start,vocad,pocad,_jas);
                                  end;
                   pockej(rychlost);
                   until padla;
End;{zmenpaletu}

{$endif}


procedure RotujPaletu(var P:rgbpal256; vocad,pocad:byte; oKolik:integer);
var i:byte;
{}procedure nastav(b:byte);{za barvu i na obrazovce nastavi barvu b z palety}
{}Begin
{}{$ifdef procentovyjas}
{}if _jas>100 then setrgbpal(i,p[b,1]+((_max-p[b,1])*(_jas-100)) div 100,
{}                             p[b,2]+((_max-p[b,2])*(_jas-100)) div 100,
{}                             p[b,3]+((_max-p[b,3])*(_jas-100)) div 100)
{}            else setrgbpal(i,(p[b,1]*_jas) div 100,
{}                             (p[b,2]*_jas) div 100,
{}                             (p[b,3]*_jas) div 100);
{}{$else}
{}if _jas>128 then setrgbpal(i,p[b,1]+((_max-p[b,1])*(_jas-128)) shr 7,
{}                             p[b,2]+((_max-p[b,2])*(_jas-128)) shr 7,
{}                             p[b,3]+((_max-p[b,3])*(_jas-128)) shr 7)
{}            else setrgbpal(i,(p[b,1]*_jas) shr 7,
{}                             (p[b,2]*_jas) shr 7,
{}                             (p[b,3]*_jas) shr 7);
{}{$endif}
{}End;{nastav}
Begin
okolik:=okolik mod (pocad-vocad+1);{abychom to nerotovali nekolikrat dokola}
if okolik>0 then begin
                 for i:=vocad+okolik to pocad do nastav(i-okolik);
                 for i:=vocad to vocad+okolik-1 do nastav(i+pocad-vocad+1-okolik);
                 end
 else if okolik<0 then begin
                       for i:=vocad to pocad+okolik do nastav(i-okolik);
                       for i:=pocad+okolik+1 to pocad do nastav(i-pocad+vocad-okolik-1);
                       end;
End;{rotujpaletu}

function NastavPresnostPalety(BitovaHloubka:byte):byte; assembler;
Asm
mov AX,$4F08         {sluzba "bitova hloubka palety"}
mov BL,0             {podsluzba "nastav ji"}
mov BH,bitovahloubka {kolik bitu chceme}
int $10              {do toho!}
cmp AX,$4F   {jak jsme dopadli?}
je @OK       {dobre ->}
 xor AX,AX     {spatne => vratime nulu a promennou _max nechame byt}
 jmp @konec
@OK:
shr BX,8     {presuneme vysledek z BH do BL}
mov AX,BX    {-> v AL vratime skutecny nastaveny pocet bitu}
{vypocitame maximalni hodnotu barevne slozky:}
mov CX,BX    {CX = pocet bitu}
or BX,$FFFF  {BX = vsechny bity na 1}
shl BX,CL    {posun o CX bitu vlevo}
not BX       {negace vsech bitu}
mov _max,BL  {a to je vysledek}
@konec:
End;{nastavpresnostpalety}

procedure prevedpaletu(var p1:rgbpal256; od1,do1:byte; var p2:rgbpal256; od2,do2:byte; var vysledek:prevodnipole);
var i,j,tojeona:byte;
    vzdalenost,nejkratsi:longint;
    dr,dg,db:longint; {word nema znamenko a integer by nestacil, proto longint}
Begin
for i:=0 to 255 do vysledek[i]:=i; {}
for i:=od2 to do2 do {barvy v cilove palete}
 begin
 nejkratsi:=10000000; {neco hodne velkeho, nejlepe nekonecno}
 tojeona:=0;
 for j:=od1 to do1 do {usek barev v pocatecni palete}
  begin
  dr:=p1[j,1]-p2[i,1]; dg:=p1[j,2]-p2[i,2]; db:=p1[j,3]-p2[i,3];{rozdily slozek barvy}
  vzdalenost:=dr*dr+dg*dg+db*db;{"vzdalenost" mezi barvami - pres Pythagora
                                (odmocnovat neni treba, muzeme rovnou porovnavat mocniny)}
  if vzdalenost<nejkratsi then begin {prakticka ukazka hledani nejmensiho cisla z pole :-)}
                               nejkratsi:=vzdalenost;
                               tojeona:=j; {barva s nejmensim rozdilem je ta, kterou hledame}
                               end;
  end;
 vysledek[i]:=tojeona; {uloz ji}
 end;
End;{prevedpaletu}

function NajdiNejblizsiBarvu(var paleta:rgbpal256; R,G,B:integer):byte;
var i:byte;
    Vzdalenost,NejmensiVzdalenost:longint;
    dr,dg,db:longint;
Begin
nejmensivzdalenost:=60000;
najdinejblizsibarvu:=0;
for i:=1 to 255 do {barva 0 je vyhrazena pro pruhlednost, takze ji preskocime}
  begin
  dr:=paleta[i,1]-r; dg:=paleta[i,2]-g; db:=paleta[i,3]-b;
  vzdalenost:=dr*dr+dg*dg+db*db;{Pythagorova veta, jenom bez odmocniny (zdrzovala by)}
  if vzdalenost<nejmensivzdalenost then begin
                                        nejmensivzdalenost:=vzdalenost;
                                        najdinejblizsibarvu:=i;
                                        end;
  if vzdalenost=0 then break;
  end;
End;{najdinejblizsibarvu}


END.
