Procedure Spkr_Silence; Assembler;
Asm
  IN     AL,61h
  AND    AL,0FCh
  OUT    61h,AL
End;
