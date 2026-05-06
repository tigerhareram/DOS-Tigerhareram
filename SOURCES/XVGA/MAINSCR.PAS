Procedure MainScreen;
Var s: string;
Begin

  {objects -> to page 3}

  {from page 2 to page 3 copy image graphics 160x200 alien not sprite}
  XVGA_CopyImage(Random(480),Random(200),False,Image[0].ImgPointer);

  {from page 2 to page 3 copy image graphics 160x200 cosmon yes sprite}
  XVGA_CopyImage(Random(480),Random(200),True,Image[1].ImgPointer);

  {flip page 3 to visible screen page 0}
  XVGA_FlipPage(3,0);

  {fps counter}
  Str(fps,s);
  XVGA_BarZ(10,405,73,412,ColX[1]); {clear fps space wirh color 1} {Init define}
  writexy(10,405,'fps='+s);
End;