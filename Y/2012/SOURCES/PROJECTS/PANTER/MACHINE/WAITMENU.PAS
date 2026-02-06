Procedure WaitMenu(limit_ms: Word);
Var
  ReadPort: Byte;
  pocitadlo: Word;
Begin
  pocitadlo:=0;
  ReadPort:=InPortB($60);
  While (ReadPort>=128) and (pocitadlo<>limit_ms) do
  Begin
    Wait(1);
    ReadPort:=InPortB($60);
    If pocitadlo<limit_ms then Inc(pocitadlo);
  End;
End;
