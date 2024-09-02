procedure _SetDisplayOrigin(x,y:word); assembler;
{Nastavi polohu leveho horniho rohu monitoru (pocatku zobrazeni) nad
videopameti (VRAM). Normalni hodnota je 0,0.}
Asm
mov AX,$4F07
xor BX,BX
mov CX,x
mov DX,y
int $10
End;{_setdisplayorigin}
