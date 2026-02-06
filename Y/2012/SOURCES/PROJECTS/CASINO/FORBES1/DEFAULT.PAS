Procedure SetDefault;
Var I: Byte;
Begin
  Ending:=False;
  For I:=0 to 4 do
  Begin
    Button[I].Open:=False;
    Button[I].Pressed:=False;
    Button[I].Blink1:=False;
    Button[I].Blink2:=False;
    Button[I].Counter:=0;
    Button[I].Phase:=0;
  End;
  For I:=0 to 9 do WinInfo.Vyher[I]:=0;
  AddFundDiag:=False;
  AddFundSelect:=0;
  Score:=0;
  Credit:=0;
  BetCounter:=0;
  RollCounter:=0;
  RollCounter2:=0;
  RollCounter3:=0;
  Korigovat2:=False;
  Sazka:=5;
  Randomize;
  Valec[0].SCounter:=Random(MaxSymbolu);
  Valec[1].SCounter:=Random(MaxSymbolu);
  Valec[2].SCounter:=Random(MaxSymbolu);
End;