Procedure MainWorldScreen;
Var I,Kn,N: Word;
    X,Y: Word;

Begin
  SVGA_ClearPage(ColX[0]);
  SVGA_Rectangle(0,0,639,479,ColX[15]);
  SVGA_Rectangle(0,400,639,479,ColX[15]);
  Text_OutText(20,420,'controls: Left, Right, Insert, Enter, Esc',Buffer[0],SVGA);
  Text_OutText(585,419,'Page=',Buffer[0],SVGA);
  Text_OutNumber(620,420,StranaCis,False,Buffer[0],SVGA);
  Text_OutText(590,439,'Gra=',Buffer[0],SVGA);
  Text_OutNumber(620,440,VisiblePage,False,Buffer[0],SVGA);
  Case VisibleBMP of
    0: Begin Text_OutText(580,460,'BMP=False',Buffer[0],SVGA); End;
    1: Begin Text_OutText(580,460,'BMP=True',Buffer[0],SVGA); End;
    {LAYER BMP first !!}
  End; {Case End}


End;
