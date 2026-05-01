{$A+,B-,D-,E+,F-,G+,I-,L-,N+,O-,P+,Q-,R-,S-,T-,V+,X+,Y-}
unit flclib;

(**** FLCLIB ****************************************************************
 * Author    : Max Maischein, Stefan Goehler, Germany                       *
 * Version   : 1.2b                                                         *
 * Task      : flX-videoplayer, able to play multiple files at once         *
 * Copyright : You can use this unit entired in your own programs. Using    *
 *             parts of it or ripping any code off is not allowed without   *
 *             my permission. If you wanna use this unit in commercial      *
 *             products, I mean if you wanna get ANY money or other for     *
 *             software based on one of my units, you'll have to contact me *
 *             - we'll find a way.                                          *
 *             See grafx.txt for more details.                              *
 * Comments  : .original version by Max Maischein, improved by me           *
 *             .you won't get very much speedup with asm, it's also not     *
 *              very easy to rewrite the parts to it ;)                     *
 ******** INFORMATION *******************************************************
 * my homepage: http://www.crossfire-designs.de                             *
 * ^^^note that you can get there always the actual version of this unit    *
 * if you have additions, tips or sth. else, mail to stefan.goehler@gmx.de  *
 ******** HISTORY ***********************************************************
 * Version 1.0 : Original by Max Maischein                                  *
 * Version 1.1 : *removed some bugs                                         *
 *               +support for Hires-videos added                            *
 *               *rewritten to OOP to get multiple file support (my very    *
 *                first try with OOP :)                                     *
 * Version 1.2 : +support for old FLI's - added 2 procedures                *
 *               *fixed bug of Max Maischein in Palette-procedures          *
 ******** KNOWN PROBLEMS ****************************************************
 * .in Hicolor, palette changes after the first image may cause wrong       *
 *  colors - cannot change that because of the limitation to 64K            *
 * .has problems with the displayment of some special FLCs, but unlike the  *
 *  program PV, the player doesn't crash every time                         *
 ****************************************************************************)
(*
  Q&D .FLC player

  You are allowed to modify the program to suit your needs, but in all
  events, this notice and the authors (my) name have to remain intact
  within this source code, and you have to credit me in any derivative
  work (=program etc.) that results from this file.

  corion@informatik.uni-frankfurt.de
  Max_Maischein@fido.spam.de
*)
interface
uses crt,flc,grafx,gr_vars;


const
  ReadBuffSize : word = 65528;

type
  PByte = ^Byte;

  flcplayer = object
    constructor open(name : string);
    destructor  done;virtual;
    function    getversionstring : string;
    function    nextpic : boolean;virtual;
    procedure   loadnextpic(x,y : integer);virtual;
    private
    procedure fli_color64;virtual;
    procedure fli_color256;virtual;
    procedure loadnewdata;virtual;
    procedure fli_worddelta;virtual;
    procedure fli_bytedelta;
    procedure fli_copy;virtual;
    procedure fli_black;virtual;
    procedure fli_brun;virtual;
    private
    f                 : file;
    NextBlockStart    : longint;
    NextSubBlockStart : longint;
    readbuffstop : word;
    otherchunk : procedure(chunktype : byte);
    LineBuffer : array[0..1023] of byte;
    LinePos    : integer;

    DataPtr    : ^byte;
    overlap    : word;
    H          : TFLIHeader;
    CurrBlock  : TFLCBlock;
    SubBlock   : TFLCSubBlock;
    OldClock   : LongInt;
    TimeDiff   : LongInt;
    CurrFrame  : Integer;
    RestartPos : LongInt;
    Buffer     : pointer;
    BufEnd     : ^byte;
    BufSize    : longint;
    aniHeight  : word;
    aniWidth   : word;
    bytesleft  : longint;
    flc_xpos,flc_ypos : integer;
    truecolpal : ^col32pal;
    oldpal     : pointer;
  end;

  function info_flc(name : string;var image_info : timage_info) : byte;

implementation

const
  clock_scale  = 4659 div 70;

function info_flc(name : string;var image_info : timage_info) : byte;
var
  f : file;
  h : ^tfliheader;
  w : word;
