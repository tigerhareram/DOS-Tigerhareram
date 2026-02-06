Function Mouse_Btn3: Word; Assembler;
Asm
    Mov AX, 0003H
    Int 33H
    Mov AX, 3
    And AX, BX
    Shr BX, 2
    Mov AX, BX
End;
