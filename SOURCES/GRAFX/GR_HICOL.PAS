{$A+,B+,F-,G+,I-,O+,P+,Q-,R-,S-,T-,V-,X+,Y-,N+}
unit gr_hicol;
interface
uses gr_vars;

  procedure patternline_16(x1,y1,sizex: integer;col : longint);far;
  procedure hline_16(x1,y1,sizex: integer;col : longint);far;
  procedure vline_16(x1,y1,sizey: integer;col : longint);far;
  procedure line_norm_16(x1,y1,x2,y2 : integer);far;
  function  rgb_15(r,g,b : byte) : longint;far;
  function  rgb_16(r,g,b : byte) : longint;far;
  procedure dergb_15(l : longint;var r,g,b : byte);far;
  procedure dergb_16(l : longint;var r,g,b : byte);far;
  procedure putpixel_16(x,y : integer;col : longint);far;
  function  getpixel_16(x,y : integer) : longint;far;
  function  calcbank_16(x,y : integer) : word;far;
  procedure convdata_15(var input,output;size : word);far;
  procedure convdata_16(var input,output;size : word);far;
  procedure alpha_15(var input,output;size : word);far;
  procedure alpha_16(var input,output;size : word);far;
  procedure conv8bit_16(var input,output;size : word);far;
  procedure bar_vesa_16(x1,y1,x2,y2: integer);far;

implementation

procedure patternline_16(x1,y1,sizex: integer;col : longint);
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
    add   ax,actviewport.x1
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
    add   bx,bx
    mov   sizex,bx
    sub   ax,actviewport.x1
    mov   x1,ax
    sub   di,actviewport.y1
    add   di,pageadd
    push  ax
    push  di
    call  calcbank
    mov   i2,ax
  end;
  if (fillstylenum < 2) then
  begin
    if i2 < i2+word(sizex) then
    fillword(ptr(currentmode.writeptr,i2)^,sizex,col)
    else begin
      i3 := 0-i2;
      fillword(ptr(currentmode.writeptr,i2)^,i3,col);
      incbank;
      fillword(ptr(currentmode.writeptr,0)^,sizex-i3,col);
    end;
  end else begin
    if i2 < i2+word(sizex) then
    fillpattern_32(ptr(currentmode.writeptr,i2)^,sizex,col,bkcolor,x1 and 7,fillstyle[y1 and 7+1])
		else begin
      i3 := 0-i2;
      fillpattern_32(ptr(currentmode.writeptr,i2)^,i3,col,bkcolor,x1 and 7,fillstyle[y1 and 7+1]);
      incbank;
      fillpattern_32(ptr(currentmode.writeptr,0)^,sizex-i3,col,bkcolor,x1 and 7+i3 and 7,fillstyle[y1 and 7+1]);
    end;
  end;
  endofproc:
end;

procedure hline_16(x1,y1,sizex: integer;col : longint);assembler;
{draw a horizontal line}
asm
  mov   cx,sizex
  mov   ax,x1
  or    cx,cx
  jz    @endofproc
  jns   @next
    neg   cx
    sub   ax,cx
  @next:
  add   ax,actviewport.x1
  mov   bx,ax
  add   bx,cx
  mov   di,y1
  add   di,actviewport.y1
  cmp   di,fillviewport.y1
  jl    @endofproc
  cmp   di,fillviewport.y2
  jg    @endofproc
  mov   cx,fillviewport.x1
  mov   dx,fillviewport.x2
  cmp   ax,dx
  jg    @endofproc
  cmp   bx,cx
  jl    @endofproc
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
  add   bx,bx
  mov   sizex,bx
  sub   ax,actviewport.x1
  mov   x1,ax
  sub   di,actviewport.y1
  add   di,pageadd
  push  ax
  push  di
  call  calcbank
  mov   cx,ax
  add   ax,sizex
  jc    @overflow
    push   currentmode.writeptr
    push   cx
    push   sizex
    push   word ptr col
    call   fillword
  jmp  @endofproc
  @overflow:
    xor    ax,ax
    sub    ax,cx
    push   ax
    push   currentmode.writeptr
    push   cx
    push   ax
    push   word ptr col
    call   fillword
    call   incbank
    pop    ax
    mov    cx,sizex
    sub    cx,ax
    push   currentmode.writeptr
    push   0
    push   cx
    push   word ptr col
    call   fillword
  @endofproc:
