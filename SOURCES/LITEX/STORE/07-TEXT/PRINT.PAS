(****************************************************************************
                                pro texty:
*****************************************************************************)

procedure _NactiFont(var FN:_font; JmenoSouboru:string);
{Nacte ze souboru font.
FN - promenna typu _Font. Kdyz je po skonceni procedury FN.fdata=nil, znamena
     to, ze se nekde stala chyba a nacteni se nepovedlo.
JmenoSouboru - odkud se ma nacitat (napr. 'neco.fnt')
Proceduru nelze pouzivat na jiz nactene fonty (zustaly by ztracene v pameti)!!}
var velikost:word;
    b:byte;
    soubor:file;
Begin
assign(soubor,jmenosouboru);
reset(soubor,1);
fn.fdata:=nil; {jestli se neco pokazi, tohle tady zustane}
blockread(soubor,fn.fvyska,1);
velikost:=256*fn.fvyska; {je 256 znaku a kazdy ma tolik bytu, jak je vysoky}
if (ioresult<>0)or(velikost>maxavail) then exit;
getmem(fn.fdata,velikost);
blockread(soubor,fn.fstdroztec,1);
blockread(soubor,b,1);
fn.fstdx:=b and 15;
fn.fstdy:=b shr 4;
blockread(soubor,fn.fdata^,velikost);
if ioresult<>0 then begin
                    freemem(fn.fdata,velikost);{kdyz se font nenacetl, tak nema cenu zbytecne zabirat pamet}
                    fn.fdata:=nil;
                    end;
close(soubor);
if ioresult<>0 then ;{reset Ioresultu pro pripad chyby pri Close (i to se muze stat)}
End;{_nactifont}


procedure _ZrusFont(var fn:_font);
{Vymaze font z pameti. Ukazatel FN.fdata nastavi na nil.}
Begin
if fn.fdata<>nil then begin
                      freemem(fn.fdata,fn.fvyska*256);
                      fn.fdata:=nil; fn.fvyska:=0; {aby bylo jasne, ze uz tu nic neni}
                      end;
End;{_zrusfont}


procedure _NastavText(velikostX,velikostY,roztec:byte);
{Nastavi styl textu pro proceduru _Print. Kdyz je jakykoli parametr roven 0,
zustava nastavena jeho minula hodnota (tj. nemeni se).
 velikostX, velikostY - velikost pisma, technicky vzato rozmer jednoho pixelu,
                        pro vodorovny a svisly smer.
 roztec - roztec dvou sousednich znaku (od leveho kraje jednoho po levy kraj
          druheho). Normalne je rovna sirce znaku. Kdyz menite velikost pisma,
          nezapomente zadat roztec rovnou napr. 8*velikostX, jinak bude pismo
          zdrcle dohromady (coz se nekdy hodi, proto tenhle system).}
Begin
if velikostx<>0 then __velikostx:=velikostx;
if velikosty<>0 then __velikosty:=velikosty;
if roztec<>0 then __roztec:=roztec;
End;{_nastavtext}


procedure _NastavFont(var fn:_font; NastavDoporucene:boolean);
{Nastavi font pro psani procedurou _Print (viz dale). Promennou F je potreba
zachovat, protoze se na ni pouze napichnou prislusne ukazatele, ale font se
nikam fyzicky nekopiruje.
 NastavDoporucene - true => Nastavi se doporucene parametry textu (velikost a
                            roztec), ktere byly s fontem ulozeny v souboru.
                    false => Nastaveni textu se nezmeni.}
Begin
__font:=fn.fdata;
__vyska:=fn.fvyska;
if NastavDoporucene then with fn do _nastavtext(fstdx,fstdy,fstdroztec);
End;{_nastavfont}


procedure _print(ix,iy:integer; barva:byte; textik:string);
{Napise na obrazovku text (podobne jeko Outtextxy). Orezava podle okraju
obrazovky (640x480). Souradnice ix,iy predstavuji vzdy levy horni roh textu.}
var PoziceVRetezci:word; {index pro pohyb mezi znaky retezce (word proto, aby nepretekl, kdyz bude retezec 255 znaku dlouhy)}
    CisloRadku:word; {index pro pohyb mezi radky pismena}
    radek:byte; {data - jeden radek pismena (bitove pole)}
    x,y:integer; {pomocne - aktualni souradnice na obrazovce}
    i:integer; {ridici promenna do asm cyklu}
    OfsetRadku:word; {ofset aktualne zpracovavaneho radku (bytu) ve fontu}
    delka:word; {sirka souvisleho vybarveneho useku pismena}
