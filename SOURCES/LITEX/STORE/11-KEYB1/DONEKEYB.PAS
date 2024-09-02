Procedure Kbd_Done;
Begin
  SetIntVec(9, @BIOSKeyboardHandler);
End;