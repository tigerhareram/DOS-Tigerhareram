{$A+,B+,D-,E-,F-,G+,I-,L-,N-,O-,R-,S-,V-,X+}
{****************************************************************************
 * Author           : Stefan Goehler, Germany                               *
 * Version          : official 1.3                                          *
 * Task             : Mousedriver for the unit grafx                        *
 * Copyright : You can use this unit entired in your own programs. Using    *
 *             parts of it or ripping any code off is not allowed without   *
 *             my permission. If you wanna use this unit in commercial      *
 *             products, I mean if you wanna get ANY money or other for     *
 *             software based on one of my units, you'll have to contact me *
 *             - we'll find a way.                                          *
 ****************************************************************************
 * I don't know any bugs - if there are any, please email me:               *
 * stefan.goehler@gmx.de                                                    *
 * my homepage      : http://www.crossfire-designs.de                       *
 *    ^^there is always the newest version available (included in grafx)    *
 * This mouseunit works similar to the unit drivers, which you get with your*
 * copy of TP. Especially the event-handling.                               *
 ******* HISTORY ************************************************************
 * History                                                                  *
 * Version 1.0 : first public availible Version (11. Aug. 1997)             *
 * Version 1.1 : +added support to specify the area to move (setmousearea)  *
 *               +added procedure setmousepos to set cursorposition         *
 * Version 1.11: *changed all a little bit so that it can run correctly with*
 *                setviewport                                               *
 * Version 1.2 : +added support for animated cursors                        *
 *               *mousedr7 uses now instead of the old not very flexible    *
 *                format windows .cur and .ani files                        *
 *               +cursors are now loadable from harddisk                    *
 *               *made unit more compatible - programming bugs do not cause *
 *                any crashes                                               *
 *               *event-engine improved                                     *
 *               +added direct mouseaccess- unit also without mousedriver   *
 *                runable, when the mouse is a MS-compatible on a Comport   *
 * Version 1.3 : +support for Hi/Truecolor-modes                            *
 ****************************************************************************}

unit mousedr7;
interface
uses dos,grafx,gr_vars;
type
  mouse_tevent = record
    buttons : byte   ;
    what    : integer;
    where   : pointtype;
  end;

const
  cursor_std  = 1;
  cursor_hand = 2;
  cursor_wait = 3;
  cursor_text = 4;

