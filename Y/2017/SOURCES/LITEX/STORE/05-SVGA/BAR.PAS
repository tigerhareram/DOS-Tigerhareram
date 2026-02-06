procedure SVGA_Bar(x,y,barva:word);
Begin
  SVGA_BarZ(x,y,x+7,y+7,barva);
End;