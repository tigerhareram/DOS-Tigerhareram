uses crt,grafx,gr_vars;

var incer : word;


procedure line4(x1,y1,x2,y2: integer);assembler;
var
w    : word;
asm
mov ax,pageadd
add y1,ax
add y2,ax
		PUSH	BP
                MOV     SI,X2         { XE }
                SUB     SI,X1         { XE - X }
		JNS	@PutLine_2
		MOV	AX,X2
{		XCHG	AX,X1}{_very_ slow on a Pentii}
                MOV     BX,AX
                MOV     AX,X1
                MOV     X1,BX
		MOV	X2,AX
		MOV	AX,Y2
{		XCHG	AX,Y1}
                MOV     BX,AX
                MOV     AX,Y1
                MOV     Y1,BX
		MOV	Y2,AX
		NEG	SI		{ DLTX:= -DLTX }
@PutLine_2:
           PUSHA
    db 66h;XOR AX,AX
    db 66h;XOR DX,DX
           MOV AX,currentmode.scanline
           MOV DX,Y1
    db 66h;MUL DX
           MOV DX,X1
    db 66h;ADD AX,DX
           MOV W,AX
    db 66h;SHR AX,16
           cmp ax,lastbank
           je @next
           PUSH AX
           CALL setbank2
           @next:
           POPA
           MOV DI,W
           MOV ES,currentmode.writeptr


		INC	byte ptr ES:[DI]
		MOV	BX,Y2
		SUB	BX,Y1
		JNS	@PutLine_8
		NEG	BX		{ DLTY := -DLTY }
                CMP     SI,BX
		JG	@PutLine_20
		MOV	CX,BX		{ Loopcount = DLTY }
                OR      CX,CX
		JZ	@PutLine_0	{ Loopcount = 0 ? }
                MOV     BP,BX
		NEG	BP		{ SUM = - DLTY }
		ADD	SI,SI		{ 2 * DLTX }
		ADD	BX,BX		{ 2 * DLTY }
@PutLine_12:    SUB	DI,currentmode.scanline         { Y := Y - 1 }
		JC	@PutLine_13	{ Achte auf Bankswitch }
@PutLine_14:    ADD	BP,SI		{ SUM := SUM + 2 DLTX }
		JS	@PutLine_16	{ Skip, wenn SUM < 0 }
		SUB	BP,BX		{ SUM = SUM - 2 DLTY }
		INC	DI		{ X := X + 1 }
		JZ	@PutLine_15	{ Achte auf Bankswitch }
@PutLine_16:    INC	byte ptr ES:[DI]	        { Setze Pixel }
		DEC	CX
		JNZ	@PutLine_12	{ Loop mit DLTY }
		JMP	@PutLine_0
@PutLine_13:	CALL	DecBank
		JMP	@PutLine_14
@PutLine_15:	CALL	IncBank
		JMP	@PutLine_16
@PutLine_20:	MOV	CX,SI		{ Loopcount = DLTX }
		JCXZ	@PutLine_0	{ Loopcount = 0 ? }
		MOV	BP,SI
		NEG	BP		{ SUM = - DLTX }
		ADD	SI,SI		{ 2 * DLTX }
		ADD	BX,BX		{ 2 * DLTY }
@PutLine_22:    INC	DI			{ X := X + 1 }
		JZ	@PutLine_23	        { Achte auf Bankswitch }
@PutLine_24:    ADD	BP,BX			{ SUM := SUM + 2 DLTY }
		JS	@PutLine_26	        { Skip, wenn SUM < 0 }
		SUB	BP,SI			{ SUM := SUM - 2DLTX }
		SUB	DI,currentmode.scanline         	{ Y := Y - 1 }
		JC	@PutLine_25	        { Achte auf Bankswitch }
@PutLine_26:    INC	byte ptr ES:[DI]		        { Setze Pixel }
		DEC	CX
		JNZ	@PutLine_22	        { Loop mit DLTX }
@PutLine_0:     JMP     @END
@PutLine_23:	CALL	IncBank
		JMP	@PutLine_24
@PutLine_25:	CALL	DecBank
		JMP	@PutLine_26
@PutLine_8:	CMP	SI,BX
		JG	@PutLine_40
		MOV	CX,BX		{ Loopcount = DLTY }
		JCXZ	@PutLine_0	{ Loopcount = 0 ? }
		MOV	BP,BX
		NEG	BP		{ SUM = - DLTY }
		ADD	SI,SI		{ 2 * DLTX }
		ADD	BX,BX		{ 2 * DLTY }
@PutLine_32:    ADD	DI,currentmode.scanline         { Y := Y + 1 }
		JC	@PutLine_33	        { Achte auf Bankswitch }
