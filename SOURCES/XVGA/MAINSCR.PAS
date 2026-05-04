Procedure MainScreen;
Var s: string;
Begin
  XVGA_FlipPage(1,3);       {background layer map & gra , bmp filled 640x480}
{ XVGA_Pixel(Random(640),Random(480),Random(256)); }
  Str(fps,s);
  XVGA_BarZ(10,405,73,412,ColX[1]); {clear fps space wirh color 1} {Init define}
  writexy(10,405,'fps='+s);
End;