Procedure MainWorldScreen;
Var I,Kn,N: Word;
    X,Y: Word;

Begin
  SVGA_ClearPage(ColX[0]);
  SVGA_Rectangle(0,0,639,479,ColX[15]);
  SVGA_Rectangle(0,400,639,479,ColX[15]);
End;
