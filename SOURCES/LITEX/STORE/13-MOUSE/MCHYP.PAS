Function Mouse_Y: Word; Assembler;
Asm
    Mov AX, 0003H
    Int 33H
    Mov AX, DX
End;
