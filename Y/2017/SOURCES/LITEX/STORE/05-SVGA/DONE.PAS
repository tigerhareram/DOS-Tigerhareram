procedure SVGA_Done; assembler;
{konec grafiky a navrat do puvodniho rezimu obrazovky}
Asm
xor AH,AH
mov AL,_puvodnirezim {obvykle 3 (textak 80x25x16)}
int $10
End;{svga_done}
