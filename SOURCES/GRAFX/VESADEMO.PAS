{$A+,B+,F-,G+,I-,O+,P+,Q-,R-,S-,T-,V-,X+,Y-,E+,N+}
{****************************************************************************
 * Author           : Stefan Goehler, Germany                               *
 * Version          : official 1.13                                         *
 * Task             : show how to use my units                              *
 * Copyright        : This prog has been written only to demonstrate how to *
 *                    use my units. You must not use any parts of this in   *
 *                    other programs, because some parts of the source were *
 *                    not written by me!                                    *
 ******* CONTACT ************************************************************
 * my homepage: http://www.crossfire-designs.de                             *
 * ^^^note that you can get there always the actual version of this program *
 * if you have additions, tips or sth. else, mail to stefan.goehler@gmx.de  *
 ******* HISTORY ************************************************************
 * Version 1.0 : first public available Version (11th Aug. 1997)            *
 * Version 1.1 : +added putpixeltest                                        *
 *               +added endscroller                                         *
 *               *changed putspritetest a bit so it can run with pageflip   *
 *               +added checking, if computer does sth other (multitasking?)*
 *               *changed in putspritetest scrolling to bouncing            *
 *               +used extended mouseprocedures(setmousearea, setmousepos)  *
 *                (12th Aug 1997)                                           *
 * Version 1.11  *changed the endscroller for the new 8bit font-support     *
 * Version 1.12  +support for new features of grafx1.3                      *
 * Version 1.13  *changed endscroller                                       *
 ****************************************************************************}
uses grafx,crt,mousedr7,fadelib,pngunit,gr_vars;

var
  stony,p,p2 : pointer;
  x,y,i      : integer;
  i1,i2      : integer;
  interlaced : boolean;
  s          : string ;
  endtime    : longint;

type
  wintype = record {little part of the whole variable}
            pos : pointtype;
          button : array[0..9] of record
 available,active,rep,pushed : boolean;
           incer      : byte;
           nexttime   : longint;{fÅr Wiederholungen bei einem DrÅcken}
           scroll     : record
           scrollable : boolean;
           min,max    : pointtype;
           end;

            text      : record
     available,middle : boolean;
          assignedkey : char;
                  col : byte;
                  txt : string[20];
                  pos : pointtype;
                  end;
              procptr : record
            available : boolean;
                 proc : procedure;
              end;
                  image : record
              available : boolean;
                      p : pointer;
                   size : word;
                    pos : pointtype;
                    gr  : pointtype;
                   end;
            size : pointtype;
                pos  : pointtype;
                end;
end;

var
  window : array[0..0] of wintype;

const
  hell     : byte = 24;
  mhell    : byte = 25;
  mitte    : byte = 26;
  schatten : byte = 27;
  dunkel   : byte = 28;
  text     : byte = 29;

procedure frame(x1,y1,x2,y2 :integer;raised : boolean);
var
  col : byte;
begin
  col := getcolor;
  if raised then setcolor(dunkel) else setcolor(mhell);
  line(x2,y2,x2,y1);
  line(x2-1,y2,x1,y2);
  if raised then begin
    setcolor(mhell);
    line(x1+1,y1+1,x2-2,y1+1);
    line(x1+1,y1+1,x1+1,y2-2);
    setcolor(hell);
    line(x1,y1,x2-1,y1);
    line(x1,y1,x1,y2-1);
  end else begin
    setcolor(schatten);
    line(x1,y1,x2,y1);
    line(x1,y1,x1,y2);
  end;

  if raised then begin
    setcolor(schatten);
    line(x2-1,y2-1,x2-1,y1+1);
    line(x2-1,y2-1,x1+1,y2-1);
  end
  else begin
    setcolor(dunkel);
    line(x1+1,y1+1,x1+1,y2-1);
    line(x1+1,y1+1,x2-1,y1+1);
    setcolor(hell);
    line(x2-1,y2-1,x2-1,y1+2);
    line(x2-1,y2-1,x1+2,y2-1);
  end;
  setcolor(col);
