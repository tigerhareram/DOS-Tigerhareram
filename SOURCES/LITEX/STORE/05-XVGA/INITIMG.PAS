Procedure XVGA_InitImage(x,y,xsize,ysize: word; p: pointer);
Begin
  openimage(p,xsize,ysize);
  getimagesize(p,x,y);
End;