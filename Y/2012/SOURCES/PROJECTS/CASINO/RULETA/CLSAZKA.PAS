Procedure ClearSazka;
var I: Byte;
Begin
  For I:=0 to 61 do SazPole[I].Vsazeno:=False;
End;