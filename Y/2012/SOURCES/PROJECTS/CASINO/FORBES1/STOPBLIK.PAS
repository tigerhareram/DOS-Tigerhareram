Procedure StopAllBlink;
Var I: Byte;
Begin
  For I:=0 to 4 do
  Begin
    Button[I].Blink1:=False;
    Button[I].Blink2:=False;
  End;
End;