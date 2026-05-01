{$A+,B+,F-,G+,I-,O+,P+,Q-,R-,S-,T-,V-,X+,Y-}
unit bmpcx;
{****************************************************************************
 * Author           : Stefan Goehler, Germany                               *
 * Version          : 1.2                                                   *
 *******                                                                    *
 * my mail-adress   : stefan.goehler@gmx.de                                 *
 * my homepage      : http://crossfire.home.pages.de                        *
 ****** COPYRIGHT ***********************************************************
 * This unit is delivered with the GrafX-package. You are not allowed to    *
 * use this unit or parts of it out of the GrafX-package, i.e. for another  *
 * graphical unit. For more copyright information see grafx.txt             *
 ****** HISTORY *************************************************************
 * Version 1.1  *improved error-management                                  *
 *              +added procedures infobmp, infopcx                          *
 *              +picture output divertable via grafx (changeable procedure  *
 *               pointer                                                    *
 *               (published with grafx1.3c)                                 *
 * Version 1.2  *Truecolor-abilities                                        *
 *              +bmp-saver added (programmed by Enrico May, extended by     *
 *               me for truecolor and some other)                           *
 *              *bmp-loader loads now all of bmp supported color-depths     *
 *              *speeded up PCX-loader about 45% (got more asm-experience ;)*
 *              +added pcx-saver (yet only for 8 bpp)                       *
 *               (published with grafx1.4)                                  *
 ****************************************************************************}
interface
uses grafx,gr_vars;

  function loadbmp(px,py : integer;name: string) : byte;
  function savebmp(x1,y1,x2,y2 : integer;name : string) : byte;
  function savepcx(x1,y1,x2,y2 : integer;name : string) : byte;
  function loadpcx(px,py : integer;name: string) : byte;
  function info_bmp(name : string;var image_info : timage_info) : byte;
  function info_pcx(name : string;var image_info : timage_info) : byte;

implementation
var
  p           : pointer;
  f           : file;
  nr,maxread  : word;
  i           : word;

type
  pcxh = record
    id,version                  : byte;
    compression                 : byte; { 1= PCX }
    bpp                         : byte;
    minx,miny,
    maxx,maxy,
    dpix,dpiy                   : word;
    pal16                       : array[0..47] of byte;
    reserved,bitplanes          : byte;
    bytesperline,
    paltype                     : word; { 1=b/w or colored; 2= greyscale }
    hscreensize,vscreensize     : word; { mostly filled with garbage     }
    reserved2                   : array[0..53] of byte;
  end;

procedure readblock;
begin
  blockread(f,p^,maxread,nr);
end;

procedure refill(frompos : word);
begin
  move2(ptr(seg(p^),ofs(p^)+frompos)^,p^,maxread-frompos);
  blockread(f,ptr(seg(p^),ofs(p^)+maxread-frompos)^,frompos,nr);
end;


function loadpcx(px,py : integer;name: string) : byte;
var
  i,y,mempos  : word;
  h           : pcxh;
  linep       : pointer;
  count       : byte;
  sizex,sizey : word;
  stoppos     : word;

begin
  loadpcx := image_filenotfound;
  filemode := 64;
  assign(f,name);
  {$I-}reset(f,1);{$I+}
  if ioresult <> 0 then exit;
  blockread(f,h,sizeof(h),i);

  if (h.id <> $0A)or(h.version <> 5)or(h.bpp <> 8)or(h.compression <> 1) then begin
    loadpcx := image_falseformat;
    close(f);
    exit;
  end;
  if i < sizeof(h) then begin
    loadpcx := image_falseend;
    close(f);
    exit;
  end;

  seek(f,filesize(f)-768);
  blockread(f,pal^,sizeof(pal^));
  setpal;
  seek(f,sizeof(h));
  sizex := h.maxx-h.minx;
  sizey := h.maxy-h.miny;
  getmem(linep,sizex+1);
  maxread := 64000;
  getmem(p,succ(maxread));
  mempos  := ofs(p^);
  stoppos := mempos+maxread-1;
  readblock;
  for y := 0 to sizey do begin
    asm
           db    66h;xor ax,ax
           db    66h;xor bx,bx
           db    66h;xor cx,cx
           mov   ax,nr
           or    ax,ax
           jz    @start
           mov   bx,mempos
           sub   bx,p.word
           mov   cx,sizex
           db    66h;shl cx,1
           db    66h;add cx,bx
           db    66h;cmp cx,ax
           jna   @start
           push  bx
           call  refill
           mov   ax,p.word
           mov   mempos,ax

@start   : mov   si,mempos
           les   di,linep
           mov   dx,sizex
           push  ds
           mov   ds,p[2].word
@lp      : mov   bx,ds:[si]
           cmp   bl,0BFh
           jna   @putpixel
           mov   al,bh
           and   bx,3Fh
           mov   ah,al
           mov   cx,bx
           shr   cl,2
           jz    @below4
           push  ax
           db    66h;shl ax,16
           pop   ax
           db    0F3h,66h,0ABh      { rep   stosd      }
@below4  : mov   cx,bx
           and   cx,11b
           jz    @zero
           mov   es:[di],ax
           add   di,cx
           and   cl,1b
           jz    @zero
           mov   es:[di-1],al
@zero    : add   si,2
           sub   dx,bx
           jnc   @lp
           jmp   @stop
@putpixel: mov   es:[di],bl
           inc   si
           inc   di
           sub   dx,1
           jnc   @lp
@stop    : mov   mempos,si
           pop   ds
           push  px
           mov   ax,py
           add   ax,y
           push  ax
           mov   bx,sizex
           inc   bx
           push  bx
           push  h.bpp.word
           push  es
           push  linep.word
           call  image_putline
end;

{
  repeat
    if mempos > nr then begin
      readblock;
      mempos := 0;
    end;
    if mem[seg(p^):ofs(p^)+mempos] > $BF then begin
      count := mem[seg(p^):ofs(p^)+mempos] and $3F;
      if count > 0 then begin
        if mempos = nr then begin
          readblock;
          mempos:=65535;
        end;
        fillbyte(mem[seg(linep^):ofs(linep^)+vx],count,mem[seg(p^):ofs(p^)+mempos+1]);
        inc(vx,count);
        inc(mempos,2);
      end;
    end else begin
      mem[seg(linep^):ofs(linep^)+vx]:=mem[seg(p^):ofs(p^)+mempos];
      inc(vx);
      inc(mempos);
    end;
  until vx>h.sizex;
  vx := 0;
  image_putline(px,py+y,sizex,h.bpp,linep);}
  end;

  close(f);
  freemem(p,succ(maxread));
  freemem(linep,sizex+1);
  loadpcx := image_noerror;
end;

function info_pcx(name: string;var image_info : timage_info) : byte;
var
  h          : pcxh;
begin
  info_pcx := image_filenotfound;
  {$I-}
  filemode := 64;
  assign(f,name);
  reset(f,1);
  {$I+}
  if ioresult <> 0 then exit;
  blockread(f,h,sizeof(h),i);

  if (h.id <> $0A) then begin
    info_pcx := image_falseformat;
    close(f);
    exit;
  end;
  if i < sizeof(h) then begin
    info_pcx := image_fileerror;
    close(f);
    exit;
  end;
  with image_info do begin
    size.x       := h.maxx-h.minx;
    size.y       := h.maxy-h.miny;
    bpp          := h.bpp;
    greyscale    := h.paltype = 2;
    alphachannel := false;
    transparency := false;
    compressed   := h.compression = 1;
    case h.compression of
      1 : comptype := 'RLE';
      else comptype := 'unknown';
    end;
    interlaced   := false;
    frames       := 1;
    trans_color  := 0;
    memsize      := longint(size.x)*size.y+imagedatasize;
    disksize     := filesize(f);
    supported    := (h.version = 5)and(h.bpp = 8)and(h.compression = 1);
    version      := h.version;
  end;
  close(f);
  info_pcx := image_noerror;
end;

type
  bmph = record
    id         : array[0..1] of char;
    filesize   : longint;
    reserved   : longint;
    imagestart : longint;
    headersize : longint;
    sizex      : longint;
    sizey      : longint;
    planes     : word;   {1}
    bpp        : word;
    comptype   : longint;{0:no compression;1: RLE 8 bit;2: RLE 4 bit}
    imagesize  : longint;
    hor_res    : longint;
    vert_res   : longint;
    usedcolors : longint;
    bluecomp   : byte;
    greencomp  : byte;
    redcomp    : byte;
    filler     : byte;
  end;

  tbmppal = array[0..255] of record
    b,g,r,dummy : byte;
  end;

var
  h        : bmph;
  bmppal   :^tbmppal;


function info_bmp(name: string;var image_info : timage_info) : byte;
begin
  info_bmp := image_filenotfound;
  {$I-}
  filemode := 64;
  assign(f,name);
  reset(f,1);
  blockread(f,h,sizeof(h));
  {$I+}
  if ioresult <> 0 then exit;

  if (h.id[0] <> 'B')or(h.id[1] <> 'M') then begin
    info_bmp := image_falseformat;
    close(f);
    exit;
  end;
  with image_info do begin
    size.x       := h.sizex;
    size.y       := h.sizey;
    bpp          := h.bpp;
    greyscale    := false;
    alphachannel := false;
    transparency := false;
    compressed   := h.comptype <> 0;
    case h.comptype of
      0 : comptype := 'none';
      1 : comptype := 'RLE 8 bit';
      2 : comptype := 'RLE 4 bit';
      else comptype := 'unknown';
    end;
    interlaced   := false;
    frames       := 1;
    trans_color  := 0;
    memsize      := longint(size.x)*size.y+1024+imagedatasize;
    disksize     := filesize(f);
    supported    := h.comptype = 0;
    version      := 1;
  end;
  close(f);
  info_bmp := image_noerror;
end;

function loadbmp(px,py : integer;name: string) : byte;
var
  y,mempos : word;
  lineread : word;
  readmax  : word;
  oldalign : byte;

begin
  loadbmp := image_filenotfound;
  {$I-}
  filemode := 64;
  assign(f,name);
  reset(f,1);
  {$I+}
  if ioresult <> 0 then exit;
  blockread(f,h,sizeof(h),i);

  if (h.id[0] <> 'B')or(h.id[1] <> 'M')or(h.comptype <> 0)or
  ((h.bpp <> 1)and(h.bpp <> 4)and(h.bpp <> 8)and(h.bpp <> 24))
  then begin
    loadbmp := image_falseformat;
    close(f);
    exit;
  end;
  if i < sizeof(h) then begin
    loadbmp := image_falseend;
    close(f);
    exit;
  end;

  if (h.bpp <= 8) then begin
    new(bmppal);
    blockread(f,bmppal^,(word(1) shl h.bpp) shl 2);
    for i := 0 to word(1) shl h.bpp-1 do begin
      pal^[i].r := bmppal^[i].r;
      pal^[i].g := bmppal^[i].g;
      pal^[i].b := bmppal^[i].b;
    end;
    setpal;
    dispose(bmppal);
  end else if currentmode.bpp = 8 then begin
    getpal;
    initrgb;
  end;

  seek(f,h.imagestart);
  lineread := ((longint(h.sizex)*h.bpp) shr 3);
  if (lineread <> lineread and not 3) then lineread := (lineread and not 3)+4;

  oldalign  := dataalign;
  dataalign := align_bgr;
  maxread := 64000;
  readmax := (maxread div lineread)*lineread;
  getmem(p,succ(readmax));
  mempos := readmax;

  seek(f,h.imagestart);
  dec(h.sizey);
  for y := h.sizey downto 0 do begin
    if mempos = readmax then begin
      blockread(f,p^,readmax,mempos);
      mempos := 0;
    end;
    image_putline(px,py+y,h.sizex,h.bpp,ptr(seg(p^),ofs(p^)+mempos));
    inc(mempos,lineread);
  end;

  dataalign := oldalign;
  close(f);
  freemem(p,succ(readmax));
  loadbmp := image_noerror;
end;

function savebmp(x1,y1,x2,y2 : integer;name : string) : byte;
var
  f        : file;
  x,y      : word;
  line1    : pointer;
  linesize : word;
  r,g,b    : byte;
  oldalign : byte;

begin
  savebmp := image_fileerror;
  assign(f,name);
  {$I-}
  rewrite(f,1);
  {$I+}
  if ioresult <> 0 then exit;
  with h do begin
    id := 'BM';
    if currentmode.bpp = 8 then imagestart := sizeof(h) + 1024
    else imagestart := sizeof(h);
    headersize := 40;
    sizex      := abs(x2-x1)+1;
    sizey      := abs(y2-y1)+1;
    planes     := 1;
    bpp        := currentmode.bpp;
    if bpp >= 15 then bpp := 24;
    comptype   := 0;
    x := sizex*(bpp shr 3);
    if (x <> x and not 3) then x := (x and not 3)+4;
    imagesize  := x*sizey;
    hor_res    := sizex;
    vert_res   := sizey;
    usedcolors := longint(1) shl currentmode.bpp;
    bluecomp   := 255;
    greencomp  := 255;
    redcomp    := 255;
    filesize   := imagestart+imagesize;
  end;
  savebmp := image_nodiskmem;
  {$I-}blockwrite(f,h,sizeof(h));{$I+}
  if ioresult <> 0 then exit;
  if currentmode.bpp = 8 then begin
    new(bmppal);
    getpal;
    for x := 0 to 255 do begin
      bmppal^[x].r := pal^[x].r;
      bmppal^[x].g := pal^[x].g;
      bmppal^[x].b := pal^[x].b;
      bmppal^[x].dummy := 0;
    end;
    {$I-}blockwrite(f,bmppal^,sizeof(tbmppal));{$I+}
    if ioresult <> 0 then begin
      dispose(bmppal);
      exit;
    end;
    dispose(bmppal);
  end;
  if currentmode.bpp = 8 then
  linesize := h.sizex else linesize := h.sizex*3;
  if (linesize <> linesize and not 3) then linesize := (linesize and not 3)+4;

  oldalign  := dataalign;
  dataalign := align_rgb;

  getmem(line1,linesize);
  for y := y2 downto y1 do begin
    image_getline(x1,y,h.sizex,h.bpp,line1);
    {$I-}blockwrite(f,line1^,linesize);{$I+}
    if ioresult <> 0 then begin
      dataalign := oldalign;
      freemem(line1,linesize);
      exit;
    end;
  end;
  freemem(line1,linesize);
  close(f);
  savebmp := image_noerror;
  dataalign := oldalign;
end;

function savepcx(x1,y1,x2,y2 : integer;name : string) : byte;
type
  tb = array[0..65528] of byte;
var
  linep,p      : pointer;
  h            : pcxh;
  f            : file;
  x,y,i        : word;
  sizex,sizey  : word;
  wc           : word;
  a            : byte;
  last,current : byte;
begin
  if currentmode.bpp <> 8 then begin
    savepcx := image_falsebpp;
    exit;
  end;
  if x2 < x1 then swapw(x1,x2);
  if y2 < y1 then swapw(y1,y2);
  sizex := x2-x1;
  sizey := y2-y1;

  savepcx := image_fileerror;
  assign(f,name);
  {$I-}
  rewrite(f,1);
  {$I+}
  if ioresult <> 0 then exit;
  with h do begin
    id           := $0A;
    version      := 5;
    compression  := 1;
    bpp          := 8;
    {Nice thing to fuck up some poor loaders if minx/miny <> 0...}
    minx         := 0;
    miny         := 0;
    maxx         := sizex;
    maxy         := sizey;
    dpix         := 75;
    dpiy         := 75;
    move2(pal^,pal16,48);
    reserved     := 0;
    bitplanes    := 1;
    bytesperline := maxx+1;
    paltype      := 1;
    hscreensize  := currentmode.maxx;
    vscreensize  := currentmode.maxy;
    fillbyte(reserved2,54,0);
  end;
  savepcx := image_nodiskmem;
  {$I-}blockwrite(f,h,sizeof(h));{$I+}
  if ioresult <> 0 then begin
    close(f);
    exit;
  end;
  if maxavail < (sizex+2)*3 then begin
    savepcx := image_nomem;
    close(f);
    exit;
  end;
  getmem(linep,sizex+2);
  getmem(p,(sizex+2)*2);
  for y := y1 to y2 do begin
    wc := 0;
    image_getline(x1,y,sizex+1,h.bpp,linep);
    last := tb(linep^)[0];
    i := 1;
    for x := 1 to sizex do
    begin
      current := tb(linep^)[x];
      if (last = current) then begin
        inc(i);
        if i = 63 then begin
          tb(p^)[wc] := i or $C0;
          tb(p^)[wc+1] := last;
          inc(wc,2);
          i := 0;
        end;
      end else begin
        if (i >= 1) then begin
          if (i = 1)and(last and $C0 <> $C0) then begin
            tb(p^)[wc] := last;
            inc(wc);
          end else begin
            tb(p^)[wc] := i or $C0;
            tb(p^)[wc+1] := last;
            inc(wc,2);
          end;
          i := 1;
          last := current;
        end;
      end;
    end;
        if (i >= 1) then begin
          if (i = 1)and(last and $C0 <> $C0) then begin
            tb(p^)[wc] := last;
            inc(wc);
          end else begin
            tb(p^)[wc] := i or $C0;
            tb(p^)[wc+1] := last;
            inc(wc,2);
          end;
        end;
    {$I-}blockwrite(f,p^,wc);{$I+}
    if ioresult <> 0 then begin
      close(f);
      freemem(linep,sizex+2);
      freemem(p,(sizex+2)*2);
      exit;
    end;
  end;
  getpal;
  a := 12;
  blockwrite(f,a,1); {Read indicator}
  blockwrite(f,pal^,sizeof(paltype),i);
  if i = sizeof(paltype) then savepcx := image_noerror;
  close(f);
  freemem(linep,sizex+2);
  freemem(p,(sizex+2)*2);
end;



begin
end.
