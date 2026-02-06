Procedure SetAllClose;
Var I: Byte;
Begin
  For I:=0 to 4 do Button[I].Open:=False;
End;


Procedure SetAllOpen;
Var I: Byte;
Begin
  For I:=0 to 4 do Button[I].Open:=True;
End;


Procedure SetButtons2;
Var I: Byte;
Begin
  For I:=0 to 4 do Button[I].Phase:=0;
  UpdateTlacitka;
End;