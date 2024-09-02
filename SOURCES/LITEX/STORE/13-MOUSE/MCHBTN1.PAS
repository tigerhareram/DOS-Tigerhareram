Function Mouse_Btn1: Word; Assembler;
Asm
    Mov AX, 0003H
    Int 33H
    Mov AX, 1
    And AX, BX
    Mov AX, BX
End;