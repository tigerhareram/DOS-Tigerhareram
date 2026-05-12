Procedure P16_Done(StartColor: Byte);
Var I: Byte;
Begin
  If XVGA_Enabled=False
  then
  For I:=0 to 15 do P16_SetPal(StartColor+I,PalBack[StartColor+I].R,
                                            PalBack[StartColor+I].G,
                                            PalBack[StartColor+I].B)
  else
  For I:=0 to 15 do setrgbpalette(StartColor+I,PalBack[StartColor+I].R,
                                               PalBack[StartColor+I].G,
                                               PalBack[StartColor+I].B);
End;