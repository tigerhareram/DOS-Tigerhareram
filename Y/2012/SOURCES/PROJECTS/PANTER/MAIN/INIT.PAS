Procedure Init;
Begin
  InitKeyboard;
  InitTimer;
  InitBuffers;
  Init320x200;
  InitTexter(255);
  SetDefault;
End;