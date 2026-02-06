Procedure LoadGraphics;
Begin
  LoadGrPage('forbes1.gra',0);
  LoadBlok(0,32,0,0,39,159,Buffer[1]);
  LoadBlok(160,0,40,0,55,79,Buffer[1]);

  LoadGrPage('forbes2.gra',0);
  LoadBlok(40,32,0,0,39,159,Buffer[1]);

  LoadGrPage('forbes3.gra',0);
  LoadBlok(80,32,0,0,39,159,Buffer[1]);
  LoadBlok(160,80,40,0,55,79,Buffer[1]);

  LoadGrPage('forbes4.gra',0);
  LoadBlok(120,32,0,0,39,159,Buffer[1]);

  LoadGrPage('forbes5.gra',0);
  LoadBlok(0,0,0,0,159,31,Buffer[1]);
  LoadBlok(160,184,0,32,79,47,Buffer[1]);
  LoadBlok(240,184,80,32,92,47,Buffer[1]);
  LoadBlok(160,164,93,32,119,47,Buffer[1]);

  LoadGrPage('forbes6.gra',0);
  LoadBlok(0,0,0,0,79,79,Buffer[3]);
  LoadBlok(80,0,0,80,95,95,Buffer[3]);
  LoadBlok(80,16,0,96,95,111,Buffer[3]);
  LoadBlok(0,80,0,112,79,143,Buffer[3]);
  LoadBlok(0,112,0,144,79,159,Buffer[3]);

  LoadBmpFile('mafia.bmp',0,128);
  LoadBitMap(200,0,Buffer[3]);

  PrepareGFXPage;
End;