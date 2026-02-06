Procedure Loading;
Begin
  LoadGrPage('head.gra',0);
  LoadBlok(0,0,0,0,159,199,Buffer[1]);

  LoadRawFile('01.raw',0,1);
  LoadRawFile('02.raw',0,2);
  LoadRawFile('03.raw',0,3);
End;