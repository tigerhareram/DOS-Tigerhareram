{$A+,B+,F-,G+,I-,O+,P+,Q-,R-,S-,T-,V-,X+,Y-}
{****************************************************************************
 * Author           : Stefan Goehler, Oliver Fromme, Germany                *
 * Version          : 1.1                                                   *
 *******                                                                    *
 * my mail-adress   : stefan.goehler@gmx.de                                 *
 * my homepage      : http://crossfire.home.pages.de                        *
 ****** COPYRIGHT ***********************************************************
 * This unit is delivered with the GrafX-package. You are not allowed to    *
 * use this unit out of the GrafX-package, i.e. for another graphical unit. *
 * For more copyright information see grafx.txt                             *
 ****** HISTORY *************************************************************
 * Version 1.0  first version of this unit, delivered with GrafX 1.0        *
 * Version 1.1  *fixed a large amount of bugs                               *
 *              *loads now all non-interlaced images                        *
 ****** KNOWN PROBLEMS ******************************************************
 * .Unit cannot load PNGs made by photoshop - I don't know who causes this  *
 *  problem, but the decompressor returns with an error on these images     *
 ****************************************************************************}
unit pngunit;
interface
uses grafx,gr_vars,crc32,adler32,inflate;

  function  loadpng(px,py : integer;name: string) : byte;
  function  loadpngmem(px,py : integer;p : pointer;palstart,palend : byte) : byte;
  function  info_png(name: string;var image_info : timage_info) : byte;
  procedure resetvars;
  procedure BufferedReadfile(var desti; c : word);far;
  procedure BufferSkipBackfile(c : LongInt);far;
  procedure BufferSkipBackmem(c : LongInt);far;
  procedure BufferedReadmem(var desti; c : word);far;
  function  MyHeapErrorFunc(Size: word) : integer;far;
  procedure ResetReadBuffer;
  procedure CheckIO;
  procedure ReadChunkHead;
  function  FindChunk(c : string) : integer;
  procedure SkipChunk;
  function  GetLineSize(PixelWidth : LongInt) : LongInt;
  procedure Process_IHDR;
  procedure Process_PLTE;
  procedure Process_IDAT;
  procedure Process_Iend;
  procedure Process_GAMA;
  procedure Process_SBIT;
  procedure Process_CHRM;
  procedure Process_TRNS;
  procedure Process_BKGD;
  procedure Process_HIST;
  procedure Process_TEXT;
  procedure Process_ZTXT;
  procedure Process_PHYS;
  procedure Process_TIME;

const
  NumChunks = 14;
  chunks : array[1..NumChunks] of
  record
    Name    : array[0..3] of char;
    Process : procedure;
    HaveIt  : boolean; {True = chunk has appeared}
  end = ((Name: 'IHDR'; Process: Process_IHDR; HaveIt: False),
         (Name: 'PLTE'; Process: Process_PLTE; HaveIt: False),
         (Name: 'IDAT'; Process: Process_IDAT; HaveIt: False),
         (Name: 'IEND'; Process: Process_Iend; HaveIt: False),
         (Name: 'gAMA'; Process: Process_GAMA; HaveIt: False),
         (Name: 'sBIT'; Process: Process_SBIT; HaveIt: False),
         (Name: 'cHRM'; Process: Process_CHRM; HaveIt: False),
         (Name: 'tRNS'; Process: Process_TRNS; HaveIt: False),
         (Name: 'bKGD'; Process: Process_BKGD; HaveIt: False),
         (Name: 'hIST'; Process: Process_HIST; HaveIt: False),
         (Name: 'tEXt'; Process: Process_TEXT; HaveIt: False),
         (Name: 'zTXt'; Process: Process_ZTXT; HaveIt: False),
         (Name: 'pHYs'; Process: Process_PHYS; HaveIt: False),
         (Name: 'tIME'; Process: Process_TIME; HaveIt: False));

  ReadBuffSize = 65528;

type
  tReadBuff  = array[0..Pred(ReadBuffSize)] of byte;
  pReadBuff  = ^tReadBuff;

