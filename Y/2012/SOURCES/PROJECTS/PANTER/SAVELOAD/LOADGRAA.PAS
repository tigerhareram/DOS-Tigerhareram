Procedure LoadGraphicsA;
Var I: Byte;
Begin
  LoadGrPage('misc.gra',0);
  LoadBlok(128,192,128,192,159,199,Buffer[1]);
  LoadBlok(20,181,0,0,84,18,Buffer[1]);
  WriteWaitScreen;

  LoadGrPage('logo.gra',0);
  LoadBlok(0,0,0,0,159,199,Buffer[2]);

  LoadGrPage('panter1.gra',0);
  For I:=0 to 5 do LoadBlok(I*20,148,0,I*32,19,I*32+31,Buffer[1]);
  For I:=0 to 5 do LoadBlok(128,I*16,120,I*32+8,151,I*32+23,Buffer[1]);

  LoadGrPage('panter2.gra',0);
  For I:=0 to 5 do
  Begin
    LoadBlok(0,I*16,0,I*16,15,I*16+15,Buffer[1]);
    LoadBlok(16,I*16,0,I*16,15,I*16+7,Buffer[1]);
    LoadBlokM(16,I*16+8,0,I*16+8,15,I*16+15,Buffer[1]);
    LoadBlok(32,I*16,16,I*16,31,I*16+15,Buffer[1]);
    LoadBlok(48,I*16,16,I*16,31,I*16+7,Buffer[1]);
    LoadBlokM(48,I*16+8,16,I*16+8,31,I*16+15,Buffer[1]);
    LoadBlok(64,I*16,32,I*16,47,I*16+15,Buffer[1]);
    LoadBlok(80,I*16,48,I*16,63,I*16+15,Buffer[1]);
    LoadBlokM(96,I*16,32,I*16,47,I*16+15,Buffer[1]);
    LoadBlokM(112,I*16,48,I*16,63,I*16+15,Buffer[1]);
  End;

  {Lod}
  LoadBlok(0,96,0,96,15,111,Buffer[1]);
  LoadBlok(32,96,16,96,31,111,Buffer[1]);
  LoadBlokM(64,96,32,96,47,111,Buffer[1]);
  LoadBlok(96,96,32,96,47,111,Buffer[1]);

  {Vzducholod}
  LoadBlok(0,112,0,112,143,127,Buffer[1]);
End;