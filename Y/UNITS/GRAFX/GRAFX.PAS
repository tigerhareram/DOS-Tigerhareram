{$A+,B+,F-,G+,I-,O+,P+,Q-,R-,S-,T-,V-,X+,Y-,N+}
unit grafx;
{**** GRAFX *****************************************************************
 * Author    : Stefan Goehler, Germany                                      *
 * Version   : 1.4c                                                         *
 * Task      : Replacing the unit graph with much more speed and features   *
 * References: . C'T 6/95, C'T 2/97 (the BEST german computer magazine)     *
 *             . t1-svga1.zip                                               *
 *             . vgadoc4b.zip (look with Altavista or sth. else for them)   *
 *             . COMPUTER GRAPHICS: principles and practice (second edition)*
 *               - english version (ISBN 0-201-12110-7)                     *
 *             . PC Intern 5 (very good german-only book)                   *
 *             . some graphicunits and standalone-units                     *
 *             . FPK-graph-Sources                                          *
 *             . SWAG                                                       *
 *             . my own knowledge :)                                        *
 * Copyright : You can use this unit entired in your own programs. Using    *
 *             parts of it or ripping any code off is not allowed without   *
 *             my permission. If you wanna use this unit in commercial      *
 *             products, I mean if you wanna get ANY money or other for     *
 *             software based on one of my units, you'll have to contact me *
 *             - we'll find a way.                                          *
 *             More details in grafx.txt                                    *
 * Comments  :-have fun, it's only to 80,333 percent compatible with unit   *
 *             graph ;)                                                     *
 ******** INFORMATION *******************************************************
 * my homepage: http://www.crossfire-designs.de                             *
 * ^^^note that you can get there always the actual version of this unit    *
 * if you have additions, tips or sth. else, mail to stefan.goehler@gmx.de  *
 ****************************************************************************}

interface
uses crt,{$IFDEF DPMI}winapi,{$ENDIF}
     gr_vars,gr_8bit,gr_hicol;

type
  LineSettingsType = record
    linestyle : word;
    pattern   : word;
    thickness : word;
  end;
  FillSettingsType = record
    pattern : word;
    color   : longint;
  end;
  timage_info = record
    { They MUST be ALL filled by a loader! }
    size         : pointtype;
    bpp          : word   ;   { Bytes per pixel            }
    greyscale    : boolean;
    alphachannel : boolean;
    transparency : boolean;   { Image is transparent       }
    compressed   : boolean;
    comptype     : string[15];{ Short compression type string, i.e. 'RLE' }
    interlaced   : boolean;
    frames       : longint;   { only filled if video       }
    speed        : longint;   { if video, then in fps*1000, means 25 fps = 25000 }
    trans_color  : longint;   { transparent color          }
    memsize      : longint;   { size in memory when loaded }
    disksize     : longint;   { file size on disk          }
    supported    : boolean;   { true if loadable by loader }
    version      : longint;   { version of the imageformat }
  end;

