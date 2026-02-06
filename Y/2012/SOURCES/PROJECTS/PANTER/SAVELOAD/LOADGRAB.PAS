Procedure LoadGraphicsB;
Var I: Byte;
Begin
  WriteWaitScreen;
  LoadGrPage('world.gra',0);
  LoadBlok(0,0,0,0,159,199,Buffer[2]);
End;