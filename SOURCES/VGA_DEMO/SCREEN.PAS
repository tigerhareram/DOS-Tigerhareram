Procedure Screen;
Begin
  VGA_ClearPage(Col[0],Buffer[3]);

  Map_WriteVGASegment(0,0,X1,Y1,X2,Y2,Buffer[3],Col[0],Col[0]);
  VGA_BarZ(0,0,46,13,Col[2],Buffer[3]);
  VGA_Rectangle(0,0,46,13,Col[1],Buffer[3]);
  Text_OutText(2,2,'fps=',Buffer[3],VGA);
  Text_OutNumber(28,3,fps,False,Buffer[3],VGA);

  VGA_Rectangle(0,0,319,199,Col[1],Buffer[3]);

{ VGA_WaitRetrace; } { fps cycles max , limit 30000 Pentium 75Mhz}
  VGA_FlipPage(Buffer[3],Buffer[4]);
End;