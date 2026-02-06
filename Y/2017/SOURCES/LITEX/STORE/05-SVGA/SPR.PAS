Procedure SVGA_Spr(x,y,x1,y1,Transp,BufferFrom:Word);
Begin
  SVGA_SprZ(x,y,x1,y1,x1+7,y1+7,Transp,BufferFrom);
End;