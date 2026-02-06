Procedure Automat4;
Begin
  PrepareRulette;
  LoadGraphics4;
  LoadSND4;
  InitTexter(160+14);
  WriteAutomatScreen4;
  SetDefaults4;
  Repeat
    ReadImput4;
    ProcesTlacitka4;
    WriteAutomatScreen4;
  Until Ending4=True;
  PlaySound(6);
  Wait(100);
  ShutdownTexter;
End;