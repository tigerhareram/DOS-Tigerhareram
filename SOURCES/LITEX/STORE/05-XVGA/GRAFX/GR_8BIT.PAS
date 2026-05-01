{$A+,B+,F-,G+,I-,O+,P+,Q-,R-,S-,T-,V-,X+,Y-,N+}
unit gr_8bit;
interface
uses gr_vars;

  procedure patternline_8(x1,y1,sizex: integer;col : longint);far;
  procedure hline_8(x1,y1,sizex: integer;col : longint);far;
  procedure vline_8(x1,y1,sizey: integer;col : longint);far;
  procedure line_norm_8(x1,y1,x2,y2 : integer);far;
  procedure line_styl_8(x1,y1,x2,y2 : integer);far;
  procedure putpixel_8(x,y : integer;col : longint);far;
  function  getpixel_8(x,y : integer) : longint;far;
  function  calcbank_8(x,y : integer) : word;far;
  function  rgb_8(r,g,b : byte) : longint;far;
  procedure dergb_8(l : longint;var r,g,b : byte);far;
  procedure bar_vesa_8(x1,y1,x2,y2: integer);far;
  procedure convdata_8(var input,output;size : word);far;

implementation

const
  tolerance : word = 20;

procedure patternline_8(x1,y1,sizex: integer;col : longint);
{draw a horizontal line}
var
  i2,i3   : word;
label
	endofproc;
begin
  asm
    mov   cx,sizex
    mov   ax,x1
    or    cx,cx
    jz    endofproc
    jns   @next
      neg   cx
      sub   ax,cx
    @next:
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
    jg    endofproc
    cmp   bx,cx
    jl    endofproc
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
    push  ax
    push  di
    call  calcbank
    mov   i2,ax
  end;
  if (fillstylenum < 2) then begin
    if i2 < i2+word(sizex) then
    fillbyte(ptr(currentmode.writeptr,i2)^,sizex,col)
    else begin
      i3 := 0-i2;
      fillbyte(ptr(currentmode.writeptr,i2)^,i3,col);
      incbank;
      fillbyte(ptr(currentmode.writeptr,0)^,sizex-i3,col);
    end;
  end else
  begin
    if i2 < i2+word(sizex) then
    fillpattern(ptr(currentmode.writeptr,i2)^,sizex,col,bkcolor,x1 and 7,fillstyle[y1 and 7+1])
    else begin
      i3 := 0-i2;
      fillpattern(ptr(currentmode.writeptr,i2)^,i3,col,bkcolor,x1 and 7,fillstyle[y1 and 7+1]);
      incbank;
      fillpattern(ptr(currentmode.writeptr,0)^,sizex-i3,col,bkcolor,x1 and 7+i3 and 7,fillstyle[y1 and 7+1]);
    end;
  end;
  endofproc:
end;

procedure hline_8(x1,y1,sizex: integer;col : longint);assembler;
{draw a horizontal line}
asm
  mov   cx,sizex
  mov   di,x1
  or    cx,cx
  jz    @endofproc
  jns   @next
    neg   cx
    sub   di,cx
  @next:
  mov   bx,di
  add   bx,cx
  mov   dx,actviewport.y1
  mov   ax,y1
  add   ax,dx
  js    @endofproc
  cmp   ax,fillviewport.y2
  jg    @endofproc
  mov   cx,fillviewport.x1
  mov   dx,fillviewport.x2
  cmp   di,dx
  jg    @endofproc
  cmp   bx,cx
  jl    @endofproc
  cmp   di,cx
  jnl   @next1
     mov   di,cx
  @next1:
  inc   dx
  cmp   bx,dx
  jng   @next2
     mov   bx,dx
  @next2:
  sub   bx,di
  mov   sizex,bx
  add   ax,pageadd
  mov   cx,currentmode.scanline
  mul   cx
  add   ax,di
  adc   dx,0
  cmp   dx,lastbank
  je    @noswitch
    push   ax
    push   dx
    call   setbank2
    pop    ax
  @noswitch:
  mov   cx,ax
  add   ax,sizex
  jc    @overflow
    push   currentmode.writeptr
    push   cx
    push   sizex
    push   word ptr col
    call   fillbyte
  jmp  @endofproc
  @overflow:
    xor   ax,ax
    sub   ax,cx
    push   ax
    push   currentmode.writeptr
    push   cx
    push   ax
    push   word ptr col
    call   fillbyte
    call   incbank
    pop    ax
    mov    cx,sizex
    sub    cx,ax
    push   currentmode.writeptr
    push   0
    push   cx
    push   word ptr col
    call   fillbyte
  @endofproc:
