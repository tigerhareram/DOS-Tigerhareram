Procedure Ending;
Begin
  XVGA_DoneImage(Image[0].ImgPointer); {make memory free again}
  XVGA_DoneImage(Image[1].ImgPointer); {make memory free again}
End;