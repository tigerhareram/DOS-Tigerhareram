Procedure MainScreen;
Var s: string;
Begin
  {objects -> to page 3}

  XVGA_setactivepage(3);    {MainScreen play in page 3 = scene}
  XVGA_FlipPage(1,3);       {background layer map and txt -> to page 3}

  {fps counter}
  Str(fps,s);
  XVGA_BarZ(10,405,106,412,ColX[0]); {clear fps space wirh color 1} {Init define}
  writexy(10,405,'fps='+s);
  Str(STEP,s);
  writexy(10,415,'step='+s);

  {flip page 3 to visible screen page 0}
  XVGA_FlipPage(3,0); {to screen}
End;