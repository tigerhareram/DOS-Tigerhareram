uses gr_vars,grafx,crt,fadelib;
const
  xsid = 0.002;
  ysid = 0.002;
  xadd = -0.196005;
  yadd = 0.669916;
  maxcount = 255;


var
  x,y       : word;
  pw,pix    : word;
  numscr,wm : byte;
  count     : byte;
  xsc,ysc,left,top,zx,zy,xc,yc,tempx,bot,right : single;

procedure loadpal;
var
  a,b : word;
begin
  for a:=1 to 85 do begin
    b := a*255 div 85;

    pal^[a].r     := b;
    pal^[85+a].g  := b;
    pal^[170+a].b := b;

    pal^[170+a].r := 0;
    pal^[a].g     := 0;
    pal^[85+a].b  := 0;

    pal^[171-a].r := b;
    pal^[256-a].g := b;
    pal^[86-a].b  := b;
  end;
  pal^[0].r:=0;
  pal^[0].g:=0;
  pal^[0].b:=0;
  setpal;
end;

procedure rotate;
var
  col : coltype;
begin
  repeat
    palrot(1,255);
    waitretrace;
    waitretrace;
    waitretrace;
    setpal;
  until keypressed;
end;

{procedure calculate;
begin
  for y := 0 to mxy do begin
    for x := 0 to mxx do
    begin
      xc := x*xsc+xadd;
      yc := y*ysc+yadd;
      zx := 0;
      zy := 0;
      count := 0;
      while(zx*zx+zy*zy < 4)and(count < maxcount) do begin
        tempx := zx*zx-zy*zy+xc;
        zy    := 2*zx*zy+yc;
        zx    := tempx;
        inc(count);
      end;
      if count = maxcount then count := 0;
      putpixel(x,y,count);
    end;
    if keypressed then break;
  end;
end;}

(*procedure calculate;
const
  abbruchwert : word = 4;
begin
  yc := -ysc+yadd;
  for y := 0 to mxy do begin
    yc := yc+ysc;
    xc := -xsc+xadd;
      asm
        mov  x,0
        @lp:
        finit                           { Alles neu }
        fld xc
        fld xsc
        fadd                            {xc := xc+xsc}
        fstp xc
        fld [xc]                        { Lade xc }
        fld [yc]                        { Lade yc }
        fldz                            { x^2 = 0 }
        fldz                            { y^2 = 0 }
        fldz                            { a = 0 }
        fldz                            { b = 0 }

        mov cx,[maxcount]               { cx = Max. Anzahl der Iterationen }
        mov bx,[abbruchwert]            { bx = Abbruchwert }
        mov dx,0                        { ax = Funktioneswert = 0 }
@repeat:
        fld st(1)                       { Kopiere x }
        fmul st(0),st(0)                { x^2 }
        fst st(4)                       { Speicher x^2 }

        fld st(1)                       { Kopiere y }
        fmul st(0),st(0)                { y^2 }
        fst st(4)                       { Speicher y^2 }
        fsub                            { x^2 - y^2 }

        fadd st(0),st(6)                { x(n+1) = x^2 - x^2 + r }
        fxch st(2)                      { Austausch x <> x(n+1) }

        fmul                            { x * y }
        fadd st(0),st(0)                { 2 * x * y }
        fadd st(0),st(4)                { y(n+1) = 2*x*y+i }

        inc dx	                        { Inc Tiefe }

        fld st(3)                       { Kopier x^2 }
        fadd st(0),st(3)                { und addier y^2 }

        ficomp [abbruchwert]            { Vergleiche }
        fstsw ax
        sahf                            { mov flags,ax }
        ja @end                         { Ja, fertig }

        dec cx
        jnz @repeat                    { cx = cx -1 > 0 ? }
@end:
        push x
        push y
        push dx
        call putpixel
        mov  bx,x
        inc  bx
        mov  x,bx
        cmp  bx,mxx
        jne  @lp
    end;
    if keypressed then break;
  end;
end;*)

FUNCTION mandelbrot(r,i :  extended):WORD;

{
Verwendung der Register:
	ax = Funktionswert: Anzahl der Iterationen
	bx = Abbruchwert
	cx = Max. Anzahl der Iterationen
}
LABEL
	fertig;
