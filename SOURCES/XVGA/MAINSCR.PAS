Procedure MainScreen;
Var s: string;
Begin
  XVGA_Pixel(Random(640),Random(480),Random(256));
  Str(fps,s);
  XVGA_BarZ(10,205,73,212,1); {clear fps space wirh color 1} {Init define}
  writexy(10,205,'fps='+s);
End;