@PutLine_34:    ADD	BP,SI			{ SUM := SUM + 2 DLTX }
		JS	@PutLine_36	        { Skip, wenn SUM < 0 }
		SUB	BP,BX			{ SUM := SUM - 2 DLTY }
		INC	DI			{ X := X + 1 }
		JZ	@PutLine_35	        { Achte auf Bankswitch }
@PutLine_36:    INC	byte ptr ES:[DI]                 { Setze Pixel }
		DEC	CX
		JNZ	@PutLine_32	        { Loop mit DLTY }
		JMP	@PutLine_0
@PutLine_33:	CALL	IncBank
		JMP	@PutLine_34
@PutLine_35:	CALL	IncBank
		JMP	@PutLine_36
@PutLine_40:	MOV	CX,SI		{ Loopcount = DLTX }
		JCXZ	@PutLine_0	{ Loopcount = 0 ? }
		MOV	BP,SI
		NEG	BP		{ SUM = - DLTX }
		ADD	SI,SI		{ 2 * DLTX }
		ADD	BX,BX		{ 2 * DLTY }
@PutLine_42:    INC	DI			{ X := X + 1 }
		JZ	@PutLine_43	        { Achte auf Bankswitch }
@PutLine_44:    ADD	BP,BX			{ SUM := SUM + 2 DLTY }
		JS	@PutLine_46	        { Skip, wenn SUM < 0 }
		SUB	BP,SI			{ SUM := SUM - 2 DLTX }
		ADD	DI,currentmode.scanline                 { Y := Y + 1 }
		JC	@PutLine_45	        { Achte auf Bankswitch }
@PutLine_46:    INC	byte ptr ES:[DI]	        	{ Setze Pixel }
		DEC	CX
		JNZ	@PutLine_42	        { Loop mit DLTX }
		JMP	@PutLine_0
@PutLine_43:	CALL	IncBank
		JMP	@PutLine_44
@PutLine_45:	CALL	IncBank
		JMP	@PutLine_46
@end:
pop bp
end;

procedure LineBobs;
procedure Funky3Pal;
var
  loop,r,g,b,rx,gx,bx : integer;
  r_up,g_up,b_up      : boolean;
begin
  r := 0;
  g := 0;
  b := 0;
  rx := random(5) + 1;
  gx := random(5) + 1;
  bx := random(5) + 1;
  r_up := true;
  g_up := true;
  b_up := true;
  for loop := 0 to 255 do begin
    pal^[loop].r := r;
    pal^[loop].g := g;
    pal^[loop].b := b;
    if r_up then inc(r,rx) else dec(r,rx);
    if g_up then inc(g,gx) else dec(g,gx);
    if b_up then inc(b,bx) else dec(b,bx);
    if (r + rx > 63) or (r - rx < 0) then begin
      r_up := not r_up;
      rx := succ(random(5));
    end;
    if (g + gx > 63) or (g - gx < 0) then begin
      g_up := not g_up;
      gx := succ(random(5));
    end;
    if (b + bx > 63) or (b - bx < 0) then begin
      b_up := not b_up;
      bx := succ(random(5));
    end;
  end;
  shiftpal;
  setpal;
end;
  procedure JustDoIt;
  var
    loop : integer;
   procedure LineBob;
   var
     x1,y1,x2,y2,dx1,dx2,dy1,dy2 : integer;
    procedure Checkbounds (var a, b : integer; c : integer);
    begin
      if a > c then b := -1 else
      if a < 0 then b := 1;
    end;

    begin
      x1 := random(maxx);
      x2 := random(maxx);
      y1 := random(maxy);
      y2 := random(maxy);
      dx1 := +1;
      dx2 := -1;
      dy1 := +1;
      dy2 := -1;
      repeat
        inc(x1,dx1);
        inc(x2,dx2);
        inc(y1,dy1);
        inc(y2,dy2);
        CheckBounds(x1,dx1,mxx);
        CheckBounds(x2,dx2,mxx);
        CheckBounds(y1,dy1,mxy);
        CheckBounds(y2,dy2,mxy);
        if x1 < 0 then x1 := 0;
        if x2 < 0 then x2 := 0;
        if y1 < 0 then y1 := 0;
        if y2 < 0 then y2 := 0;
        if incer mod 5 = 0 then waitretrace;
        line4(x1, y1, x2, y2);
        inc(incer);
      until (incer = 6000)or(keypressed);
    end;
begin
  repeat
    incer := 0;
    funky3pal;
    randomize;
    lineBob;
    cleardevice;
  until keypressed;
  while keypressed do readkey;
end;
  begin
    JustDoIt;
  end;

begin
  setmode(1024,768,8);
  linebobs;
  closegraph;
end.