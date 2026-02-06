Procedure P16_Init(StartColor: Byte);
Var I: Byte;
Begin
  For I:=0 to 15 do
  Begin
    P16_GetPal(StartColor+I,PalBack[StartColor+I].R,
                            PalBack[StartColor+I].G,
                            PalBack[StartColor+I].B);
  End;
End;