end;


procedure vline_8(x1,y1,sizey: integer;col : longint);assembler;
asm
  mov   cx,sizey
  mov   ax,y1
  or    cx,cx
  jz    @end
  jns   @next
     neg   cx
     sub   ax,cx
  @next:
  add   ax,actviewport.y1
  mov   bx,ax
  add   bx,cx
  mov   di,x1
  add   di,actviewport.x1
  cmp   di,fillviewport.x1
  jl    @end
  cmp   di,fillviewport.x2
  jg    @end
  mov   cx,fillviewport.y1
  mov   dx,fillviewport.y2
  cmp   ax,dx
  jg    @end
  cmp   bx,cx
  jl    @end
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
  mov   sizey,bx
  sub   ax,actviewport.y1
  sub   di,actviewport.x1
  add   ax,pageadd
  push  di
  push  ax
  call  calcbank
  mov   es,[currentmode.writeptr]
  mov   di,ax
  mov   al,byte ptr col
  mov   cx,sizey
  mov   bx,currentmode.scanline
  @lp:
     mov   es:[di],al
     add   di,bx
     jc    @nextbank
     @again:
     dec    cx
  jnz   @lp
  jmp   @end
  @nextbank:
    call  incbank
    jmp   @again
  @end:
end;

procedure line_norm_8(x1,y1,x2,y2 : integer);assembler;
var
  w : word;
asm
{Complete description in C'T 2/97
 Listing in VESA8.ASM with full comments and little bit
 other form... I had to adjust something for my own unit..
 it's a little bit faster than it's original (Pentii-optimized) :>}
  mov   ax,pageadd
  add   y1,ax
  add   y2,ax
  mov   ax,fillviewport.x1
  add   x1,ax
  add   x2,ax
  mov   ax,fillviewport.y1
  add   y1,ax
  add   y2,ax

  push  BP
  mov   SI,X2         { XE }
  sub   SI,X1         { XE - X }
  JNS   @PutLine_2
  mov   AX,X2
{  XCHG   AX,X1}{_very_ slow on a Pentii}
  mov   BX,AX
  mov   AX,X1
  mov   X1,BX
  mov   X2,AX
  mov   AX,Y2
{  XCHG   AX,Y1}
  mov   BX,AX
  mov   AX,Y1
  mov   Y1,BX
  mov   Y2,AX
  NEG   SI		{ DLTX:= -DLTX }
@PutLine_2:
           pushA
    db 66h;xor   AX,AX
    db 66h;xor   DX,DX
           mov   AX,currentmode.scanline
           mov   DX,Y1
    db 66h;MUL   DX
           mov   DX,X1
    db 66h;add   AX,DX
           mov   W,AX
    db 66h;shr   AX,16
           cmp   ax,lastbank
           je    @next
           push  AX
           CALL  setbank2
           @next:
           POPA
           mov   DI,W
           mov   ES,currentmode.writeptr

		CMP   writemode,0
		JNE   @PutLine_X

		mov   AL,byte ptr currentcolor	{ AL := Farbe }

		mov   ES:[DI],AL
		mov   BX,Y2
		sub   BX,Y1
		JNS   @PutLine_8
		NEG   BX		{ DLTY := -DLTY }
                CMP   SI,BX
		JG    @PutLine_20
		mov   CX,BX		{ Loopcount = DLTY }
                OR    CX,CX
		JZ    @PutLine_0	{ Loopcount = 0 ? }
                mov   BP,BX
		NEG   BP		{ SUM = - DLTY }
		add   SI,SI		{ 2 * DLTX }
		add   BX,BX		{ 2 * DLTY }
