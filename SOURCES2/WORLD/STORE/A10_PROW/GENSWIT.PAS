Procedure GenerSwitch(I: Byte);
Var N: Byte;
    NilFreq: Word;
Begin
  If GeneratorSwitch[I]=0 then GeneratorSwitch[I]:=1
                          else GeneratorSwitch[I]:=0;
  If I<3 then
  Begin
    For N:=0 to 2 do If I<>N then GeneratorSwitch[N]:=0;
    For N:=6 to 11 do If I<>N then GeneratorSwitch[N]:=0;
  End;
  If ((I>2) and (I<6)) then
  Begin
    For N:=3 to 11 do If I<>N then GeneratorSwitch[N]:=0;
  End;
  If ((I>5) and (I<8)) then
  Begin
    For N:=0 to 5 do If I<>N then GeneratorSwitch[N]:=0;
    For N:=8 to 11 do If I<>N then GeneratorSwitch[N]:=0;
  End;
  If I>7 then
  Begin
    For N:=0 to 11 do If I<>N then GeneratorSwitch[N]:=0;
  End;

End;