end;


procedure drawbutton(win,bttn : integer;pushed : boolean);
{A part of my unit windows; maybe, I puplish it in some time}
var i,x,y : integer;
begin
setfont(2,3);
if pushed then i := 1 else i := 0;
with window[win] do begin
if pushed then begin
setcolor(schatten);
rectangle(pos.x+button[bttn].pos.x,pos.y+button[bttn].pos.y,pos.x+button[bttn].pos.x+button[bttn].size.x,
pos.y+button[bttn].pos.y+button[bttn].size.y);
setcolor(mitte);
rectangle(pos.x+button[bttn].pos.x+1,pos.y+button[bttn].pos.y+1,pos.x+button[bttn].pos.x+button[bttn].size.x-1,
pos.y+button[bttn].pos.y+button[bttn].size.y-1);
end else frame(pos.x+button[bttn].pos.x,pos.y+button[bttn].pos.y,pos.x+button[bttn].pos.x+button[bttn].size.x,
pos.y+button[bttn].pos.y+button[bttn].size.y,true);

setfillstyle(solidfill,mitte);
bar(pos.x+button[bttn].pos.x+2,pos.y+button[bttn].pos.y+2,pos.x+button[bttn].pos.x+button[bttn].size.x-2,
pos.y+button[bttn].pos.y+button[bttn].size.y-2);
if button[bttn].text.available then begin
setcolor(button[bttn].text.col);
if button[bttn].text.middle then begin
x := button[bttn].size.x shr 1 - textwidth(button[bttn].text.txt) shr 1+1;
y := button[bttn].size.y shr 1 - textheight shr 1-2;
writexy(pos.x+button[bttn].pos.x+x+i,pos.y+button[bttn].pos.y+y+i,
button[bttn].text.txt);
end else
writexy(pos.x+button[bttn].pos.x+button[bttn].text.pos.x+i,pos.y+button[bttn].pos.y+button[bttn].text.pos.y+i,
button[bttn].text.txt);
end;
if button[bttn].image.available then begin
putimage(button[bttn].image.pos.x+button[bttn].pos.x+pos.x+i,button[bttn].image.pos.y+button[bttn].pos.y+pos.y+i,
button[bttn].image.p)
end;
end;
end;

procedure definebutton(win,x,y,sx,sy,txtx,txty,txtcol,btn : integer;txt : string;actv,middle : boolean;p : pointer);
begin
 with window[win] do begin
  button[btn].available   := true;
  button[btn].active      := actv;
  button[btn].pos.x       := x   ;
  button[btn].pos.y       := y   ;
  button[btn].size.x      := sx  ;
  button[btn].size.y      := sy  ;
  button[btn].text.middle := middle;
  if txt <> '' then begin
    button[btn].text.available := true  ;
    button[btn].text.pos.x     := txtx  ;
    button[btn].text.pos.y     := txty  ;
    button[btn].text.col       := txtcol;
    button[btn].text.txt       := txt   ;
    if p <> nil then begin
      button[btn].procptr.available := true;
     {button[btn].procptr.proc      := p   ;}
      move2(p,button[btn].procptr.proc,4);
    end;
  end;
 end;
end;



function detint : boolean;assembler;
{detects, if the gfxcard displays in interlaced mode}
asm
  cli
  call waitretrace
  xor  cx,cx
  mov  dx,03DAh
  mov  bx,maxy
  dec  bx
  @lp1:
    in   al,dx
    test al,8d
    jz   @nz
      inc cl
    @nz:
    test al,1D
  jnz  @lp1
  @lp2:
    in   al,dx
    test al,1D
  jz   @lp2
  dec  bx
  jnz  @lp1
  mov  al,cl
  sti
end;

