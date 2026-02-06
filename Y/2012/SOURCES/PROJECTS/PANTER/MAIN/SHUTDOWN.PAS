Procedure Shutdown;
Begin
  Init80x25;
  ShutdownTimer;
  ShutdownBuffers;
  ShutdownKeyboard;
End;
