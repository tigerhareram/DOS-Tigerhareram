Function Mouse_X: Word; Assembler;
Asm
    Mov AX, 0003H
    Int 33H
    Mov AX, CX
End;
