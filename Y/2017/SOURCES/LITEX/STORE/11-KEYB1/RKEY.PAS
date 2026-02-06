Function Kbd_RKey: Byte;
Begin
  Repeat Until KeyCode in [1..127];
  Kbd_RKey:=KeyCode;
End;