{$A+,B+,D-,E-,F-,G+,I-,L-,N-,O-,P+,Q-,R-,S-,T-,V-,X+,Y-}
{****************************************************************************
 * Author           : Stefan Goehler, Germany                               *
 * Version          : unofficial 1.2                                        *
 *******                                                                    *
 * my mail-adress   : stefan.goehler@gmx.de                                 *
 * my homepage      : http://crossfire.home.pages.de                        *
 ****** HISTORY *************************************************************
 * Version 1.1  +added procedure fadecircle                                 *
 * Version 1.2  +added Hicolor-abilities                                    *
 *              *changed up all for 8-bit setrgbpalette                     *
 *              +added procedure palrot                                     *
 ****************************************************************************}

unit fadelib;
interface
uses grafx,gr_vars;

const
  fade_norm  = 0;
  fade_down  = 1;
  fade_right = 2;

  procedure  fade2white;
  procedure  fadeout;
  procedure  fadeshades;
  procedure  faderollo(direction : byte;col : longint);
  procedure  fadein;{only 8 bpp}
  procedure  fadecircle(direction : byte;col : longint);
  procedure  palrot(startcol,endcol : byte);{only 8 bpp}

implementation
var
  i,i2 : integer;

procedure fade2white;
var
  y : integer;
begin
  if currentmode.bpp = 8 then begin
    getpal;
    for i2 := 63 downto 0 do begin
      waitretrace;
      for i := 0 to 255 do begin
        if pal^[i].r < 251 then inc(pal^[i].r,4) else pal^[i].r := 255;
        if pal^[i].g < 251 then inc(pal^[i].g,4) else pal^[i].g := 255;
        if pal^[i].b < 251 then inc(pal^[i].b,4) else pal^[i].b := 255;
      end;
      setpal;
    end;
  end else if currentmode.bpp = 15 then begin
    for i := 0 to 31 do
    for y := 0 to mxy do begin
      getline(0,y,maxx,gfxbuf);
      asm
        mov   cx,maxx
        les   di,gfxbuf
        @lp:
          mov   ax,es:[di]
          mov   dx,ax

          mov   bx,dx
          and   bx,11111b {B}
          add   bx,1
          cmp   bx,31
          jna   @next1
            mov   bx,31
          @next1:
          mov   ax,bx

          mov   bx,dx
          and   bx,1111100000b {G}
          add   bx,32
          cmp   bx,1111100000b
          jna   @next2
            mov   bx,1111100000b
          @next2:
          or    ax,bx

          mov   bx,dx
          and   bx,111110000000000b {R}
          add   bx,1024
          cmp   bx,111110000000000b
          jna   @next3
            mov   bx,111110000000000b
          @next3:
          or    ax,bx

          mov   es:[di],ax
          add   di,2
        dec   cx
        jnz   @lp
      end;
      putline(0,y,maxx,gfxbuf);
    end;
  end else if currentmode.bpp = 16 then begin
    for i := 0 to 31 do
    for y := 0 to mxy do begin
      getline(0,y,maxx,gfxbuf);
      asm
        mov   cx,maxx
        les   di,gfxbuf
        @lp:
          mov   ax,es:[di]
          mov   dx,ax

          mov   bx,dx
          and   bx,11111b {B}
          add   bx,1
          cmp   bx,31
          jna   @next1
            mov   bx,31
          @next1:
          mov   ax,bx

          mov   bx,dx
          and   bx,11111100000b {G}
          add   bx,64
          cmp   bx,11111100000b
          jna   @next2
            mov   bx,11111100000b
          @next2:
          or    ax,bx

          mov   bx,dx
          and   bx,1111100000000000b {R}
          add   bx,2048
          jnc   @next3
            mov   bx,1111100000000000b
          @next3:
          or    ax,bx

          mov   es:[di],ax
          add   di,2
        dec   cx
        jnz   @lp
      end;
      putline(0,y,maxx,gfxbuf);
    end;
  end;
end;

procedure fadeout;
var
  y : integer;
begin
  if currentmode.bpp <= 8 then begin;
    getpal;
    for i2 := 63 downto 0 do begin
      waitretrace;
      for i := 0 to 255 do begin
        if pal^[i].r > 4 then dec(pal^[i].r,4) else pal^[i].r := 0;
        if pal^[i].g > 4 then dec(pal^[i].g,4) else pal^[i].g := 0;
        if pal^[i].b > 4 then dec(pal^[i].b,4) else pal^[i].b := 0;
      end;
      setpal;
    end;
  end else if currentmode.bpp = 15 then begin
    for i := 0 to 31 do
    for y := 0 to mxy do begin
      getline(0,y,maxx,gfxbuf);
      asm
        mov   cx,maxx
        les   di,gfxbuf
        @lp:
          mov   ax,es:[di]
          mov   dx,ax

          mov   bx,dx
          and   bx,11111b {B}
          sub   bx,1
          jnc   @next1
            xor   bx,bx
          @next1:
          mov   ax,bx

          mov   bx,dx
          and   bx,1111100000b {G}
          sub   bx,32
          jnc   @next2
            xor   bx,bx
          @next2:
          or    ax,bx

          mov   bx,dx
          and   bx,111110000000000b {R}
          sub   bx,1024
          jnc   @next3
            xor   bx,bx
          @next3:
          or    ax,bx

          mov   es:[di],ax
          add   di,2
        dec   cx
        jnz   @lp
      end;
      putline(0,y,maxx,gfxbuf);
    end;
  end else if currentmode.bpp = 16 then begin
    for i := 0 to 31 do
    for y := 0 to mxy do begin
      getline(0,y,maxx,gfxbuf);
      asm
        mov   cx,maxx
        les   di,gfxbuf
        @lp:
          mov   ax,es:[di]
          mov   dx,ax

          mov   bx,dx
          and   bx,11111b {B}
          sub   bx,1
          jnc   @next1
            xor   bx,bx
          @next1:
          mov   ax,bx

          mov   bx,dx
          and   bx,11111100000b {G}
          sub   bx,64
          jnc   @next2
            xor   bx,bx
          @next2:
          or    ax,bx

          mov   bx,dx
          and   bx,1111100000000000b {R}
          sub   bx,2048
          jnc   @next3
            xor   bx,bx
          @next3:
          or    ax,bx

          mov   es:[di],ax
          add   di,2
        dec   cx
        jnz   @lp
      end;
      putline(0,y,maxx,gfxbuf);
    end;
  end;