end;

procedure vline_16(x1,y1,sizey: integer;col : longint);assembler;
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
  mov   di,currentmode.writeptr
  mov   es,di
  mov   di,ax
  mov   ax,word ptr col
  mov   cx,sizey
  mov   bx,currentmode.scanline
      @lp:
      mov   es:[di],ax
      add   di,bx
      jc    @nextbank
      @again:
      dec    cx
      jnz    @lp
    jmp    @end
       @nextbank:
       call  incbank
       jmp   @again
    @end:
end;

procedure line_norm_16(x1,y1,x2,y2 : integer);assembler;
var
  w : word;
asm
  mov   ax,pageadd
  add   y1,ax
  add   y2,ax
  mov   ax,fillviewport.x1
  add   x1,ax
  add   x2,ax
  mov   ax,fillviewport.y1
  add   y1,ax
  add   y2,ax
  PUSH  BP
  MOV   SI,X2         { XE }
  SUB   SI,X1         { XE - X }
  JNS   @PutLine_2
  MOV   AX,X2
{  XCHG  AX,X1}{_very_ slow on a Pentii}
  MOV   BX,AX
  MOV   AX,X1
  MOV   X1,BX
  MOV   X2,AX
  MOV   AX,Y2
{  XCHG  AX,Y1}
  MOV   BX,AX
  MOV   AX,Y1
  MOV   Y1,BX
  MOV   Y2,AX
  NEG   SI            { DLTX:= -DLTX }
@PutLine_2:
           PUSHA
    db 66h;XOR   AX,AX
    db 66h;XOR   DX,DX
           MOV   AX,currentmode.scanline
           MOV   DX,Y1
    db 66h;MUL   DX
           MOV   DX,X1
           ADD   DX,DX
    db 66h;ADD   AX,DX
           MOV   W,AX
    db 66h;SHR   AX,16
           cmp   ax,lastbank
           je    @next
           PUSH  AX
           CALL  setbank2
           @next:
           POPA
           MOV   DI,W
           MOV   ES,currentmode.writeptr

		CMP	writemode,0
		JNE	@PutLine_X

		MOV	Ax,word ptr currentcolor { AL := Farbe }

		MOV	ES:[DI],AX
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
		ADD	DI,2		{ X := X + 1 }
		JC	@PutLine_15	{ Achte auf Bankswitch }
@PutLine_16:    MOV	ES:[DI],AX	{ Setze Pixel }
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
@PutLine_22:    ADD	DI,2			{ X := X + 1 }
		JC	@PutLine_23	        { Achte auf Bankswitch }
@PutLine_24:    ADD	BP,BX			{ SUM := SUM + 2 DLTY }
		JS	@PutLine_26	        { Skip, wenn SUM < 0 }
		SUB	BP,SI			{ SUM := SUM - 2DLTX }
		SUB	DI,currentmode.scanline         	{ Y := Y - 1 }
		JC	@PutLine_25	        { Achte auf Bankswitch }
@PutLine_26:    MOV	ES:[DI],AX		{ Setze Pixel }
		DEC	CX
		JNZ	@PutLine_22	        { Loop mit DLTX }
@PutLine_0:     POP	BP
                JMP     @END
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
		ADD	DI,2			{ X := X + 1 }
		JC	@PutLine_35	        { Achte auf Bankswitch }
@PutLine_36:    MOV	ES:[DI],AX		{ Setze Pixel }
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
@PutLine_42:    ADD	DI,2			{ X := X + 1 }
		JC	@PutLine_43	        { Achte auf Bankswitch }
