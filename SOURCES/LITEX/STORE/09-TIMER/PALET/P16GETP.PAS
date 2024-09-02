Procedure P16_GetPal(Color:Byte; Var PalR,PalG,PalB:Byte); assembler;
Asm
cli
mov DX,$03C7
mov AL,color
out DX,AL
add DX,2
in AL,DX
les DI,palr
mov ES:[DI],AL
in AL,DX
les DI,palg
mov ES:[DI],AL
in AL,DX
les DI,palb
mov ES:[DI],AL
sti
End;