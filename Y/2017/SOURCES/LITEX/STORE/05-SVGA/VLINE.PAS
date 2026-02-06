procedure SVGA_VLine(x,y1,y2:word; barva:byte); assembler;
{svisla cara z bodu x,y1 do bodu x,y2}
var incr:word;
Asm
mov BX,__lhy;           mov CX,_zapisovacisegment
add y1,BX;              mov ES,CX
add y2,BX
mov AX,_MaxX
inc AX
mov incr,AX   {incr = sirka obrazovky}
mul y1
add AX,x
adc DX,0      {DX = pocatecni banka}
mov DI,AX     {DI = pocatecni ofset}

cmp DX,_CurBank
je @neprepinej
 mov AX,DX
 mov _curbank,DX
 mul _granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank
@neprepinej:          {pocatecni banka nastavena}

mov AL,barva
mov [ES:DI],AL        {prvni pixel je nakreslen}

mov CX,y2
sub CX,y1             {CX = pocet cyklu}
jz @konec

 @cyklus:
 add DI,incr          {DI = ofset dalsiho pixelu}

 jnc @PoradVJedneBance
  inc _curbank
  mov AX,_curbank
  mul _granularity
  mov DX,AX
  mov AX,$4F05
  mov BX,_zapisovaciokno
  call __switchbank
  mov AL,barva        {do AL vratime barvu}
 @PoradVJedneBance:   {spravna banka je nastavena}

 mov [ES:DI],AL       {pixel je nakreslen}
 loop @cyklus

@konec:
End;{svga_vline}
