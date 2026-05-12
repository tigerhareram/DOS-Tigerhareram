Procedure P16_BlackOut(StartColor: Byte);
Var I: Byte;
Begin
  If XVGA_Enabled=False
  then For I:=0 to 15 do P16_SetPal(StartColor+I,0,0,0)
  else For I:=0 to 15 do setrgbpalette(StartColor+I,0,0,0)
End;