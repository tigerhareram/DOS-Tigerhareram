{$A+,B+,F-,G+,I-,O+,P+,Q-,R-,S-,T-,V-,X+,Y-}
{****************************************************************************
 * Author           : Stefan Goehler, Germany                               *
 *******                                                                    *
 * my mail-adress   : stefan.goehler@gmx.de                                 *
 * my homepage      : http://www.crossfire-designs.de                       *
 ****** COPYRIGHT ***********************************************************
 * This unit is delivered with the GrafX-package. You are not allowed to    *
 * use this unit or parts of it out of the GrafX-package, i.e. for another  *
 * graphical unit. For more copyright information see grafx.txt             *
 ****************************************************************************}
unit gr_vars;
interface
uses crt{$IFDEF DPMI},winapi{$ENDIF};
type
  coltype = record
    r,g,b : byte;
  end;

  pointtype = record
    x,y : integer;
  end;

  TextSettingsType = record
    Font      : word;
    Direction : word;
    CharSize  : word;
    Horiz     : word;
    Vert      : word;
  end;

  ViewPortType = record
    x1,y1,x2,y2 : integer;
    mxx,mxy     : word   ;
    clip        : boolean;
  end;

  paltype = array[0..255] of coltype;

  vesainfo = record
    VESASignature : array[0..3] of char;
    VESAVersion   : word;
    OEMStringPtr  : pchar;
    Capabilities  : longint;
    VideoModePtr  : pointer;
    totalmemory   : word;
    {beware - this will only be filled if VBE 2 or above is available}
    OemSoftwareRev    : word;
    OemVendorNamePtr  : pchar;
    OemProductNamePtr : pchar;
    OemProductRevPtr  : pchar;
    reserved          : array[1..222] of byte;
    OemData           : array[1..256] of byte;
  end;

  modeinfo = record
    ModeAttributes     : word;
    WinAAttributes     : byte;
    WinBAttributes     : byte;
    WinGranularity     : word;
    Winsize            : word;
    WinASegment        : word;
    WinBSegment        : word;
    WinFuncPtr         : pointer;
    BytesPerScanLine   : word;
    XResolution        : word;
    YResolution        : word;
    XCharsize          : byte;
    YCharsize          : byte;
    NumberOfPlanes     : byte;
    BitsPerPixel       : byte;
    NumberOfBanks      : byte;
    MemoryModel        : byte;
    BankSize           : byte;
    NumberOfImagePages : byte;
    Reserved1          : byte;
    RedMaskSize        : byte;
    RedFieldPosition   : byte;
    GreenMaskSize      : byte;
    GreenFieldPosition : byte;
    BlueMaskSize       : byte;
    BlueFieldPosition  : byte;
    RsvdMaskSize       : byte;
    RsvdFieldPosition  : byte;
    DirectColorModeInfo: byte;
    {VBE 2 Variables}
    PhysBasePtr        : pointer;
    OffScreenMemOffset : pointer;
    OffScreenMemSize   : word;
    Reserved          : array[1..206] of byte;
  end;

  FillPatternType = array[1..8] of byte;

  {$IFOPT N+}
  fpu = single;
  {$ELSE}
  fpu = real;
  {$ENDIF}

  tscreenmode = record
    mode              : word;    { normally vesa-screenmode    }
    mxx,mxy,maxx,maxy : word;    { size of the current mode    }
    lasty             : word;    { last available y-position   }
    bpp               : byte;
    bytesperpixel     : byte;
    scanline          : word;    { how many bytes per scanline }
    banked            : boolean; { never false under tp ;))    }
    writeptr,readptr  : word;    { where the graphical data is written/readen }
    device            : byte;    { 0 = Gfxcard                 }
    numofpages        : byte;
  end;

var
  currentmode      : tscreenmode;
  s                : string  ;
  gfx_inited       : boolean ; { True if graphical mode active }
  actviewport,actscreen,fillviewport : viewporttype;{current viewport-settings }
  gresult          : integer ; { contains last error - 0 after call of graphresult }
  winfuncptr       : pointer ; { Bankswitchpointer - used in Realmode}
  shifter          : byte    ; { Used for setbank }
  vesainfoblock    : vesainfo;
  modeinfoblock    : modeinfo;
  twowins          : boolean ; { True if 2 bank-windows used }
  coljump          : coltype ;
  card : record
    chipid      : string[20];{ Like 'S3','ATI' if unknown, then 'VESA'}
    chipname    : string[25];{ has included the name of the chip }
    chipnum     : word;      { Chip Version number }
    chiprev     : word;      { Chip revision }
    fastid      : byte;      { Has included the number for constants like S3}
    ioadr       : word;
    speedup     : boolean;   { use normal speedups like setbank, scroll }
    speedupfunc : boolean;   { use full hardware acceleration           }
    speedupmode : byte;
    upspeeded   : boolean;   { filled after initialization - card uses then HW-Acceleration}
    upspeedable : boolean;
    speedups : record        { which acceleration the card does support }
      bar,bitblit,line,cursor,polygon,banking,scale : boolean;
    end;
  end;
  stylecounter     : word;