@PutLine_44:    ADD	BP,BX			{ SUM := SUM + 2 DLTY }
		JS	@PutLine_46	        { Skip, wenn SUM < 0 }
		SUB	BP,SI			{ SUM := SUM - 2 DLTX }
		ADD	DI,currentmode.scanline                 { Y := Y + 1 }
		JC	@PutLine_45	        { Achte auf Bankswitch }
@PutLine_46:    MOV	ES:[DI],AX		{ Setze Pixel }
		DEC	CX
		JNZ	@PutLine_42	        { Loop mit DLTX }
		JMP	@PutLine_0
@PutLine_43:	CALL	IncBank
		JMP	@PutLine_44
@PutLine_45:	CALL	IncBank
		JMP	@PutLine_46
@PutLine_X:     MOV     AX,word ptr currentcolor	{ AL := Farbe }
                XOR	ES:[DI],AX
                MOV     BX,Y2
		SUB	BX,Y1
		JNS	@PutLinX_8
		NEG	BX		{ DLTY := -DLTY }
                CMP     SI,BX
		JG	@PutLinX_20
		MOV	CX,BX		{ Loopcount = DLTY }
		JCXZ	@PutLinX_0	{ Loopcount = 0 ? }
                MOV     BP,BX
		NEG	BP		{ SUM = - DLTY }
		ADD	SI,SI		{ 2 * DLTX }
		ADD	BX,BX		{ 2 * DLTY }
@PutLinX_12:    SUB	DI,currentmode.scanline         { Y := Y - 1 }
		JC	@PutLinX_13	        { Achte auf Bankswitch }
@PutLinX_14:    ADD	BP,SI			{ SUM := SUM + 2 DLTX }
		JS	@PutLinX_16	        { Skip, wenn SUM < 0 }
		SUB	BP,BX			{ SUM = SUM - 2 DLTY }
		ADD	DI,2			{ X := X + 1 }
		JC	@PutLinX_15	        { Achte auf Bankswitch }
@PutLinX_16:    XOR	ES:[DI],AX		{ Setze Pixel }
		DEC	CX
		JNZ	@PutLinX_12	        { Loop mit DLTY }
		JMP	@PutLinX_0
@PutLinX_13:	CALL	DecBank
		JMP	@PutLinX_14
@PutLinX_15:	CALL	IncBank
		JMP	@PutLinX_16
@PutLinX_20:	MOV	CX,SI		{ Loopcount = DLTX }
		JCXZ	@PutLinX_0	{ Loopcount = 0 ? }
                MOV     BP,SI
		NEG	BP		{ SUM = - DLTX }
		ADD	SI,SI		{ 2 * DLTX }
		ADD	BX,BX		{ 2 * DLTY }
@PutLinX_22:    ADD	DI,2			{ X := X + 1 }
		JC	@PutLinX_23	        { Achte auf Bankswitch }
@PutLinX_24:    ADD	BP,BX			{ SUM := SUM + 2 DLTY }
		JS	@PutLinX_26	        { Skip, wenn SUM < 0 }
		SUB	BP,SI			{ SUM := SUM - 2DLTX }
		SUB	DI,currentmode.scanline                 { Y := Y - 1 }
		JC	@PutLinX_25	        { Achte auf Bankswitch }
@PutLinX_26:    XOR	ES:[DI],AX		{ Setze Pixel }
		DEC	CX
		JNZ	@PutLinX_22	        { Loop mit DLTX }
@PutLinX_0:     JMP	@PutLine_0
@PutLinX_23:	CALL	IncBank
		JMP	@PutLinX_24
@PutLinX_25:	CALL	DecBank
		JMP	@PutLinX_26
@PutLinX_8:	CMP	SI,BX
		JG	@PutLinX_40
		MOV	CX,BX		{ Loopcount = DLTY }
		JCXZ	@PutLinX_0	{ Loopcount = 0 ? }
                MOV     BP,BX
		NEG	BP		{ SUM = - DLTY }
		ADD	SI,SI		{ 2 * DLTX }
		ADD	BX,BX		{ 2 * DLTY }