@PutLine_12:    sub   DI,currentmode.scanline         { Y := Y - 1 }
		JC    @PutLine_13	{ Achte auf Bankswitch }
@PutLine_14:    add   BP,SI		{ SUM := SUM + 2 DLTX }
		JS    @PutLine_16	{ Skip, wenn SUM < 0 }
		sub   BP,BX		{ SUM = SUM - 2 DLTY }
		INC   DI		{ X := X + 1 }
		JZ    @PutLine_15	{ Achte auf Bankswitch }
@PutLine_16:    mov   ES:[DI],AL	{ Setze Pixel }
		DEC   CX
		jnz   @PutLine_12	{ Loop mit DLTY }
		JMP   @PutLine_0
@PutLine_13:	CALL  DecBank
		JMP   @PutLine_14
@PutLine_15:	CALL  IncBank
		JMP   @PutLine_16
@PutLine_20:	mov   CX,SI		{ Loopcount = DLTX }
		JCXZ  @PutLine_0	{ Loopcount = 0 ? }
		mov   BP,SI
		NEG   BP		{ SUM = - DLTX }
		add   SI,SI		{ 2 * DLTX }
		add   BX,BX		{ 2 * DLTY }
@PutLine_22:    INC   DI			{ X := X + 1 }
		JZ    @PutLine_23	        { Achte auf Bankswitch }
@PutLine_24:    add   BP,BX			{ SUM := SUM + 2 DLTY }
		JS    @PutLine_26	        { Skip, wenn SUM < 0 }
		sub   BP,SI			{ SUM := SUM - 2DLTX }
		sub   DI,currentmode.scanline         	{ Y := Y - 1 }
		JC    @PutLine_25	        { Achte auf Bankswitch }
@PutLine_26:    mov   ES:[DI],AL		{ Setze Pixel }
		DEC   CX
		jnz   @PutLine_22	        { Loop mit DLTX }
@PutLine_0:     POP   BP
                JMP   @END
@PutLine_23:	CALL  IncBank
		JMP   @PutLine_24
@PutLine_25:	CALL  DecBank
		JMP   @PutLine_26
@PutLine_8:	CMP   SI,BX
		JG    @PutLine_40
		mov   CX,BX		{ Loopcount = DLTY }
		JCXZ  @PutLine_0	{ Loopcount = 0 ? }
		mov   BP,BX
		NEG   BP		{ SUM = - DLTY }
		add   SI,SI		{ 2 * DLTX }
		add   BX,BX		{ 2 * DLTY }
@PutLine_32:    add   DI,currentmode.scanline         { Y := Y + 1 }
		JC    @PutLine_33	        { Achte auf Bankswitch }
@PutLine_34:    add   BP,SI			{ SUM := SUM + 2 DLTX }
		JS    @PutLine_36	        { Skip, wenn SUM < 0 }
		sub   BP,BX			{ SUM := SUM - 2 DLTY }
		INC   DI			{ X := X + 1 }
		JZ    @PutLine_35	        { Achte auf Bankswitch }
@PutLine_36:    mov   ES:[DI],AL		{ Setze Pixel }
		DEC   CX
		jnz   @PutLine_32	        { Loop mit DLTY }
		JMP   @PutLine_0
@PutLine_33:	CALL  IncBank
		JMP   @PutLine_34
@PutLine_35:	CALL  IncBank
		JMP   @PutLine_36
@PutLine_40:	mov   CX,SI		{ Loopcount = DLTX }
		JCXZ  @PutLine_0	{ Loopcount = 0 ? }
		mov   BP,SI
		NEG   BP		{ SUM = - DLTX }
		add   SI,SI		{ 2 * DLTX }
		add   BX,BX		{ 2 * DLTY }
@PutLine_42:    INC   DI			{ X := X + 1 }
		JZ    @PutLine_43	        { Achte auf Bankswitch }
@PutLine_44:    add   BP,BX			{ SUM := SUM + 2 DLTY }
		JS    @PutLine_46	        { Skip, wenn SUM < 0 }
		sub   BP,SI			{ SUM := SUM - 2 DLTX }
		add   DI,currentmode.scanline                 { Y := Y + 1 }
		JC    @PutLine_45	        { Achte auf Bankswitch }