Begin
if (textik='') or (__font=nil) or (__velikostx=0) or (__velikosty=0)
   or (ix+__velikostx shl 3-1>639) or (iy>479) then exit;
PoziceVRetezci:=1;
 repeat {cyklus pro kazdy znak retezce}
 asm
 {priprava pocitadla radku:}
 mov AX,__vyska
 mov cisloradku,AX {bude se postupne odcitat az do nuly}

 {nacteni znaku:}
 xor AX,AX {kvuli vynulovani AH}
 lea SI,textik
 mov BX,pozicevretezci
 mov AL,[SS:SI+BX]  {precteni znaku z retezce}

 {adresa znaku ve fontu:}
 mul __vyska   {ASCII kod znaku * __vyska = ofset prvniho radku znaku ve fontu}
 les DI,__font
 add DI,AX
 mov ofsetradku,DI

 {yova souradnice LH rohu znaku:}
 mov AX,iy
 mov y,AX

 {cyklus pro kazdy radek fontu:}
 @MameOfsetRadku:
 mov AL,[ES:DI] {radek z fontu}
 mov radek,AL

 {projiti radku bit po bitu:}
 mov AX,ix;  mov i,8 {pocitadlo bitu}
 mov x,AX;   mov delka,0 {pocitadlo delky jednickovych useku musi byt na zacatku vynulovane}
  @ProKazdyBit:
  rol radek,1
  jnc @dira
   {dokud jsou jednicky, jenom pricitame delku:}
   mov AX,__velikostx
   add delka,AX
   jmp @BitVyrizen
  @dira:
   {jakmile jednicky skonci, vykreslime nasbirany jednickovy usek:}
   cmp delka,0 {mame neco nasbirano?}
   je @JenPosun {ne}
    @kresleni:
    mov AX,x
    push AX {x1}
    mov BX,y
    cmp __velikosty,1
    je @hline
     {kdyz je pismo ve svislem smeru roztazene, kreslime bar:}
     push BX {y1}
     add AX,delka
     dec AX;        add BX,__velikosty
     push AX; {x2}  dec BX
                    push BX {y2}
     push word ptr barva
     call svga_barz
     jmp @vykresleno
    @hline:
     {kdyz pismo roztazene neni, kreslime jenom caru:}
     add AX,delka
     dec AX
     push AX {x2}
     push BX {y}
     push word ptr barva
     call svga_hline
    @vykresleno:
    mov AX,delka
    add x,AX
    mov delka,0
   @JenPosun:
   {na obrazovce o jeden (roztazeny) pixel dal:}
   mov AX,__velikostx
   add x,AX
  @BitVyrizen:
  dec i
  jnz @ProKazdyBit;

  {Prosli jsme vsech 8 bitu, ale mozna nam jeste ceka na zpracovani
  nascitana delka posledniho jednickoveho useku. V takovem pripade se
  musime vratit a nechat ho vykreslit:}
  cmp delka,0
  je @RadekOpravduVyrizen
   mov i,1 {aby bitovy cyklus hned skoncil}
   jmp @kresleni
  @RadekOpravduVyrizen:

 dec cisloradku
 jz @CelyZnakVykreslen
  {na dalsi radek na obrazovce:}
  mov AX,__velikosty
  add y,AX
  {na dalsi radek ve fontu:}
  les DI,__font
  inc ofsetradku
  mov DI,ofsetradku
  jmp @MameOfsetRadku
 @CelyZnakVykreslen:
 end;
 inc(ix,__roztec);
 inc(pozicevretezci);
 until (pozicevretezci>length(textik)) or (ix>639);
End;{_print}


function _SirkaTextu(PocetZnaku:byte):word;
{spocita sirku retezce o zadanem poctu znaku (v pixelech)}
Begin
_sirkatextu:=pocetznaku*__roztec;
End;{_sirkatextu}


function _VyskaTextu:word;
{vraci vysku jakehokoli textu (vsechny znaky fontu jsou stejne vysoke, takze
nezalezi na tom, co se pise)}
Begin
_vyskatextu:=__velikosty*__vyska;
End;{_vyskatextu}
