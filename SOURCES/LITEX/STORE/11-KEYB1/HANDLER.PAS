{$F+}
procedure KeyboardHandler(Flags, CS, IP, AX, BX, CX, DX,
                          SI, DI, DS, ES, BP: Word); Interrupt;
begin
  KeyCode := Port[$60];

  If KeyCode<129 then
  Begin
    Key[KeyCode]:=1;
  End else
  Begin
    Dec(KeyCode,128);
    Key[KeyCode]:=0;
    Inc(KeyCode,128);
  End;

  Port[$20] := $20;
end;
{$F-}