Procedure P16_Init(StartColor: Byte);
Var I: Byte;
Begin
  If XVGA_Enabled=False
  then
  For I:=0 to 15 do
  Begin
    P16_GetPal(StartColor+I,PalBack[StartColor+I].R,
                            PalBack[StartColor+I].G,
                            PalBack[StartColor+I].B);
  End
  else {XVGA_Enabled=True}
  For I:=0 to 15 do
  Begin
    getrgbpalette(StartColor+I,PalBack[StartColor+I].R,
                               PalBack[StartColor+I].G,
                               PalBack[StartColor+I].B);
  End;
End;