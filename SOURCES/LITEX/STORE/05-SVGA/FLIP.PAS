procedure SVGA_FlipPage; assembler;
{Prohodi aktivni a viditelnou stranku. Pri zapnutem strankovani je nutne ji
volat pokazde, kdyz chceme nechat zobrazit to, co jsme nakreslili.
Ma zabudovane cekani na navrat paprsku, takze obraz neblika.}
Asm
xor BX,BX
xor CX,CX     {pro hybani obrazovkou}
mov DX,$03DA
 @cekani1:               {cekani na navrat paprsku}
 in AL,DX
 test AL,8
 jz @cekani1
mov AX,__lhy
or AX,AX
jz @ActiveNa1
 {viditelnou na 1:}
 mov AX,$4F07
 mov DX,__lhy             {obrazovka dolu}
 int $10
 {aktivni na 0:}
 xor AX,AX
 mov __lhy,AX             {__lhy nahoru}
 jmp @prepnuto          {hotovo}
@ActiveNa1:
 {viditelnou na 0:}
 mov AX,$4F07
 xor DX,DX                {obrazovka nahoru}
 int $10
 {aktivni na 1:}
 mov AX,_maxy
 inc AX
 mov __lhy,AX              {__lhy dolu}
@prepnuto:
End;{svga_flippage}
