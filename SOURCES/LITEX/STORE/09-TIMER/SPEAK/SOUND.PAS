Procedure Spkr_Sound(Hertz: Word); Assembler;
Asm
  MOV    BX,SP
  MOV    BX,&Hertz
  MOV    AX,34DDh
  MOV    DX,0012h
  CMP    DX,BX
  JNB    @J1
  DIV    BX
  MOV    BX,AX
  IN     AL,61h
  TEST   AL,03h
  JNZ    @J2
  OR     AL,03h
  OUT    61h,AL
  MOV    AL,-4Ah
  OUT    43h,AL
@J2:
  MOV    AL,BL
  OUT    42h,AL
  MOV    AL,BH
  OUT    42h,AL
@J1:
End;