begin
  info_flc := image_filenotfound;
  assign(f,name);
  {$I-}
  filemode := 64;
  reset(f,1);
  {$I+}
  if ioresult <> 0 then exit;
  new(h);
  blockread(f,h^,sizeof(tfliheader),w);
  if (h^.formatid <> $AF11)and(h^.formatid <> $AF12) then begin
    info_flc := image_falseformat;
    dispose(h);
    close(f);
    exit;
  end;
  if w < sizeof(tfliheader) then begin
    info_flc := image_fileerror;
    dispose(h);
    close(f);
    exit;
  end;
  with image_info do begin
    size.x       := h^.width;
    size.y       := h^.height;
    bpp          := h^.depth;
    greyscale    := false;
    alphachannel := false;
    transparency := false;
    compressed   := true;
    comptype     := 'RLE/Delta';
    interlaced   := false;  { I don't know yet how to detect this }
    frames       := h^.numframes;
    if h^.formatid = $AF12 then speed := 1000000 div h^.speed
    else speed := 4608000 div (h^.speed*clock_scale);
    trans_color  := 0;
    memsize      := (h^.width*h^.height*h^.depth) shr 3;
    disksize     := filesize(f);
    supported    := (h^.depth = 8);
    version      := h^.formatid-$AF10;
  end;
  dispose(h);
  close(f);
end;

procedure flcplayer.fli_color256;
var
  StartColor  : Integer;
  J,I         : Integer;
  CurrPacket  : PFLCColorPacket;
  ColorCount  : Integer;
  PacketCount : Integer;
  P           : PFLCColorTriplet;
begin
  oldpal     := col8bitpal;
  col8bitpal := @truecolpal^;
  startcolor := 0;
  currpacket := Buffer;
  inc(pbyte(CurrPacket),2);
  PacketCount := Word(Buffer^);
  for J := 0 to PacketCount-1 do begin
    with CurrPacket^ do begin
      P := @Data;
      Inc(StartColor,SkipCount);
      ColorCount := ColorTriplets;
      if ColorCount = 0 then ColorCount := 256;
      for i := 0 to ColorCount-1 do begin
        setrgbpal(startcolor+i,p^.r,p^.g,p^.b);
        inc(p);
      end;
      Inc(StartColor,ColorCount);
      CurrPacket := @P^;
    end;
  end;
  setpal;
  col8bitpal := oldpal;
end;

procedure flcplayer.fli_color64;
var
  StartColor  : Integer;
  J,I         : Integer;
  CurrPacket  : PFLCColorPacket;
  ColorCount  : Integer;
  PacketCount : Integer;
  P           : PFLCColorTriplet;
begin
  oldpal     := col8bitpal;
  col8bitpal := @truecolpal^;
  startcolor := 0;
  currpacket := Buffer;
  inc(word(CurrPacket),2);
  PacketCount := Word(Buffer^);
  for J := 0 to PacketCount-1 do begin
    with CurrPacket^ do begin
      P := @Data;
      Inc(StartColor,SkipCount);
      ColorCount := ColorTriplets;
      if ColorCount = 0 then ColorCount := 256;
      for i := 0 to ColorCount-1 do begin
        setrgbpal(startcolor+i,p^.r shl 2,p^.g shl 2,p^.b shl 2);
        inc(p);
      end;
      Inc(StartColor,ColorCount);
      CurrPacket := @P^;
    end;
  end;
  setpal;
  col8bitpal := oldpal;
end;


procedure flcplayer.loadnewdata;
begin
  overlap := readbuffsize-(word(dataptr)-ofs(buffer^));
  move2(ptr(seg(buffer^),word(dataptr))^,buffer^,overlap);
  if bytesleft-overlap > readbuffsize then begin
    blockread(f,ptr(seg(buffer^),ofs(buffer^)+overlap)^,readbuffsize-overlap);
    dec(bytesleft,readbuffsize-overlap);
  end else begin
    blockread(f,ptr(seg(buffer^),ofs(buffer^)+overlap)^,bytesleft);
    bytesleft := 0;
  end;
  dataptr := buffer;
end;

procedure flcplayer.fli_brun;
var
  i,j     : integer;
  count   : byte;
begin
  oldpal     := col8bitpal;
  col8bitpal := @truecolpal^;
  dataptr    := buffer;
  for i := 0 to Pred(aniHeight) do begin
    inc(DataPtr);
    if (bytesleft > 0)and(word(dataptr)-ofs(buffer^) >= readbuffstop) then loadnewdata;
    LinePos := 0;
    while LinePos < aniWidth do begin
      Count := DataPtr^;
      inc(DataPtr);
      if Count and $80 <> 0 then begin
        asm neg [Count] end;
        move2(DataPtr^, LineBuffer[LinePos], Count);
        inc(DataPtr,Count);
      end else begin
        fillbyte(LineBuffer[LinePos], Count, DataPtr^);
        inc(DataPtr);
      end;
      inc(LinePos,Count);
    end;
    image_putline(flc_xpos,i+flc_ypos,aniwidth,h.depth,@linebuffer);
  end;
  col8bitpal := oldpal;
end;

procedure flcplayer.fli_worddelta;
var
  NumLines   : word;
  NumPackets : integer;
  CurrLine   : integer;
  I          : integer;
  XPos       : word;
  Count      : byte;
begin
  oldpal     := col8bitpal;
  col8bitpal := @truecolpal^;
  CurrLine := 0;
  NumLines := word(Buffer^);
  DataPtr  := Buffer;
  inc(DataPtr,2);
  while NumLines > 0 do begin
    NumPackets := word(pointer(DataPtr)^);
    inc(DataPtr,2);
    if (bytesleft > 0)and(word(dataptr)-ofs(buffer^) >= readbuffstop) then loadnewdata;
    case NumPackets shr 14 of
      0 : begin
            XPos := 0;
            for I := 1 to NumPackets do begin
              inc(XPos, DataPtr^);inc(DataPtr);
              Count := DataPtr^;inc(DataPtr);
              if Count and $80 = 0 then begin
                if currline < aniheight then
                image_putline(xpos+flc_xpos,currline+flc_ypos,Count shl 1,h.depth,dataptr);
                inc(DataPtr,Count shl 1);
              end else begin
                asm neg [Count] end;
                fillword(linebuffer,Count shl 1,word(Pointer(DataPtr)^));
                if currline < aniheight then
                image_putline(xpos+flc_xpos,currline+flc_ypos,Count shl 1,h.depth,@linebuffer);
                inc(DataPtr,2);
              end;
              inc(XPos,Count shl 1);
            end;
            inc(CurrLine);
            dec(NumLines);
          end;
      2 : begin
            image_putline(aniwidth+flc_xpos,currline+flc_ypos,1,h.depth,@numpackets);
            xpos := aniwidth;
            inc(currline);
          end;
      3 : inc(CurrLine,abs(NumPackets));
    end;
  end;
  col8bitpal := oldpal;
end;

procedure flcplayer.fli_bytedelta;
{ New one added by me to support old FLI's. Maybe a bit buggy yet }
var
  NumLines   : word;
  NumPackets : word;
  CurrLine   : integer;
  I          : integer;
  XPos       : word;
  Count      : byte;
begin
  oldpal     := col8bitpal;
  col8bitpal := @truecolpal^;
  DataPtr    := Buffer;
  CurrLine   := word(Buffer^);inc(DataPtr,2);
  NumLines   := word(Pointer(DataPtr)^);inc(DataPtr,2);

  while NumLines > 0 do begin
    dec(NumLines);
    NumPackets := DataPtr^;inc(DataPtr);
    if (bytesleft > 0)and(word(dataptr)-ofs(buffer^) >= readbuffstop) then loadnewdata;
    XPos := 0;
    for I := 1 to NumPackets do begin
      inc(XPos,DataPtr^);inc(DataPtr);
      Count := DataPtr^;inc(DataPtr);
      if Count and $80 = 0 then begin
        if currline < aniheight then
        image_putline(xpos+flc_xpos,currline+flc_ypos,Count,h.depth,dataptr);
        inc(DataPtr,Count);
      end else begin
        asm neg [Count] end;
        if currline < aniheight then
        fillbyte(linebuffer,Count,DataPtr^);
        image_putline(xpos+flc_xpos,currline+flc_ypos,Count,h.depth,@linebuffer);
        inc(DataPtr);
      end;
      inc(XPos,Count);
    end;
    inc(CurrLine);
  end;
  col8bitpal := oldpal;
end;

procedure flcplayer.fli_copy;
var
  y : integer;
begin
  oldpal     := col8bitpal;
  col8bitpal := @truecolpal^;
  DataPtr := Buffer;
  for y := 0 to aniheight-1 do begin
    inc(dataptr,aniwidth);
    if (bytesleft > 0)and(word(dataptr)-ofs(buffer^) >= readbuffstop) then loadnewdata;
    image_putline(flc_xpos,flc_ypos+y,aniwidth,h.depth,dataptr);
  end;
  col8bitpal := oldpal;
end;

procedure flcplayer.fli_black;
var
  y : integer;
begin
  oldpal     := col8bitpal;
  col8bitpal := @truecolpal^;
  fillbyte(linebuffer,aniwidth,0);
  for y := 0 to aniheight-1 do
  image_putline(flc_xpos,flc_ypos+y,aniwidth,8,@linebuffer);
  col8bitpal := oldpal;
end;

function getclock : longint;assembler; {Taken from the FLILIB source}
{ this routine returns a clock with occassional spikes where time
  will look like its running backwards 1/18.2th of a second.  The resolution
  of the clock is 1/(18.2*256) = 1/4659 second.  66 ticks of this clock
  are supposed to be equal to a monitor 1/70 second tick.}
asm
{  mov   ah,0             { get tick count from Dos and use for hi 3 Bytes }
{  int   01Ah             { lo order count in DX, hi order in CX }
  mov   es,[seg0040]
  mov   dx,es:[6Ch]
  mov   cx,es:[6Eh]

  mov   ah,dl
  mov   dl,dh
  mov   dh,cl

  mov   al,0             { read lo Byte straight from timer chip }
  out   $0043,al         { latch count }

  mov   al,1
  out   $0043,al         { set up to read count }
  in    al,$0040         { read in lo Byte (and discard) }
  in    al,$0040         { hi Byte into al }
  neg   al               { make it so counting up instead of down }
end;


procedure otherchunk_norm(chunktype : byte);far;
begin
end;

constructor flcplayer.open(name : string);
begin
  otherchunk := otherchunk_norm;
{  open := image_filenotfound;}
  assign(f,name);
  {$I-}
  filemode := 64;
  reset(f,1);
  {$I+}
  if (ioresult <> 0) then fail;
  blockread(f,h,sizeof(h));
  if (h.formatid <> $AF12)and(h.formatid <> $AF11) then begin
    close(f);
    fail;
  end;
  aniWidth  := H.Width;
  aniHeight := H.Height;

  if aniwidth > 1024 then begin
    close(f);
    fail;
  end;
  if h.depth <> 8 then fail;
  new(truecolpal);
  if memavail < readbuffsize then fail;
  getmem(buffer,readbuffsize);
  if h.formatid = $AF12 then begin
    seek(f,H.offsetFrame1);
    TimeDiff :=  trunc(LongInt(4608)*(H.Speed/1000));
  end
  else TimeDiff := H.Speed * clock_scale;
  CurrFrame  := 0;
  restartpos := filepos(f);
end;

destructor flcplayer.done;
begin
  dispose(truecolpal);
  close(f);
  freemem(buffer,readbuffsize);
end;

function flcplayer.getversionstring : string;
begin
  getversionstring := 'FlcLib 1.2b';
end;

function flcplayer.nextpic : boolean;
begin
  nextpic := oldclock+timediff <= getclock;
end;

procedure flcplayer.loadnextpic(x,y : integer);
var
  i : integer;
begin
  flc_xpos := x;
  flc_ypos := y;
  OldClock := GetClock;
  blockread(f,currblock,sizeof(currblock));
  NextBlockStart := filepos(f) - SizeOf(CurrBlock) + CurrBlock.Size;
  if CurrBlock.Size > 0 then
  for I := 1 to CurrBlock.SubBlocks do begin
    blockread(f,SubBlock,SizeOf(SubBlock));
    if ioresult <> 0 then exit;
    BufSize := SubBlock.Size - SizeOf(SubBlock);
    NextSubBlockStart := filepos(f) + BufSize;
    BufEnd := Buffer;
    inc(BufEnd,BufSize+1);
    if bufsize > readbuffsize then begin
      bytesleft    := bufsize-readbuffsize;
      bufsize      := readbuffsize;
      readbuffstop := readbuffsize-(aniwidth shl 1);
    end else begin
      readbuffstop := readbuffsize;
      bytesleft := 0;
    end;
    blockread(f,buffer^,bufsize);
    if ioresult <> 0 then exit;
    case subblock.blockid of
      0  : ;
      4  : fli_color256;
      7  : fli_worddelta;
      11 : fli_color64;
      12 : fli_bytedelta;
      13 : fli_black;
      15 : fli_brun;
      16 : fli_copy;
      else otherchunk(subblock.blockid);
    end;
    seek(f,nextsubblockstart);
  end;
  seek(f,NextBlockStart);
  inc(CurrFrame);
  if CurrFrame = H.NumFrames then begin
    CurrFrame := 1;
    Seek(f,RestartPos);
  end;
end;


begin
end.