@PutLine_46:    mov   ES:[DI],AL		{ Setze Pixel }
		DEC   CX
		jnz   @PutLine_42	        { Loop mit DLTX }
		JMP   @PutLine_0
@PutLine_43:	CALL  IncBank
		JMP   @PutLine_44
@PutLine_45:	CALL  IncBank
		JMP   @PutLine_46
@PutLine_X:     mov   AL,byte ptr currentcolor	{ AL := Farbe }
                xor   ES:[DI],AL
                mov   BX,Y2
		sub   BX,Y1
		JNS   @PutLinX_8
		NEG   BX		{ DLTY := -DLTY }
                CMP   SI,BX
		JG    @PutLinX_20
		mov   CX,BX		{ Loopcount = DLTY }
		JCXZ  @PutLinX_0	{ Loopcount = 0 ? }
                mov   BP,BX
		NEG   BP		{ SUM = - DLTY }
		add   SI,SI		{ 2 * DLTX }
		add   BX,BX		{ 2 * DLTY }
@PutLinX_12:    sub   DI,currentmode.scanline         { Y := Y - 1 }
		JC    @PutLinX_13	        { Achte auf Bankswitch }
@PutLinX_14:    add   BP,SI			{ SUM := SUM + 2 DLTX }
		JS    @PutLinX_16	        { Skip, wenn SUM < 0 }
		sub   BP,BX			{ SUM = SUM - 2 DLTY }
		INC   DI			{ X := X + 1 }
		JZ    @PutLinX_15	        { Achte auf Bankswitch }
@PutLinX_16:    xor   ES:[DI],AL		{ Setze Pixel }
		DEC   CX
		jnz   @PutLinX_12	        { Loop mit DLTY }
		JMP   @PutLinX_0
@PutLinX_13:	CALL  DecBank
		JMP   @PutLinX_14
@PutLinX_15:	CALL  IncBank
		JMP   @PutLinX_16
@PutLinX_20:	mov   CX,SI		{ Loopcount = DLTX }
		JCXZ  @PutLinX_0	{ Loopcount = 0 ? }
                mov   BP,SI
		NEG   BP		{ SUM = - DLTX }
		add   SI,SI		{ 2 * DLTX }
		add   BX,BX		{ 2 * DLTY }
@PutLinX_22:    INC   DI			{ X := X + 1 }
		JZ    @PutLinX_23	        { Achte auf Bankswitch }
@PutLinX_24:    add   BP,BX			{ SUM := SUM + 2 DLTY }
		JS    @PutLinX_26	        { Skip, wenn SUM < 0 }
		sub   BP,SI			{ SUM := SUM - 2DLTX }
		sub   DI,currentmode.scanline                 { Y := Y - 1 }
		JC    @PutLinX_25	        { Achte auf Bankswitch }
@PutLinX_26:    xor   ES:[DI],AL		{ Setze Pixel }
		DEC   CX
		jnz   @PutLinX_22	        { Loop mit DLTX }
@PutLinX_0:     JMP   @PutLine_0
@PutLinX_23:	CALL  IncBank
		JMP   @PutLinX_24
@PutLinX_25:	CALL  DecBank
		JMP   @PutLinX_26
@PutLinX_8:	CMP   SI,BX
		JG    @PutLinX_40
		mov   CX,BX		{ Loopcount = DLTY }
		JCXZ  @PutLinX_0	{ Loopcount = 0 ? }
                mov   BP,BX
		NEG   BP		{ SUM = - DLTY }
		add   SI,SI		{ 2 * DLTX }
		add   BX,BX		{ 2 * DLTY }
@PutLinX_32:    add   DI,currentmode.scanline         { Y := Y + 1 }
		JC    @PutLinX_33	{ Achte auf Bankswitch }
@PutLinX_34:    add   BP,SI			{ SUM := SUM + 2 DLTX }
		JS    @PutLinX_36	        { Skip, wenn SUM < 0 }
		sub   BP,BX			{ SUM := SUM - 2 DLTY }
		INC   DI			{ X := X + 1 }
		JZ    @PutLinX_35	        { Achte auf Bankswitch }
