Procedure SavePal;
Var I: Byte;
Begin
  For I:=16 to 79 do GetPal(I,Palette[I].R,Palette[I].G,Palette[I].B);
End;


Procedure FadeToColor;
Var I,A: Byte;
    Tmp: array[1..3] of Byte;
Begin
  For A:=0 to 63 do
  Begin
    WaitRetrace;
    For I:=16 to 47 do
    Begin
      GetPal(I,Tmp[1],Tmp[2],Tmp[3]);
      If Tmp[1]>Palette[I].R then Dec(Tmp[1]);
      If Tmp[2]>Palette[I].G then Dec(Tmp[2]);
      If Tmp[3]>Palette[I].B then Dec(Tmp[3]);
      SetPal(I,Tmp[1],Tmp[2],Tmp[3]);
    End;
  End;
End;


Procedure FadeToNothing;
Var I,A,Col2: Byte;
    Tmp: array[1..3] of Byte;
Begin
  For A:=0 to 63 do
  Begin
    WaitRetrace;
    For I:=16 to 47 do
    Begin
      GetPal(I,Tmp[1],Tmp[2],Tmp[3]);
      If Tmp[1]<63 then Inc(Tmp[1]);
      If Tmp[2]<63 then Inc(Tmp[2]);
      If Tmp[3]<63 then Inc(Tmp[3]);
      SetPal(I,Tmp[1],Tmp[2],Tmp[3]);
    End;
  End;
End;


Procedure ValecCFG;
Begin
  SavePal;
  FadeToNothing;
  Valec[0].SCounter:=Random(MaxSymbolu);
  Valec[1].SCounter:=Random(MaxSymbolu);
  Valec[2].SCounter:=Random(MaxSymbolu);
  SetupSymboly;
  KresliValce;
  UpdateValce;
  FadeToColor;
End;
