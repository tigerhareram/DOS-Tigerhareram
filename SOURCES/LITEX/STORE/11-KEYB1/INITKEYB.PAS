Procedure Kbd_Init;
Begin
  GetIntVec(9, @BIOSKeyboardHandler);
  SetIntVec(9, Addr(KeyboardHandler));
End;