var
  infile : file;
  pstart,pend : byte;
  BufferedRead   : procedure(var desti; c : word);
  BufferSkipBack : procedure(c : LongInt);
  memreadpos     : longint;
  ReadBuff       : pReadBuff;
  rbpos,rbend    : word;
  posx,posy      : integer;
  First          : boolean; {True = first chunk}
  ChunkHead : record
    Length : LongInt;
    Name   : array[0..3] of char
  end;

  PNGHead : Record {see the PNG spec, draft #9}
    Width,Height  : LongInt;
    BitsPerSample : byte  ;
    Colortype     : byte  ;
    CM,Filter,IL  : byte  ;
  end;
  imagep,lastrow : pointer;
  LineSize       : LongInt;{number of bytes in one row incl. filter byte}


implementation

var
  RunCRC : tCRC; {see unit CRC32 for details}
  RunAdl : tAdler; {see unit Adler32 for details}

  currentoffset : longint;{byte position in current row}
  decompbytes   : longint;{counts decompressed bytes}
  bytesneeded   : longint;{bytes actually decompressed, should be = decompbytes}
  numlines      : longint;{number of scanlines = number of filter bytes}
  outputrow     : pReadBuff;
  PaletteSize,bytesPerLine : word;
  CurrentPass              : byte;     {Adam7 pass, 0..6}

procedure die(const msg : string);
begin
  closegraph;
  writeln('PNGimage loaderror: '+msg);
  close(infile);
  halt;
end {Die};

procedure checkio;
var
  iores : integer;
begin
  iores := ioresult;
  if iores <> 0 then
  if iores = 100 then
  die('premature end of file')
  else
  die('I/O error #'+makestr(iores)+' reading from input file.');
end {CheckIO};

{Some read buffer routines for faster access
 on devices with slow response time.}

procedure resetreadbuffer;
begin
  rbpos := readbuffsize;
  rbend := readbuffsize;
  memreadpos := 0;
end {ResetReadBuffer};


procedure bufferedreadfile(var desti; c : word);
var
  ec,r : word;
label
  noload;
begin
  asm
    db 66h;xor   ax,ax
    db 66h;xor   bx,bx
    db 66h;xor   dx,dx
           mov  ax,rbpos
           mov  bx,c
           mov  cx,bx
    db 66h;add  bx,ax
           mov  dx,readbuffsize
    db 66h;cmp  bx,dx
           jna  noload
  end;
{      if rbpos+LongInt(c) > LongInt(ReadBuffSize) then begin}
  r := readbuffsize-rbpos;
  if rbpos < readbuffsize then
  move2(readbuff^[rbpos],readbuff^,r);
  blockread(infile,readbuff^[r],rbpos,ec);
  if ec < rbpos then rbend := r+ec;
  rbpos := 0;
{      end;}
  asm
    mov ax,rbpos
    mov cx,c
    noload:
    mov dx,ds
    lds si,readbuff
    add si,ax
    les di,desti
    mov ax,cx
    shr cx,2
    jz @not4
    db 0F3h,66h,0A5h{rep movsd}
    @not4:
    mov cx,ax
    and cx,11b
    jz @end
    rep movsb
    @end:
    mov ds,dx
    mov bx,rbpos
    add bx,ax
    cmp bx,rbend
    jna @na
    mov inoutres,100
    jmp @a
    @na:
    add rbpos,ax
    @a:
  end;
end;

procedure bufferskipbackfile(c : longint);
begin
  if rbpos >= c then dec(rbpos,c)
  else begin
    resetreadbuffer;
    seek(infile,filepos(infile)-c);
  end;
end {BufferSkipBack};


procedure bufferedreadmem(var desti; c : word);
var
  ec,r : word;
begin
  move2(ptr(seg(imagep^),ofs(imagep^)+memreadpos)^,desti,c);
  inc(memreadpos,c);
end;

procedure bufferskipbackmem(c : longInt);
begin
  dec(memreadpos,c);
end;

procedure readcheck(var desti; c : word);
begin
  bufferedread(desti,c);
  checkio;
  dec(chunkhead.length,c);
  updatecrc32(runcrc,desti,c);
end {ReadCheck};



function myheaperrorfunc(size: word) : integer;
begin
  if size = 0 then
  myheaperrorfunc := 2 {success}
  else
  myheaperrorfunc := 1 {return NIL}
end {MyHeapErrorFunc};

{Swap a 32 bit variable (MSB<->LSB).}

procedure swap32(var longvar : longint);Assembler;
asm
  les   si,longvar
  mov   ax,es:[si]
  mov   dx,es:[si+2]
  xchg  al,dh
  xchg  ah,dl
  mov   es:[si],ax
  mov   es:[si+2],dx
end {Swap32};

{Swap a 16 bit variable (MSB<->LSB).}

procedure swap16(var wordvar : word);Assembler;
asm
  les   si,wordvar
  mov   ax,es:[si]
  xchg  al,ah
  mov   es:[si],ax
end {Swap16};

procedure readchunkhead;
begin
  bufferedread(chunkhead,sizeof(chunkhead));
  checkio;
  with chunkhead do begin
    swap32(length);
    initcrc32(runcrc);
    updatecrc32(runcrc,name,4);
  end;
end {ReadChunkHead};

{Skip to the end of the current chunk and check the CRC.}

procedure skipchunk;
var
  checkcrc : tcrc;
  b        : byte;
begin
  with chunkhead do
  if length < 0 then begin
    bufferskipback(-length);
    checkio;
  end else
  while chunkhead.length > 0 do
  readcheck(b,1);
  bufferedread(checkcrc,4);
  checkio;
end {SkipChunk};

{Callback for inflate:  feed an input byte to inflate.}

function png_readbyte : byte;far;
var
  checkcrc : tcrc;
  b        : byte;
begin
  while chunkhead.length = 0 do begin
    skipchunk;
    readchunkHead;
  end;
  readcheck(b,1);
  png_readbyte := b;
end {PNG_Readbyte};

{Apply a filter to a single row of pixels.}
var
  w    : word;
  bypp : word;
  bpp  : word;
{procedure subfilt;
begin
  for w := bpp to bytesperline-1 do
  inc(mem[seg(outputrow^):ofs(outputrow^)+w+1],
  mem[seg(outputrow^):ofs(outputrow^)+w-bpp+1]);
end;}
procedure subfilt;assembler;
asm
  les   di,outputrow
  mov   cx,bytesperline
  dec   cx
  sub   cx,bypp
  inc   di
  mov   si,di
  add   di,bypp
  @lp:
    mov   al,es:[si]
    add   es:[di],al
    inc   di
    inc   si
    dec   cx
  jnz   @lp
end;

{procedure upfilt;
begin
  for w := 0 to bytesperline-1 do
  inc(mem[seg(outputrow^):ofs(outputrow^)+w+1],
  mem[seg(lastrow^):ofs(lastrow^)+w]);
end;}
procedure upfilt;assembler;
asm
  les   di,outputrow
  mov   cx,bytesperline
  dec   cx
  inc   di
  push  ds
  lds   si,lastrow
  @lp:
    mov   al,ds:[si]
    add   es:[di],al
    inc   di
    inc   si
    dec   cx
  jnz   @lp
  pop ds
end;

{procedure averagefilt;
var
  c1 : word;
begin
  c1 := 0;
  for w := 0 to bytesperline-1 do begin
    if w >= bpp then c1 := mem[seg(outputrow^):ofs(outputrow^)+w-bpp+1];
    inc(mem[seg(outputrow^):ofs(outputrow^)+w+1],
    (c1+mem[seg(lastrow^):ofs(lastrow^)+w]) shr 1);
  end;
end;}

procedure averagefilt;assembler;
asm
  mov   dx,bytesperline
  mov   cx,bypp
  sub   dx,cx
  jz    @end
  les   di,outputrow
  inc   di
  mov   bx,di
  push  ds
  lds   si,lastrow
  @lp:
    mov   al,ds:[si]
    shr   al,1
    add   es:[di],al
    inc   si
    inc   di
  dec   cx
  jnz   @lp

  xor   ax,ax
  cmp   dx,1
  jle   @stop
  dec   dx
  @lp2:
    mov   al,es:[bx]
    mov   cl,ds:[si]
    add   ax,cx
    shr   ax,1
    add   es:[di],al
    inc   si
    inc   di
    inc   bx
  dec   dx
  jnz   @lp2
  @stop:
  pop   ds
  @end:
end;

{function paethpredictor(a,b,c : byte) : byte;
var
  p,pa,pb,pc : word;
begin
  p  := a+b-c;
  pa := abs(integer(p)-a);
  pb := abs(integer(p)-b);
  pc := abs(integer(p)-c);
  if (pa <= pb)and(pa <= pc) then paethpredictor := a
  else if pb <= pc then paethpredictor := b else
  paethpredictor := c;
end;}

function paethpredictor(a,b,c : word) : byte;assembler;
var
  p,pa,pb,pc : word;
asm
  mov   si,b
  mov   di,a
  push  bp
  mov   bp,c
  mov   dx,di
  add   di,si
  sub   di,bp

  mov   ax,di
  sub   ax,dx
  jns   @nexta;neg ax;@nexta:
  mov   bx,di
  sub   bx,si
  jns   @nextb;neg bx;@nextb:
  mov   cx,di
  sub   cx,bp
  jns   @nextc;neg cx;@nextc:

  cmp   ax,bx
  jnbe  @useb
  cmp   ax,cx
  jnbe  @useb
  mov   ax,dx
  jmp   @end
  @useb:
  cmp   bx,cx
  jnbe  @usec
  mov   ax,si
  jmp   @end
  @usec:
  mov   ax,bp
  @end:
  pop   bp
end;

procedure paethfilt;
var
  c1,c2 : byte;
begin
  c1 := 0;
  c2 := 0;
  for w := 0 to bytesperline-2 do begin
    if w >= bypp then begin
      c1 := outputrow^[w-bypp+1];
      c2 := mem[seg(lastrow^):ofs(lastrow^)+w-bypp];
    end;
    inc(outputrow^[w+1],
    paethpredictor(c1,mem[seg(lastrow^):ofs(lastrow^)+w],c2));
  end;
end;

procedure applyfilter;
begin {ApplyFilter}
  case outputrow^[0] of
    0 :;
    1 : subfilt;
    2 : upfilt;
    3 : averagefilt;
    4 : paethfilt;
  end;
end {ApplyFilter};

function  getlinesize(pixelwidth : longint) : longint;
begin
  with pnghead do
  case colortype of
    0 : getlinesize := (bitspersample*pixelwidth+7) shr 3+1;
    2 : getlinesize := (bitspersample shr 3)*3*pixelwidth+1;
    3 : getlinesize := (bitspersample*pixelwidth+7) shr 3+1;
    4 : getlinesize := (bitspersample shr 2)*pixelwidth  +1;
    6 : getlinesize := (bitspersample shr 1)*pixelwidth  +1;
    else
    getlinesize := pixelwidth shl 3+1;
    {should be pretty save if user wants to ignore error}
  end;
end {GetLineSize};

{Tables for Adam7 interlacing.}

const
  adam7_startrow : array[0..6] of byte=(0,0,4,0,2,0,1);
  adam7_startcol : array[0..6] of byte=(0,4,0,2,0,1,0);
  adam7_incrmrow : array[0..6] of byte=(8,8,8,4,4,2,2);
  adam7_incrmcol : array[0..6] of byte=(8,8,4,4,2,2,1);

var
 cury : longint;

{Number of pixels/row in current pass}

function passwidth : longint;
begin
  passwidth :=
  (pnghead.width+adam7_incrmcol[currentpass]-1-adam7_startcol[currentpass])
  div adam7_incrmcol[currentpass];
end {PassWidth};

{Number of rows in current pass}

function passheight : longint;
begin
  passheight :=
  (pnghead.height+adam7_incrmrow[currentpass]-1-adam7_startrow[currentpass])
  div adam7_incrmrow[currentpass]
end {PassHeight};

{Callback for inflate:  provides output data from the sliding window.}

procedure showline(x,y,width,bpp : integer;bw : boolean;data : pointer);
var
  p : pointer;
begin
  if bw then
  case bpp of
    1,2,4,8 : image_putline(x,y,width,bpp,data);
    16,32 : begin
           getmem(p,width);
           asm
             mov   cx,width
             mov   bx,bpp
             shr   bx,3
             les   di,data
             mov   dx,ds
             lds   si,p
             @lp:
               mov   al,es:[di]
               mov   ds:[si],al
               add   di,bx
               inc   si
             dec   cx
             jnz   @lp
             mov   ds,dx
           end;
           image_putline(x,y,width,8,p);
           freemem(p,width);
         end;
  end else
  case bpp of
    1,2,4,8,24 : image_putline(x,y,width,bpp,data);
    48,64 : begin
           getmem(p,pnghead.width*3);
           asm
             mov   cx,width
             mov   bx,bpp
             shr   bx,3
             les   di,data
             mov   dx,ds
             lds   si,p
             @lp:
               mov   al,es:[di]
               mov   ah,es:[di+2]
               mov   ds:[si],ax
               mov   al,es:[di+4]
               mov   ds:[si+2],al
               add   di,bx
               add   si,3
             dec   cx
             jnz   @lp
             mov   ds,dx
           end;
           image_putline(x,y,width,24,p);
           freemem(p,pnghead.width*3);
         end;
    32 : begin
           getmem(p,pnghead.width*3+1);
           asm
             mov   cx,width
             les   di,data
             mov   dx,ds
             lds   si,p
             @lp:
               db    66h;mov   ax,es:[di]
               db    66h;mov   ds:[si],ax
               add   di,4
               add   si,3
             dec   cx
             jnz   @lp
             mov   ds,dx
           end;
           image_putline(x,y,width,24,p);
           freemem(p,pnghead.width*3+1);
         end;
  end;
end;

function png_flush(w : word) : integer;far;
var
  copyoffset,copycount : word;
begin
  png_flush  := 0;
  copyoffset := 0;
  inc(decompbytes,w);
  updateadler32(runadl,slide^,w);
  if currentpass > 6 then exit; {Process_IDAT detects this}
  while w > 0 do begin
    if pnghead.il = 1 then begin {interlaced}
      {Skip empty passes}
      while ((passwidth = 0)or(passheight = 0))and(currentpass < 7) do
      inc(currentpass);
      if currentpass > 6 then exit;
      bytesperline := getlinesize(passwidth);
    end else {non-interlaced}
    bytesperline := linesize;
    if w > bytesperline-currentoffset then
    copycount := bytesperline-currentoffset else copycount := w;
    if currentoffset+copycount <= 65528 then
    move2(slide^[copyoffset],outputrow^[currentoffset],copycount);
    dec(w,copycount);
    inc(copyoffset,copycount);
    inc(currentoffset,copycount);
    if currentoffset >= bytesperline then begin {next row}
      applyfilter;
      currentoffset := 0;
      if pnghead.il = 1 then begin {interlaced}
        inc(cury,adam7_incrmrow[currentpass]);
        if cury >= pnghead.height then begin
          inc(currentpass);
          if currentpass = 6 then
          showline(posx,posy+cury,pnghead.width,bpp,(pnghead.colortype = 0)or
                  (pnghead.colortype = 4),ptr(seg(outputrow^),ofs(outputrow^)+1));
          if currentpass > 6 then exit;
          cury := adam7_startrow[currentpass];
        end;
      end else begin {non-interlaced}
        showline(posx,posy+cury,pnghead.width,bpp,(pnghead.colortype = 0)or
                (pnghead.colortype = 4),ptr(seg(outputrow^),ofs(outputrow^)+1));
        if pnghead.colortype <> 3 then move2(ptr(seg(outputrow^),ofs(outputrow^)+1)^,lastrow^,linesize-1);
        inc(cury);
        if cury >= pnghead.height then exit;
      end;
    end;
  end;
end {PNG_Flush};

function findchunk(c : string) : integer;
var
   i : integer;
begin
  findchunk := -1;
  for i := 1 to numchunks do
  if c = chunks[i].name then begin
    findchunk := i;
    break;
  end;
end {FindChunk};

function checklength(l : longint) : longint; {returns actual length}
begin
  checklength := chunkhead.length;
end {CheckLength};


procedure process_ihdr;
type
  byteset = set of byte;
var
  w : word;
begin {Process_IHDR}
  checklength(sizeof(pnghead));
  fillbyte(pnghead,sizeof(pnghead),0);
  readcheck(pnghead,sizeof(pnghead));
  with pnghead do begin
    swap32(width);
    swap32(height);
    linesize := getlinesize(width);
  end;
  if linesize > 65528 then
    w := 65528
  else
  w := linesize;
  getmem(outputrow,w);
  if outputrow = nil then
  die('Not enough memory for output row ('+makestr(w)+' bytes).');
  skipchunk;
end {Process_IHDR};


procedure process_plte;
var
  dummy : longint;
  i     : byte;
begin
  with chunkhead do palettesize := length div 3;
  dummy := chunkhead.Length;
  skipchunk;
  bufferskipback(dummy+4);
  bufferedread(pal^,dummy);
  bufferedread(dummy,4);
  if (pstart = 0)and(pend = 255) then setpal
  else for i := pstart to pend do setrgbpalette(i,pal^[i].r,pal^[i].g,pal^[i].b);
end {Process_PLTE};

procedure process_idat;
var
  adlercheck : longint;
  result     : integer;
  w          : word   ;
begin
  if chunks[findchunk(chunkhead.name)].haveit then begin
    skipchunk;
    exit;
  end;
  w := png_readbyte;
  w := (w shl 8) or png_readbyte;
  initadler32(runadl);
  decompbytes := 0;
  with pnghead do
  if il = 1 then begin {interlaced}
    bytesneeded := 0;
    numlines    := 0;
    for currentpass := 0 to 6 do begin
      inc(bytesneeded,getlinesize(passwidth)*passheight);
      inc(numlines,passheight)
    end
  end
  else begin {non-interlaced}
    bytesneeded := linesize*height;
    numlines := height
  end;
  currentoffset := 0;
  currentpass   := 0;
  cury          := 0;
  inflateread  := png_readbyte;
  inflateflush := png_flush;
  result := inflaterun;
{  for w := 1 to 4 do adlercheck := (adlercheck shl 8) or png_readbyte;}
  skipchunk;
end {Process_IDATs};

procedure process_iend;
begin
  checklength(0);
  skipchunk;
end {Process_Iend};

procedure process_gama;
begin
  skipchunk;
end {Process_GAMA};

procedure process_sbit;
begin
  skipchunk;
end {Process_SBIT};

procedure process_chrm;
begin
  skipchunk;
end {Process_CHRM};

procedure  process_trns;
begin
  skipchunk;
end {Process_TRNS};

procedure process_bkgd;
begin
  skipchunk;
end {Process_BKGD};

procedure process_hist;
begin
  skipchunk;
end {Process_HIST};

procedure process_text;
begin
  skipchunk;
end {Process_TEXT};

procedure process_ztxt;
begin
  skipchunk;
end {Process_ZTXT};

procedure process_phys;
begin
  skipchunk;
end {Process_PHYS};

procedure process_time;
begin
  skipchunk;
end {Process_TIME};


procedure resetvars;
var
  i : byte;
begin
  first         := false;
  linesize      := 0;
  currentoffset := 0;
  decompbytes   := 0;
  bytesneeded   := 0;
  numlines      := 0;
  currentpass   := 0;
  for i := 1 to numchunks do chunks[i].haveit := false;
  cury          := 0;
  chunkhead.name[0] := #0;
  lastrow   := nil;
  slide     := nil;
  readbuff  := nil;
  outputrow := nil;
end;

const
  png_id : array[0..7] of char = #137'PNG'#13#10#26#10;

function getbpp(coltype,bitdepth : byte) : byte;
begin
  case coltype of
    0,3 : getbpp := bitdepth;     { Grayscale/Palette       }
    2 : getbpp := bitdepth*3;     { RGB                     }
    4 : getbpp := bitdepth shl 1; { Greyscale, Alphachannel }
    6 : getbpp := bitdepth shl 2; { RGB, Alphachannel       }
  end;
end;

function bppvalid(coltype,bitdepth : byte) : boolean;
begin
  bppvalid := false;
  case coltype of
    0 : ; { Grayscale/Palette       }
    2 : ; { RGB                     }
    3 : ; { Palette image           }
    4 : ; { Greyscale, Alphachannel }
    6 : ; { RGB, Alphachannel       }
    else exit;
  end;
  if pnghead.il <> 0 then exit; {Interlaced images currently not supported}
  bppvalid := true;
end;

function info_png(name: string;var image_info : timage_info) : byte;
var
  BufMag    : array[0..7] of char;
  i         : integer;
  oldheaperrorfunc : pointer;

procedure prepareexit(code : byte);
begin
  if lastrow <> nil then freemem(lastrow,linesize);
  if readbuff <> nil then freemem(readbuff,readbuffsize);
  if outputrow <> nil then freemem(outputrow,linesize);
  info_png := code;
  heaperror := oldheaperrorfunc;
  close(infile);
end;

begin
  pstart := 0;
  pend   := 255;
  resetvars;
  BufferedRead   := BufferedReadfile;
  BufferSkipBack := BufferSkipBackfile;

  assign(infile,name);
  reset(infile,1);
  if ioresult <> 0 then begin;prepareexit(image_filenotfound);exit;end;
  oldheaperrorfunc := HeapError;
  HeapError := @MyHeapErrorFunc;
  getmem(ReadBuff,ReadBuffSize);
  if ReadBuff = NIL then begin;prepareexit(image_nomem);exit;end;
  ResetReadBuffer;
  BufferedRead(BufMag,8);
  CheckIO;
  if BufMag <> png_id then begin;prepareexit(image_falseformat);exit;end;
  with ChunkHead do
  ReadChunkHead;
  if ChunkHead.Name = 'IHDR' then begin
    Process_IHDR;
    with image_info do begin
      size.x       := pnghead.width;
      size.y       := pnghead.height;
      bpp          := getbpp(pnghead.colortype,pnghead.bitspersample);
      greyscale    := pnghead.colortype in [0,4];
      alphachannel := pnghead.colortype in [4,6];
      transparency := false;
      compressed   := true;
      comptype     := 'LZ77';
      interlaced   := pnghead.il = 1;
      frames       := 1;
      trans_color  := 0;
      memsize      := longint(size.x)*size.y*bpp div 8+imagedatasize;
      disksize     := filesize(infile);
      supported    := bppvalid(pnghead.colortype,pnghead.bitspersample);
      version      := 1;
    end;
  end;
  prepareexit(image_noerror);
end;

procedure setgreypal;
var
  i   : integer;
  bpp : word;
begin
  bpp := pnghead.bitspersample;
  if bpp >= 16 then bpp := 8;
  if pnghead.bitspersample = 1 then
  setrgbpalette(1,255,255,255) else
  for i := 0 to (1 shl bpp)-1 do
  setrgbpalette(i,i shl (8-bpp),i shl (8-bpp),i shl (8-bpp));
end;

var
  oldalign : byte;

function loadpngmem(px,py : integer;p : pointer;palstart,palend : byte) : byte;
var
  BufMag    : array[0..7] of char;
  i         : integer;
  oldheaperrorfunc : pointer;
procedure prepareexit(code : byte);
begin
  loadpngmem := code;
  HeapError  := oldheaperrorfunc;
  if lastrow <> nil then freemem(lastrow,linesize);
  if slide <> nil then freemem(slide,wsize);
  if readbuff <> nil then freemem(ReadBuff,ReadBuffSize);
  if outputrow <> nil then freemem(outputrow,linesize);
  dataalign := oldalign;
end;

begin
  oldalign := dataalign;
  dataalign := align_rgb;
  pstart := palstart;
  pend   := palend;
  resetvars;
  resetreadbuffer;
  imagep := p;
  BufferedRead   := BufferedReadmem;
  BufferSkipBack := BufferSkipBackmem;

  posx := px;
  posy := py;
  oldheaperrorfunc := heaperror;
  heaperror := @myheaperrorfunc;
  getmem(slide,wsize);
  if slide = nil then begin;prepareexit(image_nomem);exit;end;
  getmem(readbuff,readbuffsize);
  if readbuff = nil then begin;prepareexit(image_nomem);exit;end;
  resetreadbuffer;
  bufferedread(bufmag,8);
  checkio;
  if bufmag <> png_id then begin;prepareexit(image_falseformat);exit;end;
  first := true;
  with chunkhead do
  while name <> 'IEND' do begin
    readchunkhead;
    if chunkhead.name = 'IHDR' then begin
      process_ihdr;
      if not bppvalid(pnghead.colortype,pnghead.bitspersample) then
      begin;prepareexit(image_falseformat);exit;end;
      if pnghead.colortype in [0,4] then setgreypal;
      getmem(lastrow,linesize);
      fillbyte(lastrow^,linesize,0);
      bpp  := getbpp(pnghead.colortype,pnghead.bitspersample);
      bypp := linesize div pnghead.width;
    end
    else begin
      if first then begin;prepareexit(image_falseformat);exit;end;
      i := findchunk(chunkhead.name);
      if i >= 0 then begin
        chunks[i].process;
        chunks[i].haveit := true;
      end
      else begin
        skipchunk;
      end;
    end;
    first := false;
  end;
  prepareexit(0);
end;


function loadpng(px,py : integer;name: string) : byte;
var
  bufmag    : array[0..7] of char;
  i         : integer;
  oldheaperrorfunc : pointer;

procedure prepareexit(code : byte);
begin
  if lastrow <> nil then freemem(lastrow,linesize);
  if slide <> nil then freemem(slide,wsize);
  if readbuff <> nil then freemem(ReadBuff,ReadBuffSize);
  if outputrow <> nil then freemem(outputrow,linesize);
  loadpng := code;
  heaperror := oldheaperrorfunc;
  close(infile);
end;

begin
  oldalign  := dataalign;
  dataalign := align_rgb;
  pstart    := 0;
  pend      := 255;
  resetvars;
  bufferedread   := bufferedreadfile;
  bufferskipback := bufferskipbackfile;

  posx := px;
  posy := py;
  assign(infile,name);
  reset(infile,1);
  if ioresult <> 0 then begin;prepareexit(image_filenotfound);exit;end;
  oldheaperrorfunc := heaperror;
  heaperror := @myheaperrorfunc;
  getmem(slide,wsize);
  if slide = nil then begin;prepareexit(image_nomem);exit;end;
  getmem(readbuff,readbuffsize);
  if readbuff = nil then begin;prepareexit(image_nomem);exit;end;
  resetreadbuffer;
  bufferedread(bufmag,8);
  checkio;
  if bufmag <> png_id then begin;prepareexit(image_falseformat);exit;end;
  first := true;
  with chunkhead do
  while name <> 'IEND' do begin
    readchunkhead;
    if chunkhead.name = 'IHDR' then begin
      process_ihdr;
      if not bppvalid(pnghead.colortype,pnghead.bitspersample) then
      begin;prepareexit(image_falseformat);exit;end;
      if pnghead.colortype in [0,4] then setgreypal;
      getmem(lastrow,linesize);
      fillbyte(lastrow^,linesize,0);
      bpp := getbpp(pnghead.colortype,pnghead.bitspersample);
      if bpp >= 24 then initrgb;
      bypp := linesize div pnghead.width;
    end
    else begin
      if first then begin;prepareexit(image_falseformat);exit;end;
      i := findchunk(chunkhead.name);
      if i >= 0 then begin
        chunks[i].process;
        chunks[i].haveit := true;
      end
      else begin
        skipchunk;
      end;
    end;
    first := false;
  end;
  prepareexit(0);
end;

begin
end.
