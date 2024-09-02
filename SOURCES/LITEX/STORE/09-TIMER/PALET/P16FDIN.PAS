Procedure P16_FadeIn(StartColor,Tempo:Byte);
Var I,N: Byte;
    ms: Word;
Begin
  ms:=((Tempo*100)+256) div 64;

  For N:=0 to 63 do
  Begin
    For I:=0 to 15 do
    Begin
      P16_GetPal(StartColor+I,Tmp[StartColor+I,1],
                              Tmp[StartColor+I,2],
                              Tmp[StartColor+I,3]);
      If Tmp[StartColor+I,1]<PalBack[StartColor+I].R then inc(Tmp[StartColor+I,1]);
      If Tmp[StartColor+I,2]<PalBack[StartColor+I].G then inc(Tmp[StartColor+I,2]);
      If Tmp[StartColor+I,3]<PalBack[StartColor+I].B then inc(Tmp[StartColor+I,3]);
      P16_SetPal(StartColor+I,Tmp[StartColor+I,1],
                              Tmp[StartColor+I,2],
                              Tmp[StartColor+I,3]);
    End;
    Timer_Wait(ms);
  End;
End;