@PutLinX_36:    xor   ES:[DI],AL		{ Setze Pixel}
		DEC   CX
		jnz   @PutLinX_32	        { Loop mit DLTY}
		JMP   @PutLinX_0
@PutLinX_33:	CALL  IncBank
		JMP   @PutLinX_34
@PutLinX_35:	CALL  IncBank
		JMP   @PutLinX_36
@PutLinX_40:	mov   CX,SI		{ Loopcount = DLTX}
		JCXZ  @PutLinX_0	{ Loopcount = 0 ?}
                mov   BP,SI
		NEG   BP		{ SUM = - DLTX}
		add   SI,SI		{ 2 * DLTX }
		add   BX,BX		{ 2 * DLTY }
@PutLinX_42:    INC   DI			{ X := X + 1}
		JZ    @PutLinX_43	        { Achte auf Bankswitch}
@PutLinX_44:    add   BP,BX			{ SUM := SUM + 2 DLTY}
		JS    @PutLinX_46	        { Skip, wenn SUM < 0}
		sub   BP,SI			{ SUM := SUM - 2 DLTX}
		add   DI,currentmode.scanline                 { Y := Y + 1}
		JC    @PutLinX_45	        { Achte auf Bankswitch}
@PutLinX_46:    xor   ES:[DI],AL		{ Setze Pixel}
		DEC   CX
		jnz   @PutLinX_42	        { Loop mit DLTX}
		JMP   @PutLinX_0
@PutLinX_43:	CALL  IncBank
		JMP   @PutLinX_44
@PutLinX_45:	CALL  IncBank
		JMP   @PutLinX_46
@end:
end;

var
  mempos : longint;

procedure pixel;assembler;
asm
  db 66h;mov   ax,word ptr mempos
         mov   si,ax
  db 66h;shr   ax,16
         cmp   ax,lastbank
         je    @next
         push  ax
         call  setbank2

  @next: mov   es,[currentmode.writeptr]
         mov   al,byte ptr currentcolor
         cmp   writemode,0
         jne   @doxor
         mov   es:[si],al
         jmp   @end
  @doxor:xor   es:[si],al
  @end:
end;
procedure line_styl_8(x1,y1,x2,y2 : integer);
{Since I was too lazy, this proc is fairly optimized yet...
 only partially converted to asm (and not very well ;)       }
var
  d,dx,dy,aincr,bincr,xincr,x,y,yincr : integer;
begin
  stylecounter := 0;
  asm
    mov   ax,fillviewport.x1
    add   x1,ax
    add   x2,ax
    mov   ax,fillviewport.y1
    add   y1,ax
    add   y2,ax
  end;
  if (abs(x2-x1) < abs(y2-y1)) then
  begin
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
    calcbank(x,y);
    mempos := longint(y+pageadd)*currentmode.scanline+x;
    asm
      mov  ax,stylecounter
      add  ax,ax
      jnz  @nooverflow
        mov  ax,1
      @nooverflow:
      mov  stylecounter,ax
      test linestyle,ax
      jz   @nopixel
        call pixel
      @nopixel:
    end;
    for y := y1+1 to y2 do
    begin
      if (d >= 0) then
      begin
        inc(mempos,xincr);
        inc(d,aincr);
      end else
      inc(d,bincr);
    asm
      mov  ax,stylecounter
      add  ax,ax
      jnz  @nooverflow
        mov  ax,1
      @nooverflow:
      mov  stylecounter,ax
      test linestyle,ax
      jz   @nopixel
        call pixel
      @nopixel:
db 66h;xor  ax,ax
       mov  ax,currentmode.scanline
