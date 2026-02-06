Procedure HistorieHer;
Var I: Byte;
Begin
  If ((VkladyTMP<>VyplacenoTMP) and (Credit=0) and (Multiwin=0)) then
  Begin
    DatRec2.Vklad[0]:=VkladyTMP;
    DatRec2.Vyplaceno[0]:=VyplacenoTMP;
    For I:=MaxHistorie downto 1 do
    Begin
      If (I-1)>=0 then
      Begin
        DatRec2.Vklad[I]:=DatRec2.Vklad[I-1];
        DatRec2.Vyplaceno[I]:=DatRec2.Vyplaceno[I-1];
      End;
    End;
    DatRec2.Vklad[0]:=0;
    DatRec2.Vyplaceno[0]:=0;
    VkladyTMP:=0;
    VyplacenoTMP:=0;
  End;
End;