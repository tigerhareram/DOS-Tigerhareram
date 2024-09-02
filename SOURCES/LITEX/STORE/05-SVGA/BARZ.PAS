procedure SVGA_BarZ(x1,y1,x2,y2:word; barva:word); assembler;
{vyplneny obdelnik, parametry stejne jako u Rectangle}
var sirka,incr:word;
Asm
mov AX,__lhy
 mov BX,_zapisovacisegment
add y1,AX
 mov ES,BX        {ES = cilovy segment}
add y2,AX         {pro virtualni obrazovku}
 mov BX,barva
inc y2         {aby se to pak lip pocitalo}
 mov BH,BL
mov AX,_maxx
 mov barva,BX     {barva ma ted hodnotu v obou bytech}
sub AX,x2
 mov BX,x2 {*}
add AX,x1
 sub BX,x1
mov incr,AX      {incr = kolik se musi pridat k ofsetu na konci radku, abychom se dostali na zacatek dalsiho}
 inc BX
mov AX,_Maxx
 mov sirka,BX         {sirka spocitana}
inc AX
mul y1
add AX,x1
adc DX,0        {DX = banka}
mov DI,AX       {DI = ofset zacatku radku}

 @zacatek:         {zacatek cyklu}

 mov BX,DI
 mov CX,DX
 add BX,sirka
 adc CX,0
 dec BX
 sbb CX,0           {CX = banka bodu na konci radku}

 cmp DX,_curbank
 je @neprepinej
  push DX
  call _SwitchBank
 @neprepinej:         {pocatecni banka nastavena}

 cmp CX,_curbank       {je banka na konci radku stejna jako na zacatku?}
 je @najednou         {je -> vykresli se cely radek najednou}

  or CX,$FFFF
  sub CX,DI
  inc CX            {CX = sirka prvni casti}
  mov AX,sirka
  sub AX,CX
  push AX     {zasobnik = sirka druhe casti}

  mov AX,barva
  db $66; shl AX,16
  mov AX,barva           {EAX = barva}

   mov BX,CX
   shr CX,2
   db $66; rep stosw
   and BX,3
   mov CX,BX
   rep stosb

  mov AX,_curbank
  inc AX
  push AX
  call _switchbank      {druha banka nastavena}

  pop CX
  jmp @jedeme

 @najednou:
 mov CX,sirka
 @jedeme:
                       {CX = sirka zbytku radku}
 mov AX,barva
 db $66; shl AX,16
 mov AX,barva           {EAX = barva}

  mov BX,CX
  shr CX,2
  db $66; rep stosw
  and BX,3
  mov CX,BX
  rep stosb

 mov DX,_curbank
 add DI,incr       {DI = ofset zacatku dalsiho radku}
 adc DX,0          {DX = banka -''-}
 inc y1
 mov AX,y1
 cmp AX,y2
 jne @zacatek
End;{svga_barz}