db 66h;add  word ptr mempos,ax
    end;
    end;
  end
  else
  begin
    if (x1 > x2) then
    begin
      swapw(x1,x2);
      swapw(y1,y2);
    end;
    if (y2 > y1) then yincr := currentmode.scanline
                 else yincr := -currentmode.scanline;

    dx := x2 - x1;
    dy := abs(y2-y1);
    d  := dy shl 1 - dx;
    aincr := (dy - dx) shl 1;
    bincr := dy shl 1;
    x := x1;
    y := y1;
    calcbank(x,y);
    mempos := longint(y+pageadd)*currentmode.scanline+x;
    asm
      mov  ax,stylecounter
      add  ax,ax
      jnz  @nooverflow
        mov  ax,1
      @nooverflow:
      mov  stylecounter,ax
      test linestyle,ax
      jz   @nopixel
        call pixel
      @nopixel:
    end;
      asm
               mov  cx,x2
               sub  cx,x1

       @xlp:   cmp  d,0
               jae @noyinc
        db 66h;xor  ax,ax
               mov  ax,yincr
        db 66h;add  word ptr mempos,ax
               mov  ax,aincr
               add  d,ax
               jmp  @yinced
      @noyinc: mov  ax,bincr
               add  d,ax
      @yinced:

        mov  ax,stylecounter
        add  ax,ax
        jnz  @nooverflow
          mov  ax,1
        @nooverflow:
        mov  stylecounter,ax
        test linestyle,ax
        jz   @nopixel
          call pixel
        @nopixel:
        db 66h;inc word ptr mempos
        loop @xlp
    end;
  end;
end;

procedure putpixel_8(x,y : integer;col : longint);assembler;
asm
         mov   bx,x
         add   bx,actviewport.x1
         cmp   bx,fillviewport.x1
         jl    @end
         cmp   bx,fillviewport.x2
         jg    @end
         mov   cx,currentmode.scanline
         cmp   bx,cx
         jnl   @end
         mov   ax,y
         add   ax,actviewport.y1
         cmp   ax,fillviewport.y1
         jl    @end
         cmp   ax,fillviewport.y2
         jg    @end
         add   ax,pageadd
         mul   cx
         add   ax,bx
         adc   dx,0
         mov   si,ax
         cmp   dx,lastbank
         je    @next
         push  dx
         call  setbank2
 @next:  mov   es,[currentmode.writeptr]
         mov   al,byte ptr col
         cmp   writemode,0
         jne   @doxor
         mov   es:[si],al
         jmp   @end
 @doxor: xor   es:[si],al
 @end:
end;


function getpixel_8(x,y : integer) : longint;assembler;
asm
         mov   bx,x
         add   bx,actviewport.x1
         cmp   bx,fillviewport.x1
         jl    @end
         cmp   bx,fillviewport.x2
         jg    @end
         mov   cx,currentmode.scanline
         cmp   bx,cx
         jnb   @end
         mov   ax,y
         add   ax,actviewport.y1
         cmp   ax,fillviewport.y1
         jl    @end
         cmp   ax,fillviewport.y2
         jg    @end
         add   ax,pageadd
         mul   cx
         add   ax,bx
         adc   dx,0
         mov   si,ax
         cmp   dx,lastbank
         je    @next
         push  dx
         call  setbank2
  @next: mov   es,[currentmode.readptr]
         mov   al,es:[si]
         @end:
         xor   ah,ah
         xor   dx,dx
end;

function calcbank_8(x,y : integer) : word;assembler;
{calculates position x,y in GFXmem, sets bank and
 returns the memory-position}
asm
  mov   bx,x
  add   bx,actviewport.x1
  mov   ax,actviewport.y1
  mov   cx,currentmode.scanline
  add   ax,y
  mul   cx
  add   ax,bx
  adc   dx,0
  mov   si,ax
  cmp   dx,lastbank
  je    @end
  push  dx
  call  setbank2
@end:
  mov   ax,si
end;

(*function rgb_8(r,g,b : byte) : longint;assembler;
{search for nearest color in virtal palette}
asm
  xor   dx,dx
  mov   al,r
  add   al,g
  add   al,b
  jz    @stop
  mov   al,r
  mov   ah,g
  mov   dl,255
  mov   si,1024
  les   di,pal
  add   di,770
  xor   ch,ch
  @lp:
    sub   di,3
    xor   bh,bh
    mov   bl,b
    sub   bl,es:[di]
    mov   cl,ah
    sub   cl,es:[di-1]
    add   bx,cx
    mov   cl,al
    sub   cl,es:[di-2]
    add   bx,cx
    cmp   bx,si
    jnb   @end
      mov   si,bx
      mov   dh,dl
      cmp   si,tolerance
      jb    @stop
    @end:
  dec   dl
  jnz   @lp
  @stop:
  mov   al,dh
  xor   dx,dx
  xor   ah,ah
end;*)

