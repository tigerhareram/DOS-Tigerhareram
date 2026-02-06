Procedure Loading;
Begin
  WriteText(Buffer[2],160,0,5,5,1,10,10,'loading',Buffer[4]);
  Start_LoadSymbol(54,10,0,ColorRed);

  SaveLoad(False); {LOAD HiScore}

  LoadGrPage('agent.gra',0);
  LoadBlok(0,0,0,0,159,199,Buffer[1]);

  LoadGrPage('logo.gra',0);
  LoadBlok(160,0,0,0,159,199,Buffer[1]);

  LoadGrPage('design.gra',0);
  LoadBlok(0,0,0,0,159,199,Buffer[2]);

  LoadSndFile('agent.snd',0);

  Stop_LoadSymbol;
End;