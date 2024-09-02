Procedure Mouse_SetXSize(X1,X2: Word); Assembler;
Asm
  Mov AX, 0007H
  Mov CX, [X1]
  Mov DX, [X2]
  Int 33H
End;
