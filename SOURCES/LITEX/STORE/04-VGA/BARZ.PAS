procedure VGA_BarZ(x1,y1,x2,y2,Barva,BufferTo:word); assembler;
Asm
mov DI,bufferto
mov ES,DI
xor DI,DI;              mov AX,y1
add DI,x1;              mov BX,AX
shl AX,6;               shl BX,8;
add DI,AX;              mov CX,x2
add DI,BX;              sub CX,x1
mov DX,319;             mov AX,barva
sub DX,CX;              mov AH,AL          {DX = prirustek ofsetu mezi radky}
inc CX;                 push AX            {CX = delka radku}
mov BX,y2;              db $66; shl AX,16
sub BX,y1;              pop AX
inc BX;                 mov SI,CX
mov y1,BX;              and SI,3           {y1 = kolik radku se bude kreslit}
shr CX,2                                   {CX = dwordy, SI = byty}
mov BX,CX                                  {BX = dwordy}
 @cyklus:
  db $66; rep stosw
 mov CX,SI
  rep stosb
 add DI,DX;             mov CX,BX
 dec y1
 jnz @cyklus
End;{vgabar}
