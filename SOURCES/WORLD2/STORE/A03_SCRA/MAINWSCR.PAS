Procedure MainWorldScreen;
Var I,Kn,N: Word;
    X,Y: Word;

Begin
  SVGA_ClearPage(ColX[0]);
  SVGA_Rectangle(0,0,639,479,ColX[15]);
  SVGA_Rectangle(0,400,639,479,ColX[15]);
  Text_OutText(20,420,'controlls: Left Right Enter Esc',Buffer[0],SVGA);
  Text_OutNumber(620,420,StranaCis,False,Buffer[0],SVGA);
  Text_OutNumber(620,440,VisiblePage,False,Buffer[0],SVGA);
End;