{function currenttime : longint;assembler;
asm
  xor ah,ah
  int 1Ah
  mov ax,dx
  mov dx,cx
end;}
function currenttime : longint;assembler;
asm
  mov   es,[seg0040]
  mov   ax,es:[6Ch]
  mov   dx,es:[6Eh]
end;

procedure getrefresh;
begin
  interlaced := detint;
  endtime := currenttime;
  repeat until endtime <> currenttime;
  i2 := 5;
  endtime := currenttime+round(18.2*i2);
  i1 := 0;
  repeat
    inc(i1);
    waitretrace;
  until (currenttime >= endtime)or(keypressed);
end;

procedure stars;external;
{$L stars}

procedure exitproggy;
begin
  closegraph;
  halt;
end;

function keyexit : boolean;
var
  ch : char;
begin
  repeat
    ch := readkey;
  until (ch = #27)or(ch = #13);
  if ch = #27 then keyexit := true else keyexit := false;
end;

function buttn(win,btn: integer) : boolean;
var
  col    : integer;
  pushed,p : boolean;
begin
  col := getcolor;
  with window[win] do begin
    waitretrace;
    hidemouse;
    drawbutton(win,btn,true);


   showmouse;
   if event.buttons = 1 then begin
     repeat
       getmouseevent;

 {  if event.what = 4 then begin}
       if (event.where.x > pos.x+button[btn].pos.x-1)and(event.where.y > pos.y+button[btn].pos.y-1)and
(event.where.x < pos.x+button[btn].pos.x+button[btn].size.x+1)and(event.where.y < pos.y+button[btn].pos.y+button[btn].size.y+1)
       then begin
         if not p then begin
           waitretrace;
           hidemouse;
           drawbutton(win,btn,true);
           p := true;
           showmouse;
         end;
         if (button[btn].procptr.available)and(button[btn].rep) then
         button[btn].procptr.proc;
       end else begin
         if p then begin
         waitretrace;
         hidemouse;
         drawbutton(win,btn,false);
         showmouse;
         p := false;
       end;
 {  end;}
     end;

   until event.what and evmouseup <> 0; end;
   if (event.where.x > pos.x+button[btn].pos.x-1)and(event.where.y > pos.y+button[btn].pos.y-1)and
   (event.where.x < pos.x+button[btn].pos.x+button[btn].size.x+1)and
   (event.where.y < pos.y+button[btn].pos.y+button[btn].size.y+1)
   then buttn := true else buttn := false;
   pushed := true;
   if p or pushed then begin
     waitretrace;
     hidemouse;
     drawbutton(win,btn,false);
     showmouse;
   end;
   setcolor(col);
   if pushed then delay(10);
    pushed := false;
  end;
end;

var
  ex       : boolean;
  bpressed : boolean;

procedure bexit;
begin
  ex := true;
  bpressed := true;
end;

procedure bcontinue;
begin
  ex := false;
  bpressed := true;
end;

procedure menuscreen;
var
  upal : paltype;
const
  yesno : array[false..true] of string = ('No','Yes');
begin
  getuserpal(upal);
  loadpngmem(0,0,@stars,0,255);
  openimage(stony,320,200);
  getimage(0,0,319,199,stony);
  for x := 1 to maxx div 320 do
  putimage(x*320,0,stony);
  for y := 1 to maxy div 200 do
  for x := 0 to maxx div 320 do
  putimage(x*320,y*200,stony);
  closeimage(stony);

  setrgbpalette(hell    ,58 shl 2,52 shl 2,47 shl 2);
  setrgbpalette(mhell   ,52 shl 2,45 shl 2,41 shl 2);
  setrgbpalette(mitte   ,45 shl 2,37 shl 2,34 shl 2);
  setrgbpalette(schatten,35 shl 2,26 shl 2,24 shl 2);
  setrgbpalette(dunkel  ,24 shl 2,14 shl 2,13 shl 2);
  setrgbpalette(text    , 0 shl 2,17 shl 2, 0 shl 2);
  for i := 0 to 16 do setrgbpalette(i,upal[i].r,upal[i].g,upal[i].b);

  setfont(3,0);
  rrectangle(0,0,mxx,mxy,10);
  initmouse;
  writexy(10,mxy-20,'Uses '+grafx_version+' - '#155' 1996-1998 by Stefan Gîhler');
  writexy(10,5,'**** Current configuration ****');
  writexy(10,30,'Resolution     : '+makestr(maxx)+'x'+makestr(maxy));
  writexy(10,50,'Colors         : '+makestr(currentmode.bpp)+' Bits');
  showmouse;
  setmousepos(mxx shr 1,mxy shr 1);
  changecursor(cursor_wait);
  s := 'Frequency      : please wait...';
  openimage(p,textwidth(s),textheight);
  getimage(10,70,10+textwidth(s),70+textheight,p);
  writexy(10,70,s);
  getrefresh;
  changecursor(cursor_std);
  hidemouse;
  putimage(10,70,p);
  closeimage(p);
  s := 'Frequency      : '+makestrr((i1/i2),4,1)+' Hz';
  if interlaced then s := s+' (interlaced)';
  writexy(10,70,s);
  writexy(10,90,'Card           : '+getdrivername);
  writexy(10,110,'Bytes/Scanline : '+makestr(currentmode.scanline));
  writexy(10,135,'**** VESA-Info ****');
  writexy(10,150,'Vesa-version  : '+makestr(hi(vesainfoblock.vesaversion))+'.'+makestr(lo(vesainfoblock.vesaversion)));
  writexy(10,170,'Memory        : '+makestr(vesainfoblock.totalmemory*64)+' KB');

  move(ptr(getrmselector(
  (longint(vesainfoblock.oemstringptr) shr 16)),
  (longint(vesainfoblock.oemstringptr) and $FFFF))^,s[1],255);
  for i := 1 to 255 do if s[i] = #0 then break;
  s[0] := chr(i);
  writexy(10,190,'OEMString     : '+s);
  writexy(10,210,'Virtual pages : '+makestr(currentmode.numofpages));

  if card.upspeedable then begin
    writexy(10,300,'Hardware acceleration supported by GRAFX');

    writexy(10,320,'Bankswitching : '+yesno[card.speedups.banking]);
    writexy(10,335,'Bar           : '+yesno[card.speedups.bar]);
    writexy(10,350,'Bitblitting   : '+yesno[card.speedups.bitblit]);
    writexy(10,365,'Line          : '+yesno[card.speedups.line]);
    writexy(10,380,'Mousecursor   : '+yesno[card.speedups.cursor]);
    writexy(10,395,'Polygons      : '+yesno[card.speedups.polygon]);
    writexy(10,410,'Scaling       : '+yesno[card.speedups.scale]);
  end;

  fillchar(window[0],sizeof(window[0]),0);
  definebutton(0,20,250,80,20,0,0,text,0,'Continue',true,true,@bcontinue);
  definebutton(0,110,250,80,20,0,0,text,1,'Exit',true,true,@bexit);
  bpressed := false;

  frame(10,240,200,280,false);
  setfillcolor(mitte);
  bar(12,242,198,278);
  drawbutton(0,0,false);
  drawbutton(0,1,false);
  showmouse;
  setmousearea(10,240,200,280);
  setmousepos(60,240);
  repeat
    getmouseevent;
    if event.buttons = 1 then begin
      for i := 0 to 1 do
      with window[0].button[i] do begin
        if pointerthere(pos.x,pos.y,pos.x+size.x,pos.y+size.y) then if
        buttn(0,i) then procptr.proc;
      end;
    end;
  until (bpressed)or(keypressed);
  donemouse;
  if ex then exitproggy;
  if keypressed then if keyexit then exitproggy;
  setfont(3,0);
end;

procedure statusbar(s : string;col : byte);
begin
  setcolor(col);
  setfillcolor(black);
  bar(0,mxy-19,mxx,mxy);
  rrectangle(0,mxy-19,mxx,mxy,10);
  settextjustify(centertext,toptext);
  writexy(mxx div 2,mxy-17,s+' - Enter to continue or ESC to exit');
  settextjustify(lefttext,toptext);
end;

var
  stab1,stab2 : array[0..255] of byte;
  j1,j2,c     : byte;
  e,e1,e2     : byte;
  decx,decy   : boolean;

procedure createplasma(p : pointer);
begin
  dec(e1);
  inc(j1,2);
  asm
    les di,p
    add di,imagedatasize
    xor dh,dh
    @lp2:
      xor ah,ah
      xor bh,bh
      mov al,dh
      mov bl,e1
      add ax,bx
      cmp ax,255;jnae @next;sub ax,255;@next:
      mov si,ax
      mov cl,byte ptr stab1[si]
      mov al,j1
      mov si,ax
      mov ch,byte ptr stab1[si]
      xor dl,dl
      @lp:
        xor ah,ah
        xor bh,bh
        mov al,dl
        mov bl,cl
        add ax,bx
        cmp ax,255;jnae @next2;sub ax,255;@next2:

        mov si,ax
        mov bl,byte ptr stab1[si]
        mov al,dh
        add al,ch
        mov si,ax
        add bl,byte ptr stab2[si]
        shr bl,1
        add bl,128
        mov bh,bl
        mov es:[di],bx
        mov es:[di+160],bx
        add di,2
        inc dl
        cmp dl,79
      jna @lp
      add di,160
      inc dh
      cmp dh,59
    jna @lp2
  end;
end;

procedure initplasma;
begin
  for x := 0 to 63 do begin
    setrgbpal(x,x,0,x shl 2);
    setrgbpal(127-x,x,0,x shl 2);
    setrgbpal(127+x,x shl 2,x shl 1,0);
    setrgbpal(254-x,x shl 2,x shl 1,0);
  end;
  for i := 127 downto 0 do
  setrgbpalette(i+128,pal^[i shl 1].r,pal^[i shl 1].g,pal^[i shl 1].b);

  for x := 0 to 255 do begin
    stab1[x] := round(sin(2*pi*x/255)*128)+128;
    stab2[x] := round(cos(2*pi*x/255)*128)+128;
  end;
  i1 := 50;
  j1 := 90;
end;

procedure scaletest;

var
  endtime,i    : longint;
  s            : string;
  average,count: longint;

begin
  initplasma;
  openimage(p,159,119);
  cleardevice;
  statusbar('Putimagetest (using waitretrace)',white);
  x := 0;
  y := 0;
  decx := false;
  decy := false;
  repeat
    createplasma(p);
    waitretrace;
    putimage(x,y,p);
    if decx then dec(x) else inc(x);
    if decy then dec(y) else inc(y);
    if (x = 0)or(x = mxx-160) then decx := not decx;
    if (y = 0)or(y = mxy-140) then decy := not decy;
  until keypressed;
  if keyexit then exitproggy;

  cleardevice;
  statusbar('Scaletest (maximum speed)',white);
{  setfont(1,0);
  for i := 1 to 32 do setrgbpalette(i+31,i*2-1,i*2-1,i*2-1);}
  endtime := currenttime+1;
  repeat until currenttime >= endtime;{Synchronize}
  endtime := currenttime+18;
  i       := 0;
  count   := 0;
  average := 0;
  s       := '';
  repeat
    if currenttime >= endtime then begin
      inc(average,i);
      inc(count);
      s := makestrr(average / count,4,2)+' FPS';
      endtime := currenttime+18;
      i := 0;
    end;
    inc(i);
    createplasma(p);
    scale(p,0,0,maxx,maxy-20);
    writexy(mxx-textwidth(s)-10,mxy-45,s);
  until keypressed;
  if keyexit then exitproggy;
  closeimage(p);
  setfont(3,0);
end;

procedure makepal(startcol,objr,objg,objb : byte);
const
  palwhite = 10; {How many of the 64 colors that should be white}
begin
  {black to object color}
  for i := 0 to 63-palwhite do
  setrgbpalette(startcol+i,((objr*i) div (63-palwhite)) shl 2,
                           ((objg*i) div (63-palwhite)) shl 2,
                           ((objb*i) div (63-palwhite)) shl 2);
  {object color to white}
  for i := 0 to palwhite do
  setrgbpalette(startcol+i+63-palwhite,(objr+((63-objr)*i) div palwhite) shl 2,
                                       (objg+((63-objg)*i) div palwhite) shl 2,
                                       (objb+((63-objb)*i) div palwhite) shl 2);
end;

procedure fillcircletest;
var
  coltab : word;
begin
  getpal;
  cleardevice;
 { for i := 0 to 63 do setrgbpalette(i,i,0,0);
  for i := 0 to 63 do setrgbpalette(i+64,0,i,0);
  for i := 0 to 63 do setrgbpalette(i+128,0,0,i);
  for i := 0 to 63 do setrgbpalette(i+128+64,i,i,i);}
 { makepal(0,32,16,63);}
  makepal(0,63,32,16);
  makepal(64,32,63,16);
  makepal(128,16,16,63);
  makepal(128+64,63,16,16);
  getpal;
  statusbar('Circletest',rgb(255,255,255));
  setviewport(0,0,mxx,mxy-20,true);
  setcolor(rgb(255,255,255));
  repeat
    x := random(mxx);
    y := random(mxy);
    coltab := random(4)*64;
    for i := 0 to 63 do begin
      setfillcolor(i+coltab);
      fillcircle(x+(63-i) div 2,y+(63-i) div 2,(63-i)*2);
    end;
{    writexy(10,10,'Ever seen such fast circle output?');}
  until keypressed;
  setviewport(0,0,mxx,mxy,true);
  if keyexit then exitproggy;
  fadecircle(fade_right,0);
  delay(500);
  setpal;
end;

procedure putpixeltest;
var
  sterne : array[0..500] of record
             x,y,ebene:integer;
           end;
  stnr,x,y :word;
begin
  cleardevice;
  for i := 16 to 31 do setrgbpalette(i,(i-16) shl 4,(i-16) shl 4,(i-16) shl 4);
  statusbar('Putpixeltest',31);
  setviewport(0,0,mxx,mxy-20,true);
  repeat
    waitretrace;
    for stnr := 0 to 500 do begin
      with sterne[stnr] do begin
        putpixel(x,y,0);
        putpixel(x+1,y,0);
        dec(x,ebene shr 5 + 1);
        if x <= 0 then begin
          x := mxx;
          y:= random(mxy+1);
          ebene := random(256);
        end;
        putpixel(x,y,ebene shr 4 + 16);
        putpixel(x+1,y,ebene shr 4 + 16);
      end;
    end;
  until keypressed;
  if keyexit then exitproggy;
  setviewport(0,0,mxx,mxy,true);
end;

procedure vesademo;external;
{$L VESADEMO}
procedure pngloadtest;
var
  lx,ly        : word;
  r,dx,dy,d2y  : word;
  first,first2 : boolean;
begin
  cleardevice;
  loadpngmem(0,0,@stars,0,255);
  openimage(stony,320,200);
  getimage(0,0,319,199,stony);
  for x := 1 to maxx div 320 do
  putimage(x*320,0,stony);
  for y := 1 to maxy div 200 do
  for x := 0 to maxx div 320 do
  putimage(x*320,y*200,stony);
  closeimage(stony);

  loadpng(10,100,'VESADEMO.PNG');
  getpal;
  statusbar('LoadPNGTest',rgb(255,255,255));
  setcolor(rgb(255,255,255));
  writexy(10,50,'The color of this text has been set via rgb');
  writexy(10,85,'Visit my homepage:');
  writexy(10,250,'http://www.crossfire-designs.de');
  writexy(10,265,'-Sourcecode');
  writexy(10,280,'-MODs');
  writexy(10,295,'-tons of good links');
  writexy(10,310,'-the absolute best jokes (only german part)');
  if keyexit then exitproggy;

  if currentmode.numofpages > 0 then begin
  statusbar('< Putspritetest (with using setvisualpage)',rgb(255,255,255));
  copypage(0,1);{copy first page on the second}
  statusbar('> Putspritetest (with using setvisualpage)',rgb(255,255,255));
  setactivepage(0);

  x := 0;
  y := 0;
  first := true;
  first2:= true;

  openimage(p,87,83);
  openimage(p2,87,83);

  dx := 8;
  dy := 1;
  d2y:= 1;
  x  := 20+dx shr 1;
  y  := 12+dy shr 1;

  repeat
    setvisualpage(0);
    setactivepage(1);
    if not first then putimage(lx,ly,p);
    lx := x;
    ly := y;
    first := false;
    x := x + dx;
    if (x > mxx - 87)or(x <= 0) then begin
       dec(x,dx);
       dx:= -dx;
    end;
    y := y + dy;
    if (y > mxy - 83)or(y <= 0) then begin
      dec(y,dy);
      dy:= -dy;
    end;
    inc(dy,d2y);

    getimage(x,y,x+87,y+83,p);
    putsprite(x,y+1,@vesademo,0);

    setvisualpage(1);
    setactivepage(0);
    if not first2 then putimage(lx,ly,p2);
    lx := x;
    ly := y;
    first2 := false;
    inc(x,dx);
    if (x > mxx - 87)or(x <= 0) then begin
      dec(x,dx);
      dx:= -dx;
    end;
    inc(y,dy);
    if (y > mxy - 83) or (y <= 0) then begin
      dec(y,dy);
      dy:= -dy;
    end;
    inc(dy,d2y);

    getimage(x,y,x+87,y+83,p2);
    putsprite(x,y,@vesademo,0);
  until keypressed;

  setactivepage(0);
  setvisualpage(0);
  putimage(x,y,p2);
  closeimage(p);
  closeimage(p2);
  if keyexit then exitproggy;
  end;
end;

procedure readlntest;
begin
  statusbar('Readgraphlinetest (just type something) ',rgb(255,255,255));
  s := '';
  readgraphline(20,110,rgb(255,255,255),20,1,s);
  setfont(3,0);
  writexy(20,130,s);
  statusbar('Readgraphlinetest with predefined text',rgb(255,255,255));
  s := 'This is a testtext';
  readgraphline(20,160,rgb(255,255,255),20,length(s)+1,s);
  writexy(20,180,s);
  if keyexit then exitproggy;
end;


procedure scroller;
const
  textlines = 23;
  scrolltext : array[0..textlines-1] of string=(
  'That''s all folks!',
  'I hope, you enjoyed this demo',
  'Thank you for making use of my programs',
  'More sourcecode from me available @ my homepage:',
  'http://www.crossfire-designs.de',
  '',
  'If you have some improvements, additions,',
  'bug reports or something else, please email me',
  '',
  '$ 1997-1998 by Stefan Gîhler, Germany',
  'stefan.goehler@gmx.de',
  '',
  'Greets fly to:',
  'Sophie BÅchner',
  'Johannes Bialek',
  'Hristo Chilingirov',
  'Christian Klukas',
  'Carsten KrÅger',
  'Yvonne Schedel',
  'Arsene von Wyss',
  'And all persons which helped me in any way',
  '',
  'CYA');
var
  p           : pointer;

  procedure drawplasma;
  begin
    createplasma(p);
    scale(p,0,0,maxx,maxy);
  end;
  function drawtext(ypos : integer) : integer;
  begin
    for i := 0 to textlines-1 do
    begin
      if ypos > -30 then
      writexy(maxx shr 1,ypos,scrolltext[i]);
      if scrolltext[i] = '' then inc(ypos,40) else inc(ypos,30);
      if ypos > mxy then break;
    end;
    drawtext := ypos;
  end;
  procedure fadedown;
  begin
    for i := 0 to 255 do begin
      if pal^[i].r > 4 then dec(pal^[i].r,2) else pal^[i].r := 0;
      if pal^[i].g > 4 then dec(pal^[i].g,2) else pal^[i].g := 0;
      if pal^[i].b > 4 then dec(pal^[i].b,2) else pal^[i].b := 0;
    end;
    setpal;
  end;
var
  ypos,endpos : integer;
  currpage    : byte;

begin
  setactivepage(1);
  cleardevice;
  setactivepage(0);
  cleardevice;
  setvisualpage(0);
  setfont(1,0);
  settextjustify(centertext,toptext);
  initplasma;
  for i := 0 to 31 do setrgbpalette(i+32,i shl 3,i shl 3,i shl 3);
  getpal;
  openimage(p,159,119);

  ypos := mxy;
  currpage := 1;
  while keypressed do readkey;
  repeat
    setactivepage(currpage);
    drawplasma;
    dec(ypos);
    endpos := drawtext(ypos);
    setvisualpage(currpage);
    if endpos < 98 then fadedown;
    if currpage = 1 then currpage := 0 else currpage := 1;
  until (ypos <= -32767)or(endpos <= -30)or(keypressed);
  closeimage(p);
end;



var
  ch : char;
begin
  loadfont('fonts\descent.chs',3);
  if graphresult <> 0 then begin
    writeln('Error: fonts\descent.chs font not found');
    halt;
  end;
  loadfont('fonts\hyena.chs',1);
  if graphresult <> 0 then begin
    writeln('Error: fonts\hyena.chs font not found');
    halt;
  end;
  clrscr;
  writeln('Vesademo 1.13 (c) 1997-1998 by Stefan Goehler, Germany');
  writeln('Uses '+grafx_version);
  writeln('****************************');
  endtime := currenttime;
  repeat until endtime <> currenttime;
  endtime := currenttime+18;
  i1 := 0;
  repeat
    inc(i1);
    waitretrace;
  until (currenttime >= endtime);
  if i1 < 65 then begin
    writeln('IT SEEMS YOUR COMPUTER IS DOING SOMETHING ELSE AT THIS MOMENT -');
    writeln('SOME PARTS OF THE DEMO WON''T RUN AS WELL AS THEY SHOULD DO :(');
    writeln('Left CPU-time: around ',i1*100 div 70,'%');
{    writeln('Press anykey...');
    readkey;}
  end;

  if card.upspeedable then begin
    writeln;
    writeln('GRAFX has detected the "'+getdrivername+'" chip on your card.');
    writeln('You have the choice between following:');
    writeln;
    writeln(' [0]  Use ONLY VESA functions (use if there are any problems)');
    writeln(' [1]  Use hardware-bankswitching and scrolling');
    writeln(' [2]  Use ALL accelerated functions of this card!!! (default)');
    repeat
      ch := readkey;
    until (ch in [#27,#13,'0','1','2']);
    if ch = #27 then halt; {Stop program if ESC}
    case ch of
      '0' : setaccelerationmode(0);
      '1' : setaccelerationmode(1);
      '2',#13 : setaccelerationmode(2);
    end;
  end;

  setmode(800,600,8);
  i := graphresult;
  if i <> 0 then begin
    textmode(3);
    writeln('Sorry, an error occured');
    writeln('Grafx says: '+grapherrormsg(i));
    writeln('Press the anykey');
    readkey;
    halt;
  end;

  menuscreen;
  faderollo(fade_norm,black);
  scaletest;
  fadeshades;
  fillcircletest;
  putpixeltest;
  pngloadtest;
  readlntest;
  fadeout;
  scroller;
  closegraph;
  while keypressed do readkey;
  closefont(1);
  closefont(3);
end.