const
  gfxbuf      : pointer = nil;
  gfxbufsize  : word    = 0;
  stdgfxbufsize = 32767+4;
  lastbank    : word = 65535;
  pageadd     : word = 0;
  currentcolor: longint = 0;
  fillcolor   : longint = 0;
  bkcolor     : longint = 0;
  writemode   : byte = 0;
  dataalign   : byte = 0;
  rgbinited   : boolean = false;
  on  = true;
  off = false;

  currentsize : byte = 1;
  font        : byte = 0;
  linestyle   : word = $FFFF;
  linestylenum: word = 0;
  fillstyle   : fillpatterntype = ($FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF);
  fillstylenum: word = 1;
  pr          : boolean = true; {try to wait for cathod-beam after setvisualpage? }

  VESA   = 0;
  S3     = 1;
  TSENG  = 2;
  CIRRUS = 3;
  ATI    = 4;
  CHIPS  = 5;

 filloutpattern : array[0..12] of FillPatternType = (
   ($00,$00,$00,$00,$00,$00,$00,$00),     { Backgroundcolor }
   ($FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF),     { Foregroundcolor }
   ($ff,$ff,$00,$00,$ff,$ff,$00,$00),     { === }
   ($01,$02,$04,$08,$10,$20,$40,$80),     { /// }
   ($07,$0e,$1c,$38,$70,$e0,$c1,$83),     { /// als dicke Linien }
   ($07,$83,$c1,$e0,$70,$38,$1c,$0e),     { \\\ als dicke Linien }
   ($5a,$2d,$96,$4b,$a5,$d2,$69,$b4),     { \ \\ \ }
   ($ff,$88,$88,$88,$ff,$88,$88,$88),     { K„stchen }
   ($18,$24,$42,$81,$81,$42,$24,$18),     { Rauten }
   ($cc,$33,$cc,$33,$cc,$33,$cc,$33),     { "Mauermuster" }
   ($80,$00,$08,$00,$80,$00,$08,$00),     { wide dots }
   ($88,$00,$22,$00,$88,$00,$22,$00),     { close dots }
   (0,0,0,0,0,0,0,0));

  linepattern : array[0..3] of word = ($FFFF,$CCCC,$FC78,$F8F8);

{Settextjustify-constants}
{Horizontal}
  LeftText     = 0;
  RightText    = 2;
{Vertikal}
  BottomText   = 0;
  TopText      = 2;
{vertikal and horizontal}
  CenterText   = 1;

type
  chartype = array[0..255] of record
    numofpoints : byte;
    pointpos : array[0..15] of record
      x,y      : byte;
      stopline : boolean;
      reserved : byte;
    end;
  end;
  col32type = longint;
  col32pal = array[0..255] of col32type;
var
  header : array[0..7] of record
    kennung               : string[11];
    version               : word;
    name                  : string[20];
    charsize,height,width : byte;
    chartype              : byte;{1= Vektor;2= Bitmap;3=8 Bit bitmap}
    colordepth            : byte;
    startchar,endchar     : word;
    distance              : byte;
    memsize               : word;
    reserved              : array[0..16] of byte;
  end;


  fontinfo : array[0..7] of record
    memsize   : word;
    fromdisk  : boolean;
    available : boolean;
  end;
  chars  : array[0..7] of pointer;
  charpoints : ^chartype;

  point  : array[0..499] of word;{y-size of a circle cannot be larger than 500 points}
  oldcol : byte;

const
  ATTR = $3C0;
  SEQ  = $3C4;
  GRC  = $3CE;
  coproav : boolean = false;

  textx : word = 0{lefttext};
  texty : word = 2{toptext};
var
  pal : ^paltype;

  col8bitpal : ^col32pal;

{$IFDEF DPMI}
{Ripped from BGIDEMO.PAS}
type
 TRealRegs = record
   RealEDI: Longint;
   RealESI: Longint;
   RealEBP: Longint;
   RealESPRES : Longint;
   RealEBX: Longint;
   RealEDX: Longint;
   RealECX: Longint;
   RealEAX: Longint;
   RealFlags: Word;
   RealES: Word;
   RealDS: Word;
   RealFS: Word;
   RealGS: Word;
   RealIP: Word;
   RealCS: Word;
   RealSP: Word;
   RealSS: Word;
 end;
var
  Segment,Selector : Word;
{$ENDIF}
var
  setbank  : procedure(bank : word);
  setbank2 : procedure(bank : word);
  incbank  : procedure;
  decbank  : procedure;
  calcbank : function(x,y : integer) : word;

  procedure getpal;
  procedure initrgb;
  procedure puttext;
  procedure gettext;
  function  getlasty : word;
  function  getmaxx : word;
  function  getmaxy : word;
  procedure move2(var input,output;size : word);
var
  sprite2mem : procedure(var input,output;size : word;key : longint);
  procedure sprite2mem_8(var input,output;size : word;key : longint);
  procedure sprite2mem_16(var input,output;size : word;key : longint);
{  procedure moveQ(var input,output;size : word);}
  procedure move2screen(var input,output;size : word);
  procedure movefromscreen(var input,output;size : word);
  procedure fillbyte(var dest; Times : word;data : byte);
  procedure fillword(var dest;times : word;data : word);
  procedure filldword(var dest;times : word;data : longint);
  procedure fillpattern(var output;size : word;value1,value2 : byte;xpos,pattern : byte);
  procedure fillpattern_32(var output;size : word;value1,value2 : longint;xpos,pattern : byte);
  function  textwidth(s : string) : word;
  function  loadfont(name : string;num : byte) : boolean;
  function  closefont(num : byte) : boolean;
  function  loadfontmem(p : pointer;num : byte) : boolean;
  function  makestr(w : longint) : String;
  function  makestrr(r : real;sh,st : byte) : String;

  procedure swapb(var b1,b2);
  procedure swapw(var w1,w2);
  procedure swapd(var d1,d2);
  function  GetRMSelector(segment : word) : word;
  procedure modinx(pt,inx,mask,nwv:word);
  procedure clrinx(pt,inx,val:word);
  procedure wrinx3(pt,inx:word;val:longint);
  procedure wrinx2(pt,inx,val:word);
  procedure setinx(pt,inx,val:word);
  function  tstrg(pt,msk:word):boolean;
  function  rdinx(pt,inx:word):word;
  procedure wrinx(pt,inx,val:word);       {write VAL to register PT index INX}
  function  testinx2(pt,rg,msk:word):boolean;
  function  testinx(pt,rg:word):boolean;

  procedure getvesainfo;
var
  colpal : array[0..4095] of byte;
  square : array[-255..255] of longint; { squaretable, used for 24 to 8 bit color conversion }

implementation
var
  getted           : boolean; { True after call of gettext - for puttext }
  load             : word;
  screen           : pointer;
  cpos             : pointtype;


procedure setgfxbufsize(size : word);
begin
  if gfxbuf <> nil then freemem(gfxbuf,gfxbufsize);
  if size < 4096 then size := 4096;
  gfxbufsize := size;
  getmem(gfxbuf,size);
end;

(*function colorfit(r,g,b : integer) : byte;assembler;
var
  farbnr : word;
asm
  les   si,pal
  mov   farbnr,0
  db    66h;mov cx,0FFFFh;dw 0FFFFh  {Quadratischer Fehler des besten Farbwerts in bl}
  mov   bl,0
@2:
  xor   ah,ah
  mov   al,es:[si]
  sub   ax,r
  db    66h,0Fh,0BFh,0C0h {movsx eax,ax}
  db    66h;mul ax
  db    66h;mov di,ax
  xor   ah,ah
  mov   al,es:[si+1]
  sub   ax,g
  db    66h,0Fh,0BFh,0C0h {movsx eax,ax}
  db    66h;mul ax
  db    66h;add di,ax
  xor   ah,ah
  mov   al,es:[si+2]
  sub   ax,b
  db    66h,0Fh,0BFh,0C0h {movsx eax,ax}
  db    66h;mul ax
  db    66h;add di,ax
  add   si,3
  db    66h;cmp di,cx
  jnb   @1
    {Besser!}
    db    66h;mov cx,di
    mov   bx,farbnr
@1:
  inc   farbnr
  cmp   farbnr,256
  jnz   @2
  mov   al,bl
@ende:
end;*)
function rgb_8(r,g,b : integer) : byte;assembler;
asm
  les   si,pal
  db    66h;mov cx,0FFFFh;dw 0FFFFh
  mov   ah,255
  sub   r,256
  sub   g,256
  sub   b,256
@lp:
  mov   bx,es:[si]
  mov   dh,es:[si+2]
  mov   dl,bh
  xor   bh,bh
  sub   bx,r
  shl   bx,2
  db    66h;mov di,word ptr square[bx]
  xor   bh,bh
  mov   bl,dl
  sub   bx,g
  shl   bx,2
  db    66h;add di,word ptr square[bx]
  xor   bh,bh
  mov   bl,dh
  sub   bx,b
  shl   bx,2
  db    66h;add di,word ptr square[bx]
  add   si,3
  db    66h;cmp di,cx
  jnb   @1
    db    66h;mov cx,di
    mov   al,ah
@1:
  dec   ah
  jnz   @lp
  not   al
end;

procedure getpal;
var
  i : integer;
begin
  port[$3C7] := 0;
  for i := 0 to 255 do begin
    pal^[i].r  := port[$3C9] shl 2;
    pal^[i].g  := port[$3C9] shl 2;
    pal^[i].b  := port[$3C9] shl 2;
  end;
end;

procedure initrgb;
var
  i : word;
begin
  if currentmode.bpp > 8 then exit;
  if rgbinited then exit;
  getpal;
  for i := 0 to 4095 do
  colpal[i] := rgb_8((i and 15) shl 4,(i) and 240,(i shr 4) and 240);
  rgbinited := true;
end;

procedure gettext;
{get and save the text screen}
begin
 if not getted then begin
   cpos.x := wherex;
   cpos.y := wherey;
   if lastmode = 3+font8x8 then load := 80*50*4 else load := 80*25*2;
   getmem(screen,load);
   move2(ptr(getrmselector($B800),0)^,screen^,load);
   getted := true;
 end;
end;

procedure puttext;
{put the saved text screen}
begin
  if getted then begin
 {   if lastmode = 3+font8x8 then load := 80*50*4 else load := 80*25*2;}
    move2(screen^,ptr(getrmselector($B800),0)^,load);
    gotoxy(cpos.x,cpos.y);
    freemem(screen,load);
    getted := false;
  end;
end;

function getlasty : word;assembler;
{get the last accessable y-line of the card}
asm
  mov  ax,currentmode.lasty
end;

function getmaxx : word;assembler;
{only for compatibility}
asm
  mov  ax,currentmode.mxx
end;

function getmaxy : word;assembler;
{only for compatibility}
asm
  mov  ax,currentmode.mxy
end;

function textwidth(s : string) : word;
var
  i2,cr,sy,chw,cx : byte;
  crs,width       : byte;
  dummy,i,i3      : word;
  xwidth          : word;
  incx            : word;
  incer,px        : word;
  chp             : pointer;
  dist            : byte;
begin
  if length(s) = 0 then begin
    textwidth := 0;
    exit;
  end;
  if header[font].chartype = 1 then begin
    xwidth := 0;
    crs    := header[font].charsize;
    incx   := (crs*currentsize) div 12;

    for i := 0 to pred(ord(s[0])) do begin
      cr := ord(s[i+1]);
      width := 0;
      if cr <> 32 then begin
(*        for i2 := 1 to charpoints^[cr].numofpoints do
        begin
          cx := charpoints^[cr].pointpos[i2].x;
          {if (cr >= ord('0'))and((cr <= ord('9'))) then width := 12;}
          if width < cx then width := cx;
        end;*)
        asm
          les di,charpoints
          mov ax,word ptr cr   { get the char to draw                   }
          xor ah,ah
          mov bx,ax
          shl ax,6
          add ax,bx             {hehe - saved some cpu time!            }

{          mov cx,65            { one vec-char : 65 bytes                }
{          mul cx               { and calculate memory position          }
          add di,ax
          mov al,es:[di]       { get the amount of lines to draw        }
          dec al
          mov i2,al            { and save it in i2                      }
          mov i3,0             { now reset i3                           }
          @lp:

            push di            { save di for next loop                  }
            mov dx,i3          { load i3                                }
            add dx,4           { increment it by 4,                     }
            mov i3,dx          { write the value back                   }
            lea ax,es:[di+1]
            add ax,dx          { add now i3 to ax                       }
            mov di,ax          { now we have the actual memory position }
            mov bl,es:[di]     { so load x and y value to bx            }
            pop di
            cmp width,bl
            jnb @next
            mov width,bl
            @next:
          dec i2
          jnz @lp
        end;
      end else width := (crs*currentsize) div 7;
      asm
        mov   bl,crs
        mov   al,width
        mul   currentsize
        div   bl
        xor   ah,ah
        mov   bx,xwidth
        add   bx,ax
        add   bx,incx
        mov   xwidth,bx
      end;
    end;
    textwidth := xwidth;
  end else if header[font].chartype = 2 then
  textwidth := (header[font].width+header[font].distance)*length(s)
  else if header[font].chartype = 3 then begin
    xwidth := 0;
    chp    := chars[font];
    dist   := header[font].distance;

    for i := 0 to pred(ord(s[0])) do begin
      cr := ord(s[i+1]);
      px := memw[seg(chp^):ofs(chp^)+(cr-header[font].startchar)*2]+
      (header[font].endchar-header[font].startchar+1)*2;
      width := memw[seg(chp^):ofs(chp^)+px+2];
      if (cr <> 32)and(width > 0)and(cr >= header[font].startchar)
      and(cr <= header[font].endchar) then
      inc(xwidth,width+dist)
      else
      inc(xwidth,header[font].width);
    end;
    textwidth := xwidth;
  end;
end;

function loadfont(name : string;num : byte) : boolean;
{load font from disk}
var
  f       : file;
  i       : word;
  size    : byte;
  memsize : word;
begin
  loadfont := false;
  assign(f,name);
  filemode := 64;
  {$I-}reset(f,1);{$I+}
  if ioresult <> 0 then begin
    gresult := 8{grFontNotFound};
    exit;
  end;
  blockread(f,header[num],sizeof(header[num]));
  if header[num].kennung = 'GSCharset>>' then begin
    if header[num].chartype = 1 then begin
      new(charpoints);
      for i := header[num].startchar to header[num].endchar do begin
       {if eof(f) then begin;close(f);exit;end;}
        blockread(f,size,1);
        charpoints^[i].numofpoints := size;
        blockread(f,charpoints^[i].pointpos,size*4);
      end;
    end else if header[num].chartype = 2 then begin
      memsize:=(header[num].width*header[num].height*header[num].colordepth)div 8
               *(header[num].endchar-header[num].startchar+1);
      getmem(chars[num],memsize);
      blockread(f,chars[num]^,memsize);{muss noch veraendert werden, um variabel zu sein}
    end else if header[num].chartype = 3 then begin
      memsize:= header[num].memsize;
      getmem(chars[num],memsize);
      blockread(f,chars[num]^,memsize);
    end;
  end else begin
    close(f);
    gresult := 13{grInvalidFont};
    exit;
  end;
  close(f);
  fontinfo[num].fromdisk  := true;
  fontinfo[num].available := true;
  fontinfo[num].memsize   := memsize;
  loadfont := true;
end;

function closefont(num : byte) : boolean;
{unload a font}
begin
  closefont := false;
  if not fontinfo[num].available then exit;
  if fontinfo[num].fromdisk then
  if (header[num].chartype = 2)or(header[num].chartype = 3) then
  freemem(chars[num],fontinfo[num].memsize);
  fontinfo[num].available := false;
  fontinfo[num].fromdisk  := false;
  fontinfo[num].memsize   := 0;
  closefont := true;
end;


function loadfontmem(p : pointer;num : byte) : boolean;
{load font from memory}
var
  i       : word;
  size    : byte;
  ppos    : word;
  memsize : word;
begin
  ppos := 0;
  loadfontmem := false;
  move2(p^,header[num],sizeof(header[num]));
  inc(ppos,sizeof(header[num]));
  if header[num].kennung = 'GSCharset>>' then begin
    if header[num].chartype = 1 then begin
      new(charpoints);
      for i := header[num].startchar to header[num].endchar do begin
        move(ptr(seg(p^),ofs(p^)+ppos)^,size,1);
        inc(ppos);
        charpoints^[i].numofpoints := size;
        move2(ptr(seg(p^),ofs(p^)+ppos)^,charpoints^[i].pointpos,size*4);
        inc(ppos,size*4);
      end;
    end else if header[num].chartype = 2 then
    chars[num] := ptr(seg(p^),ofs(p^)+ppos)
    else if header[num].chartype = 3 then
    chars[num] := ptr(seg(p^),ofs(p^)+ppos);
  end else begin
    gresult := 13{grInvalidFont};
    exit;
  end;
  fontinfo[num].fromdisk  := false;
  fontinfo[num].available := true;
  fontinfo[num].memsize   := memsize;
  loadfontmem := true;
end;

function makestr(w : longint) : string;
{convert integer to string}
var
  c : string;
begin
  str(w,c);
  makestr := c;
end;

function makestrr(r : real;sh,st : byte) : string;
{convert real to string}
var
  c : string;
begin
  str(r:sh:st,c);
  makestrr := c;
end;

(*
procedure moveQ(var input,output;size : word);assembler;
{uses fpu - makes memory movements a bit more faster
(39 MB/s instead of 33 MB/s on my P90 in normal mem but
not to gfx-mem :( )}
asm
 cld
 {$IFOPT E+}
 push  ds
 cmp   coproav,0
 jne   @av
   call   move2
 jmp  @end
 @av:
 lds  si,input
 les  di,output
 mov  cx,size
 mov  ax,cx
 shr  cx,4
 jz   @not16
 @lp:
   fild  qword ptr ds:[si]
   fild  qword ptr ds:[si+8]
   fxch
   fistp qword ptr es:[di]
   fistp qword ptr es:[di+8]

   add   si,16
   add   di,16
   dec   cx
 jnz   @lp
 @not16:
 mov   cx,ax
 and   cx,1111b
 mov   ax,cx
 shr   cx,2
 db    0F3h,66h,0A5h{rep movsd}
 mov   cx,ax
 and   cx,11b
 jz    @end
 @no4:
 rep   movsb
 @end:
 pop   ds
 {$ELSE}
 call  move2
 {$ENDIF}
end;*)

procedure move2(var input,output;size : word);assembler;
{use it instead of the normal move.. size is to set in bytes}
asm
  cld
  mov   dx,ds
  lds   si,input
  les   di,output
  mov   cx,size
  mov   ax,cx
  shr   cx,2
  jz    @not4
  db    0F3h,66h,0A5h{rep movsd}
  @not4:
  mov   cx,ax
  and   cx,11b
  jz    @end
  rep   movsb
  @end:
  mov   ds,dx
end;

procedure move2screen(var input,output;size : word);assembler;
{optimized for 32-Bit address output}
asm
  cld
  mov   dx,ds
  lds   si,input
  les   di,output
  mov   cx,size
  mov   ax,cx
  cmp   cx,8
  jb    @start
  mov   cx,di
  and   cx,11b
  jz    @iszero
  xor   cx,11b
  inc   cx
  sub   ax,cx
  rep   movsb
  @iszero:
  mov   cx,ax
  @start:
    shr   cx,2
    db    0F3h,66h,0A5h{rep movsd}
    and   ax,11b
    jz    @end
    mov   cx,ax
    rep   movsb
  @end:
  mov   ds,dx
end;

procedure movefromscreen(var input,output;size : word);assembler;
{optimized for 32-Bit address input (PCI-Bus)}
asm
  cld
  mov   dx,ds
  lds   si,input
  les   di,output
  mov   cx,size
  mov   ax,cx
  cmp   cx,8
  jb    @start
  mov   cx,si
  and   cx,11b
  jz    @iszero
  mov   bx,4
  sub   bx,cx
  mov   cx,bx
  rep   movsb
  sub   ax,bx
  @iszero:
  mov   cx,ax
  @start:
    shr   cx,2
    jz    @end
    db    0F3h,66h,0A5h{rep movsd}
    mov   cx,ax
    and   cx,11b
    jz    @end
    rep   movsb
  @end:
  mov   ds,dx
end;


procedure fillbyte(var dest;times : word;data : byte);assembler;
{Runs like fillchar but with dwords.. you have to set the times
 to fill in bytes. Optimized for maximum screen-output (32-Bit PCI)}
asm
  cld
  mov   al,data
  les   di,dest
  mov   ah,al
  mov   dx,times
  cmp   dx,8
  jb    @start
  mov   cx,di
  and   cx,11b
  jz    @start
  xor   cx,11b
  inc   cx
  sub   dx,cx
  rep   stosb
  @start:
    mov   bx,ax
    db    66h;shl ax,16
    mov   cx,dx
    mov   ax,bx
    shr   cx,2
    db    0F3h,66h,0ABh{rep stosd}
    and   dx,11b
    jz    @end
    mov   cx,dx
    rep   stosb
  @end:
end;

procedure fillword(var dest;times : word;data : word);assembler;
asm
  cld
  mov   ax,data
  mov   cx,ax
  db    66h;shl ax,16
  mov   ax,cx
  mov   dx,times
  shr   dx,1
  jz    @end
  les   di,dest
  mov   cx,di
  and   cx,10b
  jz    @iszero
    stosw
    dec   dx
  @iszero:
  mov   cx,dx
  shr   cx,1
  jz    @small
  db    0F3h,66h,0ABh{rep stosd}
  @small:
  and   dx,1b
  jz    @end
  mov   es:[di],ax
  @end:
end;

procedure filldword(var dest;times : word;data : longint);assembler;
asm
       cld
db 66h;mov   ax,word ptr data
       les   di,dest
       mov   cx,times
       db    0F3h,66h,0ABh{rep stosd}
end;

procedure fillpattern(var output;size : word;value1,value2 : byte;xpos,pattern : byte);assembler;
asm
  mov   cl,xpos
  and   cl,7
  mov   al,1
  shl   al,cl
  les   di,output
  mov   si,size
  or    si,si
  jz    @end
  mov   ah,pattern
  mov   dl,value1
  mov   dh,value2
  @lp:

    test  ah,al
    jz    @usebk
      mov   es:[di],dl
      jmp   @normcol
    @usebk:
      mov   es:[di],dh
    @normcol:
    add   al,al
    jz    @reset
    @cont1:
    inc   di
    dec   si
  jnz   @lp
  jmp   @end
  @reset:
  mov   al,1
  jmp   @cont1
  @end:
end;

procedure fillpattern_32(var output;size : word;value1,value2 : longint;xpos,pattern : byte);assembler;
asm
  les  di,output
  mov  cx,size
  mov  bl,pattern
  mov  bh,xpos
  db 66h;mov ax,word ptr value1
  db 66h;mov dx,word ptr value2
  inc cx
  @lp:

    test bl,bh
    jz @usebk
      db   66h;mov es:[di-1],ax
      jmp  @normcol
    @usebk:
      db 66h;mov es:[di-1],dx
    @normcol:
    add  bh,bh
    jnz  @no
    mov  bh,1
    @no:
    add  di,4
    dec  cx
  jnz  @lp
end;

procedure sprite2mem_8(var input,output;size : word;key : longint);assembler;
{key is the transparent color}
asm
  push  ds
  les   di,input
  lds   si,output
  mov   cx,size
  mov   dx,cx
  shr   cx,1
  jz    @end
  mov   bl,byte ptr key
  @lp:
    mov   ax,es:[di]
    cmp   al,bl
    je    @black;mov ds:[si],al;@black:
    cmp   ah,bl
    je    @black2;mov ds:[si+1],ah;@black2:

    add   di,2
    add   si,2
    dec   cx
  jnz   @lp
  and   dx,1
  jz    @end
  mov   al,es:[di]
  cmp   al,bl
  je    @black3;mov ds:[si],al;@black3:

  @end:
  pop   ds
end;

procedure sprite2mem_16(var input,output;size : word;key : longint);assembler;
{key is the transparent color}
asm
  push  ds
  les   di,input
  lds   si,output
  mov   cx,size
  shr   cx,1
  jz    @end
  mov   bx,word ptr key
  @lp:
    mov   ax,es:[di]
    cmp   ax,bx
    je    @black;mov ds:[si],ax;@black:
    add   di,2
    add   si,2
    dec   cx
  jnz   @lp
  @end:
  pop   ds
end;

procedure swapb(var b1,b2);assembler;
asm
  mov   dx,ds
  les   di,b1
  lds   si,b2
  mov   al,es:[di]
  mov   bl,ds:[si]
  mov   ds:[si],al
  mov   es:[di],bl
  mov   ds,dx
end;

procedure swapw(var w1,w2);assembler;
asm
  mov   dx,ds
  les   di,w1
  lds   si,w2
  mov   ax,es:[di]
  mov   bx,ds:[si]
  mov   ds:[si],ax
  mov   es:[di],bx
  mov   ds,dx
end;

procedure swapd(var d1,d2);assembler;
asm
  mov   dx,ds
  les   di,d1
  lds   si,d2
  db    66h;mov   ax,es:[di]
  db    66h;mov   bx,ds:[si]
  db    66h;mov   ds:[si],ax
  db    66h;mov   es:[di],bx
  mov   ds,dx
end;

function GetRMSelector(segment : word) : word;assembler;
asm
{$ifdef dpmi}
  mov   ax,2
  mov   bx,segment
  int   31h
{$else}
  mov   ax,segment
{$endif}
end;

function rdinx(pt,inx:word):word;       {read register PT index INX}
var x:word;
begin
  if pt = $3C0 then
  begin
    x := port[seq+6];    {Reset Attribute Data/Address Flip-Flop}
    port[$3C0] := inx and $DF;    {Clear bit 5 of index}
    for x := 1 to 10 do;
    rdinx := port[$3C1];    {delay}
    x := port[seq+6];    {Reset Attribute Data/Address Flip-Flop}
    for x := 1 to 10 do;   {delay}
    port[$3C0] := $20;    {Set index bit 5 to keep display alive}
    x := port[seq+6];    {Reset Attribute Data/Address Flip-Flop}
  end
  else begin
    port[pt] := inx;
    rdinx := port[pt+1];
  end;
end;

procedure wrinx(pt,inx,val:word);       {write VAL to register PT index INX}
var x : word;
begin
  if pt = $3C0 then
  begin
    x := port[seq+6];
    port[$3C0] := inx and $DF;
    port[$3C0] := val;
    x := port[seq+6];    {If Attribute Register then reset Flip-Flop}
    port[$3C0] := $20;
    x := port[seq+6];
  end
  else begin
    port[pt] := inx;
    port[pt+1] := val;
  end;
end;

procedure wrinx2(pt,inx,val:word);
begin
  wrinx(pt,inx,lo(val));
  wrinx(pt,inx+1,hi(val));
end;

procedure wrinx3(pt,inx:word;val:longint);
begin
  wrinx(pt,inx,lo(val));
  wrinx(pt,inx+1,hi(val));
  wrinx(pt,inx+2,val shr 16);
end;

procedure wrinx2m(pt,inx,val:word); {Write VAL to the index pair (INX,INX+1)}
begin                               {in motorola (big endian) format}
  wrinx(pt,inx,hi(val));
  wrinx(pt,inx+1,lo(val));
end;

procedure wrinx3m(pt,inx:word;val:longint);
begin
  wrinx(pt,inx+2,lo(val));
  wrinx(pt,inx+1,hi(val));
  wrinx(pt,inx,val shr 16);
end;

procedure modinx(pt,inx,mask,nwv:word);  {In register PT index INX sets
                                          the bits in MASK as in NWV
                                          the other are left unchanged}
var temp:word;
begin
  temp:=(rdinx(pt,inx) and (not mask))+(nwv and mask);
  wrinx(pt,inx,temp);
end;

procedure modreg(reg,mask,nwv:word);  {In register REG sets the bits in
                                       MASK as in NWV other are left unchanged}
var temp:word;
begin
  temp:=(port[reg] and (not mask))+(nwv and mask);
  port[reg] := temp;
end;


procedure setinx(pt,inx,val:word);
var x:word;
begin
  x:=rdinx(pt,inx);
  wrinx(pt,inx,x or val);
end;

procedure clrinx(pt,inx,val:word);
var x:word;
begin
  x:=rdinx(pt,inx);
  wrinx(pt,inx,x and (not val));
end;

function tstrg(pt,msk:word):boolean;
var
  old,nw1,nw2:word;
begin
  old := port[pt];
  port[pt] := old and not msk;
  nw1 := port[pt] and msk;
  port[pt] := old or msk;
  nw2 := port[pt] and msk;
  port[pt] := old;
  tstrg := (nw1 = 0)and(nw2 = msk);
end;

function testinx2(pt,rg,msk:word):boolean;
var
  old,nw1,nw2:word;
begin
  old := rdinx(pt,rg);
  wrinx(pt,rg,old and not msk);
  nw1 := rdinx(pt,rg) and msk;
  wrinx(pt,rg,old or msk);
  nw2 := rdinx(pt,rg) and msk;
  wrinx(pt,rg,old);
  testinx2:=(nw1=0) and (nw2=msk);
end;

function testinx(pt,rg:word):boolean;
begin
  testinx := testinx2(pt,rg,$ff);
end;

{$IFDEF DPMI}

procedure getvesainfo;
begin
  asm
    push  0000h
    push  0200h
    call  globaldosalloc
    mov   segment,dx
    mov   selector,ax
    mov   di,offset RealModeRegs
    mov   word ptr [DI].TRealRegs.RealSP, 0
    mov   word ptr [DI].TRealRegs.RealSS, 0
    mov   word ptr [DI].TRealRegs.RealEAX, 4F00h
    mov   word ptr [DI].TRealRegs.RealES, dx
    mov   word ptr [DI].TRealRegs.RealEDI, 0
    mov   ax,ds
    mov   es,ax
    mov   ax,0300h
    mov   bx,0010h
    int   31h
  end;
  move2(ptr(selector,0)^,vesainfoblock,512);
  globaldosfree(selector);
end;

{$ELSE}
procedure getvesainfo;assembler;
asm
  mov   ax,4F00h
  mov   di,seg vesainfoblock
  mov   es,di
  mov   di,offset vesainfoblock
  int   10h
end;
{$ENDIF}

procedure sysfont2;external;
{$L SYSFONT2}
procedure littn2;external;
{$L LITTN2}
var
  i : longint;
begin
  new(pal);
  new(col8bitpal);
  setgfxbufsize(stdgfxbufsize);
  if (not loadfontmem(@LITTN2,2))or(not loadfontmem(@SYSFONT2,0)) then
  begin
    writeln('GrafX: An error occured while loading standard fonts from memory');
    writeln('Program aborted');
    exit;
  end;
  gresult  := 0;
  coproav  := test8087 <> 0;
  for i := -255 to 255 do square[i] := i*i;
end.

