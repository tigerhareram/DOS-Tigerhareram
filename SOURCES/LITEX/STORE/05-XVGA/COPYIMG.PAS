Procedure XVGA_CopyImage(x,y: word; Sprite: Boolean; ColorTransparent: Byte; ObjectNumber: Word);
Begin
  If Sprite = false then putimage(x,y,Img[ObjectNumber].Point)
                    else putsprite(x,y,Img[ObjectNumber].Point,ColorTransparent);
End;