CONST
	abbruchwert : WORD = 4;					{ Wegen FICOMP }
	MaxTiefe : WORD = maxcount;
{$ifopt G-}
VAR
	status : WORD;
{$endif}
BEGIN
	asm

		finit                           { Alles  neu }
		fld tbyte ptr [r]               { Lade r }
		fld tbyte ptr [i]               { Lade i }
		fldz                            { x^2 = 0 }
		fldz                            { x^2 = 0 }
		fldz                            { x^2 = 0 }
		fldz                            { x^2 = 0 }

		mov cx,[MaxTiefe]               { cx = Max. Anzahl der Iterationen }
		mov bx,[abbruchwert]            { bx = Abbruchwert }
		mov dx,0                        { ax = Funktioneswert = 0 }

@repeat:

		fld st(1)			{ Kopiere x }
		fmul st(0),st(0)		{ x^2 }
		fst st(4)			{ Speicher x^2 }

		fld st(1)			{ Kopiere y }
		fmul st(0),st(0)	        { y^2 }
		fst st(4)			{ Speicher y^2 }
		fsub				{ x^2 - y^2 }

		fadd st(0),st(6)                { x(n+1) = x^2 - x^2 + r }
		fxch st(2)			{ Austausch x <> x(n+1) }

		fmul 		                { x * y }
		fadd st(0),st(0)		{ 2 * x * y }
		fadd st(0),st(4)		{ y(n+1) = 2*x*y+i }

		inc dx				{ Inc Tiefe }

		fld st(3)			{ Kopier x^2 }
		fadd st(0),st(3)		{ und addier y^2 }

		ficomp [abbruchwert]		{ Vergleiche }
		fstsw ax
		sahf				{ mov flags,ax }
		ja fertig			{ Ja, fertig }

		loop @repeat			{ cx = cx -1 > 0 ? }

fertig:

		mov @result,dx                  { Ergebnis nicht vergessen }
	END;
END;

procedure calculate(dx,dy : extended);
var
  x,y,Tiefe2,Tiefe1 : WORD;

  function zyklodentest(xc,yc:extended) : integer;
  var
    r,s,x,y,x2,y2 : extended;
  begin
    y2 := yc*yc;
    x2 := xc+1.0;
    if (xc>-0.75) then begin
      r:= xc*xc+y2;
      s:= SQRT(r-0.5*xc+0.0625);
      if ((16.0*r*s)>(5.0*s-4.0*xc+1.0)) then
      Zyklodentest:=mandelbrot(xc,yc) else Zyklodentest:=4;
    end else
    if ((x2*x2+y2)>0.0625) then Zyklodentest:=mandelbrot(xc,yc) else
    Zyklodentest:=4;
  end;

begin
  yc := yadd;
  y  := 0;
  repeat
    xc := xadd;
    x  := 0;
    Tiefe1 := Zyklodentest(xc,yc);
    putpixel(x,y,Tiefe1);
    repeat
      xc := xc+dx+dx;
      Inc(x,2);
      Tiefe2:=Zyklodentest(xc,yc);
      putpixel(x,y,Tiefe2);
      if (Tiefe1 <> Tiefe2) then Tiefe1 := Zyklodentest(xc-dx,yc);
      putpixel(x-1,y,Tiefe1);
      Tiefe1 := Tiefe2;
    until (x >= MxX);
    xc := xadd;
    for x:=0 to MxX do begin
      Tiefe1 := getpixel(x,y);
      Tiefe2 := getpixel(x,y+2);
      if (Tiefe1 = Tiefe2) then putpixel(x,y+1,Tiefe1) else
      putpixel(x,y+1,Zyklodentest(xc,yc+dy));
      xc:=xc+dx;
    end;
    yc:={yc-dy-dy}yc+dy+dy;
    inc(y,2);
  until (y >= MxY) or KeyPressed;								{ !!! }
end;


begin
  setmode(640,480,8);
  if graphresult <> 0 then exit;
  loadpal;
  xsc := xsid/mxx;
  ysc := ysid/mxy;
  while keypressed do readkey;
  calculate(xsc,ysc);
  rotate;
  while keypressed do readkey;
  closegraph;
end.