{function rgb_8(r,g,b : byte) : longint;assembler;
asm
  mov   bl,r
  shr   bl,3
  xor   bh,bh
  mov   al,g
  mov   cl,b
  shl   ax,2
  and   ax,1111100000b
  shl   cx,7
  and   cx,111110000000000b
  or    bx,ax
  or    bx,cx
  mov   al,byte ptr colpal[bx]
  xor   dx,dx
  xor   ah,ah
end;}

function rgb_8(r,g,b : byte) : longint;assembler;
var
  cr,cg,cb : integer;
asm
  cmp   rgbinited,true
  je    @fastrgb
  xor   ah,ah
  mov   al,r
  mov   cr,ax
  mov   al,g
  mov   cg,ax
  mov   al,b
  mov   cb,ax
  les   si,pal
  db    66h;mov cx,0FFFFh;dw 0FFFFh
  mov   ah,255
  sub   cr,256
  sub   cg,256
  sub   cb,256
@lp:
  mov   bx,es:[si]
  mov   dh,es:[si+2]
  mov   dl,bh
  xor   bh,bh
  sub   bx,cr
  shl   bx,2
  db    66h;mov di,word ptr square[bx]
  xor   bh,bh
  mov   bl,dl
  sub   bx,cg
  shl   bx,2
  db    66h;add di,word ptr square[bx]
  xor   bh,bh
  mov   bl,dh
  sub   bx,cb
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
  jmp   @end
@fastrgb:
  mov   bl,r
  shr   bl,4
  xor   bh,bh
  mov   al,g
  mov   cl,b
  and   ax,11110000b
  shl   cx,4
  and   cx,111100000000b
  or    bx,ax
  or    bx,cx
  mov   al,byte ptr colpal[bx]
@end:
  xor   dx,dx
  xor   ah,ah
end;


procedure dergb_8(l : longint;var r,g,b : byte);assembler;
asm
  xor   bh,bh
  mov   bl,byte ptr l
  mov   ax,bx
  add   bx,bx
  add   bx,ax
  les   di,pal
  add   di,bx
  mov   ax,es:[di]
  mov   cl,es:[di+2]
  les   di,r
  mov   byte ptr es:[di],al
  les   di,g
  mov   byte ptr es:[di],ah
  les   di,b
  mov   byte ptr es:[di],cl
{  r := pal^[l and 255].r shl 2;
  g := pal^[l and 255].g shl 2;
  b := pal^[l and 255].b shl 2;}
end;

procedure bar_vesa_8(x1,y1,x2,y2: integer);
var
  sizex,sizey,i,i2,i3,oli2 : word;
  switched                 : boolean;
