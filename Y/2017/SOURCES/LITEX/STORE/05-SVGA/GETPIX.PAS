function _GetPixel(x,y:word):byte; assembler;
{vrati barvu pixelu na danych souradnicich}
Asm
mov AX,__lhy
mov DX,_ctecisegment
add y,AX
mov ES,DX
mov AX,_MaxX
inc AX
mul y
add AX,x
adc DX,0
mov CX,_cteciokno
mov DI,AX
cmp CX,_zapisovaciokno
jne @prepni {pokud nejsou obe okna stejna, nemusi promenna Curbank platit => prepneme vzdy}
cmp DX,_CurBank
je @neprepinej
 mov _curbank,DX
 @prepni:
 mov AX,DX
 mul _Granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_cteciokno
 call __switchbank
@neprepinej:
mov AL,[ES:DI]
End;{_getpixel}
