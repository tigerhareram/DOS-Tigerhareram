Procedure Loading;
Var I,X,Y: Word;
Begin
  LoadDefaultFont(0,180,ColorGreen,Buffer[1]);

  WriteText(Buffer[1],0,180,5,5,1,10,10,'loading',Buffer[4]);
  Start_LoadSymbol(54,10,ColorBlack,ColorGreen);


  LoadGrPage('kameny.gra',0);
  LoadBlok(0,0,0,0,159,23,Buffer[1]);
  LoadBlok(0,24,0,24,159,47,Buffer[1]);
  LoadBlok(0,48,0,48,159,71,Buffer[1]);
  LoadBlok(160,0,0,72,19,95,Buffer[1]);
  LoadBlok(160,24,20,72,39,95,Buffer[1]);
  LoadBlok(160,48,40,72,59,95,Buffer[1]);
  LoadBlok(0,72,0,96,59,119,Buffer[1]);
  LoadBlok(0,96,60,96,139,119,Buffer[1]);
  LoadBlok(0,120,0,120,79,143,Buffer[1]);
  LoadBlok(0,144,80,120,159,143,Buffer[1]);
  WriteBlok(0,0,0,0,179,167,Buffer[1],Buffer[2]);
  Blok(0,0,179,167,ColorKamen,Buffer[1]);
  WriteSprite(0,0,0,0,179,167,Buffer[2],Buffer[1]);
  For Y:=0 to 6 do
  For X:=0 to 8 do
  Begin
    WritePixel(X*20,Y*24,ColorBlack,Buffer[1]);
    WritePixel(X*20+19,Y*24,ColorBlack,Buffer[1]);
    WritePixel(X*20,Y*24+23,ColorBlack,Buffer[1]);
    WritePixel(X*20+19,Y*24+23,ColorBlack,Buffer[1]);
  End;

  Stop_LoadSymbol;
  Blok(54,10,56,14,ColorBlack,Buffer[4]);
End;