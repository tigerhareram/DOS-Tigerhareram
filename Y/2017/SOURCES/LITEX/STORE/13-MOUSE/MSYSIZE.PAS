Procedure Mouse_SetYSize(Y1,Y2: Word); Assembler;
Asm
  Mov AX, 0008H
  Mov CX, [Y1]
  Mov DX, [Y2]
  Int 33H
End;