begin
  if y1 > y2 then swapw(y1,y2);
  if x1 > x2 then swapw(x1,x2);
  inc(x1,actviewport.x1);
  inc(y1,actviewport.y1);
  inc(x2,actviewport.x1);
  inc(y2,actviewport.y1);


  if (y1 > fillviewport.y2) or (y2 < fillviewport.y1) then exit;
  if (x1 > fillviewport.x2) or (x2 < fillviewport.x1) then exit;
  if x1 < fillviewport.x1 then x1 := fillviewport.x1;
  if x2 > fillviewport.x2 then x2 := fillviewport.x2;
  if y1 < fillviewport.y1 then y1 := fillviewport.y1;
  if y2 > fillviewport.y2 then y2 := fillviewport.y2;

  sizex := succ(abs(x2-x1));
  sizey := abs(y2-y1);
  inc(y1,pageadd);
  i2 := calcbank(x1-actviewport.x1,y1-actviewport.y1);
  oli2 := i2;
  switched := false;
  if fillstylenum < 2 then
  for i := y1 to y1+sizey do begin
    if i2 < i2+sizex then begin
      if (oli2 > i2)and(not switched) then incbank;
      fillbyte(ptr(currentmode.writeptr,i2)^,sizex,fillcolor);
      switched := false;
    end
    else begin
      i3 := 0-i2;
      fillbyte(ptr(currentmode.writeptr,i2)^,i3,fillcolor);
      incbank;
      switched := true;
      fillbyte(ptr(currentmode.writeptr,0)^,sizex-i3,Fillcolor);
    end;
    oli2 := i2;
    inc(i2,currentmode.scanline);
  end else
  for i := y1 to y1+sizey do begin
    if i2 < i2+sizex then begin
      if (oli2 > i2)and(not switched) then incbank;
      fillpattern(ptr(currentmode.writeptr,i2)^,sizex,fillcolor,bkcolor,x1 and 7,fillstyle[i and 7+1]);
      switched := false;
    end
    else begin
      i3 := 0-i2;
      fillpattern(ptr(currentmode.writeptr,i2)^,i3,fillcolor,bkcolor,x1 and 7,fillstyle[i and 7+1]);
      incbank;
      switched := true;
      fillpattern(ptr(currentmode.writeptr,0)^,sizex-i3,fillcolor,bkcolor,x1 and 7+i3 and 7,fillstyle[i and 7+1]);
    end;
    oli2 := i2;
    inc(i2,currentmode.scanline);
  end;
end;

(*function nearcol(r,g,b : byte) : byte;assembler;
asm
  mov   bl,r
  shr   bl,3
  xor   bh,bh
  mov   al,g
  mov   cl,b
  shl   ax,2
  and   ax,1111100000b
  shl   cx,7
  and   cx,111110000000000b
  or    bx,ax
  or    bx,cx
  mov   al,byte ptr colpal[bx]
end;*)

(*procedure convdata_8(var input,output;size : word);
var
  i : word;
begin
  if dataalign = 0 {bgr} then begin
    for i := 0 to size-1 do mem[seg(output):ofs(output)+i] :=
    nearcol(mem[seg(input):ofs(input)+i*3],
          mem[seg(input):ofs(input)+i*3+1],
          mem[seg(input):ofs(input)+i*3+2]);
  end else begin
    for i := 0 to size-1 do mem[seg(output):ofs(output)+i] :=
    nearcol(mem[seg(input):ofs(input)+i*3+2],
          mem[seg(input):ofs(input)+i*3+1],
          mem[seg(input):ofs(input)+i*3]);
  end;
end;*)

procedure convdata_8(var input,output;size : word);assembler;
asm
  mov   cx,size
  or    cx,cx
  jz    @end
  db 0Fh,0B4h,76h,offset input {lfs si,input}
  les   di,output
  mov   al,dataalign
  or    al,al
  jnz   @lp_rgb
  @lp_bgr:
    db    64h,8Ah,14h       { mov   dl,fs:[si] }
    db    64h,8Ah,44h,01h   { mov   al,fs:[si+1] }
    db    64h,8Ah,5Ch,02h   { mov   bl,fs:[si+2] }
    shr   bl,4
    xor   bh,bh
    and   ax,11110000b
    shl   dx,4
    and   dx,111100000000b
    or    bx,ax
    or    bx,dx
    mov   al,colpal[bx].byte
    mov   es:[di],al
    add   si,3
    inc   di
    dec   cx
  jnz   @lp_bgr
  jmp   @end
  @lp_rgb:
    db    64h,8Ah,1Ch       { mov   bl,fs:[si] }
    shr   bl,3
    xor   bh,bh
    db    64h,8Ah,44h,01h   { mov   al,fs:[si+1] }
    db    64h,8Ah,54h,02h   { mov   dl,fs:[si+2] }
    shl   ax,2
    and   ax,1111100000b
    shl   dx,7
    and   dx,111110000000000b
    or    bx,ax
    or    bx,dx
    mov   al,colpal[bx].byte
    mov   es:[di],al
    add   si,3
    inc   di
    dec   cx
  jnz   @lp_rgb
@end:
end;


begin
end.