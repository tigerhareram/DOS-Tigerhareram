procedure SVGA_Pixel(x,y:word; barva:byte); assembler;
{nakresli pixel}
Asm
mov AX,__lhy
mov DX,_zapisovacisegment
add y,AX       {pro virtualni obrazovku}
mov ES,DX      {ES = segment pro videopamet}
mov AX,_MaxX
inc AX         {AX = sirka obrazovky}
mul y          {vynasob AX ypsilonem; co pretece, dej do DX}
add AX,x       {k AX pricti x}
adc DX,0       {jestli AX preteklo, zvys hodnotu DX}
               {vysledek: v AX je ofset bodu, v DX cislo banky}
mov DI,AX      {ofset ulozime do registru k tomu urcenemu}
               {ted se postarame o bankovani:}
cmp DX,_CurBank   {neni nahodou potrebna banka uz nastavena?}
je @neprepinej    {je -> nebudeme se zdrzovat prepinanim}
 mov _curbank,DX                      {rozepsana procedura _switchbank}
 mov AX,DX
 mul _Granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank
@neprepinej:
mov AL,barva
mov [ES:DI],AL     {samotne vykresleni pixelu uz je vylozene prkotina :-)}
End;{svga_pixel}
