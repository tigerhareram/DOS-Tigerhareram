Procedure MainScreen;
Var s: string;
Begin

  {objects -> to page 3}

  XVGA_setactivepage(3);    {MainScreen play in page 3 = scene}
  XVGA_FlipPage(1,3);       {background layer map and txt -> to page 3}

  {from page 2 to page 3}
  XVGA_CopyImage(320,0,True,120,0);
  XVGA_CopyImage(480,0,True,136,1);

  {fps counter}
  Str(fps,s);
  XVGA_BarZ(10,405,106,412,ColX[1]); {clear fps space wirh color 1} {Init define}
  writexy(10,405,'fps='+s);

  {flip page 3 to visible screen page 0}
  XVGA_FlipPage(3,0); {to screen}
End;