const
(*  modeset : array[0..9] of record
    mode,sx,sy : word;
  end=((mode:$013;sx:0319;sy:0199),
       (mode:$100;sx:0639;sy:0399),
       (mode:$101;sx:0639;sy:0479),
       (mode:$103;sx:0799;sy:0599),
       (mode:$105;sx:1023;sy:0767),
       (mode:$107;sx:1279;sy:1023),
       (mode:$120;sx:1599;sy:1199),{maybe that's not the same on all cards}
       (mode:0;sx:1;sy:1),
       (mode:0;sx:1;sy:1),
       (mode:0;sx:1;sy:1));*)
  imagedatasize : word = 4;

{ Errorcodes for imageloaders }
  image_noerror      = 0;
  image_filenotfound = 1;
  image_falseformat  = 2;
  image_fileerror    = 3;
  image_falseend     = 4;
  image_nomem        = 5;
  image_nodiskmem    = 6;
  image_falsebpp     = 7;
  image_generror     = 8;

  image_errorstr : array[0..8] of string = ('No error',
                                            'File not found',
                                            'Format not supported',
                                            'File error',
                                            'Unexpected end of file',
                                            'Not enough memory',
                                            'Disk full',
                                            'Not able to convert colordepth',
                                            'Generic error');
{ Data alignment constants for imageoutput (ie putline24) }
  align_bgr = 0;
  align_rgb = 1;

{Palette-functions}
var
  setpal : procedure;
  procedure shiftpal;
  procedure getuserpal(var pal);
  procedure setuserpal(var pal);
  procedure setrgbpal(col,r,g,b : byte);
  procedure getrgbpal(col : byte;var r,g,b : byte);
var
  setrgbpalette : procedure(col,r,g,b : byte);
  getrgbpalette : procedure(col : byte;var r,g,b : byte);
  rgb     : function(r,g,b : byte) : longint;
  dergb   : procedure(col : longint;var r,g,b : byte);
  procedure convbpp(pixels,inbpp,outbpp : word;input,output : pointer);

  function  loadjascpal(path : string) : boolean;
  function  loadpal(name : string;pal : pointer) : boolean;

{ procedure getvesamodeinfo(m : word);}
  function  openimage(var p : pointer;sx,sy : word) : word;
  procedure closeimage(var p : pointer);
  procedure clearimage(p : pointer);
  procedure setaccelerationmode(mode : byte);
  procedure setmode(resx,resy,bpp : word);
  function  grapherrormsg(errorcode : integer) : string;
  function  graphresult : integer;
  function  getdrivername : string;
  procedure closegraph;
  procedure waitretrace;
{ procedure pageretrace;}
  procedure hretrace;
  procedure setscreen(on : boolean);
  procedure setviewport(x1,y1,x2,y2 : integer;clip : boolean);
  procedure getviewsettings(var viewport : viewporttype);
  procedure clearviewport;

{graphical functions}
  procedure getimagesize(p : pointer;var x,y : word);
  procedure setimagesize(p : pointer;x,y : word);
  function  imagesize(x1,y1,x2,y2 : integer) : word;
  procedure scale(image : pointer;px,py : integer;sx,sy : word);
var
  getpixel : function(x,y : integer) : longint;
  putpixel : procedure(x,y : integer;col : longint);

  procedure mouse_putimage(x,y: integer;p1 : pointer);
  procedure mouse_getputimage(x,y: integer;p1,p2 : pointer;key : longint);
  procedure mouse_putputimage(x,y: integer;p1,p2 : pointer;key : longint);
  procedure putsprite(x,y: integer;p : pointer;key : longint);
  procedure getimage(x1,y1,x2,y2 : integer;p : pointer);
  procedure putimage(x,y: integer;p : pointer);
var
  bar     : procedure(x1,y1,x2,y2: integer);
  line    : procedure(x1,y1,x2,y2: integer);
  bitblit : procedure(x1,y1,x2,y2,dstx,dsty : integer);

  procedure rbar(x1,y1,x2,y2 : integer;r : word);
  procedure fillcircle(x,y : integer;r : word);
  procedure fillellipse(x,y : integer;rx,ry : word);
  procedure circle(px,py : integer;r : word);
  procedure ellipse(px,py,rx,ry : integer);
var
  vline       : procedure(x1,y1,sizey : integer;col : longint);
  hline       : procedure(x1,y1,sizex : integer;col : longint);
  patternline : procedure(x1,y1,sizex : integer;col : longint);

  {Change these 2 procedures to use your own image output procedures to
   load the image i.e. into memory instead of putting them onto screen}
  image_putline : procedure(x,y : integer;sizex : word;bpp : byte;data : pointer);
  image_getline : procedure(x,y : integer;sizex : word;bpp : byte;data : pointer);
  image_pp      : procedure(x,y : integer;bpp : byte;col : longint);

  procedure putline(x1,y1,sizex: integer;p : pointer);
  procedure putline24(x1,y1,sizex: integer;p : pointer);
  procedure putline8(x1,y1,sizex: integer;p : pointer);

  procedure spriteline(x1,y1,sizex : integer;p : pointer;key : byte);
  procedure getline(x1,y1,sizex : integer;p : pointer);
var
  fillpoly : procedure (numpoints : word;var polypoints);
  procedure drawpoly(numpoints : word;var polypoints);
  procedure rectangle(x1,y1,x2,y2 : integer);
  procedure rrectangle(x1,y1,x2,y2 : integer;r : word);
  var cleardevice : procedure;

{Text-functions}
  procedure readgraphline(x1,y1,col,maxchars,posx : word;var s2 : string);

  procedure writexy(x,y : integer;s : string);
  procedure setfont(fnt,size : byte);
  procedure settextstyle(font,direction,charsize : word);
  procedure gettextsettings(var textinfo : textsettingstype);
  function  textheight : word;
  procedure settextjustify(horiz,vert : word);
const
  outtextxy : procedure(x,y : integer;textstring : string) = writexy;
  textwidth : function(s : string) : word = gr_vars.textwidth;

  procedure setactivepage(page : word);
  procedure setvisualpage(page : word);
  procedure copypage(source,destination : word);
var
  scroll : procedure(ypos : word);
  setfillstyle : procedure(pattern : word; col : longint);

  procedure setcolor(col : longint);
  procedure setbkcolor(col : longint);
  function  getcolor : longint;
  procedure getfillsettings(var FillInfo: FillSettingsType);
  procedure setfillcolor(col : longint);
  procedure setfillpattern(pattern : fillpatterntype;color : word);
  procedure setlinestyle(style : word;pattern : word;thickness : word);
  procedure getlinesettings(var lineinfo: linesettingstype);

  procedure calccircle(r : integer);

const
  Black        : longint = 0;
  maxmodes     = 24;
var
  setwritemode : procedure(mode : byte);
  convdata     : procedure(var input,output;size : word);
  conv8bit     : procedure(var input,output;size : word);

  mxx,mxy,maxx,maxy: integer;
  actpage : byte;

  restab  : array[0..4] of record
    avmodes : word;
    mode : array[0..maxmodes-1] of record
      resx,resy,mode,dummy : word;
    end;
  end;

  Blue,Green,Cyan,Red,Magenta,Brown,LightGray,
  DarkGray,LightBlue,LightGreen,LightCyan,
  LightRed,LightMagenta,Yellow,White : longint;

const
  normalput  = 0;
  copyput    = 0;
  andput     = 3; {not supported}
  orput      = 2; {not supported}
  xorput     = 1;
  notput     = 0; {not supported}

{Fill patterns}
  EmptyFill     =  0;
  SolidFill     =  1;
  LineFill      =  2;
  LtSlashFill   =  3;
  SlashFill     =  4;
  BkSlashFill   =  5;
  LtBkSlashFill =  6;
  HatchFill     =  7;
  XHatchFill    =  8;
  InterleaveFill=  9;
  WideDotFill   =  10;
  CloseDotFill  =  11;
  UserFill      =  12;

{Line style settings - support for circle implemented}
  SolidLn    = 0;
  DottedLn   = 1;
  CenterLn   = 2;
  DashedLn   = 3;
  UserBitLn  = 4;

  NormWidth  = 1;
  ThickWidth = 1;{not supported}

{Font constants}
  DefaultFont  = 0;
  TriplexFont  = 2;
  SmallFont    = 2;
  SansSerifFont= 2;
  GothicFont   = 2;
  HorizDir     = 0;
  VertDir      = 1;{not supported}
  UserCharSize = 0;
{Settextjustify-constants}
{Horizontal}
  LeftText     = 0;
  RightText    = 2;
{Vertikal}
  BottomText   = 0;
  TopText      = 2;
{vertikal and horizontal}
  CenterText   = 1;
{constants for setviewport}
  ClipOn       = True;
  ClipOff      = False;

  {graphresult constants - I removed some because they're not needed here}
  grOk             =  0;
  grNotDetected    =  2;
  grFontNotFound   =  8;
  grNoFontMem      =  9;
  grInvalidMode    = 10;
  grError          = 11;
  grIOerror        = 12;
  grInvalidFont    = 13;
  grInvalidFontNum = 14;
  grNoMouseFound   = 15;

  grafx_version = 'GrafX 1.4c';

implementation

function openimage(var p : pointer;sx,sy : word) : word;
{Get memory for an image and set it's size there}
var
  size : word;
begin
  size := imagesize(0,0,sx,sy);
  openimage := size;
  if size = 0 then begin
    p := nil;
    exit;
  end;
  getmem(p,size);
  memw[seg(p^):ofs(p^)]   := sx;
  memw[seg(p^):ofs(p^)+2] := sy;
end;

procedure closeimage(var p : pointer);
{Free the memory of an image}
var
  size : word;
begin
  size := imagesize(0,0,memw[seg(p^):ofs(p^)],memw[seg(p^):ofs(p^)+2]);
  freemem(p,size);
  p := nil;
end;

procedure clearimage(p : pointer);assembler;
{a little clearer for images getted
with getimage or sized with setimagesize}
asm
  cld
  les   di,p
  mov   ax,es
  cmp   ax,0
  je    @end { image pointer not initialized }
  mov   ax,es:[di]
  inc   ax
  mov   bx,es:[di+2]
  inc   bx
  mul   bx
  mov   cx,ax
  mov   bx,ax
  shr   cx,2
  add   di,imagedatasize
  db    66h;xor ax,ax
  db    0F3h,66h,0ABh{rep stosd}
  mov   cx,bx
  and   cx,11b
  jz    @end
  rep   stosb
  @end:
end;

procedure pageretrace;assembler;
{avoids flickering when using setvisualpage}
asm
  cmp   pr,0
  je    @end
  mov   dx,03DAh
  @lp1:
    in    al,dx
    test  al,8
  jnz   @lp1
  @lp2:
    in    al,dx
    test  al,8
  jz   @lp2
  @end:
end;

procedure setactivepage(page : word);
{sets page to draw at}
begin
  if currentmode.numofpages >= page then begin
    pageadd       := page*maxy;
    actpage       := page;
    actscreen.mxy := currentmode.lasty-pageadd;
  end;
end;

procedure setvisualpage(page : word);assembler;
{sets visible page}
asm
  mov   bx,page
  mov   ax,maxy
  mul   bx
  mov   dx,ax
  cmp   currentmode.numofpages,bl
  jnae  @end
  @next:
    push  dx
    call  scroll
  @end:
  call  pageretrace {avoid flickering}
end;

procedure copypage(source,destination : word);
begin
  bitblit(0,source*maxy,mxx,mxy+source*maxy,0,maxy*destination);
end;

procedure scroll_vesa(ypos : word);far;assembler;
asm
  mov   dx,ypos
  mov   ax,4f07h
  xor   bx,bx
  xor   cx,cx
  int   10h
end;

procedure cleardevice_vesa;far;{guess...}
var
  w    : word   ;
  l    : longint;
begin
  calcbank(0,pageadd);
  w := pageadd*currentmode.scanline;
  l := longint(currentmode.scanline)*maxy;
  if w > 0 then
  fillbyte(ptr(currentmode.writeptr,w)^,65536-w,0) else
  filldword(ptr(currentmode.writeptr,0)^,16384,0);
  dec(l,65536-w);
  repeat
    incbank;
    if l >= longint(65536) then
    filldword(ptr(currentmode.writeptr,0)^,16384,0) else
    fillbyte(ptr(currentmode.writeptr,0)^,l,0);
    dec(l,65536);
  until l <= 0;
end;



procedure scale(image : pointer;px,py : integer;sx,sy : word);
{ This new scaler is based partially on the one of kojakvga.
  (Sorry, there was no other way than ripping :)
  Originally it was even slower than my one, but I improved
  Kojak's source and gained around 35% more speed than it's
  original :P. It's around 15% faster than my old one, the
  code is more clear, it's not size-limited and it doesn't
  need for every x-pixel one more word in an array.          }
var
  y,maxx,maxy,putx,puty,old,mempos : word;
  umry,wx  : longint;

begin
  if (sx = 0)or(sy = 0) then exit;

  getimagesize(image,maxx,maxy);
  umry   := 0;
  old    := 65535;
  mempos := imagedatasize;
{  if actviewport.clip then if sx+px > actviewport.mxx+1 then putx := actviewport.mxx+1-px;}

  putx := sx;
  if px+sx+fillviewport.x1 > fillviewport.x2 then putx := fillviewport.mxx+1-px;
  puty := sy;
  if py+sy+fillviewport.y1 > fillviewport.y2 then puty := fillviewport.mxy+1-py;

  inc(maxx);
  inc(maxy);

{  wx := 65536 div (sx*currentmode.bytesperpixel) * maxx;}

  wx := (65536*maxx) div sx;

  if gfxbufsize div currentmode.bytesperpixel < putx
  then putx := gfxbufsize div currentmode.bytesperpixel;

  if (currentmode.bpp = 8) then
    asm
      dec   puty
      mov   ax,puty
      mov   y,ax
      @nextline:
      mov   cx,sy
      mov   ax,word ptr umry
      mov   dx,word ptr umry[2]
      div   cx
      { Check if the next line to display is the same as the last one }
      cmp   old,ax
      je    @end
      mov   old,ax
      { Nope: init values for next line }
      mov   ax,mempos
      push  ds

      les   di,gfxbuf
      lds   si,image
      add   si,ax

      mov   cx,putx
      mov   dx,word ptr wx
      xor   bx,bx
      inc   cx  { Needed for odd values }
      shr   cx,1
      push  bp
      mov   bp,word ptr wx[2]
      { Calculate next scaled line }
@lp:
        mov   al,[si]
        add   bx,dx
        adc   si,bp
        mov   ah,[si]
        mov   es:[di],ax
        add   bx,dx
        adc   si,bp
        add   di,2
        dec   cx
      jnz   @lp
      pop   bp
      pop   ds


      mov   si,maxx
      add   mempos,si
      @end:
      db    66h;xor   ax,ax
      mov   ax,maxy
      db    66h;add   word ptr umry,ax
      { Displayment }
      mov   ax,py
      inc   py
      les   di,gfxbuf
      push  px
      push  ax
      push  putx
      push  es
      push  di
      call  putline

      dec   y
      jns   @nextline
    end else
    if (currentmode.bpp <= 16) then
    asm
      dec   puty
      mov   ax,puty
      mov   y,ax
      @nextline:
      mov   cx,sy
      mov   ax,word ptr umry
      mov   dx,word ptr umry[2]
      div   cx
      { Check if the next line to display is the same as the last one }
      cmp   old,ax
      je    @end
      mov   old,ax
      { Nope: init values for next line }
      mov   ax,mempos
      push  ds

      les   di,gfxbuf
      lds   si,image
      add   si,ax

      mov   cx,putx
      mov   dx,word ptr wx
      xor   bx,bx
      push  bp
      mov   bp,word ptr wx[2]
      add   bp,bp
      { Calculate next scaled line }
@lp:
        mov   ax,[si]
        add   bx,dx
        jnc   @noadd
          add  si,2
        @noadd:
        add   si,bp
        mov   es:[di],ax
        add   di,2
        dec   cx
      jnz   @lp
      pop   bp
      pop   ds

      mov   si,maxx
      add   si,si
      add   mempos,si
      @end:
      db    66h;xor   ax,ax
      mov   ax,maxy
      db    66h;add   word ptr umry,ax
      { Displayment }
      mov   ax,py
      inc   py
      les   di,gfxbuf
      push  px
      push  ax
      push  putx
      push  es
      push  di
      call  putline

      dec   y
      jns   @nextline
    end;
end;



var
  size_last_circle : word;

procedure calccircle(r : integer);assembler;
asm
  mov   bx,r
  cmp   bx,size_last_circle
  je    @end                  {if the last circle had the same size, exit}

  mov   size_last_circle,bx
  mov   di,bx
  add   di,di
  mov   word ptr point,0
  mov   word ptr point[di],bx
  mov   si,1
  sub   si,bx                 { d := 1-r               }
  xor   cx,cx                 { x := 0                 }
  mov   ax,bx                 { y := r                 }
  or    ax,ax
  jbe   @end

  xor   di,di
  add   bx,bx

@start:                       { while y > x do begin   }
  or    si,si                 { if d < 0 then begin    }
  jns   @next
    mov   dx,cx
    add   dx,dx
    add   dx,3
    add   si,dx               { inc(d,x shl 1 + 3)     }
    inc   cx                  { inc(x)                 }
    sub   bx,2
    jmp   @stop               { end                    }
  @next:                      { else begin             }
    mov   dx,cx
    sub   dx,ax
    add   dx,dx
    add   dx,3
    add   si,dx               { inc(d,(x-y) shl 1 + 3) }
    inc   cx                  { inc(x)                 }
    sub   bx,2
    dec   ax                  { dec(y)                 }
    add   di,2
  @stop:                      { end                    }
  mov   word ptr point[di],cx { point[r-y] := x        }
  mov   word ptr point[bx],ax { point[r-x] := y        }
  cmp   ax,cx
  jg    @start
  @end:
end;

(*procedure calcellipse(rx,ry : longint);
var
  x,mx1,mx2,my1,my2 : integer;
  aq,bq,dx,dy,r,a,b : longint;
begin
  mx1 := -rx;
  my1 := 0;
  mx2 := rx;
  my2 := 0;

  aq := longint(rx) * rx;
  bq := longint(ry) * ry;
  dx := aq shl 1;
  dy := bq shl 1;
  r  := rx * bq;
  a  := r shl 1;
  b  := 0;
  x  := rx;
  while x > 0 do begin
    if r > 0 then begin
      inc(my1);
      dec(my2);
      inc(b,dx);
      dec(r,b);
    end;
    if r <= 0
    then begin
      dec(x);
      inc(mx1);
      dec(mx2);
      dec(a,dy);
      inc(r,a);
    end;
    point[ry-my1] := mx1;
  end;
end;*)

procedure calcellipse(rx,ry : longint);assembler;
var
  x,mx1,mx2,my1,my2 : integer;
  aq,bq,dx1,dy,r,a,b : longint;
asm
  mov   ax,rx.word
  mov   x,ax
  mov   my2,ax
  neg   ax
  mov   mx1,ax
  db 66h;xor ax,ax
  mov   my1,ax
  mov   my2,ax
  db 66h;mov   b.word,ax
  db 66h;mov   ax,rx.word
  db 66h;mul   ax
  db 66h;mov   aq.word,ax
  db 66h;shl   ax,1
  db 66h;mov   dx1.word,ax
  db 66h;mov   ax,ry.word
  db 66h;mul   ax
  db 66h;mov   bq.word,ax
  db 66h;shl   ax,1
  db 66h;mov   dy.word,ax
  db 66h;mov   ax,rx.word
  db 66h;mul   bq.word
  db 66h;mov   r.word,ax
  db 66h;shl   ax,1
  db 66h;mov   a.word,ax
@lx:
  db 66h;cmp   r.word,0
  jle @l1
  inc my1
  dec my2
  db 66h;mov   ax,b.word
  db 66h;add   ax,dx1.word
  db 66h;mov   b.word,ax
  db 66h;sub   r.word,ax
@l1:
  db 66h;cmp   r.word,0
  jg @l2
  dec x
  inc mx1
  dec mx2
  db 66h;mov   ax,a.word
  db 66h;sub   ax,dy.word
  db 66h;mov   a.word,ax
  db 66h;add   r.word,ax
@l2:
  mov   bx,ry.word
  sub   bx,my1
  mov   ax,mx1
  shl   bx,1
  mov   [bx+point].word,ax
  cmp   x,0
  ja @lx
end;

procedure fillcircle(x,y : integer;r : word);
{draws a filled circle}
var
  i  : integer;
begin
  if (r > 500)or(r = 0) then exit;
  dec(y,r);
  calccircle(r);
    for i := 0 to r-1 do begin
      patternline(x-point[i],y,point[i] shl 1,fillcolor);
      inc(y);
    end;
    for i := r-1 downto 0 do begin
      patternline(x-point[i],y,point[i] shl 1,fillcolor);
      inc(y);
    end
end;

procedure fillellipse(x,y : integer;rx,ry : word);
{draws a filled ellipse}
var
  i : integer;
begin
  if (ry > 500)or(rx = 0)or(ry = 0) then exit;
  dec(y,ry);
  if rx <> ry then calcellipse(rx,ry) else calccircle(rx);
    for i := 0 to ry-1 do begin
      patternline(x-point[i],y,point[i] shl 1,fillcolor);
      inc(y);
    end;
    for i := ry-1 downto 0 do begin
      patternline(x-point[i],y,point[i] shl 1,fillcolor);
      inc(y);
    end
end;


procedure circle(px,py : integer;r : word);
{draws a traced circle}
var
  a,b,d : integer;
begin
  if r > 1 then begin
    a := 0;
    b := r;
    d := 1-r;
    stylecounter := 1;

    while b >= a do begin
      if d < 0 then begin
        inc(d,a shl 1 + 3);
        inc(a);
      end else begin
        inc(d,(a - b) shl 1 + 5);
        inc(a);
        dec(b);
      end;
      inc(stylecounter,stylecounter);
      if stylecounter = 0 then stylecounter := 1;
      if stylecounter and linestyle <> 0 then begin
        putpixel(px+a,py-b,currentcolor);
        putpixel(px-a,py-b,currentcolor);
        putpixel(px+b,py-a,currentcolor);
        putpixel(px-b,py-a,currentcolor);
        putpixel(px+b,py+a,currentcolor);
        putpixel(px-b,py+a,currentcolor);
        putpixel(px+a,py+b,currentcolor);
        putpixel(px-a,py+b,currentcolor);
      end;
    end;
    {algorythm won't calculate the first pixels - we have to put them ourself}
    putpixel(px,py-r,currentcolor);
    putpixel(px-r,py,currentcolor);
    putpixel(px+r,py,currentcolor);
    putpixel(px,py+r,currentcolor);
  end else putpixel(px,py,currentcolor);
end;


procedure ellipse(px,py,rx,ry : integer);
var
  x,mx1,mx2,my1,my2 : integer;
  aq,bq,dx,dy,r,a,b : longint;
begin
  stylecounter := 1;
  mx1 := px - rx;
  my1 := py;
  mx2 := px + rx;
  my2 := py;

  putpixel(mx2,py,currentcolor);
  putpixel(mx1,py,currentcolor);

  aq := longint(rx) * rx;
  bq := longint(ry) * ry;
  dx := aq shl 1;
  dy := bq shl 1;
  r  := rx * bq;
  a := r shl 1;
  b := 0;
  x  := rx;
  while x > 0 do begin
    if r > 0 then begin
      inc(my1);
      dec(my2);
      inc(b,dx);
      dec(r,b);
    end;
    if r <= 0
    then begin
      dec(x);
      inc(mx1);
      dec(mx2);
      dec(a,dy);
      inc(r,a);
    end;
    inc(stylecounter,stylecounter);
    if stylecounter = 0 then stylecounter := 1;
    if stylecounter and linestyle <> 0 then begin
      putpixel(mx1,my1,currentcolor);
      putpixel(mx2,my1,currentcolor);
      putpixel(mx1,my2,currentcolor);
      putpixel(mx2,my2,currentcolor);
    end;
  end;
end;

procedure mouse_putimage(x,y: integer;p1 : pointer);
var
  sizex,sizey,i,i2,i3,i4,oli2,putmaxx : word;
  x2,y2                               : integer;
  switched                            : boolean;
begin
  sizex := succ(memw[seg(p1^):ofs(p1^)]);
  sizey := memw[seg(p1^):ofs(p1^)+2];
  x2 := x+sizex-1;
  y2 := y+sizey;
  i4 := 0;

  if (y > actscreen.y2) or (y2 < actscreen.y1) then exit;
  if (x > actscreen.x2) or (x2 < actscreen.x1) then exit;
  if x  < actscreen.x1 then begin
    inc(i4,actscreen.x1-x);
    x       := actscreen.x1;
  end;
  if x2 > actscreen.x2 then x2 := actscreen.x2;
  if y  < actscreen.y1 then begin
    inc(i4,sizex*(actscreen.y1-y));
    y  := actscreen.y1;
  end;
  if y2 > actscreen.y2 then y2 := actscreen.y2;

  putmaxx := succ(x2-x)*currentmode.bytesperpixel;
  if putmaxx = 0 then exit;
  sizey := y2-y;
  inc(y,pageadd);
  i2 := calcbank(x-actviewport.x1,y-actviewport.y1);
  i4 := i4*currentmode.bytesperpixel+imagedatasize;
  sizex := sizex*currentmode.bytesperpixel;
  oli2 := i2;
  switched := false;
  for i := y to y+sizey do begin
    if i2 < i2+putmaxx then begin
      if (oli2 > i2)and(not switched) then incbank;
      move2screen(ptr(seg(p1^),ofs(p1^)+i4)^,ptr(currentmode.writeptr,i2)^,putmaxx);
      switched := false;
    end else begin
      i3 := 0-i2;
      move2screen(ptr(seg(p1^),ofs(p1^)+i4)^,ptr(currentmode.writeptr,i2)^,i3);
      incbank;
      switched := true;
      move2(ptr(seg(p1^),ofs(p1^)+i4+i3)^,ptr(currentmode.writeptr,0)^,putmaxx-i3);
    end;
    inc(i4,sizex);
    oli2 := i2;
    inc(i2,currentmode.scanline);
  end;
end;


procedure mouse_getputimage(x,y: integer;p1,p2 : pointer;key : longint);
var
  sizex,sizey,i,i2,i3,i4,oli2,putmaxx : word;
  x2,y2                               : integer;
  switched                            : boolean;
begin
  sizex := succ(memw[seg(p1^):ofs(p1^)]);
  sizey := memw[seg(p1^):ofs(p1^)+2];
  memw[seg(p2^):ofs(p2^)]   := sizex-1;
  memw[seg(p2^):ofs(p2^)+2] := sizey;
  x2 := x+sizex-1;
  y2 := y+sizey;
  i4 := 0;

  if (y > actscreen.y2) or (y2 < actscreen.y1) then exit;
  if (x > actscreen.x2) or (x2 < actscreen.x1) then exit;
  if x  < actscreen.x1 then begin
    inc(i4,actscreen.x1-x);
    x := actscreen.x1;
  end;
  if x2 > actscreen.x2 then x2 := actscreen.x2;
  if y  < actscreen.y1 then begin
    inc(i4,sizex*(actscreen.y1-y));
    y := actscreen.y1;
  end;
  if y2 > actscreen.y2 then y2 := actscreen.y2;
  putmaxx := succ(x2-x)*currentmode.bytesperpixel;
  if putmaxx = 0 then exit;
  sizey := y2-y;
  inc(y,pageadd);
  i2 := calcbank(x-actviewport.x1,y-actviewport.y1);
  i4 := i4*currentmode.bytesperpixel+imagedatasize;

  sizex := sizex*currentmode.bytesperpixel;
  oli2 := i2;
  switched := false;
  for i := y to y+sizey do begin
    if i2 < i2+putmaxx then begin
      if (oli2 > i2)and(not switched) then incbank;
      movefromscreen(ptr(currentmode.writeptr,i2)^,ptr(seg(p2^),ofs(p2^)+i4)^,putmaxx);
      sprite2mem(ptr(seg(p1^),ofs(p1^)+i4)^,ptr(currentmode.writeptr,i2)^,putmaxx,key);
      switched := false;
    end else begin
      i3 := 0-i2;
      movefromscreen(ptr(currentmode.writeptr,i2)^,ptr(seg(p2^),ofs(p2^)+i4)^,i3);
      sprite2mem(ptr(seg(p1^),ofs(p1^)+i4)^,ptr(currentmode.writeptr,i2)^,i3,key);
      incbank;
      switched := true;
      move2(ptr(currentmode.writeptr,0)^,ptr(seg(p2^),ofs(p2^)+i4+i3)^,putmaxx-i3);
      sprite2mem(ptr(seg(p1^),ofs(p1^)+i4+i3)^,ptr(currentmode.writeptr,0)^,putmaxx-i3,key);
    end;
    inc(i4,sizex);
    oli2 := i2;
    inc(i2,currentmode.scanline);
  end;
end;

procedure mouse_putputimage(x,y: integer;p1,p2 : pointer;key : longint);
var
  sizex,sizey,i,i2,i3,i4,oli2,putmaxx : word;
  x2,y2                               : integer;
  switched                            : boolean;
begin
  sizex := succ(memw[seg(p1^):ofs(p1^)]);
  sizey := memw[seg(p1^):ofs(p1^)+2];
  memw[seg(p2^):ofs(p2^)]   := sizex-1;
  memw[seg(p2^):ofs(p2^)+2] := sizey;
  x2 := x+sizex-1;
  y2 := y+sizey;
  i4 := 0;

  if (y > actscreen.y2) or (y2 < actscreen.y1) then exit;
  if (x > actscreen.x2) or (x2 < actscreen.x1) then exit;
  if x  < actscreen.x1 then begin
    inc(i4,actscreen.x1-x);
    x := actscreen.x1;
  end;
  if x2 > actscreen.x2 then x2 := actscreen.x2;
  if y  < actscreen.y1 then begin
    inc(i4,sizex*(actscreen.y1-y));
    y := actscreen.y1;
  end;
  if y2 > actscreen.y2 then y2 := actscreen.y2;
  putmaxx := succ(x2-x)*currentmode.bytesperpixel;
  if putmaxx = 0 then exit;
  sizey := y2-y;
  inc(y,pageadd);
  i2 := calcbank(x-actviewport.x1,y-actviewport.y1);
  i4 := i4*currentmode.bytesperpixel+imagedatasize;

  oli2 := i2;
  switched := false;
  sizex := sizex*currentmode.bytesperpixel;
  for i := y to y+sizey do begin
    if i2 < i2+putmaxx then begin
      if (oli2 > i2)and(not switched) then incbank;
      move2screen(ptr(seg(p2^),ofs(p2^)+i4)^,ptr(currentmode.writeptr,i2)^,putmaxx);
      sprite2mem(ptr(seg(p1^),ofs(p1^)+i4)^,ptr(currentmode.writeptr,i2)^,putmaxx,key);
      switched := false;
    end else begin
      i3 := 0-i2;
      move2screen(ptr(seg(p2^),ofs(p2^)+i4)^,ptr(currentmode.writeptr,i2)^,i3);
      sprite2mem(ptr(seg(p1^),ofs(p1^)+i4)^,ptr(currentmode.writeptr,i2)^,i3,key);
      incbank;
      switched := true;
      move2(ptr(currentmode.writeptr,0)^,ptr(seg(p2^),ofs(p2^)+i4+i3)^,putmaxx-i3);
      sprite2mem(ptr(seg(p1^),ofs(p1^)+i4+i3)^,ptr(currentmode.writeptr,0)^,putmaxx-i3,key);
    end;
    inc(i4,sizex);
    oli2 := i2;
    inc(i2,currentmode.scanline);
  end;
end;

procedure putimage(x,y : integer;p : pointer);
var
  sizex,sizey,i,i2,i3,i4,oli2,putmaxx : word;
  x2,y2                               : integer;
  switched                            : boolean;
begin
  if p = nil then exit;
  sizex := succ(memw[seg(p^):ofs(p^)]);
  sizey := memw[seg(p^):ofs(p^)+2];
  inc(x,actviewport.x1);
  inc(y,actviewport.y1);
  x2 := x+sizex-1;
  y2 := y+sizey;
  i4 := 0;

  if (y > fillviewport.y2) or (y2 < fillviewport.y1) then exit;
  if (x > fillviewport.x2) or (x2 < fillviewport.x1) then exit;
  if x  < fillviewport.x1 then begin
    inc(i4,fillviewport.x1-x);
    x := fillviewport.x1;
  end;
  if x2 > fillviewport.x2 then x2 := fillviewport.x2;
  if y  < fillviewport.y1 then begin
    inc(i4,sizex*(fillviewport.y1-y));
    y := fillviewport.y1;
  end;
  if y2 > fillviewport.y2 then y2 := fillviewport.y2;

  putmaxx := succ(x2-x)*currentmode.bytesperpixel;
  if putmaxx = 0 then exit;
  sizey := y2-y;
  inc(y,pageadd);
  i2 := calcbank(x-actviewport.x1,y-actviewport.y1);
  i4 := i4*currentmode.bytesperpixel+imagedatasize;
  sizex := sizex*currentmode.bytesperpixel;
  oli2 := i2;
  switched := false;
  for i := y to y+sizey do begin
    if i2 < i2+putmaxx then begin
      if (oli2 > i2)and(not switched) then incbank;
      move2screen(ptr(seg(p^),ofs(p^)+i4)^,ptr(currentmode.writeptr,i2)^,putmaxx);
      switched := false;
    end else begin
      i3 := 0-i2;
      move2screen(ptr(seg(p^),ofs(p^)+i4)^,ptr(currentmode.writeptr,i2)^,i3);
      incbank;
      switched := true;
      move2(ptr(seg(p^),ofs(p^)+i4+i3)^,ptr(currentmode.writeptr,0)^,putmaxx-i3);
    end;
    inc(i4,sizex);
    oli2 := i2;
    inc(i2,currentmode.scanline);
  end;
end;


procedure putsprite(x,y: integer;p : pointer;key : longint);
{ key is the transparent color (color key) }
var
  sizex,sizey,i,i2,i3,i4,oli2,putmaxx : word;
  x2,y2                               : integer;
  switched                            : boolean;
begin
  if p = nil then exit;
  sizex := succ(memw[seg(p^):ofs(p^)]);
  sizey := memw[seg(p^):ofs(p^)+2];

  inc(x,actviewport.x1);
  inc(y,actviewport.y1);
  x2 := x+sizex-1;
  y2 := y+sizey;
  i4 := 0;

  if (y > fillviewport.y2)or(y2 < fillviewport.y1) then exit;
  if (x > fillviewport.x2)or(x2 < fillviewport.x1) then exit;
  if x  < fillviewport.x1 then begin
    inc(i4,fillviewport.x1-x);
    x := fillviewport.x1;
  end;
  if x2 > fillviewport.x2 then x2 := fillviewport.x2;
  if y  < fillviewport.y1 then begin
    inc(i4,sizex*(fillviewport.y1-y));
    y := fillviewport.y1;
  end;
  if y2 > fillviewport.y2 then y2 := fillviewport.y2;

  putmaxx := succ(x2-x)*currentmode.bytesperpixel;
  if putmaxx = 0 then exit;
  sizey := y2-y;
  inc(y,pageadd);
  i2 := calcbank(x-actviewport.x1,y-actviewport.y1);
  i4 := i4*currentmode.bytesperpixel+imagedatasize;

  sizex := sizex*currentmode.bytesperpixel;
  oli2 := i2;
  switched := false;
  for i := y to y+sizey do begin
    if i2 < i2+putmaxx then begin
      if (oli2 > i2)and(not switched) then incbank;
      sprite2mem(ptr(seg(p^),ofs(p^)+i4)^,ptr(currentmode.writeptr,i2)^,putmaxx,key);
      switched := false;
    end else begin
      i3 := 0-i2;
      sprite2mem(ptr(seg(p^),ofs(p^)+i4)^,ptr(currentmode.writeptr,i2)^,i3,key);
      incbank;
      switched := true;
      sprite2mem(ptr(seg(p^),ofs(p^)+i4+i3)^,ptr(currentmode.writeptr,0)^,putmaxx-i3,key);
    end;
    inc(i4,sizex);
    oli2 := i2;
    inc(i2,currentmode.scanline);
  end;
end;

procedure getimage(x1,y1,x2,y2 : integer;p : pointer);
var
  sizex,sizey,i,i2,i3,i4,oli2,getmaxx : word;
  switched                            : boolean;
begin
  if p = nil then exit;
  if y1 > y2 then swapw(y1,y2);
  if x1 > x2 then swapw(x1,x2);

  sizex := x2-x1+1;
  sizey := y2-y1;
  memw[seg(p^):ofs(p^)] := sizex-1;
  memw[seg(p^):ofs(p^)+2] := sizey;
  inc(x1,actviewport.x1);
  inc(y1,actviewport.y1);
  i4 := 0;

  if (y1 > fillviewport.y2)or(y2 < fillviewport.y1) then exit;
  if (x1 > fillviewport.x2)or(x2 < fillviewport.x1) then exit;
  if x1 < fillviewport.x1 then begin
    inc(i4,fillviewport.x1-x1);
    x1      := fillviewport.x1;
  end;
  if x2 > fillviewport.x2 then x2 := fillviewport.x2;
  if y1 < fillviewport.y1 then begin
    inc(i4,sizex*(fillviewport.y1-y1));
    y1 := fillviewport.y1;
  end;
  if y2 > fillviewport.y2 then y2 := fillviewport.y2;

  getmaxx := (x2-x1+1)*currentmode.bytesperpixel;
  if getmaxx = 0 then exit;
  sizey := y2-y1;
  inc(y1,pageadd);
  i2 := calcbank(x1-actviewport.x1,y1-actviewport.y1);
  i4 := i4*currentmode.bytesperpixel+imagedatasize;

  sizex := sizex*currentmode.bytesperpixel;
  oli2 := i2;
  switched := false;
  for i := y1 to y1+sizey do begin
    if i2 < i2+getmaxx then begin
      if (oli2 > i2)and(not switched) then incbank;
      movefromscreen(ptr(currentmode.readptr,i2)^,ptr(seg(p^),ofs(p^)+i4)^,getmaxx);
      switched := false;
    end
    else begin
      i3 := 0-i2;
      movefromscreen(ptr(currentmode.readptr,i2)^,ptr(seg(p^),ofs(p^)+i4)^,i3);
      incbank;
      switched := true;
      move2(ptr(currentmode.readptr,0)^,ptr(seg(p^),ofs(p^)+i4+i3)^,getmaxx-i3);
    end;
    inc(i4,sizex);
    oli2 := i2;
    inc(i2,currentmode.scanline);
  end;
end;


procedure rbar(x1,y1,x2,y2 : integer;r : word);
{bar with rounded edges - radius of circle is r}
var
  i,sizex  : word;
  x,y      : word;
begin
  sizex := abs(x2-x1);
  calccircle(r);
  hline(x1+r-point[0],y1,sizex-(r-point[0])*2+1,currentcolor);
  vline(x1,y1+r,y2-y1-r*2,currentcolor);
  hline(x1+r-point[0],y2,sizex-(r-point[0])*2+1,currentcolor);
  vline(x2,y1+r,y2-y1-r*2,currentcolor);
  for y := 1 to r do
  for x := r-point[y] to r-point[y-1] do begin
    putpixel(x1+x,y1+y,currentcolor);
    putpixel(x2-x,y1+y,currentcolor);
  end;
  for y := 1 to r do
  for x := r-point[y] to r-point[y-1] do begin
    putpixel(x1+x,y2-y,currentcolor);
    putpixel(x2-x,y2-y,currentcolor);
  end;
  for y := 1 to r do
  patternline(x1+r-point[y-1]+1,y1+y,sizex-(r*2-point[y-1]*2)-1,fillcolor);
  bar(x1+1,y1+r+1,x2-1,y2-r-1);
  for y := r downto 1 do
  patternline(x1+r-point[y-1]+1,y2-y,sizex-(r*2-point[y-1]*2)-1,fillcolor);
end;


procedure bitblit_vesa(x1,y1,x2,y2,dstx,dsty : integer);far;
{implementation is not very fast, but it works}
var
  y,sx         : integer;
  oldviewport  : viewporttype;
  oldpage      : word;
begin
  oldpage := actpage;
  setactivepage(0);
  oldviewport := actviewport;
  setviewport(0,0,mxx,currentmode.lasty,false);
  if y1 > y2 then swapw(y1,y2);
  sx := abs(x2-x1)+1;
  if sx > maxx then sx := maxx;
  if sx = 0 then exit;
  if y1 > dsty then
  for y := y1 to y2 do begin
    getline(x1,y,sx,gfxbuf);
    putline(dstx,dsty+y-y1,sx,gfxbuf);
  end else
  for y := y2 downto y1 do begin
    getline(x1,y,sx,gfxbuf);
    putline(dstx,dsty+y-y1,sx,gfxbuf);
  end;
  with oldviewport do setviewport(x1,y1,x2,y2,clip);
  setactivepage(oldpage);
end;

(*procedure bitblit_vesa(x1,y1,x2,y2,dstx,dsty : integer);far;
{faster version... seems to run ok}
var
  y,sx,sy,memy : integer;
  oldviewport  : viewporttype;
  oldpage      : word;
begin
  oldpage := actpage;
  setactivepage(0);
  oldviewport := actviewport;
  setviewport(0,0,mxx,currentmode.lasty,false);
  sx := abs(x2-x1);
  sy := abs(y2-y1);
  if sx > maxx then sx := maxx;
  if sx = 0 then exit;
  if y1 > y2 then swapw(y1,y2);
  memy := (gfxbufsize-imagedatasize) div (sx*currentmode.bytesperpixel);
  if memy >= sy then begin
    getimage(x1,y1,x1+sx,y1+sy,gfxbuf);
    putimage(dstx,dsty,gfxbuf);
  end else begin
    if y1 > dsty then begin
      for y := 0 to sy div memy-1 do begin
        getimage(x1,y1+y*memy,x1+sx,y1+memy+y*memy-1,gfxbuf);
        putimage(dstx,dsty+y*memy,gfxbuf);
      end;
      if sy mod memy > 0 then begin
        y := succ(y)*memy;
        getimage(x1,y1+y,x1+sx,y1+y+sy mod memy,gfxbuf);
        putimage(dstx,dsty+y,gfxbuf);
      end;
    end else begin
      if sy mod memy > 0 then begin
        y := (sy div memy)*memy;
        getimage(x1,y1+y,x1+sx,y1+y+sy mod memy,gfxbuf);
        putimage(dstx,dsty+y,gfxbuf);
      end;
      for y := sy div memy-1 downto 0 do begin
        getimage(x1,y1+y*memy,x1+sx,y1+memy+y*memy-1,gfxbuf);
        putimage(dstx,dsty+y*memy,gfxbuf);
      end;
    end;
  end;
  with oldviewport do setviewport(x1,y1,x2,y2,clip);
  setactivepage(oldpage);
end;*)



procedure rrectangle(x1,y1,x2,y2 :integer;r:word);
{rectangle with rounded edges - radius of circle is r}
var
  i,sizex  : word;
  x,y      : word;
begin
  inc(y1,pageadd);
  inc(y2,pageadd);
  sizex := abs(x2-x1);
  calccircle(r);
  hline(x1+r-point[0],y1,sizex-(r-point[0])*2+1,currentcolor);
  vline(x1,y1+r,y2-y1-r*2,currentcolor);
  hline(x1+r-point[0],y2,sizex-(r-point[0])*2+1,currentcolor);
  vline(x2,y1+r,y2-y1-r*2,currentcolor);
  for y := 1 to r do
  for x := r-point[y] to r-point[y-1] do begin
    putpixel(x1+x,y1+y,currentcolor);
    putpixel(x2-x,y1+y,currentcolor);
  end;
  for y := 1 to r do
  for x := r-point[y] to r-point[y-1] do begin
    putpixel(x1+x,y2-y,currentcolor);
    putpixel(x2-x,y2-y,currentcolor);
  end;
end;

procedure putline(x1,y1,sizex: integer;p : pointer);
{draw a horizontal line with image of the pointer p}
var
  i2,i3,mempos : word;
  olx1         : integer;
label
  endofproc;
begin
  if p = nil then exit;
  asm
    mov   cx,sizex
    mov   ax,x1
    or    cx,cx
    jz    endofproc
    jns   @next
      neg   cx
      sub   ax,cx
    @next:
    add   ax,actviewport.x1
    mov   olx1,ax
    mov   bx,ax
    add   bx,cx
    mov   di,y1
    add   di,actviewport.y1
    cmp   di,fillviewport.y1
    jl    endofproc
    cmp   di,fillviewport.y2
    jg    endofproc
    mov   cx,fillviewport.x1
    mov   dx,fillviewport.x2
    cmp   ax,dx
    jge   endofproc
    cmp   bx,cx
    jle   endofproc
    cmp   ax,cx
    jnl   @next1
      mov   ax,cx
    @next1:
    inc   dx
    cmp   bx,dx
    jng   @next2
      mov   bx,dx
    @next2:
    sub   bx,ax
    mov   sizex,bx
    sub   ax,actviewport.x1
    sub   di,actviewport.y1
    add   di,pageadd
    mov   bx,ax
    sub   bx,olx1
    mov   mempos,bx
    push  ax
    push  di
    call  calcbank
    mov   i2,ax
  end;
  sizex := sizex*currentmode.bytesperpixel;
  if i2 < i2+word(sizex) then
   {move2screen(ptr(seg(p^),ofs(p^)+mempos)^,ptr(currentmode.writeptr,i2)^,sizex)}
  asm
    cld
    mov   ax,mempos
    mov   di,i2
    mov   cx,sizex
    mov   bx,currentmode.writeptr
    mov   dx,ds
    lds   si,p
    add   si,ax
    mov   es,bx
    mov   ax,cx
    cmp   cx,8
    jb    @start
    mov   cx,di
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
      db    0F3h,66h,0A5h{rep movsd}
      mov   cx,ax
      and   cx,11b
      jz    @end
      rep   movsb
      @end:
    mov   ds,dx
  end
  else begin
    i3 := 0-i2;
    move2screen(ptr(seg(p^),ofs(p^)+mempos)^,ptr(currentmode.writeptr,i2)^,i3);
    incbank;
    move2(ptr(seg(p^),ofs(p^)+i3+mempos)^,ptr(currentmode.writeptr,0)^,sizex-i3);
  end;
  endofproc:
end;

procedure putline24(x1,y1,sizex: integer;p : pointer);
var
  i2,i3,mempos : word;
  olx1         : integer;
label
  endofproc;
begin
  if p = nil then exit;
  asm
    mov   cx,sizex
    mov   ax,x1
    or    cx,cx
    jz    endofproc
    jns   @next
      neg   cx
      sub   ax,cx
    @next:
    add   ax,actviewport.x1
    mov   olx1,ax
    mov   bx,ax
    add   bx,cx
    mov   di,y1
    add   di,actviewport.y1
    cmp   di,fillviewport.y1
    jl    endofproc
    cmp   di,fillviewport.y2
    jg    endofproc
    mov   cx,fillviewport.x1
    mov   dx,fillviewport.x2
    cmp   ax,dx
    jge   endofproc
    cmp   bx,cx
    jle   endofproc
    cmp   ax,cx
    jnl   @next1
      mov   ax,cx
    @next1:
    inc   dx
    cmp   bx,dx
    jng   @next2
      mov   bx,dx
    @next2:
    sub   bx,ax
    mov   sizex,bx
    sub   ax,actviewport.x1
    sub   di,actviewport.y1
    add   di,pageadd
    mov   bx,ax
    sub   bx,olx1
    mov   mempos,bx
    push  ax
    push  di
    call  calcbank
    mov   i2,ax
  end;
  sizex := sizex * currentmode.bytesperpixel;
  mempos  := mempos * 3;
  if i2 < i2+word(sizex) then
  convdata(ptr(seg(p^),ofs(p^)+mempos)^,ptr(currentmode.writeptr,i2)^,sizex)
  else begin
    i3 := 0-i2;
    convdata(ptr(seg(p^),ofs(p^)+mempos)^,ptr(currentmode.writeptr,i2)^,i3);
    incbank;
    convdata(ptr(seg(p^),ofs(p^)+i3 div currentmode.bytesperpixel*3+mempos)^,ptr(currentmode.writeptr,0)^,sizex-i3);
  end;
  endofproc:
end;

procedure putline8(x1,y1,sizex: integer;p : pointer);
var
  i2,i3,mempos : word;
  olx1         : integer;
label
  endofproc;
begin
  if p = nil then exit;
  asm
    mov   cx,sizex
    mov   ax,x1
    or    cx,cx
    jz    endofproc
    jns   @next
      neg   cx
      sub   ax,cx
    @next:
    add   ax,actviewport.x1
    mov   olx1,ax
    mov   bx,ax
    add   bx,cx
    mov   di,y1
    add   di,actviewport.y1
    cmp   di,fillviewport.y1
    jl    endofproc
    cmp   di,fillviewport.y2
    jg    endofproc
    mov   cx,fillviewport.x1
    mov   dx,fillviewport.x2
    cmp   ax,dx
    jge   endofproc
    cmp   bx,cx
    jle   endofproc
    cmp   ax,cx
    jnl   @next1
      mov   ax,cx
    @next1:
    inc   dx
    cmp   bx,dx
    jng   @next2
      mov   bx,dx
    @next2:
    sub   bx,ax
    mov   sizex,bx
    sub   ax,actviewport.x1
    sub   di,actviewport.y1
    add   di,pageadd
    mov   bx,ax
    sub   bx,olx1
    mov   mempos,bx
    push  ax
    push  di
    call  calcbank
    mov   i2,ax
  end;
  sizex := sizex * currentmode.bytesperpixel;
  if i2 < i2+word(sizex) then
  conv8bit(ptr(seg(p^),ofs(p^)+mempos)^,ptr(currentmode.writeptr,i2)^,word(sizex))
  else begin
    i3 := 0-i2;
    conv8bit(ptr(seg(p^),ofs(p^)+mempos)^,ptr(currentmode.writeptr,i2)^,i3);
    incbank;
    conv8bit(ptr(seg(p^),ofs(p^)+i3 div currentmode.bytesperpixel+mempos)^,ptr(currentmode.writeptr,0)^,word(sizex)-i3);
  end;
  endofproc:
end;

procedure image_line_std(x,y : integer;sizex : word;bpp : byte;data : pointer);far;
begin
  if data = nil then exit;
  if bpp = currentmode.bpp then begin
    putline(x,y,sizex,data);
    exit;
  end;
  case bpp of
     8 : putline8(x,y,sizex,data);
    24 : putline24(x,y,sizex,data);
    4  :
    begin
      asm
        mov   cx,sizex
        shr   cx,1
        inc   cx
        les   di,gfxbuf
        push  ds
        lds   si,data
        @lp:
          mov   al,ds:[si]
          mov   ah,al
          shr   al,4
          and   ah,0Fh
          mov   es:[di],ax
          inc   si
          add   di,2
          dec   cx
        jnz   @lp
        pop   ds
      end;
      putline8(x,y,sizex,gfxbuf);
    end;
    2  :
    begin
      asm
        mov   cx,sizex
        shr   cx,2
        inc   cx
        les   di,gfxbuf
        push  ds
        lds   si,data
        @lp:
          mov   al,ds:[si]
          mov   ah,al
          mov   dx,ax
          shr   al,6
          shr   ah,4
          and   ax,303h
          mov   es:[di],ax
          shr   dl,2
          and   dx,303h
          mov   es:[di],dx
          inc   si
          add   di,4
          dec   cx
        jnz   @lp
        pop   ds
      end;
      putline8(x,y,sizex,gfxbuf);
    end;
    1  :
    begin
      asm
        mov   cx,sizex
        shr   cx,3
        inc   cx
        les   di,gfxbuf
        push  ds
        lds   si,data
        @lp:
          mov   al,ds:[si]
          mov   ah,al
          mov   dx,ax
          shr   al,7
          shr   ah,6
          and   ax,101h
          mov   es:[di],ax
          mov   ax,dx
          shr   al,5
          shr   ah,4
          and   ax,101h
          mov   es:[di+2],ax
          mov   ax,dx
          shr   al,3
          shr   ah,2
          and   ax,101h
          mov   es:[di+4],ax
          mov   ax,dx
          shr   al,1
          and   ax,101h
          mov   es:[di+6],ax
          inc   si
          add   di,8
          dec   cx
        jnz   @lp
        pop   ds
      end;
      putline8(x,y,sizex,gfxbuf);
    end;
  end;
end;

procedure image_getline_std(x,y : integer;sizex : word;bpp : byte;data : pointer);far;
begin
  if data = nil then exit;
  if bpp <> currentmode.bpp then begin
    getline(x,y,sizex,gfxbuf);
    convbpp(sizex,currentmode.bpp,bpp,gfxbuf,data);
  end else getline(x,y,sizex,data);
end;

procedure image_pp_std(x,y : integer;bpp : byte;col : longint);far;
begin
  case bpp of
     8 : if currentmode.bytesperpixel = 8 then putpixel(x,y,col)
         else putpixel(x,y,col8bitpal^[col]);
    24 : if currentmode.bytesperpixel = 8 then putpixel(x,y,rgb(col shr 16,col shr 8,col))
         else putpixel(x,y,col);
  end;
end;

procedure spriteline(x1,y1,sizex: integer;p : pointer;key : byte);
{draw a horizontal line with image of the pointer p}
var
  i2,i3,mempos : word;
  olx1         : integer;
label
  endofproc;
begin
  if p = nil then exit;
  asm
    mov   cx,sizex
    mov   ax,x1
    or    cx,cx
    jz    endofproc
    jns   @next
      neg   cx
      sub   ax,cx
    @next:
    add   ax,actviewport.x1
    mov   olx1,ax
    mov   bx,ax
    add   bx,cx
    mov   di,y1
    add   di,actviewport.y1
    cmp   di,fillviewport.y1
    jl    endofproc
    cmp   di,fillviewport.y2
    jg    endofproc
    mov   cx,fillviewport.x1
    mov   dx,fillviewport.x2
    cmp   ax,dx
    jge   endofproc
    cmp   bx,cx
    jle   endofproc
    cmp   ax,cx
    jnl   @next1
      mov   ax,cx
    @next1:
    inc   dx
    cmp   bx,dx
    jng   @next2
      mov   bx,dx
    @next2:
    sub   bx,ax
    mov   sizex,bx
    sub   ax,actviewport.x1
    sub   di,actviewport.y1
    add   di,pageadd
    mov   bx,ax
    sub   bx,olx1
    mov   mempos,bx
    push  ax
    push  di
    call  calcbank
    mov   i2,ax
  end;
  sizex := sizex * currentmode.bytesperpixel;
  if i2 < i2+word(sizex) then
  sprite2mem(ptr(seg(p^),ofs(p^)+mempos)^,ptr(currentmode.writeptr,i2)^,sizex,key)
  else begin
    i3 := 0-i2;
    sprite2mem(ptr(seg(p^),ofs(p^)+mempos)^,ptr(currentmode.writeptr,i2)^,i3,key);
    incbank;
    sprite2mem(ptr(seg(p^),ofs(p^)+i3+mempos)^,ptr(currentmode.writeptr,0)^,sizex-i3,key);
  end;
  endofproc:
end;

procedure getline(x1,y1,sizex: integer;p : pointer);
{gets a horizontal line and puts the image to the pointer p}
var
  i2,i3,mempos : word;
  olx1         : integer;
{begin
  if p = nil then exit;
  if sizex < 1 then exit;
  if (x1 < maxx)and(x1+sizex > 0)and(y1 >= 0)and((y1 < maxy)or(not actviewport.clip)) then begin
    inc(y1,pageadd);
    if x1 < 0 then begin
      getmaxx := sizex+x1;
      x1 := 0;
    end else begin
      if x1+sizex > maxx then getmaxx := maxx-x1 else
      getmaxx := sizex;
    end;}
label
  endofproc;
begin
  if p = nil then exit;
  asm
    mov   cx,sizex
    mov   ax,x1
    or    cx,cx
    jz    endofproc
    jns   @next
      neg   cx
      sub   ax,cx
    @next:
    add   ax,actviewport.x1
    mov   olx1,ax
    mov   bx,ax
    add   bx,cx
    mov   di,y1
    add   di,actviewport.y1
    cmp   di,fillviewport.y1
    jl    endofproc
    cmp   di,fillviewport.y2
    jg    endofproc
    mov   cx,fillviewport.x1
    mov   dx,fillviewport.x2
    cmp   ax,dx
    jge   endofproc
    cmp   bx,cx
    jle   endofproc
    cmp   ax,cx
    jnl   @next1
      mov   ax,cx
    @next1:
    inc   dx
    cmp   bx,dx
    jng   @next2
      mov   bx,dx
    @next2:
    sub   bx,ax
    mov   sizex,bx
    sub   ax,actviewport.x1
    sub   di,actviewport.y1
    add   di,pageadd
    mov   bx,ax
    sub   bx,olx1
    mov   mempos,bx
    push  ax
    push  di
    call  calcbank
    mov   i2,ax
  end;

  sizex := sizex * currentmode.bytesperpixel;
{    getmaxx := getmaxx*currentmode.bytesperpixel;}
{    i2 := calcbank(x1,y1);}
    if i2 < i2+word(sizex) then
    movefromscreen(ptr(currentmode.writeptr,i2)^,p^,sizex)
    else begin
      i3 := 0-i2;
      movefromscreen(ptr(currentmode.writeptr,i2)^,p^,i3);
      incbank;
      move2(ptr(currentmode.writeptr,0)^,ptr(seg(p^),ofs(p^)+i3)^,sizex-i3);
    end;
  endofproc:
end;



{typecast parms to longint, result to fixed}
function fixedDiv(d1,d2:longint):longint;
inline(
  $66/$59/               {pop ecx}
  $58/                   {pop ax}
  $5A/                   {pop dx}
  $66/$0F/$BF/$D2/       {movsx edx,dx}
  $66/$C1/$E0/$10/       {shl eax,16}
  $66/$F7/$F9/           {idiv ecx}
  $66/$0F/$A4/$C2/$10);  {shld edx,eax,16}   {no rounding}

procedure fillpoly_vesa(numpoints : word;var polypoints);far;
type
  polygon = array[0..8191] of pointtype;
  fixed=record case byte of
    0:(f:word;i:integer);
    1:(l:longint);
  end;
var
  i,l,r,lv,rv,top,bottom,topVert : integer;
  lstep,lpos,rstep,rpos          : fixed;
  ldest,rdest                    : Pointtype;
  point                          : polygon absolute polypoints;
begin
  if (numpoints < 3) or (numpoints > 8191) then exit;
 {find top and bottom vertices}
  topVert := numpoints-1;
  top     := point[topVert].y;
  bottom  := top;
  for i := numpoints-2 downto 0 do if (point[i].y < top) then
  begin
    top     := point[i].Y;
    topVert := i;
  end else if (point[i].y > bottom) then bottom := point[i].y;

  if actviewport.clip then
  if bottom > actviewport.mxy then bottom := actviewport.mxy; {clip bottom}

  if top > bottom then exit;
  lv    := topVert;
  rv    := topVert;
  ldest := point[topVert];
  rdest := ldest;
  i     := top;
  repeat
    if i >= ldest.y then begin
      lpos.f := 0;
      lpos.i := ldest.x;
      dec(lv);
      if lv < 0 then lv := numpoints-1;
      ldest := point[lv];
      if ldest.y = i then begin
        if ldest.x < lpos.i then lpos.i := ldest.x;
        lstep.l := 0;
      end
      else lstep.l := fixedDiv(ldest.x-lpos.i,ldest.y-i);
    end;
    if i >= rdest.y then begin
      rpos.f := 0;
      rpos.i := rdest.x;
      inc(rv);
      if rv >= numpoints then rv:=0;
      rdest := point[rv];
      if rdest.y = i then begin
        if rdest.x > rpos.i then rpos.i := rdest.x;
        rstep.l := 0;
      end
      else rstep.l := fixedDiv(rdest.x-rpos.i,rdest.y-i);
    end;
    patternline(lpos.i,i,rpos.i-lpos.i+1,fillcolor);
    inc(lpos.l,lstep.l);
    inc(rpos.l,rstep.l);
    inc(i);
  until i > bottom;
end;


procedure drawpoly(numpoints : word;var polypoints);
{draw a traced polygon}
type
  polygon = array[0..8191] of pointtype;
var
  i      : word;
  point  : polygon absolute polypoints;
begin
  if (numpoints = 0)or(numpoints > 16383) then exit;
  for i := 0 to numpoints-1 do
  line(point[i].x,point[i].y,point[(i+1) mod numpoints].x,point[(i+1) mod numpoints].y);
end;

procedure setbank_vesa(bank : word);far;assembler;
{set the graphical bank of vesa}
asm
  push  cx
  cmp   currentmode.mode,13h
  je    @end
  mov   dx,bank
  cmp   dx,lastbank
  je    @end
  mov   lastbank,dx
  mov   cl,shifter
  shl   dx,cl
  xor   cl,cl
  xor   bx,bx
{$IFDEF DPMI}
  mov   ax,4F05h
  int   10h
{$ELSE}
  call   winfuncptr
{$ENDIF}
  mov   bl,twowins{for old GFX-cards... not tested yet}
  or    bl,bl
  jz    @end
  xor   bh,bh
{$IFDEF DPMI}
  mov   ax,4F05h
  int   10h
{$ELSE}
  call  winfuncptr
{$ENDIF}
  @end:
  pop   cx
end;

procedure decbank_vesa;far;assembler;
{decrease the graphical bank of vesa}
asm
  pusha
  mov   dx,lastbank
  dec   dx
  mov   lastbank,dx
  mov   cl,shifter
  shl   dx,cl
  xor   cl,cl
  xor   bx,bx
{$IFDEF DPMI}
  mov   ax,4F05h
  int   10h
{$ELSE}
  call  winfuncptr
{$ENDIF}
  mov   bl,twowins{for old GFX-cards... not tested yet}
  or    bl,bl
  jz    @end
  xor   bh,bh
{$IFDEF DPMI}
  mov   ax,4F05h
  int   10h
{$ELSE}
  call  winfuncptr
{$ENDIF}
  @end:
  popa
end;

procedure incbank_vesa;far;assembler;
{increase the graphical bank of vesa}
asm
  pusha
  mov   dx,lastbank
  inc   dx
  mov   lastbank,dx
  mov   cl,shifter
  shl   dx,cl
  xor   cx,cx
  xor   bx,bx
{$IFDEF DPMI}
  mov   ax,4F05h
  int   10h
{$ELSE}
  call  winfuncptr
{$ENDIF}
  mov   bl,twowins
  or    bl,bl
  jz    @end
  xor   bh,bh
{$IFDEF DPMI}
  mov   ax,4F05h
  int   10h
{$ELSE}
  call  winfuncptr
{$ENDIF}
  @end:
  popa
end;

procedure setbank2_vesa(bank : word);far;assembler;
{set the actual bank- don't look, if this bank is already setted}
asm
  push  cx
  cmp   currentmode.mode,0
  je    @end
  mov   dx,bank
  mov   lastbank,dx
  mov   cl,shifter
  shl   dx,cl
  xor   cl,cl
  xor   bx,bx
{$IFDEF DPMI}
  mov   cl,shifter
  shl   dl,cl
  xor   cl,cl
  mov   ah,4Fh
  mov   al,05h
  int   10h
{$ELSE}
  call  winfuncptr
{$ENDIF}
  mov   bl,twowins{for old GFX-cards... not tested yet}
  or    bl,bl
  jz    @end
  xor   bh,bh
{$IFDEF DPMI}
  mov   ax,4F05h
  int   10h
{$ELSE}
  call  winfuncptr
{$ENDIF}
  @end:
  pop   cx
end;

procedure dummyproc;far;
begin
end;


procedure waitretrace;assembler;
{waits until kathod-beam runs to the top of the screen - avoids flickering}
asm
  mov   dx,03DAh
  @lp1:
    in    al,dx
    test  al,8
  jz   @lp1
  @lp2:
    in    al,dx
    test  al,8
  jnz   @lp2
end;


procedure hretrace;assembler;
{waits until kathod-beam is in next scanline}
asm
  mov   dx,3DAh
  @lp1:
    in    al,dx
    test  al,1D
  jnz   @lp1
  @lp2:
    in    al,dx
    test  al,1D
  jz   @lp2
end;

procedure getimagesize(p : pointer;var x,y : word);assembler;
{gets the size of an image in memory}
asm
  mov   dx,ds
  les   di,p
  mov   ax,es:[di]
  mov   bx,es:[di+2]
  lds   si,x
  mov   ds:[si],ax
  lds   si,y
  mov   ds:[si],bx
  mov   ds,dx
end;

procedure setimagesize(p : pointer;x,y : word);assembler;
{sets the size of an image in memory}
asm
  les   di,p
  mov   ax,x
  mov   es:[di],ax
  mov   ax,y
  mov   es:[di+2],ax
end;

function imagesize(x1,y1,x2,y2 : integer) : word;
var
  l : longint;
begin
  l := succ(longint(abs(x2-x1)))*succ(abs(y2-y1))*currentmode.bytesperpixel+imagedatasize;
  if l > 65528 then begin
    l       := 0;
    gresult := -11;
  end;
  imagesize := l;
end;

procedure setrgbpalette_gen(i,r,g,b : byte);far;
{sets color i in virtual palette}
begin
  col8bitpal^[i] := rgb(r,g,b);
end;

procedure setrgbpalette_8(col,r,g,b : byte);far;assembler;
{sets color i to rgb value}
asm
  mov   rgbinited,false
  mov   al,byte ptr col
  mov   dx,03C8h
  out   dx,al
  inc   dx
  mov   al,r
  shr   al,2
  out   dx,al
  mov   al,g
  shr   al,2
  out   dx,al
  mov   al,b
  shr   al,2
  out   dx,al
end;

procedure getrgbpalette_8(col : byte;var r,g,b : byte);far;assembler;
asm
  mov   al,col
  mov   dx,03C7h
  add   dx,2
  in    al,dx
  shl   al,2
  les   di,r
  mov   es:[di],al
  in    al,dx
  shl   al,2
  les   di,g
  mov   es:[di],al
  in    al,dx
  shl   al,2
  les   di,b
  mov   es:[di],al
end;

procedure getrgbpalette_gen(col : byte;var r,g,b : byte);far;
begin
  dergb(col8bitpal^[col],r,g,b);
end;


procedure setbkcolor(col : longint);assembler;
asm
  db 66h;mov   ax,word ptr col
  db 66h;mov   word ptr bkcolor,ax
end;

procedure setpal_8;far;assembler;
asm
  mov   rgbinited,false
  les   di,pal
  mov   al,0
  mov   dx,03C8h
  out   dx,al
  inc   dx
  mov   bx,256
  @lp:
  db 66h;mov   ax,es:[di]
  db 66h;shr   ax,2
         and   ax,0011111100111111b
         out   dx,al
  db 66h;shr   ax,8
         out   dx,al
  db 66h;shr   ax,8
         and   al,111111b
         out   dx,al
         add   di,3
  dec   bx
  jnz   @lp
end;

procedure setpal_gen;far;
var
  i : integer;
begin
  for i := 0 to 255 do setrgbpalette(i,pal^[i].r,pal^[i].g,pal^[i].b);
end;

procedure shiftpal;
var
  i : integer;
begin
  for i := 0 to 255 do begin
    pal^[i].r := pal^[i].r shl 2;
    pal^[i].g := pal^[i].g shl 2;
    pal^[i].b := pal^[i].b shl 2;
  end;
end;


procedure setuserpal(var pal);assembler;
{sets the user-palette from pointer pal}
asm
  mov   rgbinited,false
  les   di,pal
  mov   al,0
  mov   dx,03C8h
  out   dx,al
  inc   dx
  mov   bx,256
  @lp:
  db 66h;mov   ax,es:[di]
  db 66h;shr   ax,2
         and   ax,0011111100111111b
         out   dx,al
  db 66h;shr   ax,8
         out   dx,al
  db 66h;shr   ax,8
         and   al,111111b
         out   dx,al
         add   di,3
  dec   bx
  jnz   @lp
end;


procedure getuserpal(var pal);
{gets the actual palette to pointer pal}
var
  i : integer;
begin
  port[$3C7] := 0;
  for i := 0 to 255 do begin
    mem[seg(pal):ofs(pal)+i*3]  := port[$3C9] shl 2;
    mem[seg(pal):ofs(pal)+i*3+1]:= port[$3C9] shl 2;
    mem[seg(pal):ofs(pal)+i*3+2]:= port[$3C9] shl 2;
  end;
end;

procedure setrgbpal(col,r,g,b : byte);
{sets color i in virtual palette}
begin
  pal^[col].r := r;
  pal^[col].g := g;
  pal^[col].b := b;
end;

procedure getrgbpal(col : byte;var r,g,b : byte);
{sets color i in virtual palette}
begin
  r := pal^[col].r;
  g := pal^[col].g;
  b := pal^[col].b;
end;


function loadjascpal(path : string) : boolean;
{loads JASC-Palettes made with Paint Shop Pro
 into virtual palette.. you have to call thereafter
 setpal if you want to set the palette}
var
  i2,setted  : byte   ;
  maxcol     : word   ;
  f          : text   ;
  s,s2       : string ;
  code,r,g,b : integer;
  i          : integer;
begin
  loadjascpal := false;
  i := ioresult;
  assign(f,path);
  filemode := 64;
  reset(f);
  if ioresult <> 0 then begin
    gresult := grIOerror;
    exit;
  end;
  readln(f,s);
  if s <> 'JASC-PAL' then exit;
  if eof(f) then begin
    close(f);
    exit;
  end;
  readln(f);
  if eof(f) then begin
    close(f);
    exit;
  end;
  readln(f,maxcol);
  dec(maxcol);
  if eof(f) then begin
    close(f);
    exit;
  end;
  s2 := '';
  for i := 0 to maxcol do begin
    readln(f,s);
    setted := 0;
    for i2 := 1 to length(s) do begin
      if s[i2] <> ' ' then s2 := s2+s[i2];
      if (s[i2] = ' ')or(i2 = length(s)) then begin
        case setted of
          0 : val(s2,r,code);
          1 : val(s2,g,code);
          2 : val(s2,b,code);
        end;
        if code <> 0 then exit;
        inc(setted);
        s2 := '';
      end;
    end;
    pal^[i].r := r;
    pal^[i].g := g;
    pal^[i].b := b;
    if eof(f) then begin
      close(f);
      exit;
    end;
  end;
  close(f);
  loadjascpal := true;
  rgbinited := false;
end;

function loadpal(name : string;pal : pointer) : boolean;
var
  f : file;
begin
  loadpal := false;
  {$I-}
  assign(f,name);
  filemode := 64;
  reset(f,1);
  {$I+}
  if ioresult <> 0 then exit;
  if filesize(f) <> 768 then begin
    close(f);
    exit;
  end;
  blockread(f,pal^,768);
  close(f);
  loadpal := true;
end;

procedure convbpp(pixels,inbpp,outbpp : word;input,output : pointer);
{SLOW image data convertion, dedicated to image saving}
var
{  rgb     : function(r,g,b : byte) : longint;}
  dergb   : procedure(l : longint;var r,g,b : byte);
  i       : word;
  r,g,b   : byte;
  inbypp,outbypp : word;
  inpos,outpos   : word;
begin
  case inbpp of
    8  : dergb := dergb_8;
    15 : dergb := dergb_15;
    16 : dergb := dergb_16;
    else exit;
  end;
  inbypp  := (inbpp+7) shr 3;
  outbypp := (outbpp+7) shr 3;
  inpos  := 0;
  outpos := 0;
  case outbpp of
    24 : begin
           for i := 0 to pixels-1 do begin
             dergb(memw[seg(input^):ofs(input^)+inpos],r,g,b);
             asm
               cmp   dataalign,0
               jz    @data_rgb
                 mov   al,r
                 mov   bl,b
                 mov   ah,g
                 les   di,output
                 mov   dx,outpos
                 add   di,dx
                 mov   es:[di],ax
                 mov   es:[di+2],bl
                 jmp   @stop
               @data_rgb:
                 mov   al,b
                 mov   bl,r
                 mov   ah,g
                 les   di,output
                 mov   dx,outpos
                 add   di,dx
                 mov   es:[di],ax
                 mov   es:[di+2],bl
                 jmp   @stop
               @stop:
             end;
             inc(inpos,inbypp);
             inc(outpos,outbypp);
           end;
         end;
    else exit;
  end;

end;

procedure setcolor(col : longint);assembler;
{sets current color for script and lines}
asm
  db 66h;mov   ax,word ptr col
  db 66h;mov   word ptr currentcolor,ax
end;

function getcolor : longint;assembler;
{gets current color}
asm
  mov   ax,word ptr currentcolor
  mov   dx,word ptr currentcolor[2]
end;

var
  line_uncl : procedure(x1,y1,x2,y2 : integer);
  line_norm : procedure(x1,y1,x2,y2 : integer);
  line_styl : procedure(x1,y1,x2,y2 : integer);

procedure setlinestyle(style : word;pattern: word;thickness : word);
begin
  if style < 4 then linestyle := linepattern[style] else
  linestyle := pattern;
  linestylenum := style;
  if linestyle = $FFFF then line_uncl := line_norm else
                            line_uncl := line_styl;
end;

procedure getlinesettings(var lineinfo: linesettingstype);
begin
  lineinfo.linestyle := linestylenum;
  lineinfo.pattern   := linestyle;
  lineinfo.thickness := 1;
end;

procedure setfillstyle_vesa(pattern: word;col: longint);far;
{sets current fillstyle}
begin
  fillcolor := col;
  fillstyle := gr_vars.filloutpattern[pattern];
  fillstylenum := pattern;
end;

procedure setfillpattern(pattern : fillpatterntype;color : word);
begin
  gr_vars.filloutpattern[12] := pattern;
  fillstyle               := pattern;
  fillstylenum            := 12;
  fillcolor               := color;
end;

procedure getfillsettings(var FillInfo: FillSettingsType);
begin
  fillinfo.pattern := fillstylenum;
  fillinfo.color   := fillcolor;
end;

procedure setfillcolor(col: longint);assembler;
{sets current fillstyle}
asm
  db 66h;mov   ax,word ptr col
  db 66h;mov   word ptr fillcolor,ax
end;

procedure setwritemode_vesa(mode : byte);far;assembler;
asm
  mov   al,mode
  mov   writemode,al
end;


procedure line_styl_gen(x1,y1,x2,y2 : integer);far;
var
  d,dx,dy,aincr,bincr,xincr,x,y,yincr : integer;
  procedure pp_styl(x,y : integer);
  begin
    inc(stylecounter,stylecounter);
    if stylecounter = 0 then stylecounter := 1;
    if linestyle and stylecounter <> 0 then putpixel(x,y,currentcolor);
  end;
begin
  stylecounter := 0;
  if (abs(x2-x1) < abs(y2-y1)) then begin
    if (y1 > y2) then
    begin
      swapw(x1,x2);
      swapw(y1,y2);
    end;
    if (x2 > x1) then xincr := 1 else
                      xincr := -1;

    dy := y2 - y1;
    dx := abs(x2-x1);
    d  := dx shl 1 - dy;
    aincr := (dx - dy) shl 1;
    bincr := dx shl 1;
    x := x1;
    y := y1;
    pp_styl(x,y);
    for y := y1+1 to y2 do
    begin
      if (d >= 0) then
      begin
        inc(x,xincr);
        inc(d,aincr);
      end else
      inc(d,bincr);
      pp_styl(x,y);
    end;
  end
  else
  begin
    if (x1 > x2) then
    begin
      swapw(x1,x2);
      swapw(y1,y2);
    end;

    if (y2 > y1) then yincr := 1
                 else yincr := -1;

    dx := x2 - x1;
    dy := abs(y2-y1);
    d  := dy shl 1 - dx;
    aincr := (dy - dx) shl 1;
    bincr := dy shl 1;
    x := x1;
    y := y1;
      pp_styl(x,y);
    for x := x1+1 to x2 do              { Line auf X-Achse durchlaufen }
    begin
      if (d >= 0) then
      begin
        inc(y,yincr);
        inc(d,aincr);
      end
      else
      inc(d,bincr);
      pp_styl(x,y);
    end;
  end;
end;


procedure line_vesa(x1,y1,x2,y2 : integer);far;
type
  edge = (left,right,bottom,top);
  outcode = set of edge;
var
  accept,done                  : boolean;
  outcode0,outcode1,outcodeout : outcode;
  x,y                          : integer;

  procedure compoutcode(x,y : integer;var code : outcode);
  begin
    code := [];
    if y > fillviewport.mxy then code := [top]
    else if y < 0 then code := [bottom];
    if x > fillviewport.mxx then code := code+[right]
    else if x < 0 then code := code+[left];
  end;
begin
  if not actviewport.clip then begin
    inc(x1,actviewport.x1);
    inc(x2,actviewport.x1);
    inc(y1,actviewport.y1);
    inc(y2,actviewport.y1);
  end;
  accept := false;
  done   := false;
  compoutcode(x1,y1,outcode0);
  compoutcode(x2,y2,outcode1);
  repeat
    if (outcode0 = [])and(outcode1 = []) then begin
      accept := true;
      done   := true;
    end else if outcode0*outcode1 <> [] then
    done := true else
    begin
      if outcode0 <> [] then
      outcodeout := outcode0 else outcodeout := outcode1;

      if top in outcodeout then begin
        x := x1+(x2-x1)*(fillviewport.mxy-y1) div (y2-y1);
        y := fillviewport.mxy;
      end else if bottom in outcodeout then begin
        x := x1+(x2-x1)*(-y1) div (y2-y1);
        y := 0;
      end else if right in outcodeout then begin
        x := fillviewport.mxx;
        y := y1+(y2-y1)*(fillviewport.mxx-x1) div (x2-x1);
      end else if left in outcodeout then begin
        x := 0;
        y := y1+(y2-y1)*(-x1) div (x2-x1);
      end;
      if (outcodeout = outcode0) then begin
        x1 := x;
        y1 := y;
        compoutcode(x1,y1,outcode0);
      end else begin
        x2 := x;
        y2 := y;
        compoutcode(x2,y2,outcode1);
      end;
    end;
  until done;
  if accept then line_uncl(x1,y1,x2,y2);
end;

procedure rectangle(x1,y1,x2,y2: integer);
begin
  if (linestyle = $FFFF)and(writemode = normalput) then begin
    hline(x1,y1,x2-x1+1,currentcolor);
    vline(x1,y1,y2-y1,currentcolor);
    vline(x2,y1,y2-y1,currentcolor);
    hline(x1,y2,x2-x1+1,currentcolor);
  end else begin
    line(x1,y1,x2,y1);
    line(x1,y1,x1,y2);
    line(x2,y1,x2,y2);
    line(x1,y2,x2,y2);
  end;
end;

function getclock: longint;assembler; {Taken from the FLILIB source}
asm
  xor   ah,ah           { get tick count from Dos and use For hi 3 Bytes }
  int   01Ah            { lo order count in DX, hi order in CX }
  mov   ah,dl
  mov   dl,dh
  mov   dh,cl
  xor   al,al           { read lo Byte straight from timer chip }
  out   43h,al          { latch count }

  mov   al,1
  out   43h,al          { set up to read count }
  in    al,40h          { read in lo Byte (and discard) }
  in    al,40h          { hi Byte into al }
  neg   al              { make it so counting up instead of down }
end;


procedure readgraphline(x1,y1,col,maxchars,posx : word;var s2 : string);
{ read a line (like readln) from graphical screen
  x1,y1    : position on screen
  col      : color of the text
  maxchars : maximum amount of chars to read
  posx     : position (cursor) in the text, should be >= 1
  s2       : string where to read in (can be prefilled)  }
var
  waittime           : longint;
  chars,i,y,width    : integer;
  ch,lch             : char;
  s                  : string;
  p                  : pointer;
  con                : boolean;

procedure pp_data(x,y,xm,ym : integer;p : pointer);
begin
  case currentmode.bytesperpixel of
    1: putpixel(x,y,mem[seg(p^):ofs(p^)+imagedatasize+(width+2)*ym+xm]);
    2: putpixel(x,y,memw[seg(p^):ofs(p^)+imagedatasize+(width+2)*ym shl 1+xm]);
    3: putpixel(x,y,memw[seg(p^):ofs(p^)+imagedatasize+(width+2)*ym*3+xm]);
    4: putpixel(x,y,meml[seg(p^):ofs(p^)+imagedatasize+(width+2)*ym shl 2+xm]);
  end;
end;

function txtpos : word;
var
  s2 : string ;
  i  : integer;
begin
  s2 := '';
  for i := 1 to posx-1 do s2 := s2 + s[i];
  txtpos := textwidth(s2);
end;

procedure showtxt;
begin
  putimage(x1,y1,p);
  writexy(x1+1,y1,s);
  line(txtpos+x1,y1,txtpos+x1,textheight+y1);
  con := true;
end;


begin
  setcolor(col);
  chars := length(s2);
  s := s2;
  for i := 0 to maxchars-length(s2) do s := s + ' ';
  fillbyte(s2[1],maxchars,ord('T'));
  s2[0] := chr(maxchars);
  width := textwidth(s2);
  openimage(p,width+1,textheight);
  getimage(x1,y1,width+x1+1,textheight+y1,p);
  fillbyte(s2[0],80,0);
  lch := #1;
  showtxt;
  waittime := getclock+1250;
  repeat
    if waittime <= getclock then begin
      if con then begin
        for y := 0 to textheight do
        pp_data(x1+txtpos,y1+y,txtpos,y,p);
      end else
      line(x1+txtpos,y1,x1+txtpos,y1+textheight);
      con := not con;
      waittime := getclock+1250;
    end;
    if keypressed then begin
      lch := ch;
      ch := readkey
    end else ch := #1;

    if (ord(ch)> 1)and(lch <> #0) then
    case ch of
      #8  : if posx > 1 then begin dec(chars);dec(posx);delete{2}(s,posx,1);showtxt;end;
  #13,#27 : begin;for i := 1 to chars do s2 := s2 + s[i];end;
       else if chars < maxchars then begin
         inc(chars);inc(posx); insert(ch,s,posx-1);
         showtxt;
       end;
     end;
     if (ch <> #1)and(lch = #0) then begin
      case ch of
        #71 : begin posx := 1;showtxt;end;
        #79 : begin posx := chars+1;showtxt;end;
        #75 : if posx > 1 then begin;dec(posx);showtxt;end;
        #77 : if posx <= chars then begin;inc(posx);showtxt;end;
        #83 : if posx <= chars then begin dec(chars);delete{2}(s,posx,1);showtxt;end;
       else lch := #1;
      end;
    end;

  until (ch = #27)or(ch = #13);
  if con then for y := 0 to textheight do pp_data(x1+txtpos,y1+y,txtpos,y,p);
  closeimage(p);
end;

{$IFDEF DPMI}
var
  regs    : trealregs;

function int32(intno : byte; var regs) : boolean; assembler;
asm
  mov   ax,300h
  sub   bx,bx
  mov   bl,intno
  sub   cx,cx
  les   di,Regs
  int   31h
  cmc
  mov   ax,0
  adc   ax,ax
end;
{$ENDIF}

procedure getvesamodeinfo(m : word);
var
  i,state : word;
  dosmem  : longint;
begin
{$IFDEF DPMI}
{  asm
    cmp   m,0
    je    @end
    push  0
    push  256
    call  globaldosalloc
    mov   segment,dx
    mov   selector,ax

    mov   cx,m
    mov   di,offset RealModeRegs
    mov   word ptr [di].TRealRegs.RealSP,0
    mov   word ptr [di].TRealRegs.RealSS,0
    mov   word ptr [di].TRealRegs.RealEAX,4F01h
    mov   word ptr [di].TRealRegs.RealECX,cx
    mov   word ptr [di].TRealRegs.RealES, dx
    mov   word ptr [di].TRealRegs.RealEDI, 0
    mov   ax,ds
    mov   es,ax
    mov   ax,0300h
    mov   bx,0010h
    int   31h
    @end:
    mov   di,offset RealModeRegs
    mov   ax,word ptr [di].TRealRegs.RealEAX
    mov   state,ax
  end;
  move2(ptr(selector,0)^,modeinfoblock,256);
  globaldosfree(selector);}
  dosmem := globaldosalloc(sizeof(modeinfoblock));
  with regs do begin
    realSS  := 0;
    realSP  := 0;
    realES  := dosmem shr 16;
    realEDI := 0;
    realEAX := $4F01;
    realECX := m;
  end;
  int32($10,Regs);
  move2(ptr(dosmem and $FFFF,0)^,modeinfoblock,sizeof(modeinfoblock));
  globaldosfree(dosmem);
  state := regs.realEAX;

{$ELSE}
  asm
    cmp   m,0
    je    @end
    mov   ax,4f01h
    mov   cx,m
    mov   di,seg modeinfoblock
    mov   es,di
    mov   di,offset modeinfoblock
    int   10h
    @end:
    mov   state,ax
  end;
{$ENDIF}
  winfuncptr := modeinfoblock.winfuncptr;
  currentmode.scanline := modeinfoblock.bytesperscanline;
  currentmode.bpp := modeinfoblock.bitsperpixel;
  currentmode.bytesperpixel := round(currentmode.bpp / 8);
  lastbank := 255;
{  if m < 10 then begin
    mxx  := modeset[m].sx;
    mxy  := modeset[m].sy;
    maxx := succ(mxx);
    maxy := succ(mxy);
  end else begin}
    mxx  := modeinfoblock.xresolution-1;
    mxy  := modeinfoblock.yresolution-1;
    maxx := modeinfoblock.xresolution;
    maxy := modeinfoblock.yresolution;
{  end;}
  if maxy = 0 then maxy := 1;
  if currentmode.scanline = 0 then currentmode.scanline := 1;
  currentmode.numofpages := ((longint(vesainfoblock.totalmemory) shl 16) div currentmode.scanline-8) div maxy;
  if (hi(vesainfoblock.vesaversion) = 1)and(lo(vesainfoblock.vesaversion) = 0)
  then currentmode.numofpages := 0;
  currentmode.lasty := (longint(vesainfoblock.totalmemory) shl 16) div currentmode.scanline-8;
  shifter := 7;
  i := modeinfoblock.WinGranularity;
  repeat
    i := i shr 1;
    dec(shifter)
  until i = 0;
  if state <> $4F then gresult := grInvalidMode;
end;


function getbit(value,bit : byte) : boolean;assembler;
asm
  mov   cl,bit
  mov   bl,1
  shl   bl,cl
  mov   al,value
  and   al,bl
end;

procedure setscreen(on : boolean);
begin
  port[$3c4] := 1;
  if on then
  port[$3c5] := port[$3c5] and not 32 else
  port[$3c5] := port[$3c5] or 32;
end;


function initvesamode(mode : word) : boolean;assembler;
asm
  mov   ax,4F02h
  mov   bx,mode
  int   10h
  xor   ax,004Fh { ah<>0 if mode fail, al<>4F if no vesa }
  jnz   @@fail
  mov   ax,1     { true                                  }
  jmp   @@end
@@fail:
  xor   ax,ax    { false                                 }
@@end :
end;


procedure initvgamode(mode : word);assembler;
asm
  mov   ax,mode
  int   10h
end;

function graphresult : integer;assembler;
asm
  mov   ax,gresult
  mov   gresult,0
end;

procedure resetprocs;
begin
  setbank      := setbank_vesa;
  setbank2     := setbank2_vesa;
  incbank      := dummyproc;
  decbank      := dummyproc;
  case currentmode.bpp of
     8 : begin
           calcbank    := calcbank_8;
           rgb         := rgb_8;
           dergb       := dergb_8;
           patternline := patternline_8;
           line_norm   := line_norm_8;
           line_styl   := line_styl_8;
           hline       := hline_8;
           vline       := vline_8;
           bar         := bar_vesa_8;
           putpixel    := putpixel_8;
           getpixel    := getpixel_8;
           convdata    := convdata_8;
           conv8bit    := move2;
           setpal      := setpal_8;
           setrgbpalette := setrgbpalette_8;
           getrgbpalette := getrgbpalette_8;
           sprite2mem  := sprite2mem_8;
         end;
    15 : begin
           calcbank    := calcbank_16;
           rgb         := rgb_15;
           dergb       := dergb_15;
           patternline := patternline_16;
           line_norm   := line_norm_16;
           line_styl   := line_styl_gen;
           hline       := hline_16;
           vline       := vline_16;
           bar         := bar_vesa_16;
           putpixel    := putpixel_16;
           getpixel    := getpixel_16;
           convdata    := convdata_15;
           conv8bit    := conv8bit_16;
           setpal      := setpal_gen;
           setrgbpalette := setrgbpalette_gen;
           getrgbpalette := getrgbpalette_gen;
           sprite2mem  := sprite2mem_16;
         end;
    16 : begin
           calcbank    := calcbank_16;
           rgb         := rgb_16;
           dergb       := dergb_16;
           patternline := patternline_16;
           line_norm   := line_norm_16;
           line_styl   := line_styl_gen;
           hline       := hline_16;
           vline       := vline_16;
           bar         := bar_vesa_16;
           putpixel    := putpixel_16;
           getpixel    := getpixel_16;
           convdata    := convdata_16;
           conv8bit    := conv8bit_16;
           setpal      := setpal_gen;
           setrgbpalette := setrgbpalette_gen;
           getrgbpalette := getrgbpalette_gen;
           sprite2mem  := sprite2mem_16;
         end;
  end;
  line         := line_vesa;
  setwritemode := setwritemode_vesa;
  setfillstyle := setfillstyle_vesa;
  cleardevice  := cleardevice_vesa;
  bitblit      := bitblit_vesa;
  scroll       := scroll_vesa;
  fillpoly     := fillpoly_vesa;
  line_uncl    := line_norm;
end;

{$IFDEF ACCELERATION}
procedure resetoutput;
begin
  resetprocs;
  incbank    := incbank_vesa;
  decbank    := decbank_vesa;
   if (card.fastid = S3) then begin
     if (card.speedup) then begin
       if card.speedupmode = 0 then begin
         FAST_WRITE_BUFFER_ON;
         enableext_s3;
       end;
       setbank  := setbank_s3;
       setbank2 := setbank2_s3;
       incbank  := incbank_s3;
       decbank  := decbank_s3;
       if card.speedupfunc then begin
         if card.speedups.bar then begin
           bar          := bar_s3;
           cleardevice  := cleardevice_s3;
           setfillstyle := setfillstyle_s3;
{           if card.speedups.polygon then fillpoly := fillpoly_s3;}
         end;
{      line           := line_s3;}
{         setwritemode   := setwritemode_s3;}
         if card.speedups.bitblit then bitblit := bitblit_s3;
         scroll         := scroll_s3;
         card.upspeeded := true;
       end;
     end;
   end;
   if (card.fastid = CIRRUS) then begin
     if (card.speedup) then begin
       if card.speedupmode = 0 then enableext_cirrus;
       setbank  := setbank_cirrus;
       setbank2 := setbank2_cirrus;
       incbank  := incbank_cirrus;
       decbank  := decbank_cirrus;
       scroll   := scroll_cirrus;
       if card.speedupfunc then begin
         if card.speedups.bar then begin
           bar          := bar_cirrus;
           cleardevice  := cleardevice_cirrus;
           setfillstyle := setfillstyle_cirrus;
         end;
       if card.speedups.bitblit then bitblit := bitblit_cirrus;
         card.upspeeded := true;
       end;
     end;
   end;
{   if (card.fastid = CHIPS) then begin
     if (card.speedup) then begin
       if card.speedupmode = 0 then enableext_ct;
       if card.speedups.banking then begin
         setbank  := setbank_ct;
         setbank2 := setbank2_ct;
         incbank  := incbank_ct;
         decbank  := decbank_ct;
       end;
     end;
   end;}
{   if (card.fastid = ATI) then begin
     if (card.speedup) then begin
       if card.speedups.banking then begin
         setbank  := setbank_ati;
         setbank2 := setbank2_ati;
         incbank  := incbank_ati;
         decbank  := decbank_ati;
       end;
     end;
   end;}
end;
{$ENDIF}

procedure resetgdc;assembler;
asm
  mov   dx,3CEh  {GDC}
  mov   al,5     {GDC mode}
  out   dx,al
  inc   dx
  in    al,dx    {get values}
  and   al,0FCh  {cpu byte manipulation on}
  out   dx,al
end;

procedure setaccelerationmode(mode : byte);
begin
  card.upspeeded := false;
  if mode > 0 then card.speedup := true else card.speedup := false;
  if mode > 1 then card.speedupfunc := true else card.speedupfunc := false;
  {$IFDEF ACCELERATION}
  if (gfx_inited)and(currentmode.mode > $13) then resetoutput;
  {$ENDIF}
  card.speedupmode := mode;
end;

function currenttime : longint;assembler;
asm
  mov   es,[seg0040]
  mov   ax,es:[6Ch]
  mov   dx,es:[6Eh]
end;

procedure getcolors;
begin
  if currentmode.bpp = 8 then begin
    Blue         := 1;
    Green        := 2;
    Cyan         := 3;
    Red          := 4;
    Magenta      := 5;
    Brown        := 6;
    LightGray    := 7;
    DarkGray     := 8;
    LightBlue    := 9;
    LightGreen   := 10;
    LightCyan    := 11;
    LightRed     := 12;
    LightMagenta := 13;
    Yellow       := 14;
    White        := 15;
  end else begin
    Blue         := rgb(0,0,191);
    Green        := rgb(0,191,0);
    Cyan         := rgb(0,191,191);
    Red          := rgb(191,0,0);
    Magenta      := rgb(191,0,191);
    Brown        := rgb(191,191,0);
    LightGray    := rgb(192,192,192);
    DarkGray     := rgb(128,128,128);
    LightBlue    := rgb(0,0,255);
    LightGreen   := rgb(0,255,0);
    LightCyan    := rgb(0,255,255);
    LightRed     := rgb(255,0,0);
    LightMagenta := rgb(255,0,255);
    Yellow       := rgb(255,255,0);
    White        := rgb(255,255,255);
  end;
  currentcolor := white;
  fillcolor    := white;
end;

procedure detectflicker; {lasts about 1/2 second - should be precise enough...}
var
  endtime : longint;
  count   : array[0..1] of word;
begin
  count[0] := 0;
  count[1] := 0;
  pr       := true;
  endtime := currenttime + 1;
  repeat until currenttime <> endtime;{synchronize}
  endtime := currenttime + 4;
  repeat
    waitretrace;
    inc(count[0]);
  until currenttime >= endtime;
  endtime := currenttime + 4;
  repeat
    scroll(pageadd);
    inc(count[1]);
  until currenttime >= endtime;
  if count[1] div 2 > count[0] then pr := true else pr := false;
end;

function getmode(resx,resy,colres : word) : word;
var
  table,i : byte;
begin
  getmode := 0;
  case colres of
     8 : table := 0;
    15 : table := 1;
    16 : table := 2;
{    24 : table := 3;
    32 : table := 4;}
    else exit;
  end;
  for i := 0 to restab[table].avmodes do
  with restab[table] do
  if (mode[i].resx = resx)and(mode[i].resy = resy) then begin
    getmode := mode[i].mode;
    exit;
  end;
end;

procedure setmode(resx,resy,bpp : word);
var
  i : integer;
begin
  if gfx_inited then closegraph;
  gresult := 0;
  currentmode.mode := getmode(resx,resy,bpp);
  if currentmode.mode = 0 then begin
    gresult := grinvalidmode;
    exit;
  end;
  gettext;
  if currentmode.mode <> $13 then begin
    getvesamodeinfo(currentmode.mode);
    if gresult <> 0 then begin {getvesamodeinfo failed...}
      gresult := grinvalidmode;
      exit;
    end;
    textmode(3); {for S3-cards in PM - DON'T REmovE!}
    if not initvesamode(currentmode.mode) then begin
      gresult := grInvalidMode;
      exit;
    end;
  end else initvgamode(currentmode.mode);
  resetprocs;
  getcolors;
  resetgdc;
  gfx_inited := true;
  if currentmode.mode <> $13 then begin
    incbank := incbank_vesa;
    decbank := decbank_vesa;
{$IFDEF ACCELERATION}
    i := card.speedupmode;
    card.speedupmode := 0;
    if i = 3 then setaccelerationmode(2) else setaccelerationmode(i);
    resetoutput;
{$ENDIF}

    if getbit(modeinfoblock.winBAttributes,2) then currentmode.writeptr := getrmselector(modeinfoblock.winBsegment);
    if getbit(modeinfoblock.winAAttributes,2) then currentmode.writeptr := getrmselector(modeinfoblock.winAsegment);

    if getbit(modeinfoblock.winBAttributes,1) then currentmode.readptr := getrmselector(modeinfoblock.winBsegment);
    if getbit(modeinfoblock.winAAttributes,1) then currentmode.readptr := getrmselector(modeinfoblock.winAsegment);
  end else begin
    currentmode.numofpages := 0;
    mxx := 319;
    mxy := 199;
    maxx := succ(mxx);
    maxy := succ(mxy);
    currentmode.scanline      := maxx;
    currentmode.readptr       := getrmselector($A000);
    currentmode.writeptr      := currentmode.readptr;
    currentmode.bpp           := 8;
    currentmode.bytesperpixel := 1;
    currentmode.lasty         := mxy;
  end;
  with currentmode do
  case bpp of
    8  : begin;coljump.r:=4;coljump.g:=4;coljump.b:=4;end;
    15 : begin;coljump.r:=8;coljump.g:=8;coljump.b:=8;end;
    16 : begin;coljump.r:=8;coljump.g:=4;coljump.b:=8;end;
    24,32 : begin;coljump.r:=1;coljump.g:=1;coljump.b:=1;end;
  end;
  pageadd := 0;
  if (getbit(modeinfoblock.winAAttributes,1))and
     (getbit(modeinfoblock.winAAttributes,2)) then
     twowins := false else twowins := true;

  if currentmode.writeptr <> currentmode.readptr then twowins := true;
  setviewport(0,0,mxx,mxy,true);
  gresult := grok;
  currentmode.mxx  := mxx;
  currentmode.mxy  := mxy;
  currentmode.maxx := maxx;
  currentmode.maxy := maxy;
  actscreen    := actviewport;
  actscreen.y2 := {mxy}currentmode.lasty;
  actscreen.mxy:= {mxy}currentmode.lasty;
  actscreen.clip := true;
  for i := 0 to currentmode.numofpages do begin
    setactivepage(i);
    cleardevice_vesa;
  end;
  setactivepage(0);
  getpal;
  setfillstyle(solidfill,white);
  detectflicker;
end;

function grapherrormsg(errorcode : integer) : string;
begin
  case errorcode of
    grNotDetected    : grapherrormsg := 'No VESA-card detected';
    grFontNotFound   : grapherrormsg := 'Font file not found';
    grNoFontMem      : grapherrormsg := 'Not enough memory for font';
    grInvalidMode    : grapherrormsg := 'Mode is not available on this card';
    grError          : grapherrormsg := 'Generic failure';
    grIOerror        : grapherrormsg := 'Disk I/O error';
    grInvalidFont    : grapherrormsg := 'Font is no valid GSoft charset';
    grInvalidFontNum : grapherrormsg := 'Font not available';
    grNoMouseFound   : grapherrormsg := 'No mousedriver found';
    else               grapherrormsg := 'Unknown error';
  end;
end;

function getdrivername : string;
begin
  getdrivername := card.chipid+' '+card.chipname;
end;

procedure setviewport(x1,y1,x2,y2 : integer;clip : boolean);
begin
  actviewport.x1  := x1;
  actviewport.y1  := y1;
  actviewport.x2  := x2;
  actviewport.y2  := y2;
  if actviewport.y2 > currentmode.lasty then actviewport.y2 := currentmode.lasty;
  actviewport.clip:= clip;
  actviewport.mxx := x2-x1;
  actviewport.mxy := y2-y1;
  if clip then fillviewport := actviewport else
  fillviewport := actscreen;
end;

procedure getviewsettings(var viewport : viewporttype);
begin
  move2(actviewport,viewport,sizeof(actviewport));
end;

procedure clearviewport;
begin
  oldcol    := fillcolor;
  fillcolor := black;
  with actviewport do bar(0,0,mxx,mxy);
  fillcolor := oldcol;
end;

procedure closegraph;assembler;
asm
  cmp   gfx_inited,0
  je @end
    mov   ax,lastmode
    int   10h
    call  puttext
    mov   gfx_inited,0
    mov   card.speedupmode,3
  @end:
end;

procedure settextjustify(horiz,vert : word);
begin
  textx := horiz;
  texty := vert;
end;

procedure setfont(fnt,size : byte);
{set actual font}
begin
  if fontinfo[fnt].available then begin
    font        := fnt;
    currentsize := size;
  end else gresult := grinvalidfont;
end;

procedure settextstyle(font,direction,charsize : word);
{only for compatibility}
begin
  setfont(font,charsize);
end;

procedure gettextsettings(var textinfo : textsettingstype);
begin
  textinfo.font      := font;
  textinfo.direction := 0;
  textinfo.charsize  := currentsize;
  textinfo.horiz     := currentsize;
  textinfo.vert      := currentsize;
end;

function textheight : word;
var
  i2,sy,chw,cy,cr : byte;
  crs,height      : byte;
  dummy,i,i3      : word;
  incer           : word;
begin
 if header[font].chartype = 1 then begin
   crs := header[font].charsize;
   cr  := ord('T');
   height := 0;
{   for i2 := 0 to charpoints^[cr].numofpoints do with charpoints^[cr] do begin
     cy := pointpos[i2].y*currentsize div crs;
     if height < cy then height := cy;
   end;}
(*       for i2 := 1 to charpoints^[cr].numofpoints do
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

{         mov cx,65            { one vec-char : 65 bytes                }
{         mul cx               { and calculate memory position          }
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
           mov bl,es:[di+1]   { so load x and y value to bx            }
           pop di
           cmp height,bl
           jnb @next
           mov height,bl
           @next:
         dec i2
         jnz @lp
         mov  bl,crs
         mov  al,height
         mul  currentsize
         div  bl
         mov  height,al
       end;

   textheight := height;
 end else textheight := header[font].height;
end;


procedure writexy(x,y : integer;s : string);
var
  i2,cr,sy,chw,cx,chh : byte;
  crs,width,dist      : byte;
  dummy,i,i3,sc       : word;
  xwidth              : word;
  px,py,lx,ly         : word;
  incx                : word;
  incer               : word;
  chp                 : pointer;
begin
 case textx of
   centertext : x := x-textwidth(s) div 2;
   righttext  : x := x-textwidth(s);
 end;
 case texty of
   centertext : y := y-textheight div 2;
   bottomtext : y := y-textheight;
 end;
 if length(s) = 0 then exit;
 sc := header[font].startchar;
 if header[font].chartype = 1 then begin
   xwidth := x;
   crs    := header[font].charsize;
   incx   := (crs*currentsize) div 12;
   for i := 0 to pred(ord(s[0])) do begin
     cr := ord(s[i+1]);
     width := 0;
     if xwidth > actviewport.mxx then break;
     if cr <> 32 then begin
       lx := charpoints^[cr].pointpos[0].x*currentsize div crs+xwidth;
       ly := charpoints^[cr].pointpos[0].y*currentsize div crs+y;
       asm
         les di,charpoints
         mov ax,word ptr cr   { get the char to draw                   }
         xor ah,ah

         mov bx,ax
         shl ax,6
         add ax,bx             {hehe - saved some cpu time!            }

{         mov cx,65            { one vec-char : 65 bytes                }
{         mul cx               { and calculate memory position          }
         add di,ax
         mov al,es:[di]       { get the amount of lines to draw        }
         dec al
         mov i2,al            { and save it in i2                      }
         mov i3,0             { now reset i3                           }
         @drawlp:

           push di            { save di for next loop                  }
           mov dx,i3          { load i3                                }
           add dx,4           { increment it by 4,                     }
           mov i3,dx          { write the value back                   }
           {xor dh,dh}
           lea ax,es:[di+1]
           add ax,dx          { add now i3 to ax                       }
           mov di,ax          { now we have the actual memory position }
           mov bx,es:[di]     { so load x and y value to bx            }

           mov dl,currentsize { load current charsize                  }
           xor dh,dh
           xor ch,ch
           mov cl,crs         { load relative charsize of the font     }
           xor ah,ah          { we don't need ah any more              }
           mov al,bl          { move x value to al                     }
           mul dx             { and multiply with the charsize         }
           div cx             { now divide it by the relative charsize }
           mov si,ax
           add si,xwidth      { add the x-screenpos. to the point      }

           mov dl,currentsize { load current size again for multiply   }
           mov al,bh          { load the y-position to al              }
           mul dx             { and multiply it with the charsize      }
           div cx             { and divide it by the relative charsize }
           add ax,y           { and add y-screenposition               }


           cmp bl,width       { is the actual line wider than the      }
           jna @na            { last line? If yes: save new width      }
             mov width,bl
           @na:

           mov cx,lx          { save last point-positions for the next }
           mov dx,ly          { line-drawing                           }
           mov lx,si          { ...and save new values in it           }
           mov ly,ax
           mov bl,es:[di-2]   { should the next line be drawed? If no: }
           or bl,bl           { overjump line-drawing                  }
           jnz @end
           push es            { save es because of the pointer to the  }
                              { font                                   }
           push cx            { push all points for line               }
           push dx
           push si
           push ax
           call line          { ...and draw the line                   }

           pop es             { restore es                             }
           @end:
         pop di
         dec i2               { decrease number of lines to write      }
         jnz  @drawlp
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
 end
 else if header[font].colordepth = 1 then begin
    if ((y < fillviewport.mxy+1)or(not actviewport.clip))and(x < fillviewport.mxx+1)and(y >= 0) then begin
      chw := header[font].width;
      chh := header[font].height;
      chp := chars[font];
      dist:= header[font].distance;
      sy  := header[font].height;
      if (sy+y > fillviewport.mxy) then sy := (fillviewport.mxy+1)-y;
      inc(y,pageadd);
      if actviewport.clip then
      if (x+ord(s[0])*(chw+dist)) > fillviewport.mxx+1 then begin
        i := ((actviewport.mxx+1)-x) div (chw+dist);
        if (i > 32768)or(i = 0) then exit;
        s[0] := chr(i);
      end;

      inc(x,actviewport.x1);
      inc(y,actviewport.y1);
      if x < fillviewport.x1 then begin
        i := ((x-actviewport.x1)+ord(s[0])*(chw+dist));
        if (i > 32768)or(i = 0) then exit;
        x := i mod (chw+dist)+actviewport.x1;
        i := i div (chw+dist);
        if  i = 0 then exit;
        move2(s[length(s)-i+1],s[1],i);
        s[0] := chr(i);
      end;
      xwidth := x;
{      incer := currentmode.scanline-header[font].width*currentmode.bytesperpixel;}
   case currentmode.bpp of
     8  : begin
      incer := currentmode.scanline-header[font].width;
      asm
        db   66h;xor  ax,ax
        mov  ax,currentmode.writeptr
        mov  es,ax                { load screenpointer into es          }

        mov  i,0                  { begin with char 0                   }
        xor  ch,ch
        @lp3:
          mov  py,0               { reset y-position                    }

          mov  si,i               { load stringposition                 }
          db   66h;xor cx,cx
          mov  cl,chh
          mov  ax,word ptr s[si+1]{ load char from position+1           }
          xor  ah,ah
          add  ax,sc              { add first availible char            }
          xor  ah,ah
          mul  cx                 { ...and calculate it's memposition   }
          mov  di,ax              { now save this in di                 }

          mov  cx,currentmode.scanline{ calculate position in gfx-memory    }
          mov  ax,y
          db   66h;mul cx
          mov  cx,xwidth
          db   66h;add ax,cx
          mov  si,ax              { and save the lower 16bit in si      }

          db   66h;shr ax,16
          cmp  ax,lastbank        { actual bank = setted bank?          }
          je   @next              { if yes, goto next                   }
          push ax
          call setbank2           { if not, switch to new bank          }
          @next:

          mov  al,byte ptr currentcolor    { save drawcolor in al       }
          xor  dh,dh
          mov  dl,chw             { save charwidth in dl                }
          mov  bx,xwidth          { and load actual x-position          }
          add  bx,dx
          mov  cx,maxx
          cmp  bx,cx              { is char over maxx?                  }
          jna  @na
            sub  bx,cx
            mov  dl,bl
          @na:
          mov  dh,sy              { load charheight in dh               }

          push ds
          lds  bx,chp
          add  di,bx
          @lp2:
            mov  cl,dl            { reset x-position                    }
            mov  ch,1             { reset byteposition                  }
            mov  bl,ds:[di]       { load new line of char...            }
            inc  di               { and increase lineposition           }
            @lp:
              test  bl,ch         { bit setted?                         }
              jz    @noput
                mov  es:[si],al   { yes: put pixel                      }
              @noput:
              inc  si             { next pixel                          }
              jz @inc1            { overflow? Then increase bank!       }
@continue1:   add  ch,ch          { next bit                            }
              dec  cl             { increase x-Position in the byte     }
            jnz  @lp              { charline full drawed? If no: all again}
            add  si,incer         { Next row                            }
            jc  @inc2             { Overflow?                           }
            @continue2:
            dec  dh               { decrease lines to draw              }
            jnz  @lp2             { At the end of the char? If no: next line}
          pop  ds
          @overmaxx:
          mov  al,dist
          xor  ah,ah
          add  ax,dx
          add  xwidth,ax          { icrease actual x-screenposition     }
          mov  ax,i               { load i into ax..                    }
          inc  ax                 { increase ax(i)..                    }
          mov  i,ax               { and save it into i                  }
          cmp  al,byte ptr s[0]   { All chars drawed?                   }
        jne  @lp3                 { If no : next char                   }
       jmp @end
     @inc1:   pop  ds
              pusha
              call incbank        { switch to next bank                 }
              popa
              push ds
              push bx
              lds  bx,chp
              pop  bx
              jmp  @continue1
     @inc2:   pop  ds
              pusha
              call incbank        { switch to next bank                 }
              popa
              push ds
              push bx
              lds  bx,chp
              pop  bx
              jmp  @continue2
        @end:
      end;
     end;
     else begin
     incer := currentmode.scanline-header[font].width shl 1;
     asm
      mov  ax,currentmode.writeptr
      mov  es,ax                { load screenpointer into es the      }

      mov  i,0                  { begin with char 0                   }
      xor  ch,ch
      @lp3:
        mov py,0                { reset y-position                    }

        mov si,i                { load stringposition                 }
        db 66h;xor cx,cx
        mov cl,chh
        mov ax,word ptr s[si+1] { load char from position+1           }
        add ax,sc               { add first availible char            }
        xor ah,ah
        mul cx                  { ...and calculate it's memposition   }
        mov di,ax               { now save this in di                 }

        mov cx,currentmode.scanline { calculate position in gfx-memory    }
        mov ax,y
        db 66h;mul cx
        mov cx,xwidth
        add cx,cx
        db 66h;add ax,cx

        mov si,ax               { and save the lower 16bit in si      }

        db 66h;shr ax,16
        cmp ax,lastbank         { actual bank = setted bank?          }
        je @next                { if yes, goto next                   }
        push ax
        call setbank2           { if not, switch to new bank          }
        @next:

        mov  ax,word ptr currentcolor    { save drawcolor in ax       }
        xor  dh,dh
        mov  dl,chw             { save charwidth in dl                }
        mov  bx,xwidth          { and load actual x-position          }
        add  bx,dx
        mov  cx,maxx
        cmp  bx,cx              { is char over maxx?                  }
        jna  @na
          sub  bx,cx
          mov  dl,bl
        @na:
        mov  dh,sy              { load charheight in dh               }

        push ds
        lds  bx,chp
        add  di,bx
        @lp2:
          mov  cl,dl            { reset x-position                    }
          mov  ch,1             { reset byteposition                  }
          mov  bl,ds:[di]       { load new line of char...            }
          inc  di               { and increase lineposition           }
          @lp:
            test  bl,ch         { bit setted?                         }
            jz    @noput
              mov  es:[si],ax   { yes: put pixel                      }
            @noput:
            add  si,2           { next pixel                          }
            jc  @inc1           { overflow? Then increase bank!        }
 @continue1:add  ch,ch          { next bit                            }
            dec  cl             { increase x-Position in the byte     }
          jnz  @lp              { charline full drawed? If no: all again}
          add  si,incer         { Next row                            }
          jc  @inc2             { Overflow?                           }
 @continue2:
            dec  dh             { decrease lines to draw              }
        jnz  @lp2               { At the end of the char? If no: next line}
        pop  ds
        @overmaxx:
        mov  al,dist
        xor  ah,ah
        add  ax,dx
        add  xwidth,ax          { und zur aktuellen X-Position addieren}
        mov  ax,i               { load i into ax..                    }
        inc  ax                 { increase ax(i)..                    }
        mov  i,ax               { and save it into i                  }
        cmp  al,byte ptr s[0]   { All chars drawed?                   }
      jne  @lp3                 { If no : next char                   }
     jmp @end
     @inc1:   pop  ds
              pusha
              call incbank      { then switch to next bank            }
              popa
              push ds
              push bx
              lds  bx,chp
              pop  bx
              jmp  @continue1
     @inc2:   pop  ds
              pusha
              call incbank      { then switch to next bank            }
              popa
              push ds
              push bx
              lds  bx,chp
              pop  bx
              jmp  @continue2
     @end:
     end;
   end;
 end;
   end;
  end else if (header[font].colordepth = 8)and(currentmode.bpp = 8) then begin
    xwidth := x;
    chp    := chars[font];
    dist   := header[font].distance;

    for i := 0 to pred(ord(s[0])) do begin
      cr := ord(s[i+1]);
      px := memw[seg(chp^):ofs(chp^)+(cr-header[font].startchar)*2]+
      (header[font].endchar-header[font].startchar+1)*2;
      width := memw[seg(chp^):ofs(chp^)+px+2];
      if (cr <> 32)and(width > 0)and(cr >= header[font].startchar)
      and(cr <= header[font].endchar) then begin
        putsprite(xwidth+mem[seg(chp^):ofs(chp^)+px],y+mem[seg(chp^):ofs(chp^)+px+1],
                  ptr(seg(chp^),ofs(chp^)+px+2),0);
        inc(xwidth,width+dist);
      end else
      inc(xwidth,header[font].width);
    end;
  end;
end;


var
  oldexit : pointer;

procedure exit_grafx;far;
begin
  dispose(pal);
  dispose(col8bitpal);
  freemem(gfxbuf,gfxbufsize);
  if gfx_inited then closegraph;
  exitproc := oldexit;
end;

procedure searchmodes;
const
  supportedbpp : set of byte=[8,15,16,24,32];
type
  tvideomode = array[0..1023] of word;
var
  i,rtab    : word;
  videomode : ^tvideomode;
begin
  i          := 0;
  getmem(videomode,2048);
  move2(ptr(getrmselector(longint(vesainfoblock.videomodeptr) shr 16),longint(vesainfoblock.videomodeptr) and $FFFF)^,
        videomode^,2048);
  for rtab := 1 to 4 do restab[rtab].avmodes := 0;
  while (videomode^[i] <> $FFFF) do begin
    getvesamodeinfo(videomode^[i]);
    if (modeinfoblock.memorymodel <> 0)and(modeinfoblock.bitsperpixel in supportedbpp)
    then begin
      case modeinfoblock.bitsperpixel of
        8  : rtab := 0;
        15 : rtab := 1;
        16 : rtab := 2;
        24 : rtab := 3;
        32 : rtab := 4;
      end;
      if (restab[rtab].avmodes < 25)and(
         longint(modeinfoblock.bytesperscanline)*modeinfoblock.yresolution <=
         longint(vesainfoblock.totalmemory) shl 16) then begin
        restab[rtab].mode[restab[rtab].avmodes].resx := modeinfoblock.xresolution;
        restab[rtab].mode[restab[rtab].avmodes].resy := modeinfoblock.yresolution;
        restab[rtab].mode[restab[rtab].avmodes].mode := videomode^[i];
        inc(restab[rtab].avmodes);
      end;
    end;
    inc(i);
  end;
  freemem(videomode,2048);
end;

var
  i : integer;
begin
  oldexit  := exitproc;
  exitproc := @exit_grafx;
  vesainfoblock.vesasignature := 'VBE2';{tell the VESA-Driver you want extended information}
  getvesainfo;
  if vesainfoblock.vesasignature = 'VESA' then searchmodes{ else
  for i := 1 to 9 do modeset[i].mode := 0};
  if getmode(320,200,8) = 0 then begin
    if restab[0].avmodes < maxmodes-1 then inc(restab[0].avmodes);
    i := restab[0].avmodes-1;
    restab[0].mode[i].resx := 320;
    restab[0].mode[i].resy := 200;
    restab[0].mode[i].mode := $13;
  end;

  resetprocs;
  image_putline := image_line_std;
  image_getline := image_getline_std;
  image_pp      := image_pp_std;
  card.speedup        := true;
  card.speedupfunc    := true;
  card.chipid         := 'VESA';
  card.chipname       := '';
  card.chipnum        := 0;
  card.fastid         := 0;
  card.upspeeded      := false;
  card.speedupmode    := 3;
  card.upspeedable    := false;

  if paramcount > 0 then for i := 1 to paramcount do begin
    if pos('accoff',paramstr(i)) <> 0 then card.speedupfunc := false;
    if pos('safemode',paramstr(i)) <> 0 then card.speedup := false;
  end;
  {$IFDEF ACCELERATION}
    card.upspeeded := false;
    if detect_s3 then begin
      card.chipid := 'S3';
      card.fastid := S3;
      card.upspeedable := true;
    end else
    if detect_cirrus then begin
      card.chipid := 'Cirrus';
      card.fastid := CIRRUS;
      card.upspeedable := true;
    end;

(*  if card.fastid = S3 then if lo(card.chipnum) <= $D1 {not if >= Trio32} then
  for i := 1 to 5 do begin
    { Check if all accelerated S3-Modes are available }
    getvesamodeinfo(restab[0].mode[i].mode+$100);
    if graphresult = grOk then
    inc(restab[0].mode[i].mode,$100); { Special S3 accelerated modes }
  end;*)
  {$ENDIF}
  gresult := 0;
end.
{****************************************************************************
 * History                                                                  *
 * Version 1.0   first public available Version (9th Aug.1997)              *
 * Version 1.1   +added some comments so that other persons know how to use *
 *                the procedures                                            *
 *               +added circle-routines (filled and traced)                 *
 *               *fixed a bug in procedure sprite2mem                       *
 *               *fixed a bug in readgraphline                              *
 *               +added scrollsupport                                       *
 *               *changed the cursor in readgraphline to see it better      *
 *               +added special waitretrace for setvisualpage (pageretrace) *
 *                (12th Aug.1997)                                           *
 * Version 1.11  *fixed some minor bugs                                     *
 * Version 1.2   +added setviewport                                         *
 *                ^please note that there could be some little bugs - I had *
 *                 not enough time to check all out... you know: school ;)  *
 *               +added vline                                               *
 *               *changed some things for PM - should run on S3 cards now   *
 *                faster and on other cards where it didn't run it runs now *
 *               +added some variables for compatibility with the unit graph*
 *               *fixed a bug with a wrong variable that causes a terrible  *
 *                display on some special gfx-cards (i.e. Matrox)           *
 *               *changed S3-Chip-detection because the detection runned    *
 *                sometimes not correctly                                   *
 *         thanx to Carsten KrÅger for his support with the last 2 things   *
 *                (27th Sep.1997)                                           *
 * Version 1.21  *writexy-vectorscript module rewritten to assembler - is   *
 *                now nearly 2 times faster                                 *
 *               *fixed a bug in putimage and similar procedures            *
 *                bug was caused by the implementation of setviewport       *
 *                (28th Sep.1997)                                           *
 * Version 1.25  +added support for 8-Bit fonts                             *
 *               *fixed a little bug in circle-procedure                    *
 *               *fixed a bug in writexy which causes with 1bit font wrong  *
 *                display if the font wents over the right edge             *
 *               +1bit fonts are now clipped also on the left edges         *
 *                (3rd Oct.1997)                                            *
 * Version 1.26  *changed putsprite to use other transparent colors than 0  *
 *                too                                                       *
 *               *fixed a bug in writexy/outtextxy-procedure with bankswitch*
 *               +added procedure spriteline for use with i.e. transparent  *
 *                gif's                                                     *
 *               *lines are now clipped too with setviewport                *
 *               *putpixel can also put xorpixels (with setwritemode)       *
 *                (12th Oct 1997)                                           *
 * Version 1.3   +added procedures fillpoly and drawpoly                    *
 *               +graphresult support implemented                           *
 *               *S3cards are now in PMode as fast as in realmode - the     *
 *                bankswitching uses direct the S3-card - no use of vesa -  *
 *                so this unit runs also fast with univesa! (which was in-  *
 *                compatible with the integrated speedup)                   *
 *               +the hardware acceleration of S3cards is now used          *
 *               +added procedure Bitblit - software emulation and if S3chip*
 *                present, it uses hardware acceleration                    *
 *               +All the same for Cirrus cards                             *
 *               *implemented faster circle routine (nearly 30 times faster)*
 *               *lots of other speedups                                    *
 *               +documentation comes now with this unit (not good yet ;)   *
 *               *fixed some bugs with setviewport                          *
 *               *fixed a bug in writexy                                    *
 *               *bugfix in floodfill - hanged sometimes the machine        *
 *               *fixed a lot of other bugs(I'm too lazy to list them all :)*
 *               +added partially support for setlinestyle                  *
 *                ^^supported by line, circle, rectangle and ellipse now    *
 *               +added full support for setfillstyle                       *
 *               +added function getdrivername - returns the detected card  *
 *               +added function grapherrormsg                              *
 *               +added procedure ellipse and fillellipse                   *
 *               *fixed a bug in pageretrace                                *
 *               *pageretrace is now automatically called after setvisualpage*
 *               +added function loadpal                                    *
 *               *speeded up findnearcol a little bit                       *
 *               *changed up some things for sooncoming Grafx2              *
 *               *increased speed of writexy (25%)                          *
 *               *removed a bug in putimage - every time the clipping was   *
 *                switched off, the program hanged...                       *
 *               *removed some clipping problems                            *
 *               *fixed bug with bankswitching on ATI-cards                 *
 *               *very fast and safe line-clipping algorithm implemented    *
 *               +added procedures openimage and closeimage - they'll make  *
 *                the memory/image management a lot easier                  *
 *               +procedure closefont added                                 *
 *               *changed procedure calccircle - a little bit faster and now*
 *                also only ONE version for Rm AND Pm                       *
 *               *increased speed of vline                                  *
 *               *clipping bugs removed                                     *
 * Phew... ever seen such a long revisionlist? ;) Well, the work is almost  *
 * finished now... I never thought I would have to write a half year...     *
 * a heap of alpha and beta-versions and an endless bugfixing. But I think  *
 * the work was worth it - the unit had never such few bugs like now.       *
 * Release date of version 1.3c was the 19th May 1998                       *
 *****                                                                      *
 * Version 1.4   +Yea, we have support for Hicolor now!                     *
 *               *maximum color value is now 255, please remember this!     *
 *                That's for more easy usage and probably later also for    *
 *                newer 8-bit dac's                                         *
 *               *fixed bug in the software-bitblitter                      *
 *               *color-converter (24 to 8 bit) twice fast                  *
 *               *fixed small clipping-bug in image-procedures              *
 *               *changed algorythm of scaler - now 15% faster              *
 *               *optimized some procedures about 10%                       *
 *               *calcellipse rewritten to asm (thanx 2 Maarten vd. Zwaart) *
 *               *S3 unit improved (S3 finally sent me some manuals :)      *
 *         1.4c  *fixed some bugs related with W2k and PM                   *
 *               -hardware acceleration removed - supported card types not  *
 *                available anymore in today's machines, creates only probs *
 *               *fixed hicolor scaling bug                                 *
 *               *bitblitting bug fixed                                     *
 ****************************************************************************}
