Procedure P16_BlackOut(StartColor: Byte);
Var I: Byte;
Begin
  For I:=0 to 15 do P16_SetPal(StartColor+I,0,0,0);
End;