@PutLinX_32:    ADD	DI,currentmode.scanline         { Y := Y + 1 }
		JC	@PutLinX_33	{ Achte auf Bankswitch }
@PutLinX_34:    ADD	BP,SI			{ SUM := SUM + 2 DLTX }
		JS	@PutLinX_36	        { Skip, wenn SUM < 0 }
		SUB	BP,BX			{ SUM := SUM - 2 DLTY }
		ADD	DI,2			{ X := X + 1 }
		JC	@PutLinX_35	        { Achte auf Bankswitch }
@PutLinX_36:    XOR	ES:[DI],AX		{ Setze Pixel}
		DEC	CX
		JNZ	@PutLinX_32	        { Loop mit DLTY}
		JMP	@PutLinX_0
@PutLinX_33:	CALL	IncBank
		JMP	@PutLinX_34
@PutLinX_35:	CALL	IncBank
		JMP	@PutLinX_36
@PutLinX_40:	MOV	CX,SI		{ Loopcount = DLTX}
		JCXZ	@PutLinX_0	{ Loopcount = 0 ?}
                MOV     BP,SI
		NEG	BP		{ SUM = - DLTX}
		ADD	SI,SI		{ 2 * DLTX }
		ADD	BX,BX		{ 2 * DLTY }
@PutLinX_42:    ADD	DI,2			{ X := X + 1}
		JC	@PutLinX_43	        { Achte auf Bankswitch}
@PutLinX_44:    ADD	BP,BX			{ SUM := SUM + 2 DLTY}
		JS	@PutLinX_46	        { Skip, wenn SUM < 0}
		SUB	BP,SI			{ SUM := SUM - 2 DLTX}
		ADD	DI,currentmode.scanline                 { Y := Y + 1}
		JC	@PutLinX_45	        { Achte auf Bankswitch}
@PutLinX_46:    XOR	ES:[DI],AX		{ Setze Pixel}
		DEC	CX
		JNZ	@PutLinX_42	        { Loop mit DLTX}
		JMP	@PutLinX_0
@PutLinX_43:	CALL	IncBank
		JMP	@PutLinX_44
@PutLinX_45:	CALL	IncBank
		JMP	@PutLinX_46
@end:
end;

function rgb_15(r,g,b : byte) : longint;assembler;
asm
  mov   al,b
  mov   ah,g
  mov   bl,r
  shr   ah,3
  and   bl,11111000b
  shr   ax,3
  shr   bl,1
  or    ah,bl
  xor   dx,dx
end;

function rgb_16(r,g,b : byte) : longint;assembler;
asm
  mov   al,b
  mov   ah,g
  shr   ah,2
  mov   bl,r
  shr   ax,3
  and   bl,11111000b
  or    ah,bl
  xor   dx,dx
end;

procedure dergb_15(l : longint;var r,g,b : byte);assembler;
asm
  mov   ax,word ptr l
  mov   bx,ax
  and   al,11111b
  shl   al,3
  les   di,b
  mov   es:[di],al
  mov   ax,bx
  and   ax,1111100000b
  shr   ax,2
  les   di,g
  mov   es:[di],al
  and   bh,1111100b
  add   bh,bh
  les   di,r
  mov   es:[di],bh
end;


procedure dergb_16(l : longint;var r,g,b : byte);assembler;
asm
  mov   ax,word ptr l
  mov   bx,ax
  and   ax,1111100000011111b
  shl   al,3
  les   di,b
  mov   es:[di],al
  les   di,r
  mov   es:[di],ah
  and   bx,11111100000b
  shr   bx,3
  les   di,g
  mov   es:[di],bl
end;

procedure putpixel_16(x,y : integer;col : longint);assembler;
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
         add   bx,bx
         add   ax,bx
         adc   dx,0
         mov   si,ax
         cmp   dx,lastbank
         je    @next
         push  dx
         call  setbank2
 @next:  mov   es,[currentmode.writeptr]
         mov   ax,word ptr col
         cmp   writemode,0
         jne   @doxor
         mov   es:[si],ax
         jmp   @end
 @doxor: xor   es:[si],ax
 @end:
end;


function getpixel_16(x,y : integer) : longint;assembler;
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
         add   bx,bx
         add   ax,bx
         adc   dx,0
         mov   si,ax
         cmp   dx,lastbank
         je    @next
         push  dx
         call  setbank2
  @next: mov   es,[currentmode.readptr]
         mov   ax,es:[si]
         @end:
         xor   dx,dx
end;

function calcbank_16(x,y : integer) : word;assembler;
{calculates position x,y in GFXmem, sets bank and
 returns the memory-position}
asm
  mov   bx,x
  add   bx,actviewport.x1
  add   bx,bx
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

procedure convdata_15(var input,output;size : word);assembler;
asm
  les   di,output
  mov   cx,size
  shr   cx,1
  jz    @end
  mov   al,dataalign
  push  ds
  lds   si,input
  or    al,al
  jz    @lp_rgb
  @lp_bgr:
    mov   bl,ds:[si]
    mov   ah,ds:[si+1]
    mov   al,ds:[si+2]
    shr   ah,3
    and   bl,11111000b
    shr   ax,3
    shr   bl,1
    or    ah,bl
    mov   es:[di],ax

    add   si,3
    add   di,2
    dec   cx
  jnz   @lp_bgr
  jmp   @stop
  @lp_rgb:
    mov   al,ds:[si]
    mov   ah,ds:[si+1]
    mov   bl,ds:[si+2]
    shr   ah,3
    and   bl,11111000b
    shr   ax,3
    shr   bl,1
    or    ah,bl
    mov   es:[di],ax

    add   si,3
    add   di,2
    dec   cx
  jnz   @lp_rgb

@stop:
  pop   ds
@end:
end;

procedure convdata_16(var input,output;size : word);assembler;
asm
  les   di,output
  mov   cx,size
  shr   cx,1
  jz    @end
  mov   al,dataalign
  push  ds
  lds   si,input
  or    al,al
  jz    @lp_rgb
  @lp_bgr:

    mov   bl,ds:[si]
    mov   ah,ds:[si+1]
    shr   ah,2
    mov   al,ds:[si+2]
    shr   ax,3
    and   bl,11111000b
    or    ah,bl
    mov   es:[di],ax
    add   si,3
    add   di,2
    dec   cx
  jnz   @lp_bgr
  jmp   @stop
  @lp_rgb:
    mov   al,ds:[si]
    mov   ah,ds:[si+1]
    shr   ah,2
    mov   bl,ds:[si+2]
    shr   ax,3
    and   bl,11111000b
    or    ah,bl
    mov   es:[di],ax
    add   si,3
    add   di,2
    dec   cx
  jnz   @lp_rgb

@stop:
  pop  ds
@end:
end;

procedure alpha_15(var input,output;size : word);assembler;
{ Alphamapping not implemented in this version of GrafX! }
asm
  les   di,output
  shr   size,1
  jz    @end
  push ds
  lds   si,input
  xor   ch,ch
  xor   ah,ah
  @lp2:
    mov   ch,ds:[si+3]
    mov   cl,255
    sub   cl,ch
    jz    @full
    or    ch,ch
    jz    @cont

    mov   al,es:[di]
    shl   al,3
    mul   cl
    mov   bl,ah
    mov   al,ds:[si]
    mul   ch
    add   bl,ah

    mov   ax,es:[di]
    shr   ax,2
    and   al,11111000b
    mul   cl
    mov   bh,ah
    mov   al,ds:[si+1]
    mul   ch
    add   bh,ah
    shr   bh,3
    shr   bx,3

    mov   al,es:[di+1]
    and   al,1111100b
    shl   al,1
    mul   cl
    mov   dl,ah
    mov   al,ds:[si+2]
    mul   ch
    add   dl,ah
    and   dl,11111000b
    shr   dl,1
    or    bh,dl
    mov   es:[di],bx
    @cont:

    add   si,4
    add   di,2
    dec   size
  jnz   @lp2
  pop   ds
  jmp   @end
  @full:
    mov   ax,ds:[si]
    mov   bl,ds:[si+2]
    shr   ah,3
    and   bl,11111000b
    shr   ax,3
    shr   bl,1
    or    ah,bl
    mov   es:[di],ax
  jmp   @cont
  @end:
