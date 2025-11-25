Procedure Screen;
Begin
  VGA_ClearPage(Col[0],Buffer[3]);

  Map_WriteVGASegment(0,0,X1,Y1,X2,Y2,Buffer[3],Col[1],Col[1]);

  VGA_Rectangle(0,0,319,199,Col[1],Buffer[3]);

  VGA_WaitRetrace;
  VGA_FlipPage(Buffer[3],Buffer[4]);
  Mouse_Show;
End;