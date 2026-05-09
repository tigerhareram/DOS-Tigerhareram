Procedure XVGA_InitImage(x,y,xsize,ysize: word; ObjectNumber: Word);
Begin
  openimage(Img[ObjectNumber].Point,xsize,ysize);
  getimage(x,y,x+xsize-1,y+ysize-1,Img[ObjectNumber].Point);
End;