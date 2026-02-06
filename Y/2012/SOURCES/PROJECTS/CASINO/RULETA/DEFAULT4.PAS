Procedure SetDefaults4;
Var N: Byte;
Begin
  RuletaStoji:=True;
  Ending4:=False;
  FundDiag4:=False;
  FundSelect4:=0;
  Sazka4:=5;
  BetBT4:=0;
  For N:=0 to 1 do Button4[N].Blinking:=True;
  For N:=0 to 61 do SazPole[N].Vsazeno:=False;
  {sazka na jednicku default}
  ClearSazka;
  TypSazky:=38;
  Kurz:=2;
  Xzetonu:=44;
  Yzetonu:=121;
  For N:=38 to 43 do SazPole[N].Vsazeno:=True;
  For N:=25 to 30 do SazPole[N].Vsazeno:=True;
  For N:=12 to 17 do SazPole[N].Vsazeno:=True;
End;