Procedure Automat;
var I: Byte;
Begin
  Start_LoadSymbol(5,5,0,14);
  LoadGraphics;
  LoadSounds;
  Stop_LoadSymbol;
  SetDefault;
  WriteAutomatScreen;
  For I:=0 to 2 do
  Valec[I].Scroll:=0;
  SetupSymboly;
  KresliValce;
  Repeat
    ReadImput;
    ProcesTlacitka;
    WaitRetrace;
    UpdateValce;
    UpdateTlacitka;
    Wait(2);
  Until Ending=True;
End;