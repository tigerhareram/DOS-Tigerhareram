(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: VGA.PAS                                                        *)
(*  Obsah: jednotka pro 256barevnou VGA grafiku (320x200)                  *)
(*         (jen to nejnutnejsi pro projekt Dungeon)                        *)
(*  Autori puvodni jednotky VGA256: Asp/VR group, 1996-99                  *)
(*                     Virtual Research independent group production, 1999 *)
(*  Rozsireni a optimalizace: Mircosoft (http://mircosoft.mzf.cz)          *)
(*  Posledni uprava: 17.6.2012                                             *)
(*  Pro kompilaci: ERRMSG.TPU                                              *)
(*  Pro spusteni: pokud chcete zobrazovat texty, potrebujete nejaky soubor *)
(*                s fontem typu *.FNT (vytvareji se mym programem          *)
(*                FNTEDIT, neni to zadny oficialni format)                 *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)

unit VGA;
{$N+,G+,S-,R-,Q-,V-,B-,O-}

{...$define cesky}       {vyber jazyka chybovych hlasek - vyberte }
{$define english}        {jednu direktivu, druhou nechte neaktivni}

interface

var vgaMinClipX,vgaMinClipY,vgaMaxClipX,vgaMaxClipY:word; {orezavaci okno}
    vgaCilovaOblast:pointer; {aktualni misto, do ktereho se zrovna kresli
                       (bud realna obrazovka na adrese $A000:0 nebo virtualni
                       nekde v pameti)}
    vgaVirtualScreen:pointer; {k volnemu pouziti}


procedure StartVGA;
{zapne grafiku (rezim $13 - 320x200x256)}
procedure EndVGA;
{ukonci grafiku (prepne do textoveho rezimu 80x25x16)}
procedure vgaSetVirtualOutput(target:pointer);
{Vsechny graficke operace presmeruje do dane virtualni obrazovky.}
procedure vgaSetNormalOutput;
{Vsechny graficke operace presmeruje zpatky na skutecnou obrazovku.}
procedure vgaVSync;
{Pocka na navrat vykreslovaciho paprsku obrazovky. Cokoli, co se nakresli
bezprostredne po volani teto procedury, bude zobrazeno bez blikani.}
procedure vgaSwap(source:pointer);
{Zkopiruje obsah virtualni obrazovky pod danym ukazatelem na skutecnou
obrazovku. Cekani na navrat paprsku ma zabudovane.}
function vgaAllocVirtualScreen(var where:pointer):boolean;
{Pod ukazatelem Where se pokusi alokovat pamet pro virtualni obrazovku.
Vraci true, pokud se to povede, nebo false pri nedostatku pameti.
Jako parametr doporucuji promennou vgaVirtualScreen (pokud zrovna
nepotrebujete vyrobit virtualnich obrazovek vic).}
procedure vgaFreeVirtualScreen(var which:pointer);
{Zrusi danou virtualni obrazovku (uvolni alokovanou pamet).}
procedure vgaSetWindow(minx,miny,maxx,maxy:integer);
{Nastavi velikost orezavaciho okna.}
procedure vgaSetDefaultWindow;
{Nastavi orezavaci okno na celou obrazovku.}

(******************* kreslici procedury bez orezavani: **********************)
    {nakreslene objekty nesmi vycuhovat z obrazovky, jinak bude prusvih}

procedure vgaPutPixel(x,y:word; color:byte);
{vykresli jeden pixel v dane barve na danych souradnicich}
function vgaGetPixel(x,y:word):byte;
{precte a vrati barvu pixelu na danych souradnicich}
procedure vgaHLine(x1,x2,y:word; color:byte);
{nakresli vodorovnou caru z bodu x1,y do bodu x2,y}
procedure vgaVLine(x,y1,y2:word; color:byte);
{nakresli svislou caru z bodu x,y1 do x,y2}
procedure vgaLine(x1,y1,x2,y2:word; color:byte);
{obecna cara z x1,y1 do x2,y2}
procedure vgaBar(x1,y1,x2,y2:word; barva:word);
{vyplneny obdelnik, levy horni roh x1,y1 a pravy dolni x2,y2}
procedure vgaBox(x1,y1,x2,y2,lhbarva,pdbarva,vbarva:word);
{Vyplneny obdelnik s barevnym okrajem. Lhbarva je barva leveho a horniho
okraje, Pdbarva praveho a dolniho a Vbarva je barva vyplne (pokud je 0, vypln
se nekresli).}
procedure vgaFill(color:byte);
{vyplni celou obrazovku danou barvou}

(********************* kreslici procesury s orezavanim: *********************)
      {casti objektu, ktere vycuhuji z orezavaciho okna, se nezobrazi}

procedure _vgaPutPixel(x,y:integer; color:byte);
function _vgaGetPixel(x,y:integer):byte;
procedure _vgaHLine(x1,x2,y:integer;color:byte);
procedure _vgaVLine(x,y1,y2:integer;color:byte);
procedure _vgaLine(x1,y1,x2,y2:integer; color:byte);
procedure _vgaBar(x1,y1,x2,y2:integer; vbarva:byte);
procedure _vgaBox(x1,y1,x2,y2:integer; lhbarva,pdbarva,vbarva:byte);

procedure _vgaEllipse(stredX,stredY:integer; rx,ry:word; barva:byte);
{elipsa o danem stredu, polomerech a barve}
procedure _vgaFilledEllipse(stredX,stredY:integer; rx,ry:word; barva:byte);
{vyplnena elipsa}

(************************** obrazkove procedury: ****************************)

procedure vgaPutSprite(x,y:word; obrazek:pointer);
{Vykresli specialni pruhledny obrazek (pro podrobnosti viz VESA.PAS).
Bez orezavani - obrazek nesmi vycuhovat z obrazovky!}
procedure _vgaPutSprite(x,y:integer; obrazek:pointer);
{Totez, ale orezava podle okna - vycuhovani dovoleno.}

procedure vgaGetImage(x1,y1,x2,y2:word; target:pointer);
{Nacte danou obdelnikovou oblast z obrazovky do predem pripravene dynamicke
promenne pod ukazatelem Target (velikost = sirka * vyska). Nesmi vycuhovat z
obrazovky, jinak nacte kraviny. Orezavaci okno ignoruje.}
procedure vgaPutImage(x1,y1:integer; width,height:word; source:pointer);
{Zobrazi dany obdelnikovy obrazek. X1,y1 je levy horni roh, sirku a vysku je
nutne zadat spravne, jinak bude rozhozeny.
Orezava se podle okna (i kdyz nezacina podtrzitkem).}
procedure vgaPutTImage(x1,y1:integer; width,height:word; source:pointer);
{Vykresli obrazek s vynechanim pixelu s barvou 0. Dost pomala - musi to delat
pixel po pixelu. Orezava podle okna.}

(************************* zobrazovani textu: *******************************)
{Pouziti techto procedur je naprosto stejne jako v jednotce VESA, komentare
tamtez. Jediny rozdil je v implementaci procedury Print.}

const _RidiciKody:byte=1;
      _pouzivat=1;
      _vypisovat=2;
      _preskakovat=3;
      _MeritkoKodu:word=100;

type _FontArray=array[0..0]of byte;
     _UkNaFont=^_fontarray;

     _Font = record
             fVyska:byte;
             fStdX,fStdY,fStdRoztec:byte;
             fData:_uknafont;
             end;

var __velikostX,__velikostY:byte;
    __roztec:word;
    _SirkaTextu,_VyskaTextu:word;
    _DeltaX,_DeltaY:integer;

procedure _NactiFont(var FN:_font; var Soubor:file);
procedure _NactiFont2(var FN:_font; JmenoSouboru:string);
procedure _ZrusFont(var FN:_font);
procedure _NastavFont(var FN:_font; NastavDoporucene:boolean);
procedure _NastavText(velikostX,velikostY,roztec:byte);
procedure _ZmerText(retezec:string);
function _SirkaTextu2(PocetZnaku:byte):word;
function _VyskaTextu2:word;
procedure vgaPrint(ix,iy:integer; barva:byte; textik:string);


implementation(**************************************************************)

uses errmsg,nfsup;

var __Font:_uknafont;
    __Vyska:byte;

procedure startvga;
var vysledek:byte;
Begin
asm
{spusteni grafiky:}
mov AX,$13
int $10
{kontrola, jestli opravdu bezi:}
mov AX,$0F00
int $10
mov vysledek,AL
end;
if vysledek<>$13 then {$ifdef cesky}chyba('Nepovedlo se spustit graficky rezim VGA 13h (320x200, 8 b/px).',0);{$endif}
                    {$ifdef english}chyba('VGA mode 13h (320x200, 8 b/px) could not be initialized.',0);{$endif}
End;{startvga}

procedure vgaPutPixel(x,y:word;color:byte);assembler;
Asm
les DI,vgacilovaoblast; mov BX,y
add DI,x;               shl BX,6
add DI,BX;              mov AL,color
shl BX,2
add DI,BX
mov ES:[DI],AL
End;{vgaputpixel}

function vgaGetPixel(x,y:word):byte; assembler;
Asm
les DI,vgacilovaoblast; mov BX,y
add DI,x;               shl BX,6
add DI,BX
shl BX,2
add DI,BX
mov AL,ES:[DI]
End;{vgagetpixel}

procedure _vgaPutPixel(x,y:integer;color:byte);
Begin
if (x>=vgaMinClipX)and(x<=vgaMaxClipX)and(y>=vgaMinClipY)and(y<=vgaMaxClipY)
  then vgaPutPixel(x,y,color);
End;{_vgaputpixel}

function _vgaGetPixel(x,y:integer):byte;
Begin
if x<vgaminclipx then x:=vgaminclipx
                 else if x>vgamaxclipx then x:=vgamaxclipx;
if y<vgaminclipy then y:=vgaminclipy
                 else if y>vgamaxclipy then y:=vgamaxclipy;
_vgagetpixel:=vgaGetPixel(x,y);
End;{_vgagetpixel}

procedure vgaHLine(x1,x2,y:word; color:byte); assembler;
Asm
les DI,vgacilovaoblast
mov BX,y;               mov CX,y
shl BX,8;               shl CX,6
add DI,x1;              add BX,CX
add DI,BX;              mov CX,x2
sub CX,x1;              mov AL,color
inc CX;                 mov AH,AL
mov BX,AX;              mov DX,CX
db $66; shl AX,16;      shr CX,2
mov AX,BX;              and DX,3
 db $66; rep stosw
mov CX,DX
 rep stosb
End;{vgahline}

procedure vgaVLine(x,y1,y2:word; color:byte); assembler;
Asm
les DI,vgacilovaoblast
mov BX,y1;              mov DX,y1
shl BX,8;               shl DX,6
add DI,x;               add BX,DX
add DI,BX;              mov CX,y2
mov AL,color;           sub CX,y1
inc CX
 @cyklus:
 mov ES:[DI],AL
 add DI,320
 loop @cyklus
End;{vgavline}

procedure vgaLine(x1,y1,x2,y2:word;color:byte); assembler; {prevzato bez kontroly}
        (* This is Bresenham's line *)
var d,_dx,_dy,aincr,bincr,yincr:integer;
Asm
 mov ax,x1
 cmp ax,x2
 je @@Vertical
 jbe @@1                (* if x1>x2 *)
 mov bx,x2
 mov x1,bx
 mov x2,ax              (* swap x1,x2 *)
 mov ax,y1
 mov bx,y2
 mov y1,bx
 mov y2,ax              (* swap y1,y2 *)
@@1:
 mov cx,320
 mov ax,y1
 mov bx,y2
 cmp bx,ax
 ja @@2                 (* if y2>y1 *)
 neg cx                 (* yincr=-320 *)
@@2:
 mov yincr,cx           (* else yincr=320 *)
 sub bx,ax              (* bx <- (y2-y1) *)
 jns @@3
 neg bx
@@3:
 mov _dy,bx             (* _dy=abs(y2-y1) *)
 mov ax,x2
 sub ax,x1
 mov _dx,ax             (* _dx=x2-x1 *)
 cmp ax,bx
 jb @@45                (* if _dx>=_dy *)
 shl bx,1
 mov bincr,bx           (* bincr=2*_dy *)
 sub bx,ax
 mov d,bx               (* d=2*_dy-_dx *)
 mov ax,_dy
 sub ax,_dx
 jmp @@Continue
@@45:                   (* else *)
 shl ax,1
 mov bincr,ax           (* bincr=2*_dx *)
 sub ax,bx
 mov d,ax               (* d=2*_dx-_dy *)
 mov ax,_dx
 sub ax,_dy
@@Continue:
 sal ax,1
 mov aincr,ax           (* aincr=2*(_dx-_dy) or aincr=2*(_dy-_dx) *)

 les DI,vgacilovaoblast
 mov bx,y1
 add di,x1
 shl bx,6
 add di,bx
 shl bx,2
 add di,bx
 mov bl,color
 mov es:[di],bl         (* PutPixel(x,y) *)

 mov dx,yincr
 mov ax,_dx
 cmp ax,_dy
 jb @@LessThen45

@@6:
 inc di                 (* x+=1 *)
 inc x1
 mov ax,d
 cmp ax,0
 js @@4                 (* if d>=0 *)
 add di,dx              (* y+=yincr *)
 add ax,aincr           (* d+=aincr *)
 jmp @@5
@@4:                    (* else *)
 add ax,bincr           (* d+=bincr *)
@@5:
 mov d,ax
 mov es:[di],bl         (* PutPixel(x,y) *)

 mov ax,x2
 cmp ax,x1
 ja @@6                 (* if x<x2 then loop *)
 jmp @@Exit

@@LessThen45:
 xor dx,0
 jns @@Positive
 mov cx,-1
 jmp @@6_
@@Positive:
 mov cx,1
@@6_:
 add di,dx              (* y+=yinc *)
 add y1,cx
 mov ax,d
 cmp ax,0
 js @@4_                (* if d>=0 *)
 inc di                 (* x+=1 *)
 add ax,aincr           (* d+=aincr *)
 jmp @@5_
@@4_:                   (* else *)
 add ax,bincr           (* d+=bincr *)
@@5_:
 mov d,ax
 mov es:[di],bl         (* PutPixel(x,y) *)

 mov ax,y2
 cmp ax,y1
 jne @@6_               (* if y<y2 then loop *)
 jmp @@Exit

@@Vertical:             (* draw vertical line *)
 mov ax,y1
 cmp ax,y2
 jbe @@7                (* if y1>y2 *)
 mov bx,y2
 mov y1,bx
 mov y2,ax              (* swap y1,y2 *)
@@7:
 les DI,vgacilovaoblast
 add di,x1
 mov bx,y1
 shl bx,6
 add di,bx
 shl bx,2
 add di,bx
 mov al,color           (* al <- color *)
 mov cx,y2
 sub cx,y1
 inc cx                 (* cx <- number of pixels *)
 mov dx,320
@@8:
 mov es:[di],al         (* fill line *)
 add di,dx
 loop @@8

@@Exit:
End;{vgaline}

procedure vgaBox(x1,y1,x2,y2:word; lhbarva,pdbarva,vbarva:word);
Begin
vgahline(x1,x2,y1,lhbarva);
vgavline(x1,y1,y2,lhbarva);
vgavline(x2,y1,y2,pdbarva);
vgahline(x1,x2,y2,pdbarva);
if (vbarva<>0)and(x2-x1>=2)and(y2-y1>=2) then vgabar(x1+1,y1+1,x2-1,y2-1,vbarva);
End;{vgabox}

procedure vgaFill(color:byte);assembler;
Asm
les DI,vgacilovaoblast
mov AL,color;      mov CX,16000
mov AH,AL
mov BX,AX
db $66; shl AX,16
mov AX,BX
db $66; rep stosw
End;{vgafill}

procedure _vgaEllipse(stredX,stredY:integer; rx,ry:word;barva:byte);
var x,y:word;
    a,b,as,tas,bs,tbs:longint;
    d,dx,dy:longint;
Begin
if rx=0 then begin
             _vgaVLine(stredx,stredy-ry,stredy+ry,barva);
             Exit;
             end;
if ry=0 then begin
             _vgaHLine(stredx-rx,stredx+rx,stredy,barva);
             Exit;
             end;
x:=0; y:=ry; a:=rx; b:=ry; as:=a*a;
tas:=as shl 1; bs:=b*b; tbs:=bs shl 1;
d:=bs-as*b+(as shr 2); dx:=0; dy:=tas*b;
while dx<dy do begin
               _vgaPutPixel(stredx+x,stredy+y,barva);
               _vgaPutPixel(stredx-x,stredy+y,barva);
               _vgaPutPixel(stredx+x,stredy-y,barva);
               _vgaPutPixel(stredx-x,stredy-y,barva);
               if d>0 then begin y:=y-1; dy:=dy-tas; d:=d-dy; end;
               Inc(x); dx:=dx+tbs; d:=d+bs+dx;
               end;
d:=d+((3*(as-bs)div 2-(dx+dy))div 2);
while y>0 do begin
             _vgaPutPixel(stredx+x,stredy+y,barva);
             _vgaPutPixel(stredx-x,stredy+y,barva);
             _vgaPutPixel(stredx+x,stredy-y,barva);
             _vgaPutPixel(stredx-x,stredy-y,barva);
             if d<0 then begin Inc(x); dx:=dx+tbs; d:=d+dx; end;
             y:=y-1; dy:=dy-tas; d:=d+as-dy;
             end;
_vgaPutPixel(stredx+x,stredy,barva);
_vgaPutPixel(stredx-x,stredy,barva);
End;{_vgaellipse}

procedure _vgaFilledEllipse(stredX,stredY:integer; rx,ry:word; barva:byte);
var x,y:word;
    a,b,as,tas,bs,tbs:longint;
    d,dx,dy:longint;
Begin
if rx=0 then begin
             _vgaVLine(stredX,stredY-ry,stredY+ry,barva);
             Exit;
             end;
if ry=0 then begin
             _vgaHLine(stredX-rx,stredX+rx,stredY,barva);
             Exit;
             end;
x:=0; y:=ry; a:=rx; b:=ry; as:=a*a;
tas:=as shl 1; bs:=b*b; tbs:=bs shl 1;
d:=bs-as*b+(as shr 2); dx:=0; dy:=tas*b;
while dx<dy do begin
               _vgaHLine(stredX-x,stredX+x,stredY+y,barva);
               _vgaHLine(stredX-x,stredX+x,stredY-y,barva);
               if d>0 then begin y:=y-1; dy:=dy-tas; d:=d-dy; end;
               Inc(x); dx:=dx+tbs; d:=d+bs+dx;
               end;
d:=d+((3*(as-bs)div 2-(dx+dy))div 2);
while y>0 do begin
             _vgaHLine(stredX-x,stredX+x,stredY+y,barva);
             _vgaHLine(stredX-x,stredX+x,stredY-y,barva);
             if d<0 then begin Inc(x); dx:=dx+tbs; d:=d+dx; end;
             y:=y-1; dy:=dy-tas; d:=d+as-dy;
             end;
_vgaHLine(stredX-x,stredX+x,stredY,barva);
End;{_vgafilledellipse}

procedure xchange(var a,b:integer);
var c:integer;
Begin
c:=a; a:=b; b:=c;
End;{xchange}

function ClipLine(var x1,y1,x2,y2:integer):boolean;
{Orizne souradnice cary podle okna. Vraci true, pokud z cary zbyl aspon
kousek, ktery by sel zobrazit. Komentare - viz VESA.PAS.}
Begin
 repeat
 if (x1>=vgaminclipx)and(x1<=vgamaxclipx)and
    (x2>=vgaminclipx)and(x2<=vgamaxclipx)and
    (y1>=vgaminclipy)and(y1<=vgamaxclipy)and
    (y2>=vgaminclipy)and(y2<=vgamaxclipy) then begin
                                               clipline:=true;
                                               break;
                                               end;
 if (x1<vgaminclipx)and(x2<vgaminclipx)or
    (x1>vgamaxclipx)and(x2>vgamaxclipx)or
    (y1<vgaminclipy)and(y2<vgaminclipy)or
    (y1>vgamaxclipy)and(y2>vgamaxclipy) then begin
                                             clipline:=false;
                                             break;
                                             end;
 if x1<vgaminclipx then begin
                        y1:=y1+longint(y2-y1)*(vgaMinClipX-x1)div(x2-x1);
                        x1:=vgaMinClipX;
                        end
   else if y1<vgaminclipy then begin
                               x1:=x1+longint(x2-x1)*(vgaMinClipY-y1)div(y2-y1);
                               y1:=vgaMinClipY;
                               end
    else if x1>vgamaxclipx then begin
                                y1:=y1+longint(y2-y1)*(vgaMaxClipX-x1)div(x2-x1);
                                x1:=vgaMaxClipX;
                                end
     else if y1>vgamaxclipy then begin
                                 x1:=x1+longint(x2-x1)*(vgaMaxClipY-y1)div(y2-y1);
                                 y1:=vgaMaxClipY;
                                 end
      else begin
           xchange(x1,x2);
           xchange(y1,y2);
           end;
 until false;
End;{clipline}

procedure _vgaLine(x1,y1,x2,y2:integer; color:byte);
Begin
if ClipLine(x1,y1,x2,y2) then vgaLine(x1,y1,x2,y2,color);
End;{_vgaline}

procedure _vgaHLine(x1,x2,y:integer;color:byte);
Begin
if (y<vgaMinClipY)or(y>vgaMaxClipY)or(x1>vgaMaxClipX)or(x2<vgaMinClipX) then exit;
if x1<vgaMinClipX then x1:=vgaMinClipX;
if x2>vgaMaxClipX then x2:=vgaMaxClipX;
vgaHLine(x1,x2,y,color);
End;{_vgahline}

procedure _vgaVLine(x,y1,y2:integer; color:byte);
Begin
if (x<vgaMinClipX)or(x>vgaMaxClipX)or(y1>vgaMaxClipY)or(y2<vgaMinClipY) then exit;
if y1<vgaMinClipY then y1:=vgaMinClipY;
if y2>vgaMaxClipY then y2:=vgaMaxClipY;
vgaVLine(x,y1,y2,color);
End;{_vgavline}

procedure _vgaBar(x1,y1,x2,y2:integer; vbarva:byte);
Begin
if (x1>vgaMaxClipX)or(y1>vgaMaxClipY)or(x2<vgaMinClipX)or(y2<vgaMinClipY) then Exit;
if x1<vgaMinClipX then x1:=vgaMinClipX;
if y1<vgaMinClipY then y1:=vgaMinClipY;
if x2>vgaMaxClipX then x2:=vgaMaxClipX;
if y2>vgaMaxClipY then y2:=vgaMaxClipY;
vgaBar(x1,y1,x2,y2,vbarva);
End;{_vgabar}

procedure _vgaBox(x1,y1,x2,y2:integer; lhbarva,pdbarva,vbarva:byte);
Begin
_vgaHLine(x1,x2,y1,lhbarva);
_vgaVLine(x1,y1,y2,lhbarva);
_vgaVLine(x2,y1,y2,pdbarva);
_vgaHLine(x1,x2,y2,pdbarva);
if vbarva<>0 then begin
                  if (x1>=vgaMaxClipX)or(y1>=vgaMaxClipY)or(x2<=vgaMinClipX)or(y2<=vgaMinClipY) then exit;
                  if x1<vgaMinClipX-1 then x1:=vgaMinClipX-1;
                  if y1<vgaMinClipY-1 then y1:=vgaMinClipY-1;
                  if x2>vgaMaxClipX+1 then x2:=vgaMaxClipX+1;
                  if y2>vgaMaxClipY+1 then Y2:=vgaMaxClipY+1;
                  vgaBar(x1+1,y1+1,x2-1,y2-1,vbarva);
                  end;
End;{_vgabox}

procedure vgaGetImage(x1,y1,x2,y2:word; target:pointer); assembler;
Asm
mov AX,y1;               push DS
shl AX,6;                lds SI,vgacilovaoblast
add SI,AX;               les DI,target    {ES:DI = cil}
shl AX,2;                mov DX,y2
add SI,AX;               sub DX,y1
add SI,x1;               inc DX       {DS:SI = levy horni roh}
mov AX,x2;               mov y1,DX    {y1 = vyska (mirne zneuziti promenne)}
sub AX,x1;               mov BX,320
inc AX;                               {AX = sirka}
sub BX,AX;               mov DX,AX    {BX = vzdalenost mezi koncem jednoho radku a zacatkem dalsiho}
shr DX,2;                and AX,3     {DX = dwordy; AX = byty}
 @cyklus:
 mov CX,DX
  db $66; rep movsw
 mov CX,AX
  rep movsb
 add SI,BX
 dec y1
 jnz @cyklus
pop DS
End;{vgagetimage}

procedure vgaPutImage(x1,y1:integer; width,height:word; source:pointer); assembler;
var TopCut,LeftCut,RightCut,OldWidth:word;
Asm
mov AX,width
mov OldWidth,AX
{vrsek:}
mov AX,y1
mov TopCut,0
cmp AX,vgaMaxClipY
jg @Exit
cmp AX,vgaMinClipY
jge @NahoreBezOriznuti
 mov BX,vgaMinClipY
 mov y1,BX
 sub BX,AX
 mov TopCut,BX
 sub height,BX
@NahoreBezOriznuti:
{spodek:}
mov AX,y1
add AX,height
dec AX
cmp AX,vgaMinClipY
jl @Exit
cmp AX,vgaMaxClipY
jle @DoleBezOriznuti
 mov BX,vgaMaxClipY
 sub BX,y1
 inc BX
 mov height,BX
@DoleBezOriznuti:
{levo:}
mov AX,x1
mov LeftCut,0
cmp AX,vgaMaxClipX
jg @Exit
cmp AX,vgaMinClipX
jge @VlevoBezOriznuti
 mov BX,vgaMinClipX
 mov x1,BX
 sub BX,AX
 mov LeftCut,BX
 sub width,BX
@VlevoBezOriznuti:
{pravo:}
mov AX,x1
mov RightCut,0
add AX,width
dec AX
cmp AX,vgaMinClipX
jl @Exit
cmp AX,vgaMaxClipX
jle @VpravoBezOriznuti
 mov BX,vgaMaxClipX
 sub BX,x1
 inc BX
 sub AX,vgaMaxClipX
 mov width,BX
 mov RightCut,AX
@VpravoBezOriznuti:
{zbytek:}
les DI,vgacilovaoblast
mov BX,y1
add DI,x1
shl BX,6
add DI,BX
shl BX,2
push DS
add DI,BX
lds SI,source
mov AX,TopCut
mul OldWidth
add SI,AX
add SI,LeftCut
mov AX,LeftCut
mov DX,320
add AX,RightCut
sub DX,width
mov BX,width
{kreslici cyklus:}
 @cyklus:
 mov CX,BX
 shr CX,2
  db $66; rep movsw
 mov CX,BX
 and CX,3
  rep movsb
 add DI,DX
 add SI,AX
 dec height
 jnz @cyklus
pop DS
@Exit:
End;{vgaputimage}

procedure vgaPutTImage(x1,y1:integer; width,height:word; source:pointer); assembler;
var TopCut,LeftCut,RightCut,OldWidth:word;
Asm
mov AX,width
mov OldWidth,AX
{vrsek:}
mov AX,y1
mov TopCut,0
cmp AX,vgaMaxClipY
jg @Exit
cmp AX,vgaMinClipY
jge @NahoreBezOriznuti
 mov BX,vgaMinClipY
 mov y1,BX
 sub BX,AX
 mov TopCut,BX
 sub height,BX
@NahoreBezOriznuti:
{spodek:}
mov AX,y1
add AX,height
dec AX
cmp AX,vgaMinClipY
jl @Exit
cmp AX,vgaMaxClipY
jle @DoleBezOriznuti
 mov BX,vgaMaxClipY
 sub BX,y1
 inc BX
 mov height,BX
@DoleBezOriznuti:
{levo:}
mov AX,x1
mov LeftCut,0
cmp AX,vgaMaxClipX
jg @Exit
cmp AX,vgaMinClipX
jge @VlevoBezOriznuti
 mov BX,vgaMinClipX
 mov x1,BX
 sub BX,AX
 mov LeftCut,BX
 sub width,BX
@VlevoBezOriznuti:
{pravo:}
mov AX,x1
mov RightCut,0
add AX,width
dec AX
cmp AX,vgaMinClipX
jl @Exit
cmp AX,vgaMaxClipX
jle @VpravoBezOriznuti
 mov BX,vgaMaxClipX
 sub BX,x1
 inc BX
 sub AX,vgaMaxClipX
 mov width,BX
 mov RightCut,AX
@VpravoBezOriznuti:
{zbytek:}
les DI,vgacilovaoblast
mov BX,y1
add DI,x1
shl BX,6
add DI,BX
shl BX,2
push DS
add DI,BX
lds SI,source
mov AX,TopCut
mul OldWidth
add SI,AX
add SI,LeftCut
mov AX,LeftCut
mov DX,320
add AX,RightCut
sub DX,width
mov BX,width
{kreslici cyklus:}
 @cyklus:
 mov CX,BX
 push AX            {xxx jeste musim nejak prehazet registry, aby se nemuselo delat tohle}
 or CX,CX
 jz @NeniCoKreslit
  @kresleni:
  lodsb
  or AL,AL
  jz @dira
   mov ES:[DI],AL
  @dira:
  inc DI
  loop @kresleni
 @NeniCoKreslit:
 add DI,DX
 pop AX
 add SI,AX
 dec height
 jnz @cyklus
pop DS
@Exit:
End;{vgaputimage}

procedure vgaVSync; assembler;
Asm
mov DX,$3DA
 @repeat:
 in AL,DX
 test AL,8
 jz @repeat
End;{vgavsync}

procedure endvga; assembler;
Asm
mov AX,3
int $10
End;{endvga}

procedure vgaSetWindow(minx,miny,maxx,maxy:integer);
Begin
if minx<0 then vgaminclipx:=0
          else vgaminclipx:=minx;
if miny<0 then vgaminclipy:=0
          else vgaminclipy:=miny;
if maxx>319 then vgamaxclipx:=319
            else vgamaxclipx:=maxx;
if maxy>199 then vgamaxclipy:=199
              else vgamaxclipy:=maxy;
End;{vgasetwindow}

procedure vgaSetDefaultWindow; assembler;
Asm
mov vgaMinClipX,0
mov vgaMinClipY,0
mov vgaMaxClipX,319
mov vgaMaxClipY,199
End;{vgasetdefaultwindow}

function vgaAllocVirtualScreen(var where:pointer):boolean;
Begin
if maxavail>=64000 then begin
                        getmem(where,64000);
                        fillchar(where^,64000,0);
                        vgaallocvirtualscreen:=true;
                        end
                   else vgaallocvirtualscreen:=false;
End;{vgaallocvirtualscreen}

procedure vgaFreeVirtualScreen(var which:pointer);
Begin
if which<>nil then begin
                   freemem(which,64000);
                   which:=nil;
                   end;
End;{vgafreevirtualscreen}

procedure vgaSetVirtualOutput(target:pointer);
Begin
vgacilovaoblast:=target;
End;{vgasetvirtualoutput}

procedure vgaSetNormalOutput;
Begin
vgacilovaoblast:=ptr($A000,0);
End;{vgasetnormaloutput}

procedure vgaswap(source:pointer); assembler;
Asm
call vgavsync
push DS;              mov AX,$A000
lds SI,source;        mov ES,AX
xor DI,DI;            mov CX,16000
db $66; rep movsw;
pop DS
End;{vgaswap}

procedure vgaBar(x1,y1,x2,y2:word; barva:word); assembler;
Asm
les DI,vgacilovaoblast; mov AX,y1
add DI,x1;              mov BX,AX
shl AX,6;               shl BX,8;
add DI,AX;              mov CX,x2
add DI,BX;              sub CX,x1
mov DX,319;             mov AX,barva
sub DX,CX;              mov AH,AL          {DX = prirustek ofsetu mezi radky}
inc CX;                 push AX            {CX = delka radku}
mov BX,y2;              db $66; shl AX,16
sub BX,y1;              pop AX
inc BX;                 mov SI,CX
mov y1,BX;              and SI,3           {y1 = kolik radku se bude kreslit}
shr CX,2                                   {CX = dwordy, SI = byty}
mov BX,CX                                  {BX = dwordy}
 @cyklus:
  db $66; rep stosw
 mov CX,SI
  rep stosb
 add DI,DX;             mov CX,BX
 dec y1
 jnz @cyklus
End;{vgabar}

procedure vgaPutSprite(x,y:word; obrazek:pointer); assembler;
var refDI:word; {ofset bodu x,y v cilove oblasti}
Asm
push DS
les DI,vgacilovaoblast      {ES:DI = adresa cilove oblasti}
lds SI,obrazek              {DS:SI = adresa zacatku spritu}
mov DX,[SI]                 {delka spritu}
add DX,SI                   {DX = ofset prvniho bytu za koncem spritu}
mov BX,y;            add SI,2
mov AX,y;            shl BX,6
shl AX,8;            add BX,x
add BX,AX;           dec DX
add BX,DI
mov refDI,BX                      {ES:refDI = adresa bodu x,y}
 @cyklus:
 mov DI,refDI;        lodsw {x}
 add DI,AX  {+x}
 lodsw      {y}
 mov BX,AX
 shl AX,8;           shl BX,6 {*320}
 add DI,AX
 add DI,BX  {ES:DI = adresa zacatku useku v cilove oblasti}
 lodsw      {delka useku}
 mov CX,AX
 shr CX,2;           and AX,3      {CX = dwordy, AX = byty}
  db $66; rep movsw   {rep movsd}
 mov CX,AX
  rep movsb
 cmp SI,DX  {uz jsme za koncem spritu?}
 jb @cyklus {jestli ne, jdeme zpracovat dalsi usek}
pop DS
End;{vgaputsprite}

procedure _vgaPutsprite(x,y:integer; obrazek:pointer);
(*var LHDI,{ofset leveho horniho rohu obrazku na obrazovce}
    OriznutiVlevo, OriznutiNahore, {o kolik se obrazek vlevo a nahore orizne}
    MaxX,MaxY, {pro zalohu vgamaxclipx a vgamaxclipy (protoze prepsanim DS ztratime pristup ke globalnim promennym)}
    SOL,{Skutecne Oriznuti zLeva (o kolik budou vlevo oriznuty jednotlive radky)}
    SDX,{Skutecne Delta X (xova souradnice zacatku jednotlivych radku od orizleho x obrazku}
    MaxOfset:word;{ofset prvniho bytu za koncem obrazku (abychom vedeli, kdy prestat)}*)
type HlavickaRadku = record
                     x,y:integer; {souradnice od referencniho bodu}
                     delka:word; {delka radku v px}
                     data:array[0..0] of byte; {obrazova data radku (delka je dynamicka)}
                     end;
     polebytu=array[0..0] of byte;
var index,OriznutiVlevo:word;
    SkutX,SkutY,SkutDelka,pom:integer;
    hr:^hlavickaradku;
Begin
index:=2;
while index<word(obrazek^) do
 begin
 hr:=@(polebytu(obrazek^)[index]);
 skutx:=x+hr^.x; skuty:=y+hr^.y;
 if (skuty>=vgaminclipy)and(skuty<=vgamaxclipy)and(skutx<=vgamaxclipx)
   then begin
        skutdelka:=hr^.delka;
        if skutx<vgaminclipx then begin
                                  oriznutivlevo:=vgaminclipx-skutx;
                                  dec(skutdelka,oriznutivlevo);
                                  skutx:=vgaminclipx;
                                  end
                             else oriznutivlevo:=0;
        if skutdelka>0
          then begin
               pom:=skutx+skutdelka-1-vgamaxclipx;
               if pom>0 then dec(skutdelka,pom);
               if skutdelka>0 then move32(hr^.data[oriznutivlevo],
                                          polebytu(vgacilovaoblast^)[320*skuty+skutx],
                                          skutdelka);
               end;
        end;
 inc(index,6+hr^.delka);
 end;
(*
if x<vgaminclipx then begin
                      oriznutivlevo:=vgaminclipx-x;
                      x:=vgaminclipx;
                      end
                 else oriznutivlevo:=0;
if y<vgaminclipy then begin
                      oriznutinahore:=vgaminclipy-y;
                      y:=vgaminclipy;
                      end
                 else oriznutinahore:=0;
{Ted mame x a y urcite nezaporne.
- pokud obrazek vlevo/nahore nevycuhuje, x/y se nezmeni a oriznuti = 0
- pokud vycuhuje, x/y = 0 a oriznuti = o kolik vycuhuje}
maxx:=vgamaxclipx; maxy:=vgamaxclipy; {zaloha}
asm
push DS
les DI,vgacilovaoblast   {ES:DI = obrazovka}
lds SI,obrazek    {DS:SI = adresa obrazku}
mov AX,[SI]       {AX = delka dat}
add AX,SI         {AX = ofset za koncem obrazku}
mov maxofset,AX   {maxofset = -''-}
add SI,2          {SI = ofset zacatku prvniho useku}
mov AX,y
mov BX,AX
shl BX,6;  shl AX,8
add BX,x
add BX,AX
add BX,DI
mov lhdi,BX       {ES:lhdi = adresa leveho horniho rohu obrazku na obrazovce}
 @cyklus:
 mov DI,lhdi             {DI = ofset leveho horniho rohu obrazku na obrazovce}
 {x:}
 lodsw
 mov BX,AX               {AX = BX = x pocitane od neorizleho leveho okraje}
 xor CX,CX               {CX = 0}
 sub AX,oriznutivlevo    {AX = x od orizleho leveho okraje (nebo podtekle)}
 jnc @BezOriznutiVlevo
  mov CX,oriznutivlevo
  xor AX,AX
  sub CX,BX
 @BezOriznutiVlevo:
 mov sol,CX              {sol = CX = skutecne oriznuti radku zleva}
 mov sdx,AX              {sdx = AX = skutecne x od orizleho leveho okraje}
 add DI,AX               {DI = xovy ofset skutecneho zacatku radku (zbyva pridat y)}
 {x zacatku radku je jasne, ted kontrola, jestli neni za pravym okrajem okna:}
 add AX,x                {AX = skutecne x zacatku radku}
 cmp AX,maxx
 jle @NeniMimo
  lodsw      {AX = y}
  lodsw      {AX = delka}
  add SI,AX  {radek preskocen}
  jmp @ZaverCyklu
 @NeniMimo:
 {y:}
 lodsw                   {AX = y pocitane od neorizleho horniho okraje}
 sub AX,oriznutinahore   {AX = y pocitane od orizleho horniho okraje (nebo podtekle)}
 jnc @NahoreOK
  @CouhaDole:
  lodsw             {AX = delka radku}
  add SI,AX         {radek preskocen}
  jmp @ZaverCyklu
 @NahoreOK:
 mov CX,AX               {CX = AX = y pocitane od orizleho horniho okraje}
 add AX,y                {AX = skutecne y radku}
 cmp AX,maxy
 jg @CouhaDole
 mov AX,CX               {AX = CX = y pocitane od orizleho horniho okraje}
 shl AX,6; shl CX,8
 add DI,AX
 add DI,CX               {DI = kompletni ofset zacatku radku}
 {delka:}
 lodsw
 mov CX,AX               {CX = AX = delka celeho radku}
 sub AX,sol              {AX = delka po oriznuti zleva}
 jnc @JesteZbylo
  add SI,CX       {preskoceni celeho radku}
  jmp @ZaverCyklu
 @JesteZbylo:
 add SI,sol              {preskoceni odrizleho zacatku radku}
 {levy konec vyrizen}
 mov BX,x                {BX = orizle x obrazku}
 add BX,sdx              {BX = skutecne x zacatku radku}
 add BX,AX               {BX = x za koncem radku}
 dec BX                  {BX = x konce radku}
 sub BX,maxx
 jg @VpravoOrezavame
  xor BX,BX
 @VpravoOrezavame:       {BX = kolik se odrizne zprava}
 sub AX,BX               {AX = skutecna delka, ktera se bude kreslit}
 {pravy konec vyrizen, muzeme kreslit:}
 mov CX,AX
 shr CX,2; and AX,3      {CX = dwordy, AX = byty}
  db $66; rep movsw
 mov CX,AX               {CX = byty}
  rep movsb
 {radek vykreslen}
 add SI,BX               {preskoceni pripadneho odrizleho konce radku}
 @ZaverCyklu:
 cmp SI,maxofset         {uz jsme za koncem obrazku?}
 jl @cyklus
pop DS
end;*)
End;{_vgaputsprite}


procedure _NastavFont(var fn:_font; NastavDoporucene:boolean);
Begin
__font:=fn.fdata;
__vyska:=fn.fvyska;
if NastavDoporucene then with fn do _nastavtext(fstdx,fstdy,fstdroztec);
End;{_nastavfont}

procedure _NastavText(velikostx,velikosty,roztec:byte);
Begin
if velikostx<>0 then __velikostx:=velikostx;
if velikosty<>0 then __velikosty:=velikosty;
if roztec<>0 then __roztec:=roztec;
End;{_nastavtext}

procedure _NactiFont(var FN:_font; var Soubor:file);
var velikost:word;
    b:byte;
Begin
fn.fdata:=nil;
blockread(soubor,fn.fvyska,1);
velikost:=256*fn.fvyska;
if (ioresult<>0)or(velikost>maxavail) then exit;
getmem(fn.fdata,velikost);
blockread(soubor,fn.fstdroztec,1);
blockread(soubor,b,1);
fn.fstdx:=b and 15;
fn.fstdy:=b shr 4;
blockread(soubor,fn.fdata^,velikost);
if ioresult<>0 then begin
                    freemem(fn.fdata,velikost);
                    fn.fdata:=nil;
                    end;
End;{_nactifont}

procedure _NactiFont2(var FN:_font; JmenoSouboru:string);
var f:file;
Begin
assign(f,jmenosouboru);
reset(f,1);
_nactifont(fn,f);
close(f);
if ioresult<>0 then ;
End;{_nactifont2}

procedure _ZrusFont(var fn:_font);
Begin
if fn.fdata<>nil then begin
                      freemem(fn.fdata,fn.fvyska*256);
                      fn.fdata:=nil; fn.fvyska:=0;
                      end;
End;{_zrusfont}

const MaleKody:set of char=['b','z','x','y','r','h','v']; {6znakove}
      VelkeKody:set of char=['B','Y','R','H','V','0']; {3znakove}

procedure vgaprint(ix,iy:integer;barva:byte;textik:string);
var PoziceVRetezci,znak:word;
    CisloRadku,IndexY,radek,pvx,pvy,pr,pbarva:byte;
    y,i,JakToDopadlo,piy:integer;
    kod:char;
Begin
if (textik='')or(__font=nil)or(ix+__velikostx shl 3>=vgamaxclipx)or(iy>vgamaxclipy) then exit;
if _ridicikody=_pouzivat then begin
                              pvx:=__velikostx;
                              pvy:=__velikosty;
                              pr:=__roztec;
                              pbarva:=barva;
                              piy:=iy;
                              end;
PoziceVRetezci:=1;
 repeat {cyklus pro kazdy znak retezce}
 znak:=$FFFF;
 if (_ridicikody<>_vypisovat)and
    (textik[pozicevretezci]='%')and
    (pozicevretezci+2<=byte(textik[0]))and
    (textik[pozicevretezci+1]='%')
   then begin
        kod:=textik[pozicevretezci+2];
        if kod in malekody
          then begin
               if pozicevretezci+5<=byte(textik[0]) then
                 begin
                 val(copy(textik,pozicevretezci+3,3),i,jaktodopadlo);
                 if jaktodopadlo=0 then
                   begin
                   if _ridicikody=_pouzivat then
                     case kod of 'b':barva:=i;
                                 'x':inc(ix,i*_meritkokodu div 100);
                                 'y':inc(iy,i*_meritkokodu div 100);
                                 'r':__roztec:=i*_meritkokodu div 100;
                                 'h':__velikostx:=i*_meritkokodu div 100;
                                 'v':__velikosty:=i*_meritkokodu div 100;
                                 'z':znak:=i;
                                 end;
                   inc(pozicevretezci,5);
                   if kod<>'z' then begin
                                    inc(pozicevretezci);
                                    continue;
                                    end;
                   end;
                 end;
               end
          else if kod in velkekody
                 then begin
                      if _ridicikody=_pouzivat
                        then case kod of 'B':barva:=pbarva;
                                         'Y':iy:=piy;
                                         'R':__roztec:=pr;
                                         'H':__velikostx:=pvx;
                                         'V':__velikosty:=pvy;
                                         '0':begin
                                             barva:=pbarva;
                                             iy:=piy;
                                             __roztec:=pr;
                                             __velikostx:=pvx;
                                             __velikosty:=pvy;
                                             end;
                                         end;
                      inc(pozicevretezci,3);
                      continue;
                      end;
        end;
 if (ix>=vgaminclipx)and(ix+__velikostx shl 3-1<=vgamaxclipx)and
    (__velikostx<>0)and(__velikosty<>0) then
 for CisloRadku:=0 to __vyska-1 do
  begin
  if znak=$FFFF then radek:=__font^[__vyska*byte(textik[PoziceVRetezci])+cisloradku]
                else radek:=__font^[__vyska*znak+cisloradku];
  for indexY:=0 to __velikostY-1 do
   begin
   y:=iy+cisloradku*__velikostY+indexY;
   if (y>=vgaminclipy)and(y<=vgamaxclipy)
     then asm
          mov AX,y
          les DI,vgacilovaoblast
          shl AX,6
          add DI,AX
          mov BX,8
          shl AX,2
          add DI,AX
          mov DL,radek
          add DI,ix
          mov AL,barva
          mov CL,__velikostX
           @ProKazdyPixelRadku:
           rol DL,1
           jc @PixelBude
            add DI,CX
            dec BX
            jnz @ProKazdyPixelRadku
            jmp @hotovo
           @PixelBude:
            rep stosb
            mov CL,__velikostX
            dec BX
            jnz @ProKazdyPixelRadku
           @hotovo:
          end
   end;
  end;
 inc(ix,__roztec);
 inc(pozicevretezci);
 until (pozicevretezci>length(textik))or(ix>=vgamaxclipx-__velikostx shl 3);
if _ridicikody=_pouzivat then begin
                              __velikostx:=pvx;
                              __velikosty:=pvy;
                              __roztec:=pr;
                              end;
End;{vgaprint}

function _SirkaTextu2(PocetZnaku:byte):word;
Begin
if pocetznaku=0 then _sirkatextu2:=0
                else if __roztec>8 then _sirkatextu2:=(pocetznaku-1)*__roztec+__velikostx shl 3
                                   else _sirkatextu2:=pocetznaku*__roztec;
End;{_sirkatextu2}

function _VyskaTextu2:word;
Begin
_vyskatextu2:=__velikosty*__vyska;
End;{_vyskatextu2}

procedure _ZmerText(retezec:string);
var Pozice,vx,vy:byte;
    maxX,maxY,x,y,druha,JakToDopadlo,cislo:integer;
    kod:char;
    r:word;
Begin
if retezec='' then begin
                   _SirkaTextu:=0;
                   _VyskaTextu:=__vyska*__velikosty;
                   _DeltaX:=0;
                   _DeltaY:=0;
                   exit;
                   end;
if _ridicikody=_vypisovat then begin
                               _deltax:=0; _deltay:=0;
                               _sirkatextu:=_sirkatextu2(byte(retezec[0]));
                               _vyskatextu:=_vyskatextu2;
                               exit;
                               end;
pozice:=1;
_deltax:=0; maxx:=0;
_deltay:=0; maxy:=0;
x:=0;    y:=0;
vx:=__velikostx; vy:=__velikosty; r:=__roztec;
 repeat
 if (retezec[pozice]='%')and(pozice+2<=byte(retezec[0]))and(retezec[pozice+1]='%')
   then begin
        kod:=retezec[pozice+2];
        if kod in malekody
          then begin
               if pozice+5<=byte(retezec[0]) then
                 begin
                 val(copy(retezec,pozice+3,3),cislo,jaktodopadlo);
                 if jaktodopadlo=0 then
                   begin
                   if _ridicikody=_pouzivat then
                     case kod of 'x':inc(x,cislo*_meritkokodu div 100);
                                 'y':inc(y,cislo*_meritkokodu div 100);
                                 'r':r:=cislo*_meritkokodu div 100;
                                 'h':vx:=cislo*_meritkokodu div 100;
                                 'v':vy:=cislo*_meritkokodu div 100;
                                 end;
                   inc(pozice,5);
                   if kod<>'z' then begin
                                    inc(pozice);
                                    continue;
                                    end;
                   end;
                 end;
               end
          else if kod in velkekody
                 then begin
                      if _ridicikody=_pouzivat
                        then case kod of 'Y':y:=0;
                                         'R':r:=__roztec;
                                         'H':vx:=__velikostx;
                                         'V':vy:=__velikosty;
                                         '0':begin
                                             y:=0;
                                             r:=__roztec;
                                             vx:=__velikostx;
                                             vy:=__velikosty;
                                             end;
                                         end;
                      inc(pozice,3);
                      continue;
                      end;
        end;
 if x<_deltax then _deltax:=x;
 druha:=x+(vx shl 3)-1;
 if druha>maxx then maxx:=druha;
 if y<_deltay then _deltay:=y;
 druha:=y+vy*__vyska-1;
 if druha>maxy then maxy:=druha;
 inc(x,r);
 inc(pozice);
 until pozice>byte(retezec[0]);
_sirkatextu:=maxx-_deltax+1;
_vyskatextu:=maxy-_deltay+1;
End;{_zmertext}


BEGIN
__font:=nil; __vyska:=0; __velikostX:=1; __velikostY:=1; __roztec:=8;
_deltax:=0; _deltay:=0; _sirkatextu:=0; _vyskatextu:=0;
vgasetnormaloutput;
vgasetdefaultwindow;
END.