end;

procedure alpha_16(var input,output;size : word);assembler;
{ Alphamapping not implemented in this version of GrafX! }
asm
  les   di,output
  shr   size,1
  jz    @end
  push  ds
  lds   si,input
  xor   ch,ch
  xor   ah,ah
  @lp2:
    mov   ch,ds:[si+3]
    mov   cl,255
    sub   cl,ch
    jz    @full
    or    ch,ch
    jz    @cont

    mov   al,es:[di]
    shl   al,3
    mul   cl
    mov   bl,ah
    mov   al,ds:[si]
    mul   ch
    add   bl,ah

    mov   ax,es:[di]
    shr   ax,3
    and   al,11111100b
    mul   cl
    mov   bh,ah
    mov   al,ds:[si+1]
    mul   ch
    add   bh,ah
    shr   bh,2
    shr   bx,3

    mov   al,es:[di+1]
    and   al,11111000b
    mul   cl
    mov   dl,ah
    mov   al,ds:[si+2]
    mul   ch
    add   dl,ah
    and   dl,11111000b
    or    bh,dl
    mov   es:[di],bx
    @cont:

    add   si,4
    add   di,2
    dec   size
  jnz   @lp2
  pop   ds
  jmp   @end
  @full:
    mov   ax,ds:[si]
    shr   ah,2
    mov   bl,ds:[si+2]
    shr   ax,3
    and   bl,11111000b
    or    ah,bl
    mov   es:[di],ax
  jmp   @cont
@end:
end;

procedure conv8bit_16(var input,output;size : word);assembler;
asm
  mov   cx,size
  shr   cx,1
  jz    @end
  les   si,output
  mov   ax,es
  db    8Eh,0E8h {mov gs,ax}
  push  ds
  lds   bx,col8bitpal
  mov   dx,bx
  les   si,input
  @lp2:
    mov   bl,es:[si]
    xor   bh,bh
    shl   bx,2
    add   bx,dx
    mov   ax,ds:[bx]
    db    65h,89h,05h {mov  gs:[di],ax}
    inc   si
    add   di,2
    dec   cx
  jnz   @lp2
  pop  ds
  @end:
end;

procedure bar_vesa_16(x1,y1,x2,y2: integer);
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
  inc(sizex,sizex);
  if fillstylenum < 2 then
  for i := y1 to y1+sizey do begin
    if i2 < i2+sizex then begin
      if (oli2 > i2)and(not switched) then incbank;
      fillword(ptr(currentmode.writeptr,i2)^,sizex,fillcolor);
      switched := false;
    end
    else begin
      i3 := 0-i2;
      fillword(ptr(currentmode.writeptr,i2)^,i3,fillcolor);
      incbank;
      switched := true;
      fillword(ptr(currentmode.writeptr,0)^,sizex-i3,fillcolor);
    end;
    oli2 := i2;
    inc(i2,currentmode.scanline);
  end else
  for i := y1 to y1+sizey do begin
    if i2 < i2+sizex then begin
      if (oli2 > i2)and(not switched) then incbank;
      fillpattern_32(ptr(currentmode.writeptr,i2)^,sizex,fillcolor,bkcolor,x1 and 7,fillstyle[i and 7+1]);
      switched := false;
    end
    else begin
      i3 := 0-i2;
      fillpattern_32(ptr(currentmode.writeptr,i2)^,i3,fillcolor,bkcolor,x1 and 7,fillstyle[i and 7+1]);
      incbank;
      switched := true;
      fillpattern_32(ptr(currentmode.writeptr,0)^,sizex-i3+1,fillcolor,bkcolor,x1 and 7,fillstyle[i and 7+1]);
    end;
    oli2 := i2;
    inc(i2,currentmode.scanline);
  end;
end;

begin
end.