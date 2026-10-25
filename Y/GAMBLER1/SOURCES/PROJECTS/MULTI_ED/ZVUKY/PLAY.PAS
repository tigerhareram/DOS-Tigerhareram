Procedure PrehrajZvuk(Index: Byte);
Var Offset,Posun: Word;
Begin
  Offset:=memW[ZvukTabSeg:Index*4]; {Zacatek}
  For Posun:=0 to memW[ZvukTabSeg:Index*4+2]-1 do {0 .. delka}
  Begin
    Sound(memW[SoundDataSeg:Offset*2+Posun*2]);
    If Key[1]=True then
    Begin
      While Key[1]=True do Begin End;
      Break;
    End;
    Wait(10);
  End;
  Silence;
End;