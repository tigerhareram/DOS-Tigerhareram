Procedure EditZ;
Begin
  EndingEditZ:=False;
  Repeat
    If TABZvukyT=True then
    Begin
      EditZT;
      TABZvukyT:=False;
    End;
    If TABZvukyE=True then
    Begin
      EditZE;
      TABZvukyE:=False;
    End;
  Until EndingEditZ=True;
End;