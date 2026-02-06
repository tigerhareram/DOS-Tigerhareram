Procedure PrepareRulette;
Var I,Uhel: Word;
Begin
  WriteRuleta;
  WriteZeton(9,137);
  For I:=0 to 37 do
  Begin
    Uhel:=(I*9+4) mod 360;
    KulickaXY[I].X:=Round(26*Sin(Pi*Uhel/180));
    KulickaXY[I].Y:=Round(26*Cos(Pi*Uhel/180));
  End;
End;