end;

procedure fadeshades;
var
  col : byte;
begin
  if currentmode.bpp = 8 then begin
    fade2white;
    for i := 0 to mxx div 32 do
    for i2 := 0 to 31 do
    vline(i*32+i2,0,maxy,i2+1+i*2);
    for i := 1 to 64 do
    setrgbpalette(i,128+i shl 1-1,128+i shl 1-1,128+i shl 1-1);
    fadeout;
  end else begin
    for i := 0 to mxx div 32 do
    for i2 := 0 to 31 do begin
      col := i2+1+i*2;
      vline(i*32+i2,0,maxy,rgb(128+col shl 1-1,128+col shl 1-1,128+col shl 1-1));
    end;
    fadeout;
  end;
end;

procedure faderollo(direction : byte;col : longint);
begin
  case direction of
    fade_down,fade_norm:
    for i := 0 to 19 do begin
      waitretrace;
      for i2 := 0 to mxy div 10 do hline(0,i2*20+i,maxx,col);
    end;
    fade_right:
    for i := 0 to 19 do begin
      waitretrace;
      for i2 := 0 to mxx div 10 do vline(i2*20+i,0,maxy,col);
    end;
    fade_down+fade_right:
    for i := 0 to 19 do begin
      waitretrace;
      for i2 := 0 to mxx div 10 do begin
        vline(i2*20+i,0,maxy,col);

        if i2*10 < mxy then hline(0,i2*20+i,maxx,col);
      end;
    end;
  end;
end;

procedure fadein;
var
  pal2 : ^paltype;
  i2   : integer;
begin
  if currentmode.bpp > 8 then exit;
  {Fadein not possible with more than 8 bpp and 64 K adressing}
  new(pal2);
  pal2^ := pal^;
  for i := 0 to 255 do begin
    pal^[i].r := 0;
    pal^[i].g := 0;
    pal^[i].b := 0;
  end;
  for i2 := 0 to 63 do begin
    for i := 0 to 255 do begin
      if pal^[i].r < pal2^[i].r then inc(pal^[i].r,4);
      if pal^[i].g < pal2^[i].g then inc(pal^[i].g,4);
      if pal^[i].b < pal2^[i].b then inc(pal^[i].b,4);
    end;
    waitretrace;
    setpal;
  end;
  dispose(pal2);
end;

procedure fadecircle(direction : byte;col : longint);
var
  x,y : integer;
begin
  setfillstyle(solidfill,col);
  case direction of
    fade_norm:
    for i := 0 to 28 do begin
      waitretrace;
      for y := 0 to mxy div 40 do
      for x := 0 to mxx div 40 do fillcircle(x*40+20,y*40+20,i);
    end;
    fade_down:
    for i := -mxy div 40 to 28 do begin
      waitretrace;
      for y := 0 to mxy div 40 do
      for x := 0 to mxx div 40 do
      if mxy div 40-y+i < 29 then fillcircle(x*40+20,y*40+20,mxy div 40-y+i);
    end;
    fade_right:
    for i := -mxx div 40 to 28 do begin
      waitretrace;
      for y := 0 to mxy div 40 do
      for x := 0 to mxx div 40 do
      if mxx div 40-x+i < 29 then fillcircle(x*40+20,y*40+20,mxx div 40-x+i);
    end;
    fade_right+fade_down:
    for i := -mxx div 40 to 60 do begin
      waitretrace;
      for y := 0 to mxy div 40 do
      for x := 0 to mxx div 40 do
      if mxx div 40-x-y+i < 29 then fillcircle(x*40+20,y*40+20,mxx div 40-x-y+i);
    end;
  end;
end;

procedure palrot(startcol,endcol : byte);
var
  col : coltype;
begin
  if startcol < endcol then begin
    col := pal^[startcol];
    move2(pal^[startcol+1],pal^[startcol],(endcol-startcol)*3);
    pal^[endcol] := col;
  end else begin
    col := pal^[startcol];
    move2(pal^[endcol],pal^[endcol+1],(startcol-endcol)*3);
    pal^[endcol] := col;
  end;
end;

begin
end.





