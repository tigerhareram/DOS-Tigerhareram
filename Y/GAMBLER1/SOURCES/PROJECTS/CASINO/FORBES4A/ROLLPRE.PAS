Procedure RollPre;
Var I,A: Byte;
Begin
  For I:=0 to 2 do
  Begin
    If PreValec[I].Rotate=True then
    Begin
      If PreValec[I].Counter>0 then Dec(PreValec[I].Counter)
                               else PreValec[I].Rotate:=False;

      If PreValec[I].Scroll<23 then Inc(PreValec[I].Scroll)
                               else PreValec[I].Scroll:=0;

      If PreValec[I].Scroll=0 then
      Begin
        If Valec[I].SymbolCounter>0 then Dec(Valec[I].SymbolCounter)
                                    else Valec[I].SymbolCounter:=MaxSymbolu;
        SetupSymboly(I);
      End;
    End;

    If ((PreValec[0].Rotate=False) and
        (PreValec[1].Rotate=False) and
        (PreValec[2].Rotate=False)) then AllStopedPre:=True;
  End;
End;