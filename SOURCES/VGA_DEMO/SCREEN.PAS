Procedure Screen;
Begin
  VGA_ClearPage(ColX[0],Buffer[3]);

  Map_WriteVGASegment(0,0,X1,Y1,X2,Y2,Buffer[3],ColX[0],ColX[0]); {COL[X]=RECTANGLE 8 PIXELS}
  VGA_BarZ(274,0,319,13,ColX[2],Buffer[3]);
  VGA_Rectangle(274,0,319,13,ColX[15],Buffer[3]);
  Text_OutText(276,2,'fps=',Buffer[3],VGA);
  Text_OutNumber(301,3,fps,False,Buffer[3],VGA);

  VGA_Rectangle(0,0,319,199,ColX[15],Buffer[3]);
  VGA_Rectangle(200,0,319,199,ColX[15],Buffer[3]);

{ VGA_WaitRetrace; }
  VGA_FlipPage(Buffer[3],Buffer[4]);
End;