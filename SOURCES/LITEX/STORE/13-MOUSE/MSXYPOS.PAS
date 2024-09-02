Procedure Mouse_SetXY(X,Y: Word); Assembler;
Asm
  Mov AX, 0004H
  Mov CX, [X]
  Mov DX, [Y]
  Int 33H
End;
