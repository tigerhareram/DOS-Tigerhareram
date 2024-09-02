Function Mouse_Btn2: Word; Assembler;
Asm
    Mov AX, 0003H
    Int 33H
    Mov AX, 2
    And AX, BX
    Shr BX, 1
    Mov AX, BX
End;
