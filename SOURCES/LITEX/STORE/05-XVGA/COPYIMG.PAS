Procedure XVGA_CopyImage(x,y: word; Sprite: Boolean; p: pointer);
Begin
  If Sprite = false then putimage(x,y,p)
                    else putsprite(x,y,p,0);
End;