{  sensitivy   : byte = 0;{Speed of the cursor}
  cursor      : byte = cursor_std;{Actual cursor}
  buttons     : byte = 0;{pressed buttons; internal}
  evNothing   = $00;
  evMouseDown = $01;
  evMouseUp   = $02;
  evMouseMove = $04;
  evMouseAuto = $08;
  directmouse : boolean = false;


var
  msx,msy   : integer;{posx,posy; internal}
  ps        : pointtype;{internal}
  event     : mouse_tevent; {public record filled by getmouseevent}
  mactive   : byte   ;{hidemouse increases, showmouse decreases this number -
                     to give showmouse the information, how much hidemouse
                     was called and showmouse should be called to see the
                     cursor}
  movearea  : record
    x1,y1,x2,y2 : integer;
  end;
  mouseport : byte;

  procedure initmouse   ;{should be called after setmode}
  procedure donemouse   ;{should be called before closegraph}
  function  getmousetype : string;
  procedure showmouse    ;{show the mouse}
  procedure hidemouse    ;{hide the mouse}
  procedure getmouseevent;{get the mouse events}
  procedure notmovemouse ;{stop the mousemoving, but don't hide the mouse -
                        to do some graphical actions without overdraw the mousecursor}
  procedure letmovemouse;{call it, when you have finished the drawings after notmovemouse}
  procedure changecursor(c : byte);{change the actual cursor}
  function  mousethere(x1,y1,x2,y2 : integer) : boolean;{this function checks,
              if there is any part of the cursor in the specified rectangle}
  function  pointerthere(x1,y1,x2,y2 : integer) : boolean;{this function checks,
                 if there is the top of the cursor in the specified rectangle}
  procedure setmousearea(x1,y1,x2,y2 : integer);
  procedure setmousepos(x,y : integer);

  function  openani(name : string;num : byte) : boolean;
  function  opencur(name : string;num : byte) : boolean;
  function  closecursor(num : byte) : boolean;

implementation
var
  olmsx,olmsy,i     : integer;{last positions}
  mp,mpp            : pointer;{mousecursor in the memory}
  mssize            : word   ;{memory size of the cursor (x*y+4)}
  first,active,run  : boolean;{first : first draw on the screen (after showmouse)
                               active: was already initmouse called?
                               run   : can the mousecursor be moved?}
  hotspot : pointtype;        {the position in the mouseimage where the
                               clicking point is}
  cursors : array[5..19] of record
    p       : pointer;
    memsize : word;
    is_ani  : boolean;
  end;

const
  RxR = 0;
  TxR = 0;
  IER = 1;
  MCR = 4;
  LCR = 3;
  LSR = 5;
  MSR = 6;
  DLL = 0;
  DLH = 1;

  N = 0;
  O = 8;
  E = 24;

  com_irqaddr : array[1..4] of word =(4,3,4,3);

var
  oldint           : pointer;
  com_irq,com_base : word;
  dataqueue        : array[0..49] of byte;
  queuesize        : byte;
  com_baseaddr     : array[1..4] of word;

  procedure mdr_std;external;
  {$L mdr_std}
  procedure mdr_text;external;
  {$L mdr_text}
  procedure mdr_hand;external;
  {$L mdr_hand}
  procedure mdr_wait;external;
  {$L mdr_wait}

function getmousetype : string;
var
  t : byte;
begin
  if not directmouse then begin
    asm
      mov   ax,0024h
      int   33h
      mov   t,ch
    end;
  end else t := 2;
  case t of
    1 : getmousetype := 'Bus-Mouse';
    2 : getmousetype := 'Serial Mouse';
    3 : getmousetype := 'InPort Mouse';
    4 : getmousetype := 'PS/2 Mouse';
    5 : getmousetype := 'HP Mouse';
  end;
end;

function getbit(value,bit : byte) : boolean;assembler;
asm
  mov   cl,bit
  mov   bl,1
  shl   bl,cl
  mov   al,value
  and   al,bl
end;

procedure loadico(p,out : pointer);
{ I know I'd better convert this to asm, but there's no time for such }
{ things yet...                                                       }
const
  convert : array[0..15] of longint=(0,4,2,6,1,5,3,8,7,12,10,14,9,13,11,15);
var
  sx,sy,x,y,bitdepth,i       : word;
  imagestart,mempos,imgsize  : word;
  pixel                      : array[0..255] of longint;
  conv2                      : array[0..255] of longint;
begin
  sx := mem[seg(p^):ofs(p^)+6]-1;
  sy := mem[seg(p^):ofs(p^)+7]-1;
  hotspot.x := memw[seg(p^):ofs(p^)+10];
  hotspot.y := memw[seg(p^):ofs(p^)+12];
  memw[seg(out^):ofs(out^)] := sx;
  memw[seg(out^):ofs(out^)+2] := sy;
  imagestart := mem[seg(p^):ofs(p^)+18]+104;
  bitdepth := mem[seg(p^):ofs(p^)+14+imagestart-104];
  if bitdepth = 4 then begin
    mempos  := succ(sx)*succ(sy)*currentmode.bytesperpixel+4;
    imgsize := succ(sx)*succ(sy) div 2;

    if currentmode.bpp > 8 then
    for i := 0 to 15 do begin
      convert[i] := rgb(mem[seg(p^):ofs(p^)+i*4+imagestart-64+2],
                        mem[seg(p^):ofs(p^)+i*4+imagestart-64+1],
                        mem[seg(p^):ofs(p^)+i*4+imagestart-64]);
    end;
    for y := sy downto 0 do begin
      dec(mempos,succ(sx)*currentmode.bytesperpixel);
{      for x := 0 to sx shr 1 do begin
        pixel[x shl 1] :=
        convert[(mem[seg(p^):ofs(p^)+imagestart+(sy-y)*(succ(sx) shr 1)+x] and $F0) shr 4];
        pixel[x shl 1+1] :=
        convert[mem[seg(p^):ofs(p^)+imagestart+(sy-y)*(succ(sx) shr 1)+x] and $0F];
      end;}
      asm
        mov   cx,sx
        inc   cx
        shr   cx,1
        les   di,p

        mov   dx,sy
        sub   dx,y
        mov   ax,sx
        inc   ax
        mul   dx
        shr   ax,1
        add   di,ax
        add   di,imagestart
        xor   si,si
        @lp:
          xor   bh,bh
          mov   bl,es:[di]
          mov   dl,bl
          shr   dl,4
          and   bl,0Fh
          shl   bx,2
          db 66h;mov   ax,word ptr convert[bx]
          db 66h;mov   word ptr pixel[si+4],ax
          mov   bl,dl
          shl   bx,2
          db 66h;mov   ax,word ptr convert[bx]
          db 66h;mov   word ptr pixel[si],ax
          add   si,8
          inc   di
          dec   cx
        jnz   @lp
      end;

      if currentmode.bpp > 16 then begin
        for x := 0 to sx do begin
          if not getbit(mem[seg(p^):ofs(p^)+imgsize+124+imagestart-y
                        shl 2+x shr 3],7-x and 7) then
                       meml[seg(out^):ofs(out^)+x shl 2+mempos] := pixel[x]
                  else meml[seg(out^):ofs(out^)+x shl 2+mempos] := 255;
        end;
      end else if currentmode.bpp > 8 then begin
        for x := 0 to sx do begin
          if not getbit(mem[seg(p^):ofs(p^)+imgsize+124+imagestart-y
                        shl 2+x shr 3],7-x and 7) then
                       memw[seg(out^):ofs(out^)+x shl 1+mempos] := pixel[x]
                  else memw[seg(out^):ofs(out^)+x shl 1+mempos] := 255;
{          putpixel(x,y,pixel[x]);}
        end;
      end else begin
        for x := 0 to sx do begin
          if not getbit(mem[seg(p^):ofs(p^)+imgsize+124+imagestart-y
                        shl 2+x shr 3],7-x and 7) then
                       mem[seg(out^):ofs(out^)+x+mempos] := pixel[x]
                  else mem[seg(out^):ofs(out^)+x+mempos] := 255;
        end;
      end;
    end;
  end else if bitdepth = 8 then begin
    mempos  := succ(sx)*succ(sy)*currentmode.bytesperpixel+imagedatasize;
    imgsize := succ(sx)*succ(sy);
    inc(imagestart,(256-16)*4);
    if currentmode.bpp > 8 then begin
      for i := 0 to 255 do begin
        conv2[i] := rgb(mem[seg(p^):ofs(p^)+i*4+imagestart-1024+2],
                        mem[seg(p^):ofs(p^)+i*4+imagestart-1024+1],
                        mem[seg(p^):ofs(p^)+i*4+imagestart-1024]);
        if conv2[i] = 255 then conv2[i] := 254; {transparent color}
      end;
      if currentmode.bpp > 16 then begin
        for y := sy downto 0 do begin
          dec(mempos,succ(sx) shl 2);
          for x := 0 to sx do begin
            if not getbit(mem[seg(p^):ofs(p^)+imgsize+124+imagestart-y
                          shl 2+x shr 3],7-x and 7) then
            meml[seg(out^):ofs(out^)+x shl 2+mempos] :=
            conv2[mem[seg(p^):ofs(p^)+imagestart+(sy-y)*succ(sx)+x]] else
            meml[seg(out^):ofs(out^)+x shl 2+mempos] := 255;
          end;
        end;
      end else begin
        for y := sy downto 0 do begin
          dec(mempos,succ(sx) shl 1);
          for x := 0 to sx do begin
            if not getbit(mem[seg(p^):ofs(p^)+imgsize+124+imagestart-y
                          shl 2+x shr 3],7-x and 7) then
            memw[seg(out^):ofs(out^)+x shl 1+mempos] :=
            conv2[mem[seg(p^):ofs(p^)+imagestart+(sy-y)*succ(sx)+x]] else
            memw[seg(out^):ofs(out^)+x shl 1+mempos] := 255;
          end;
        end;
      end;
    end else begin
      for i := 0 to 255 do begin
        conv2[i] := rgb(mem[seg(p^):ofs(p^)+i*4+imagestart-1024+2] shr 2,
                        mem[seg(p^):ofs(p^)+i*4+imagestart-1024+1] shr 2,
                        mem[seg(p^):ofs(p^)+i*4+imagestart-1024] shr 2);
        if conv2[i] = 255 then conv2[i] := 254; {transparent color}
      end;
      for y := sy downto 0 do begin
        dec(mempos,succ(sx));
        for x := 0 to sx do begin
          if not getbit(mem[seg(p^):ofs(p^)+imgsize+124+imagestart-y
                        shl 2+x shr 3],7-x and 7) then
          mem[seg(out^):ofs(out^)+x+mempos] :=
          conv2[mem[seg(p^):ofs(p^)+imagestart+(sy-y)*succ(sx)+x]] else
          mem[seg(out^):ofs(out^)+x+mempos] := 255;
        end;
      end;
    end;
  end;
end;

function mousethere(x1,y1,x2,y2 : integer) : boolean;
begin
if (msx+ps.x < x1)or(msy+ps.y < y1)or
   (msx > x2)or(msy > y2) then mousethere := false
   else mousethere := true;
end;

function pointerthere(x1,y1,x2,y2 : integer) : boolean;
begin
if (event.where.x < x1)or(event.where.y < y1)or
   (event.where.x > x2)or(event.where.y > y2) then pointerthere := false
   else pointerthere := true;
end;

procedure drawcursor;far;
var
  bank : word;
begin
  bank := lastbank;
  if not first then mouse_putimage(olmsx,olmsy,mp);
  mouse_getputimage(msx,msy,mpp,mp,255);
  if lastbank <> bank then setbank2(bank);
end;

var
  nomove,moveint : boolean;

procedure mouse;far;assembler;
var
  sds : word;
asm
  pusha
  cli
  mov   sds,ds
  mov   si,seg @DATA
  mov   ds,si
  cmp   nomove,1 {if animated cursor is changin', then better exit}
  je    @exit
  mov   moveint,1
  mov   ax,msx
  mov   olmsx,ax
  mov   ax,msy
  mov   olmsy,ax
  mov   ax,000bh
  int   33h
{  cmp   sensitivy,0
  je    @next
  sar   cx,1
  sar   dx,1
  @next:}
  mov   si,msx
  mov   di,msy
  add   si,cx
  add   di,dx
  mov   ax,movearea.x1
  cmp   si,ax
  jnl   @cxnotb0
  mov   si,ax
  @cxnotb0:
  cmp   si,movearea.x2
  jng   @cxnotamxx
  mov   si,movearea.x2
  @cxnotamxx:

  mov   ax,movearea.y1
  cmp   di,ax
  jnl   @dxnotb0
  mov   di,ax
  @dxnotb0:
  cmp   di,movearea.y2
  jng   @dxnotamxy
  mov   di,movearea.y2
  @dxnotamxy:
  mov   msx,si
  mov   msy,di
  mov   buttons,bl
  cmp   run,0
  je    @exit
  call  drawcursor
  mov   first,0
  mov   ds,sds
@exit:
  sti
  popa
  mov   moveint,0
end;

procedure mouseint_com;interrupt;
label
  endint;
var
  px,py : shortint;
begin
  dataqueue[queuesize] := port[com_base+RxR];
  inc(queuesize);
  if queuesize = 3 then begin
    queuesize := 0;
    if nomove then goto endint;
    moveint := true;
    buttons := dataqueue[0] and 48 shr 4;
    buttons := (not buttons) and 3;
    px := (dataqueue[1] and 63)+(dataqueue[0] and 3) shl 6;
    py := (dataqueue[2] and 63)+(dataqueue[0] and 12) shl 4;
    olmsx := msx;
    olmsy := msy;
    msx := msx+px;
    msy := msy+py;
    if msx < movearea.x1 then msx := movearea.x1;
    if msx > movearea.x2 then msx := movearea.x2;
    if msy < movearea.y1 then msy := movearea.y1;
    if msy > movearea.y2 then msy := movearea.y2;
    if not run then goto endint;
    drawcursor;
    first := false;
    moveint := false;
  end;
endint:
  port[$20] := $20;
end;

procedure searchint_com;interrupt;
begin
  if queuesize < 49 then begin
    dataqueue[queuesize] := port[com_base+RxR];
    inc(queuesize);
  end;
  port[$20] := $20;
end;


procedure setmousearea(x1,y1,x2,y2 : integer);
var
  temp : boolean;
begin
  hidemouse;
  movearea.x1 := x1;
  movearea.y1 := y1;
  movearea.x2 := x2;
  movearea.y2 := y2;
  if (msx < movearea.x1) then msx := movearea.x1;
  if (msy < movearea.y1) then msy := movearea.y1;
  if (msx > movearea.x2) then msx := movearea.x2;
  if (msy > movearea.y2) then msy := movearea.y2;
  dec(movearea.x1,hotspot.x);
  dec(movearea.y1,hotspot.y);
  dec(movearea.x2,hotspot.x);
  dec(movearea.y2,hotspot.y);
  showmouse;
end;

procedure setmousepos(x,y : integer);
begin
  hidemouse;
  msx := x;
  msy := y;
  if (msx < movearea.x1) then msx := movearea.x1;
  if (msy < movearea.y1) then msy := movearea.y1;
  if (msx > movearea.x2) then msx := movearea.x2;
  if (msy > movearea.y2) then msy := movearea.y2;
  dec(msx,hotspot.x);
  dec(msy,hotspot.y);
  showmouse;
end;

procedure notmovemouse;assembler;
asm
  mov   nomove,1
end;

procedure letmovemouse;assembler;
asm
  mov   al,mactive
  or    al,al
  jnz   @end
  mov   nomove,0
  @end:
end;


procedure showmouse;assembler;
asm
  cli
  mov   nomove,1
  mov   cl,mactive
  mov   bl,1
  mov   al,active
  or    al,al
  jz    @end
  mov   first,bl
  cmp   cl,bl
  jg @end2
    mov   first,1
    call  drawcursor
    mov   first,0
    mov   run,1
    jmp   @end
  @end2:
  dec   cl
  @end:
  mov   mactive,cl
  mov   nomove,0
  sti
end;

procedure hidemouse;assembler;
asm
  cli
  mov   nomove,1
  cmp   active,0
  je    @end
  xor   al,al
  mov   run,al
  inc   mactive
  cmp   first,1
  je    @end
  mov   first,al
  push  msx
  push  msy
  push  word ptr mp[2]
  push  word ptr mp[0]
  call  mouse_putimage
  @end:
  mov   nomove,0
  sti
end;


type
  riffheader = record{20}
    riff      : array[0..3] of char;
    chunksize : longint;
    acon      : array[0..3] of char;
  end;
  list = record
    list : array[0..3] of char;
    size : longint;
    name : array[0..7] of char;
  end;

var
  pixel                : array[0..639] of byte;
  f                    : file;
  p                    : pointer;
  h                    : riffheader;
  mempos               : word;
  l                    : list;
  anih : record
    pics      : longint;{real saved images}
    anipics   : longint;{pictures used in animation}
    crap1     : array[0..15] of byte;
    stdjiffies: longint;{1 Jiffie= 1/60 sec}
    crap2     : array[0..3] of byte;
  end;
  jiffylist,seqlist : pointer;
  jiffyav,seqav     : boolean;

var
  anitime   : real;
  incer     : word;
  lasttime  : word;
  Int1CSave : pointer;
  anirun    : boolean;

procedure anicursor;interrupt;
var
  time,i2   : word;
  bank      : word;
begin
  asm
    pushf
    call  Int1CSave
  end;
  if jiffyav then time := round(memw[seg(jiffylist^):ofs(jiffylist^)+i*4]/60*18.2) else
  time := round(anih.stdjiffies/60*18.2);
  inc(incer);
  if incer >= lasttime+time then
  begin
    lasttime := incer;
    inc(i);
    if not seqav then inc(mempos,memw[seg(p^):ofs(p^)+mempos+4]+8)
    else begin
      i2 := memw[seg(seqlist^):ofs(seqlist^)+i*4];
      mempos := 0;
      for i2 := 1 to i2 do inc(mempos,memw[seg(p^):ofs(p^)+mempos+4]+8)
    end;
    if i = anih.anipics then begin
      mempos := 0;
      i      := 0;
    end;
      loadico(ptr(seg(p^),ofs(p^)+mempos+8),mpp);
    if not moveint then begin
      nomove := true;
      bank := lastbank;
      mouse_putputimage(msx,msy,mpp,mp,255);
      if lastbank <> bank then setbank2(bank);
      nomove := false;
    end else moveint := false;
  end;
end;


procedure loadani(inp : pointer);
var
  loadpos,i2 : word;

  procedure pread(var out;size : word);
  begin
    move2(ptr(seg(inp^),ofs(inp^)+loadpos)^,out,size);
    inc(loadpos,size);
  end;

begin
  jiffyav := false;
  loadpos := 0;
  pread(h,sizeof(h));
  repeat
    pread(l,sizeof(l));
    if l.list = 'anih' then
    begin
      dec(loadpos,4);
      pread(anih,l.size-4);
    end else
    if l.list = 'rate' then
    begin
      jiffylist := ptr(seg(inp^),ofs(inp^)+loadpos-8);
      inc(loadpos,l.size-8);
      jiffyav := true;
    end else
    if l.list = 'seq ' then
    begin
      seqlist := ptr(seg(inp^),ofs(inp^)+loadpos-8);
      inc(loadpos,l.size-8);
      seqav := true;
    end else
    if l.name = 'framicon' then
    else inc(loadpos,l.size-8);
  until (l.name = 'framicon');
  dec(loadpos,4);

  p := ptr(seg(inp^),ofs(inp^)+loadpos);
  mempos := 0;
  i := 0;
  loadico(ptr(seg(p^),ofs(p^)+mempos+8),mpp);
  inc(i);
  if not seqav then inc(mempos,memw[seg(p^):ofs(p^)+mempos+4]+8)
  else begin
    i2 := memw[seg(seqlist^):ofs(seqlist^)+i*4];
    mempos := 0;
    for i2 := 1 to i2 do inc(mempos,memw[seg(p^):ofs(p^)+mempos+4]+8)
  end;
  getintvec($1C,Int1CSave);
  setintvec($1C,@anicursor);
  anirun := true;
end;


function openani(name : string;num : byte) : boolean;
var
  f : file;
begin
  openani := false;
  if (num < 5) or (num > 19) then exit;
  if cursors[num].p <> nil then exit;
  assign(f,name);
  filemode := 64;
  reset(f,1);
  if ioresult <> 0 then exit;
  if filesize(f) > 65528 then exit;
  cursors[num].memsize := filesize(f);
  cursors[num].is_ani  := true;
  getmem(cursors[num].p,cursors[num].memsize);
  blockread(f,cursors[num].p^,cursors[num].memsize);
  close(f);
  openani := true;
end;


function opencur(name : string;num : byte) : boolean;
var
  f : file;
begin
  opencur := false;
  if (num < 5) or (num > 19) then exit;
  if cursors[num].p <> nil then exit;
  assign(f,name);
  filemode := 64;
  reset(f,1);
  if ioresult <> 0 then exit;
  cursors[num].memsize := filesize(f);
  cursors[num].is_ani  := false;
  getmem(cursors[num].p,cursors[num].memsize);
  blockread(f,cursors[num].p^,cursors[num].memsize);
  close(f);
  opencur := true;
end;


function closecursor(num : byte) : boolean;
begin
  closecursor := false;
  if cursors[num].p = nil then exit;
  freemem(cursors[num].p,cursors[num].memsize);
  closecursor := true;
end;


procedure changecursor(c : byte);
begin
  if cursor <> c then begin
    cursor := c;
    hidemouse;
    if anirun then setintvec($1C,int1csave);
    anirun := false;
    inc(movearea.x1,hotspot.x);
    inc(movearea.y1,hotspot.y);
    inc(movearea.x2,hotspot.x);
    inc(movearea.y2,hotspot.y);
    inc(msx,hotspot.x);
    inc(msy,hotspot.y);
    case cursor of
      cursor_std : loadico(@mdr_std,mpp);
      cursor_hand : loadico(@mdr_hand,mpp);
      cursor_wait : loadani(@mdr_wait);
      cursor_text : loadico(@mdr_text,mpp);
      5..19 : if cursors[cursor].p <> nil then
      begin
        if cursors[cursor].is_ani then
        loadani(cursors[cursor].p) else
        loadico(cursors[cursor].p,mpp);
      end;
      else begin
        cursor := 1;
        loadico(@mdr_std,mpp);
      end;
    end;
    dec(msx,hotspot.x);
    dec(msy,hotspot.y);
    dec(movearea.x1,hotspot.x);
    dec(movearea.y1,hotspot.y);
    dec(movearea.x2,hotspot.x);
    dec(movearea.y2,hotspot.y);
    showmouse;
  end;
end;

procedure com_openport(p: word;intproc: pointer);
begin
  com_irq  := com_irqaddr[p];
  com_base := com_baseaddr[p];
  getintvec(com_irq+8,oldint);
  setintvec(com_irq+8,intproc);
  port[$21]          := Port[$21] and not (1 shl com_irq);
  port[com_base+MCR] := 11;
  port[com_base+IER] := 1;
end;

procedure com_closeport;
begin
  setintvec(com_irq+8,oldint);
  port[com_base+MCR] := 0;
  port[com_base+IER] := 0;
  port[$21] := port[$21] or (1 shl com_irq);
end;

procedure com_setspeed(bps: longint);
var
  divisor : word;
begin
  port[com_base+LCR] := port[com_base+LCR] or 128;
  divisor            := 115200 div bps;
  port[com_base+DLL] := lo(divisor);
  port[com_base+DLH] := hi(divisor);
  port[com_base+LCR] := port[com_base+LCR] and not 128;
end;

procedure com_setparam(data,parity,stop : word);
begin
  port[com_base+LCR] := (data-5)+parity+(stop-1) shl 2;
end;

var
  endtime : longint;

function currenttime : longint;assembler;
asm
  mov es,[seg0040]
  mov ax,es:[6Ch]
  mov dx,es:[6Eh]
end;

function searchmouse_com(p : byte) : boolean;
var
  i : integer;
begin
  queuesize := 0;
  com_openport(p,@searchint_com);
  com_setspeed(1200);
  com_setparam(7,N,1);
  endtime := currenttime+28;
  searchmouse_com := false;
  repeat
    if queuesize > 0 then for i := 0 to queuesize-1 do if
    (dataqueue[i] = ord('M')) then begin
      searchmouse_com := true;
      break;
    end;
  until (queuesize >= 49)or(currenttime >= endtime);
  com_closeport;
end;


function initmouse_com(p : byte) : boolean;
begin
  queuesize := 0;
  com_openport(p,@mouseint_com);
  com_setspeed(1200);
  com_setparam(7,N,1);
  endtime := currenttime+28;
  repeat
    if queuesize > 0 then if (dataqueue[queuesize-1] = ord('M')) then break;
  until (queuesize >= 2)or(currenttime >= endtime);
  queuesize := 0;
end;

procedure donemouse_com;
begin
  com_closeport;
end;


procedure initmouse;
begin
  if not gfx_inited then
  begin
    writeln('MouseDR7: Can''t initialize the mouse without graphical mode',#7);
    halt(20);
  end;
  active := true;
  first := true;
  run := true;
{  getimagesize(mp2,ps.x,ps.y);
  mssize := ImageSize(0,0,ps.x,ps.y);}
  mssize := imagesize(0,0,31,31);
  getmem(mpp,mssize);
  getmem(mp ,mssize);
  loadico(@mdr_std,mpp);
  movearea.x1 := -hotspot.x;
  movearea.y1 := -hotspot.y;
  movearea.x2 := mxx-hotspot.x;
  movearea.y2 := mxy-hotspot.y;
  msx := -hotspot.x;
  msy := -hotspot.y;
  if not directmouse then
  asm
    {set the pointer to the mouseprocedure}
    mov   ax,12
    mov   cx,0FFFFh
    mov   dx,offset cs:mouse
    push  cs
    pop   es
    int   33h
    {reset mouseposition}
    mov   ax,000bh
    int   33h
  end else initmouse_com(mouseport);
  mactive := 0;
end;


procedure donemouse;
begin
  if active then begin
    hidemouse;
    if anirun then setintvec($1C,int1csave);
    anirun := false;
    active := false;
    asm
      cmp   directmouse,0
      jne   @stop_com
        mov   ax,12
        xor   cx,cx
        xor   dx,dx
        mov   es,cx
        int   33h
        jmp   @end
      @stop_com:
        call donemouse_com
      @end:
    end;
    freemem(mp ,mssize);
    freemem(mpp,mssize);
  end;
end;

procedure getmouseevent;
begin
  if not active then exit;
  event.what    := 0;
  if (event.buttons and 1 = 0)and(buttons and 1 <> 0) then event.what := event.what or evmousedown else
  if (event.buttons and 1 <> 0)and(buttons and 1 = 0) then event.what := event.what or evmouseup;
  if (event.buttons and 2 = 0)and(buttons and 2 <> 0) then event.what := event.what or evmousedown else
  if (event.buttons and 2 <> 0)and(buttons and 2 = 0) then event.what := event.what or evmouseup;
  event.buttons := buttons;
  if (event.where.x <> msx+hotspot.x)and(event.where.y <> msy+hotspot.y) then begin
    if buttons = 0 then event.what := event.what or evmousemove else
    event.what := event.what or evmouseauto;
  end;
  event.where.x := msx+hotspot.x;
  event.where.y := msy+hotspot.y;
end;


var
  ports : integer;

begin
  asm
    xor   ax,ax
    xor   bx,bx
    int   33h
    mov   i,ax
  end;
  if i = 0 then begin
    writeln('Mouseunit: No driver found, searching mouse...');
    for i := 0 to 3 do com_baseaddr[i+1] := memw[seg0040:i shl 1];
    ports := 0;
    while com_baseaddr[ports+1] <> 0 do inc(ports);
    directmouse := false;
    for mouseport := 1 to ports do if searchmouse_com(mouseport) = true then begin
      directmouse := true;
      writeln('Microsoft-compatible mouse found at Com ',mouseport);
      break;
    end;
    if directmouse then
    else begin
      writeln('No Microsoft-compatible mouse found, program cannot be started');
      halt;
    end;
  end;
end.






