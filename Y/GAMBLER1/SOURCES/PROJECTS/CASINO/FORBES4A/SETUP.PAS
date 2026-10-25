Program Setup;
Uses DOS,Lite,Gamb1,Gamb2,Gamb3;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
  Randomize;

  InitBuffers;
  Init320x200;
  InitKeyboard;
  SaveLoadForbes(False);
  SaveLoadPenize(False);
  InitTimer;
  InitTexter(ColorTexter);

  Servis;

  ShutdownTexter;
  ShutdownTimer;
  ShutdownKeyboard;
  Init80x25;
  ShutdownBuffers;
End.