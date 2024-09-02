Procedure P16_SetPal(Color,R,G,B: byte); assembler;
Asm
cli
mov DX,$03C8
mov AL,color
out DX,AL
inc DX
mov AL,r
out DX,AL
mov AL,g
out DX,AL
mov AL,b
out DX,AL
sti
End;