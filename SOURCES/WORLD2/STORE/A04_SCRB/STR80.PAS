Procedure Str80(Cesta:String);
Var Fi: Text;
    X,Y: Byte;
Begin
  Assign(Fi,Cesta);
  Reset(Fi);
  For Y:=0 to 24 do
  For X:=0 to 79 do Read(Fi,stranka[Y,X]);
  Close(Fi);

  SVGA_ClearPage(ColX[0]);
  SVGA_Rectangle(0,400,639,479,ColX[15]);

  For Y:=0 to 24 do
  For X:=0 to 79 do Begin
                      _Print(X*8,Y*16,ColX[15],Stranka[Y,X]);
                    End;

  SVGA_WaitRetrace;
  SVGA_FlipPage;
End;
