Program Gambler;
Uses DOS,Lite,Gamb1,Gamb2,Gamb3;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
  Randomize;

  InitBuffers;
  Init320x200;
  InitKeyboard;
  SaveLoadForbes(False);
  SaveLoadPenize(False);
  If DatRec.SBEnable=True then InitSB;
  InitTimer;
  InitRawBuffers;
  InitTexter(ColorTexter);
  InitMouse;

  Loading;
  Default;
  ShowMouse;
  Main;

  ShutdownTexter;
  ShutdownRawBuffers;
  ShutdownTimer;
  If DatRec.SBEnable=True then ShutdownSB;
  ShutdownKeyboard;
  Init80x25;
  ShutdownBuffers;
End.